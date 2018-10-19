'use strict';
const AWS = require('aws-sdk');
const ECS = new AWS.ECS({ apiVersion: '2014-11-13' });
const CloudWatch = new AWS.CloudWatch({ apiVersion: '2010-08-01' });
const containerMaxCPU = process.env.container_max_cpu;
const containerMaxMemory = process.env.container_max_memory;
const cluster = process.env.cluster_name;
const namespace = process.env.cluster_name;

const list = (nextToken) => {
  return ECS.listContainerInstances({
    cluster,
    maxResults: 1,
    nextToken,
    status: 'ACTIVE',
  }).promise();
};

const describe = (containerInstanceArns) => {
  return ECS.describeContainerInstances({
    cluster,
    containerInstances: containerInstanceArns,
  }).promise();
};

const compute = (totalSchedulableContainers, nextToken) => {
  return list(nextToken)
    .then((list) => {
      return describe(list.containerInstanceArns)
        .then((data) => {
          const localSchedulableContainers = data.containerInstances
            .map(instance => ({
              cpu: instance.remainingResources.find(resource => resource.name === 'CPU').integerValue,
              memory: instance.remainingResources.find(resource => resource.name === 'MEMORY').integerValue,
            }))
            .map(remaining => Math.min(Math.floor(remaining.cpu / containerMaxCPU), Math.floor(remaining.memory / containerMaxMemory)))
            .reduce((acc, containers) => acc + containers, 0);

          console.log(`localSchedulableContainers: ${localSchedulableContainers}`);

          if (list.nextToken !== null && list.nextToken !== undefined) {
            return compute(localSchedulableContainers + totalSchedulableContainers, list.nextToken);
          }

          return localSchedulableContainers + totalSchedulableContainers;
        })
        .catch(err => console.error(err));
    })
    .catch(err => console.error(err));
};

exports.handler = (event, context, callback) => {
  console.log(`Invoke: ${JSON.stringify(event)}`);

  compute(0, undefined)
    .then((schedulableContainers) => {
      console.log(`schedulableContainers: ${schedulableContainers}`);

      return CloudWatch.putMetricData({
        MetricData: [{
          MetricName: 'SchedulableContainers',
          Dimensions: [{
            Name: 'ClusterName',
            Value: cluster,
          }],
          Value: schedulableContainers,
          Unit: 'Count'
        }],
        Namespace: namespace,
      }).promise();
    })
    .then(() => callback())
    .catch(callback);
};

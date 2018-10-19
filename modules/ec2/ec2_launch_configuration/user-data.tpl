#!/bin/bash -x
#bash -ex << "TRY"
  echo "ECS_CLUSTER=${cluster}" >> /etc/ecs/ecs.config
  yum install -y aws-cfn-bootstrap
#TRY

yum update -y
rpm -Uvh https://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm
yum -y install newrelic-sysmond wget

yum install python-pip -y
python-pip install awscli --upgrade 
export PATH=$PATH:/usr/local/bin

mkdir /root/.aws
touch /root/.aws/credentials
echo '
[default]
region = ${aws_region}
output = text' > ~/.aws/credentials


###Export AWS CLI PATH for root
echo "export PATH=\$PATH:/usr/local/bin">>/root/.bashrc

### Add managing AWS EC2 SSH access with IAM

aws s3 cp s3://${s3_hostnames}/iam_ssh/authorized_keys_command.sh /opt/authorized_keys_command.sh
aws s3 cp s3://${s3_hostnames}/iam_ssh/import_users.sh /opt/import_users.sh

chmod 000755 /opt/authorized_keys_command.sh
chmod 000644 /opt/import_users.sh

### Change sshd settings
sed -i 's:#AuthorizedKeysCommand none:AuthorizedKeysCommand /opt/authorized_keys_command.sh:g' /etc/ssh/sshd_config
sed -i 's:#AuthorizedKeysCommandUser nobody:AuthorizedKeysCommandUser nobody:g' /etc/ssh/sshd_config

### Import users and create Cron job for synchronizing  IAM and local users
bash /opt/import_users.sh
echo '*/10 * * * * root /opt/import_users.sh'>>/etc/cron.d/import_users
service sshd reload

### 

sleep $(( $RANDOM % 300 ))

if [ "$(aws s3 ls s3://${s3_hostnames}/hostnames/ | grep ${app_name}-${environment})" == "" ]; then
  echo  '2.1.1.1 ${app_name}-${environment}-001
         2.1.1.2 ${app_name}-${environment}-002
         2.1.1.3 ${app_name}-${environment}-003
         2.1.1.4 ${app_name}-${environment}-004' > ${app_name}-${environment}
else
  aws s3 cp s3://${s3_hostnames}/hostnames/${app_name}-${environment} ./${app_name}-${environment}
fi

IPS="$(cat ${app_name}-${environment} | awk '{print $1}')"

for IP in $IPS ; do
        if ping -c 1 $IP &> /dev/null
                then
                echo full
                else
                echo zero
        fi
done >> freeiplist

FIRSTFREEIP="$(paste ${app_name}-${environment} freeiplist | grep -w zero | head -n1 | awk '{print $1}')"
OWNIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
NEWHOSTNAME="$(grep -w $FIRSTFREEIP ${app_name}-${environment} | awk '{print $2}')"
hostname $NEWHOSTNAME
sed -i 's/HOSTNAME=localhost.localdomain/HOSTNAME='"$NEWHOSTNAME"'/' /etc/sysconfig/network
sed -i "s/$FIRSTFREEIP/$OWNIP/g" ${app_name}-${environment}
aws s3 cp ${app_name}-${environment} s3://${s3_hostnames}/hostnames/${app_name}-${environment}

#non-necessary as done once
rm freeiplist
ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 create-tags --resources $ID --tags Key=Name,Value=$NEWHOSTNAME


### !!! Here should be added location of S3 bucket which stores creds file 'Logs_cred' with sumo's and new_relic  keys ###


aws s3 cp s3://Bucket_name/Logs_Cred Logs_Cred
export sumo_logic_id=$(grep 'sumo_logic_id' Logs_Cred  | awk '{print $2}')
export sumo_logic_key=$(grep 'sumo_logic_key' Logs_Cred | awk '{print $2}')
export new_relic_license_key=$(grep 'new_relic_license_key'  Logs_Cred | awk '{print $2}')
rm Logs_Cred

mkdir -p /tmp/logs/production_log/
# setup sumologic collector
echo '
{
   "api.version": "v1",
   "sources": [
     {
       "sourceType" : "LocalFile",
       "name": "docker_logs-${app_name}-${environment}",
       "category": "${app_name}-${environment}-docker-logs",
       "pathExpression" : "/var/lib/docker/containers/*/*.log",
       "hostName": "HOSTNAME",
       "useAutolineMatching": false,
       "timeZone": "UTC",
       "automaticDateParsing": true,
       "forceTimeZone": false,
       "defaultDateFormat": "MMM dd HH:mm:ss"
     }
     {
       "sourceType" : "LocalFile",
       "name": "ruby_log-${app_name}-${environment}",
       "category": "${app_name}-${environment}-ruby",
       "pathExpression" : "/var/log/ruby_log/*",
       "hostName": "HOSTNAME",
       "useAutolineMatching": false,
       "timeZone": "UTC",
       "automaticDateParsing": true,
       "forceTimeZone": false,
       "defaultDateFormat": "MMM dd HH:mm:ss"
     }
     {
       "sourceType" : "LocalFile",
       "name" : "/var/log/messages-${app_name}-${environment}",
       "pathExpression" : "/var/log/messages",
       "hostName": "HOSTNAME",
       "category": "${app_name}-${environment}-msg",
       "useAutolineMatching": false,
       "timeZone": "UTC",
       "automaticDateParsing": true,
       "forceTimeZone": false,
       "defaultDateFormat": "MMM dd HH:mm:ss"
     },
     {
       "sourceType" : "LocalFile",
       "name" : "/var/log/secure-${app_name}-${environment}",
       "pathExpression" : "/var/log/secure",
       "hostName": "HOSTNAME",
       "category": "${app_name}-${environment}-secure",
       "useAutolineMatching": false,
       "multilineProcessingEnabled": false,
       "timeZone": "UTC",
       "automaticDateParsing": true,
       "forceTimeZone": false,
       "defaultDateFormat": "MMM dd HH:mm:ss"
     }
     {
       "sourceType" : "LocalFile",
       "name" : "/var/log/syslog",
       "pathExpression" : "/var/log/syslog-${app_name}-${environment}",
       "category": "${app_name}-${environment}-syslog",
       "hostName": "HOSTNAME",
       "useAutolineMatching": false,
       "multilineProcessingEnabled": false,
       "timeZone": "UTC",
       "automaticDateParsing": true,
       "forceTimeZone": false,
       "defaultDateFormat": "MMM dd HH:mm:ss"
     }
     {
       "sourceType" : "LocalFile",
       "name" : "production.log-${app_name}-${environment}",
       "pathExpression" : "/tmp/logs/production_log/*",
       "hostName": "HOSTNAME",
       "category": "${app_name}-${environment}-production-log",
       "useAutolineMatching": false,
       "multilineProcessingEnabled": false,
       "timeZone": "UTC",
       "automaticDateParsing": true,
       "forceTimeZone": false,
       "defaultDateFormat": "MMM dd HH:mm:ss"
     }
  ]
}' > /etc/s@umosources.json
sudo sed -i 's/HOSTNAME/'"$NEWHOSTNAME"'/' /etc/sumosources.json
wget "https://collectors.us2.sumologic.com/rest/download/linux/64" -O SumoCollector.sh
chmod +x SumoCollector.sh
./SumoCollector.sh -q -Vsumo.accessid=$sumo_logic_id -Vsumo.accesskey=$sumo_logic_key -VsyncSources=/etc/sumosources.json -Vcollector.name="$HOSTNAME"
#
# restart services after install
#
service docker restart
/etc/init.d/newrelic-sysmond restart
start ecs
## configure NewRelic infrastructure
echo "license_key: $new_relic_license_key" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y



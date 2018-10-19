#!/bin/bash -e

aws iam list-users --query "Users[].[UserName]" --output text | while read User; do
  SaveUserName="$User"
  SaveUserName=${SaveUserName//"+"/".plus."}
  SaveUserName=${SaveUserName//"="/".equal."}
  SaveUserName=${SaveUserName//","/".comma."}
  SaveUserName=${SaveUserName//"@"/".at."}
  if id -u "$SaveUserName" >/dev/null 2>&1; then
    echo "$SaveUserName exists"
  else
    SaveUserFileName=$(echo "$SaveUserName" | tr "." " ")
    /usr/sbin/adduser "$SaveUserName"
    echo "$SaveUserName ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$SaveUserFileName"
    echo export PATH=$PATH:/usr/local/bin>>/home/$SaveUserName/.bashrc
  fi
done

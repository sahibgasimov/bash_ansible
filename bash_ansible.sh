#!/bin/bash
# Ansible Script 

rs=`tput sgr0`    # reset
g=`tput setaf 2`  # green
y=`tput setaf 3`  # yellow
r=`tput setaf 1`  # red
b=`tput bold`     # bold
u=`tput smul`     # underline
nu=`tput rmul`    # no-underline

echo ${g}"
    What this script does?:
    
 -  Installs ansible, python, java
 -  Download and configure ansible dynamic inventory
 -  Configure '~/.ssh/config' to 'StrictHostKeyChecking no'
 -  Run Farrukh's Bash Script to create Terraform/AWS-EC2
 -  Create Ansible Tower
    * Once you installed AWX, follow this doc to set up AWX with EC2 https://debugthis.dev/awx/2020-03-25-ansible-awx-aws-ec2-auto-discovery/
 "${rs}



echo "
[${y}NOTE${rs}] Once the script is completed place your AWS ACCESS KEYS into the /opt/ansible/inventory/aws_ec2.yml"

echo #
while true
do
    echo "${y}1${rs}. Install ansible and terraform prerequisites "
    echo "${y}2${rs}. Create aws inventory file & ansible config. Create hostkey_config No"
    echo "${y}3${rs}. Run Bash Script to create Terraform/AWS-EC2"
    echo "${y}4${rs}. Create Ansible Tower (AWX)"
    echo "${y}5${rs}. Quit"
    read -p "Enter your choice: " choice
    if [ $choice -eq 1 ]
        # If inventory folder doesn't exist create it
    then
        if [[ ! -e $dir ]]; then
            sudo mkdir -p /opt/ansible/inventory
            echo ${y}"/opt/ansible/inventory exists"${rs}
        elif [[ ! -d $dir ]]; then
            echo "$dir already exists but is not a directory" 1>&2
        fi
        # sudo yum install epel-release  -y # ONLY for CentOS
        sudo amazon-linux-extras install epel -y # ONLY for Amazon Linux
        sudo yum install ansible -y
        sudo yum install java -y
        sudo yum install unzip -y
        sudo yum install awscli -y
        sudo yum install wget -y
        sudo yum install python-boto3 -y
        sudo yum install python3 -y
        sudo yum  install python3-pip
        sudo pip3 install boto3
    elif [ $choice -eq 2 ]
    then
    # To make sure there is no other prod_aws_ec2.yml file we first delete it
        rm -rf prod_aws_ec2.yml
        cat << EOF > prod_aws_ec2.yml
---
plugin: aws_ec2
regions:
  - us-east-2
hostnames:
  - ip-address
aws_access_key: # PUT YOUR AWS_ACCESS_KEY
aws_secret_key: # PUT YOUR AWS_SECRET_KEY
keyed_groups:
    - key: tags
      prefix: tag
EOF
        sudo mv prod_aws_ec2.yml /opt/ansible/inventory/
    if [ $? = 0 ]; then
        echo "prod_aws_ec2.yml  file is exported to /opt/ansible/inventory"
    else 
        echo ${r}"prod_aws_ec2.yml file is not READY"${rs}
    fi

    # Deleting original ansible.cfg in order to copy our own

        sudo mkdir -p /etc/ansible/ && cd /etc/ansible/
        sudo chmod 777 /etc/ansible/
        sudo rm -rf /etc/ansible/ansible.cfg
        sudo rm -rf /etc/ansible/master.zip
        sudo rm -rf /etc/ansible/sgasimov-dotcom-jenkins-test-*
        curl -L -o /etc/ansible/master.zip  https://github.com/sgasimov-dotcom/jenkins-test/zipball/master/
        sleep 1
        sudo unzip -o /etc/ansible/master.zip
        sudo mv  sgasimov-dotcom-jenkins-test-*/ansible.cfg /etc/ansible/
        sudo rm -rf /etc/ansible/sgasimov-dotcom-jenkins-test-*
        sudo rm -rf /etc/ansible/master.zip

    if [ $? = 0 ]; then
        echo "ansible.cfg file is READY"
    else 
        echo ${r}"ansible.cfg file is NOT READY"${rs}
    fi
    
    touch  ~/.ssh/config
    chmod 644 ~/.ssh/config
    cat << EOF  > ~/.ssh/config
Host *
        StrictHostKeyChecking no
EOF
    elif [ $choice -eq 3 ]
    then
        bash -c "$(curl https://bucket-to-check-aws-tasks.s3.amazonaws.com/AWS/scripts/shared_scripts/ansible_menu.sh)"
    
    elif [ $choice -eq 4 ]
    then 
         bash -c "$(curl https://bucket-to-check-aws-tasks.s3.amazonaws.com/AWS/scripts/shared_scripts/ansible_tower_menu.sh)"

    elif [ $choice -eq 5 ]
    then 
         break
     else
         continue
    fi
done

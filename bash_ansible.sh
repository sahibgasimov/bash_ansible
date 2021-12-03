# Ansible Script 

# 1  Install ansible, python, java
# 2. Download and configure ansible dynamic inventory
# 3. Configure "~/.ssh/config" to "StrictHostKeyChecking no"
# 4. Run Farrukh's bash script (Terraform/AWS-EC2)

#!/bin/bash
rs=`tput sgr0`    # reset
g=`tput setaf 2`  # green
y=`tput setaf 3`  # yellow
r=`tput setaf 1`  # red
b=`tput bold`     # bold
u=`tput smul`     # underline
nu=`tput rmul`    # no-underline
echo "
[${y}NOTE${rs}] Please select options below"

echo #
while true
do
    echo "${y}1${rs}. Install ansible and terraform prerequisites "
    echo "${y}2${rs}. Create aws_ec2.yml and ansible.cfg + hostkey_config"
    echo "${y}3${rs}. Run Farrukh's Bash Script (Terraform/AWS-EC2)"
    echo "${y}4${rs}. Quit"
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
    # To make sure there is no other aws_ec2.yml file we first delete it
        rm -rf aws_ec2.yml
        cat << EOF > aws_ec2.yml
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
        sudo mv aws_ec2.yml /opt/ansible/inventory/
    if [ $? = 0 ]; then
        echo "aws_ec2.yml  file is exported to /opt/ansible/inventory"
    else 
        echo ${r}"aws_ec2.yml file is not READY"${rs}
    fi

    # Deleting original ansible.cfg in order to copy our own

        sudo rm -rf /etc/ansible/ansible.cfg
        sudo rm -rf /etc/ansible/master.zip
        sudo rm -rf /etc/ansible/sgasimov-dotcom-jenkins-test-82a34e8
        cd /etc/ansible/
        curl -L -o /etc/ansible/master1.zip  https://github.com/sgasimov-dotcom/jenkins-test/zipball/master/
        sudo unzip -o /etc/ansible/master1.zip && mv  sgasimov-dotcom-jenkins-test-82a34e8/ansible.cfg /etc/ansible/
        sudo rm -rf /etc/ansible/sgasimov-dotcom-jenkins-test-82a34e8
        sudo rm -rf /etc/ansible/master1.zip

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
         break
     else
         continue
      fi
done

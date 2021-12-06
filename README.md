>This script will:
  - Install ansible, python, java on your CentOS/Amazon Linux machine.
 -  Download and configure ansible dynamic inventory.
 -  Configure '~/.ssh/config' to 'StrictHostKeyChecking no'
 -  Run Farrukh's Bash Script to create Terraform/AWS-EC2.
 -  Create Ansible Tower (AWX).
    * Once you installed AWX, follow this doc to set up AWX with EC2 https://debugthis.dev/awx/2020-03-25-ansible-awx-aws-ec2-auto-discovery/

>The only 2 things are not automated:

	• If you running this outside AWS env (for ex. digitalocean) then You still need to add AWS Access Keys to /opt/ansible/inventory/aws_ec2.yml once the folder will be created.
	BUT If your ansible server is running inside the AWS environment, attach an ec2 instance role with the required AWS ec2 permissions, this way you don’t have to add the access and secret key in the configuration. Ansible will automatically use the attached role to make the AWS API calls.
	
	• When creating AWX it will error to launch CentOS subscription in AWS Marketplace,
	follow the link in the error to activate subscription. 


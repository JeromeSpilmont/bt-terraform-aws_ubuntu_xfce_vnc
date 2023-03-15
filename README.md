## Terraform -> install ubuntu 18.04 

**Prerequisites:**

AWS account  
Terraform installed  
Key pair

---
**Target:**

Install xfce4  
Install tightvncserver  
Create vnc-daemon

---
**Launch Terraform**

first init the TF project `terraform init`  

then `terraform plan` and finally we launch the deployment using the command `terraform apply`.   
   
the TF will output the public IP and we will connect with  `vnc://` command

---

user : ubuntu  
pass : ubuntu
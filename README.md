# AWS Infrastructure Deployment with Terraform

This Terraform script automates the deployment of an AWS infrastructure comprising networking components, EC2 instances, an Application Load Balancer (ALB), and an S3 bucket. Additionally, it configures custom web servers on EC2 instances using shell scripts.

## Components Overview

### Provider Configuration
The provider block specifies the AWS provider with the desired region set to `us-east-1`, indicating that all AWS resources will be provisioned in the US East (N. Virginia) region.

### VPC Resource
The VPC block creates a Virtual Private Cloud (VPC) with the CIDR block `10.0.0.0/16` and default instance tenancy. It also assigns a tag with the name "project" to the VPC for easier identification.

### Subnet Resources
The subnet blocks define public subnets within the VPC for resource isolation and redundancy. Each subnet is associated with a specific CIDR block and availability zone.

### Internet Gateway Resource
The internet gateway block creates an internet gateway and attaches it to the VPC to enable outbound internet access for resources within the VPC.

### Route Table Resource
The route table block defines a route table associated with the VPC and adds a default route to the internet gateway, allowing traffic destined for any address (`0.0.0.0/0`) to be routed through the gateway.

### Route Table Association Resources
These blocks associate each subnet with the route table, ensuring that traffic within the subnet follows the routing rules defined in the associated route table.

### Security Group Resource
The security group block defines a security group that controls inbound and outbound traffic to EC2 instances. It allows HTTP and SSH traffic from any source (`0.0.0.0/0`).

### S3 Bucket Resource
The S3 bucket block creates an S3 bucket with a specified name and tags. S3 buckets are used for storing objects such as files, documents, and images.

### EC2 Instance Resources
These blocks launch EC2 instances with specified instance types, AMIs, and other configurations. User data scripts are provided to initialize the instances.

### Application Load Balancer Resource
The ALB block defines an Application Load Balancer (ALB) that distributes incoming HTTP traffic across the EC2 instances.

### Target Group Resources
These blocks associate EC2 instances with target groups for ALB routing.

### Listener Resource
The listener block configures listeners on the ALB to forward traffic to target groups.

## Usage

1. **Prerequisites**: Ensure you have Terraform installed on your system. You can download it from [here](https://www.terraform.io/downloads.html).

2. **Configuration**: Replace the placeholder AMI IDs in the Terraform code with the desired AMIs.

3. **Deployment**: Run `terraform init` followed by `terraform apply` to deploy the infrastructure.

4. **Access**: Once deployed, access the web servers via the ALB DNS name provided in the output.

## Customization

- **Scripts**: Modify the `webserver1.sh` and `webserver2.sh` scripts to customize the web server content or configurations.

- **Resources**: Adjust resource configurations in the Terraform code as per your requirements, such as instance types, subnet CIDR blocks, or security group rules.

## Cleanup

- After testing or when no longer needed, run `terraform destroy` to remove all deployed resources.

## GitHub Repository Setup

1. **Create a New Repository on GitHub**:
   - Go to [GitHub](https://github.com/) and log in to your account.
   - Click on the "+" icon in the top-right corner and select "New repository".
   - Fill in the repository name, description, and choose whether it's public or private.
   - Click "Create repository".

2. **Clone the Repository to Your Local Machine**:
   - Open a terminal or command prompt.
   - Use the `git clone` command to clone the repository to your local machine. Replace `<repository-url>` with the URL of your repository on GitHub.
     ```
     git clone <repository-url>
     ```
   - Change into the newly created directory.
     ```
     cd <repository-name>
     ```

3. **Add, Commit, and Push the Changes**:
   - In the terminal, add the README.md file to the staging area.
     ```
     git add README.md
     ```
   - Commit the changes with a descriptive message.
     ```
     git commit -m "Add README.md with project documentation"
     ```
   - Push the changes to the remote repository on GitHub.
     ```
     git push origin main
     ```

## License

This project is licensed under the [MIT License](LICENSE).

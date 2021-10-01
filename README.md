# Plugin AWS Resources

<p align="center">
  <img src="https://cdn.ocsinventory-ng.org/common/banners/banner660px.png" height=300 width=660 alt="Banner">
</p>

<h1 align="center">Plugin AWS Resources</h1>
<p align="center">
  <b>Some Links:</b><br>
  <a href="http://ask.ocsinventory-ng.org">Ask question</a> |
  <a href="https://www.ocsinventory-ng.org/?utm_source=github-ocs">Website</a> |
  <a href="https://www.ocsinventory-ng.org/en/#ocs-pro-en">OCS Professional</a> |
  <a href="https://wiki.ocsinventory-ng.org/10.Plugin-engine/Using-plugins-installer/">Plugin Install</a>
</p>

## Description

This plugin will retrieve Amazon AWS EC2 instances details using the describe-instances and STS AssumeRole commands of the AWS CLI.

## Prerequisites

*The following configuration has to be available :*
1. An IAM user configured with AmazonEC2ReadOnlyAccess on the AWS infrastructure and STS AssumeRole authorizations 
2. IAM roles with trust policies for the above user on the accounts you wish to scan for AWS resources
3. AWS CLI installed, see : https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html


## Configuration

Please edit the file **agent/Awsresources.pm** with your target account id(s) and target regions:

Line 47 to 49 : 
```
    # add there 1. targeted account and 2. arrays of targeted regions for this account
    my %targets = (
            '000000000002' =>    ['eu-central-1', 'us-east-2'],
            '000000000001' =>    ['eu-central-2', 'us-east-1'],
            ); 
```


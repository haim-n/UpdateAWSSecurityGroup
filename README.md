# UpdateAWSSecurityGroup
Update the source IP of an existing "allow all traffic" Security Group inbound rule based on a Security Group ID and a rule description.

Suitable for cases where you want to automatically update the security group rules to allow access from your dynamic source IP (and to remove the previous rule).

PreReqs: Place the "SG-Script-Config.json" file in the script running directory and update its parameters

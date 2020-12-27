# Update AWS Security Group
Update the source IP of an existing "allow all traffic" Security Group inbound rule based on a Security Group ID and a rule description.
Suitable for cases where you want to automatically update a security group rule to allow access from your dynamic source IP (and to remove the previous rule).

Steps and PreReqs:
1. Install AWS PowerShell module.
2. Identify the Security Group ID that you want to update and the relevant rule description.
3. Create a dedicated IAM user with the premissions described in the "IAM-Policy-Required.json" file, and copy its access keys.
4. Place the "SG-Script-Config.json" file in the script running directory and update its parameters.
5. Run the script either manually or using a scheduled task.

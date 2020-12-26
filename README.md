# Update AWS Security Group
Update the source IP of an existing "allow all traffic" Security Group inbound rule based on a Security Group ID and a rule description.
Suitable for cases where you want to automatically update the security group rules to allow access from your dynamic source IP (and to remove the previous rule).

PreReqs:
1. Identify the Security Group ID that you want to update and the relvant rule description.
2. Create a dedicated IAM user with the premissions described in the "IAM-Policy-Required.json" file, and copy its access keys.
3. Place the "SG-Script-Config.json" file in the script running directory and update its parameters.
4. Run the script either manually or using a scheduled task.

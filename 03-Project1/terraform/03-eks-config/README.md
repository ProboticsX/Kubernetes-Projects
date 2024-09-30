How to Assume the admin role??
- Generate token for the user from AWS console
- aws configure --profile <profile-name>
- export AWS_PROFILE=<profile-name> and feed in the values from generated earlier
- aws sts get-caller-identity
- aws sts assume-role --role-arn "arn:aws:iam::<REPLACE-YOUR-ACCOUNT-ID>:role/<role-name>" --role-session-name <session-name>
- export AWS_ACCESS_KEY_ID=RoleAccessKeyID, export AWS_SECRET_ACCESS_KEY=RoleSecretAccessKey, export AWS_SESSION_TOKEN=RoleSessionToken
- aws sts get-caller-identity
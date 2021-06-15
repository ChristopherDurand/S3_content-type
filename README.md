S3 "content-type" is not correctly set when using terraform to upload objects.

Steps to recreate:
1. Modify `./terraform/main.tf` and change the local variable `s3_bucket` to a globally unique name. 
2. run `terraform apply` within `./terraform`.
3. navigate to the website using your browser. you will be prompted to download `index.html` because it is set as a `binary/octet-stream` file.

This is in contrast with using the AWS CLI, where doing `aws s3 rsync ./public s3://${unique-bucket-name} --delete` will cause the website to work. This is because the AWS CLI correctly sets the content-type of each object uploaded, whereas terraform requires the user to create a map of all potential file extensions and their corresponding `content-type`.

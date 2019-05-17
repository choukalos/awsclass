#!/bin/sh
# The Bucketinator!
# Assumes your cli is already configured with access/etc and default region
#   aka aws configure  ( I defaulted US-east-2 and table output format)

# ------- Configure ----------
ACCOUNTID="895459014397"
BUCKETNAME="${ACCOUNTID}-mystuff"
AWS=`which aws`
BANNER=`which banner`

# Create S3 bucket - https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html
echo "Creating S3 Bucket ${BUCKETNAME}"
${AWS} s3 mb s3://${BUCKETNAME}

# create and upload file to S3 bucket (2 of them)
echo "Generating two files"
${BANNER} -w80 "Star Wars" > file1.txt
${BANNER} -w80 "I will be back!" > file2.txt
echo "Uploading file1.txt to ${BUCKETNAME}"
${AWS} s3 cp file1.txt s3://${BUCKETNAME}/file1.txt
echo "Uploading file2.txt to ${BUCKETNAME}"
${AWS} s3 cp file2.txt s3://${BUCKETNAME}/file2.txt

# List the files in the Bucket
echo "List files in Bucket ${BUCKETNAME}"
${AWS} s3 ls s3://${BUCKETNAME}

# List the names of S3 buckets in your region
echo "List names of S3 buckets in my region"
${AWS} s3 ls s3://

# Get the bucket policy for the bucket you created
echo "Fetching bucket ${BUCKETNAME} policy"
${AWS} s3api get-bucket-policy --bucket ${BUCKETNAME}
echo "Fetching bucket ${BUCKETNAME} ACLs"
${AWS} s3api get-bucket-acl --bucket ${BUCKETNAME}


# delete the two files in the buckets
echo "Deleting file1 from bucket ${BUCKETNAME}"
${AWS} s3 rm s3://${BUCKETNAME}/file1.txt
rm file1.txt
echo "Deleting file2 from bucket ${BUCKETNAME}"
${AWS} s3 rm s3://${BUCKETNAME}/file2.txt
rm file2.txt

# delete the buckets (but I like --force much more :( )
echo "Remove the now empty bucket ${BUCKETNAME}"
${AWS} s3 rb s3://${BUCKETNAME}

# Cleaned up and Done
echo "It is all good now...."

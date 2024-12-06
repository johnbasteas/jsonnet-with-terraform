{
  aws_iam_policy():
    {
      Version: '2012-10-17',
      Statement: [
        {
          Effect: 'Allow',
          Action: [
           'kms:Encrypt',
           'kms:Decrypt',
           'kms:GenerateDataKey',
          ],
          Resource: ['*'],
        },
      ],
    },
}

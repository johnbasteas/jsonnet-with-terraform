{
  aws_iam_policy():
    {
      Version: '2012-10-17',
      Statement: [
        {
          Effect: 'Allow',
          Action: [
           'logs:PutLogEvents',
           'logs:CreateLogStream',
           'ecr:GetDownloadUrlForLayer',
           'ecr:GetAuthorizationToken',
           'ecr:BatchGetImage',
           'ecr:BatchCheckLayerAvailability'
          ],
          Resource: ['*'],
        },
      ],
    },
}

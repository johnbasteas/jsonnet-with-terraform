{
  assume_role_policy(service): {
    Version: '2012-10-17',
    Statement: [
      {
        Effect: 'Allow',
        Principal: {
          Service: service,
        },
        Action: 'sts:AssumeRole',
      },
    ],
  },
}

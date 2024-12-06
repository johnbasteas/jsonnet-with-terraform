{
  vpc_config(static, aws_region, cidr_block): {
    [static.account_name + '-vpc']: {
      cidr: cidr_block,
      azs: [aws_region + c for c in ['a', 'b', 'c']],
      private_subnets: [cidr_block[0:5] + '%d.0/24' % i for i in [1, 2, 3]],
      database_subnets: [cidr_block[0:5] + '%d.0/24' % i for i in [4, 5, 6]],
      elasticache_subnets: [cidr_block[0:5] + '%d.0/24' % i for i in [7, 8, 9]],
      public_subnets: [cidr_block[0:5] + '%d.0/24' % i for i in [10, 11, 12]],
      enable_dns_hostnames: true,
      enable_dns_support: true,
    },
  },
}

local helpers = import '../../common/helpers.libsonnet';
local envs = import './envs/devenv.libsonnet';
local static = import '../../common/static.libsonnet';
local common_data = import '../../common/commonData.libsonnet';

{
  account_name: static.account_name,
  env: envs.global_environment_variables.env,
  aws: {
    tags: helpers.getDefaultTags($.env),
  },
  aws_resources: {
    'eu-central-1': {
      vpc: common_data.vpc_config(static=static, aws_region='eu-central-1', cidr_block='10.1.0.0/20'),
      cloudwatch: {
        log_groups: common_data.cloudwatch_config(retention_days=5),
      },
      alb: {
        [static.account_name + '-alb']: {
          sg_name: static.account_name + '-alb-sg',
          vpc: static.account_name + '-vpc',
          internal: false,
          ip_address_type: 'ipv4',
          target: {
            [static.services.nginxservice + '-tg']: {
              port: 80,
              protocol: 'HTTP',
              health_check: [
                {
                  path: '/',
                  interval: 60,
                  matcher: '200',
                  unhealthy_threshold: 2,
                },
              ],
              rules: {},
            },
          },
        },
      },
      ecs_cluster: {
        [static.account_name + '-cluster']: {
          insights: 'enabled',
          capacity_providers: ['FARGATE_SPOT', 'FARGATE'],
          default_capacity_provider: {
            capacity_provider: 'FARGATE_SPOT',
            weight: 100,
            base: 50,
          },
        },
      },
      ecs_service: {
        [static.services.nginxservice + '-service']: {
          vpc: static.account_name + '-vpc',
          alb: static.account_name + '-alb',
          alb_target: static.services.nginxservice + '-tg',
          ecs_cluster: static.account_name + '-cluster',
          use_alb_security_group: true,
          enable_icmp_ingress: false,
          ecs_security_group_name: static.services.nginxservice + '-ecs-service-sg',
          ecs_sg_allow_container_port: 80,
          desired_count: 1,
          enable_execute_command: true,
          enable_deployment_circuit_breaker: true,
          enable_deployment_circuit_breaker_rollback: true,
          assign_public_ip: true,
          capacity_provider_strategy: [
            {
              capacity_provider: 'FARGATE_SPOT',
              base: 50,
              weight: 100,
            },
          ],
          task: {
            name: static.services.nginxservice + '-task',
            container_name: static.services.nginxservice,
            container_port: 80,
            role: static.services.nginxservice + '-task',
            exec_role: 'common-task-exec',
            cpu: 1024,
            memory: 2048,
            log_group_name: 'test-lab-nginxservice-task',
          },
        },
      },
    },
    'eu-west-1': {
      vpc: { // This is an example without calling the VPC function just to understand how it works.
        [static.account_name + '-vpc']: {
          cidr: '10.2.0.0/20',
          azs: ['eu-west-1a', 'eu-west-1b', 'eu-west-1c'],
          private_subnets: ['10.2.1.0/24', '10.2.2.0/24', '10.2.3.0/24'],
          database_subnets: ['10.2.4.0/24', '10.2.5.0/24', '10.2.6.0/24'],
          elasticache_subnets: ['10.2.7.0/24', '10.2.8.0/24', '10.2.9.0/24'],
          public_subnets: ['10.2.10.0/24', '10.2.11.0/24', '10.2.12.0/24'],
          enable_dns_hostnames: true,
          enable_dns_support: true,
        },
      },
      cloudwatch: {
        log_groups: common_data.cloudwatch_config(retention_days=5),
      },
      alb: {
        [static.account_name + '-alb']: {
          sg_name: static.account_name + '-alb-sg',
          vpc: static.account_name + '-vpc',
          internal: false,
          ip_address_type: 'ipv4',
          target: {
            [static.services.nginxservice + '-tg']: {
              port: 80,
              protocol: 'HTTP',
              health_check: [
                {
                  path: '/',
                  interval: 60,
                  matcher: '200',
                  unhealthy_threshold: 2,
                },
              ],
              rules: {},
            },
          },
        },
      },
      ecs_cluster: {
        [static.account_name + '-cluster']: {
          insights: 'enabled',
          capacity_providers: ['FARGATE_SPOT', 'FARGATE'],
          default_capacity_provider: {
            capacity_provider: 'FARGATE_SPOT',
            weight: 100,
            base: 50,
          },
        },
      },
      ecs_service: {
        [static.services.nginxservice + '-service']: {
          vpc: static.account_name + '-vpc',
          alb: static.account_name + '-alb',
          alb_target: static.services.nginxservice + '-tg',
          ecs_cluster: static.account_name + '-cluster',
          use_alb_security_group: true,
          enable_icmp_ingress: false,
          ecs_security_group_name: static.services.nginxservice + '-ecs-service-sg',
          ecs_sg_allow_container_port: 80,
          desired_count: 1,
          enable_execute_command: true,
          enable_deployment_circuit_breaker: true,
          enable_deployment_circuit_breaker_rollback: true,
          assign_public_ip: true,
          capacity_provider_strategy: [
            {
              capacity_provider: 'FARGATE_SPOT',
              base: 50,
              weight: 100,
            },
          ],
          task: {
            name: static.services.nginxservice + '-task',
            container_name: static.services.nginxservice,
            container_port: 80,
            role: static.services.nginxservice + '-task',
            exec_role: 'common-task-exec',
            cpu: 1024,
            memory: 2048,
            log_group_name: 'test-lab-nginxservice-task',
          },
        },
      },
    },
    global: {
      iam: common_data.iam(env='dev'),
    },
  },
}

import json
from config0_publisher.terraform import TFConstructor


def run(stackargs):

    # instantiate authoring stack
    stack = newStack(stackargs)

    # Add default variables
    stack.parse.add_required(key="vpc_name",
                             tags="tfvar,db",
                             types="str")

    stack.parse.add_optional(key="environment",
                             default="dev",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="main_network_block",
                             default="10.9.0.0/16",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="enable_nat_gateway",
                             default="true",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="single_nat_gateway",
                             default="true",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="enable_dns_hostnames",
                             default="true",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="reuse_nat_ips",
                             default="true",
                             tags="tfvar",
                             types="bool")

    stack.parse.add_optional(key="one_nat_gateway_per_az",
                             default="false",
                             tags="tfvar",
                             types="str,bool")

    # if eks_cluster is specified, then add the correct tags to the vpc
    stack.parse.add_optional(key="eks_cluster", 
                             types="bool")

    # docker image to execute terraform with
    stack.parse.add_optional(key="aws_default_region", 
                             default="eu-west-1",
                             tags="tfvar,db,resource,runtime_settings", 
                             types="str")

    # Add execgroup
    stack.add_execgroup("config0-hub:::aws_networking::vpc",
                        "tf_execgroup")

    # Add substack
    stack.add_substack('config0-hub:::tf_executor')
    stack.add_substack('config0-hub:::parse_terraform')
    stack.add_substack('config0-hub:::publish_vpc_info', "publish_vpc")

    # Initialize
    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    # set variables
    _default_tags = {"vpc_name": stack.vpc_name}

    vpc_tags = _default_tags.copy()
    nat_gw_tags = _default_tags.copy()
    public_subnet_tags = _default_tags.copy()
    private_subnet_tags = _default_tags.copy()

    if stack.get_attr("eks_cluster"):
        k8_key = "kubernetes.io/cluster/{}".format(stack.eks_cluster)
        vpc_tags[k8_key] = "shared"
        public_subnet_tags["kubernetes.io/role/elb"] = "1"
        private_subnet_tags["kubernetes.io/role/internal_elb"] = "1"
        nat_gw_tags["Name"] = "{}-nat-eip".format(stack.eks_cluster)

    stack.set_variable("vpc_tags", 
                       json.dumps(vpc_tags),
                       tags="tfvar",
                       types="str")

    stack.set_variable("nat_gw_tags", 
                       json.dumps(nat_gw_tags),
                       tags="tfvar",
                       types="str")

    stack.set_variable("public_subnet_tags", 
                       json.dumps(public_subnet_tags),
                       tags="tfvar",
                       types="str")

    stack.set_variable("private_subnet_tags", 
                       json.dumps(private_subnet_tags),
                       tags="tfvar",
                       types="str")

    # use the terraform constructor (helper)
    # but this is optional
    tf = TFConstructor(stack=stack,
                       execgroup_name=stack.tf_execgroup.name,
                       provider="aws",
                       resource_name=stack.vpc_name,
                       resource_type="vpc",
                       terraform_type="aws_vpc")

    tf.include(maps={"vpc_id": "id"})

    # finalize the tf_executor
    stack.tf_executor.insert(display=True,
                             **tf.get())

    # parse terraform and insert subnets
    arguments = {"src_resource_type": "vpc",
                 "src_provider": "aws",
                 "src_resource_name": stack.vpc_name,
                 "dst_resource_type": "subnet",
                 "dst_terraform_type": "aws_subnet"}

    # this will map the subnet_id to id
    arguments["mapping"] = json.dumps({"id": "subnet_id"})
    arguments["must_exists"] = True
    arguments["aws_default_region"] = stack.aws_default_region

    arguments["add_values"] = json.dumps({"vpc": stack.vpc_name,
                                          "aws_default_region":stack.aws_default_region,
                                          "provider":"aws",
                                          "region":stack.aws_default_region})

    inputargs = {"arguments": arguments,
                 "automation_phase": "infrastructure",
                 "human_description": "Parse Terraform for subnets",
                 "display": True}

    inputargs["display_hash"] = stack.get_hash_object(inputargs)

    stack.parse_terraform.insert(**inputargs)

    # publish info on dashboard
    arguments = {"vpc_name": stack.vpc_name}
    inputargs = {"arguments": arguments}
    inputargs["automation_phase"] = "infrastructure"
    inputargs["human_description"] = 'Publish VPC {}'.format(stack.vpc_name)

    stack.publish_vpc.insert(display=True, **inputargs)

    return stack.get_results()

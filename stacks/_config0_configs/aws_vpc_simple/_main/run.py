import json
from config0_publisher.terraform import TFConstructor


def run(stackargs):

    # instantiate authoring stack
    stack = newStack(stackargs)

    # Add default variables
    stack.parse.add_required(key="vpc_name",
                             tags="tfvar,db",
                             types="str")

    stack.parse.add_optional(key="tier_level",
                             types="str,int")

    stack.parse.add_optional(key="vpc_id",
                             types="str",
                             default="null")

    # if eks_cluster is specified, then add the correct tags to the vpc
    stack.parse.add_optional(key="eks_cluster",
                             types="str")

    # docker image to execute terraform with
    stack.parse.add_optional(key="aws_default_region",
                             default="eu-west-1",
                             tags="tfvar,db,resource,tf_exec_env",
                             types="str")

    # Add execgroup
    stack.add_execgroup("config0-publish:::aws_networking::vpc_simple", 
                        "tf_execgroup")

    # Add substack
    stack.add_substack('config0-publish:::tf_executor')
    stack.add_substack('config0-publish:::parse_terraform')
    stack.add_substack('config0-publish:::aws_sg')
    stack.add_substack('config0-publish:::publish_vpc_info', "publish_vpc")

    # Initialize
    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    # set variables
    _default_tags = {"vpc_name": stack.vpc_name}

    vpc_tags = _default_tags.copy()
    public_subnet_tags = _default_tags.copy()
    private_subnet_tags = _default_tags.copy()

    # if eks_cluster is provided, we modify the configs
    # if we are using a vpc without a nat, the eks must be in public network
    # the internal lb must also be in public
    if stack.get_attr("eks_cluster"):
        k8_key = "kubernetes.io/cluster/{}".format(stack.eks_cluster)
        vpc_tags[k8_key] = "shared"
        public_subnet_tags["kubernetes.io/role/elb"] = "1"
        private_subnet_tags["kubernetes.io/role/internal_elb"] = "1"

    stack.set_variable("vpc_tags",
                       vpc_tags,
                       tags="tfvar",
                       types="dict")

    stack.set_variable("public_subnet_tags", 
                       public_subnet_tags,
                       tags="tfvar",
                       types="dict")

    stack.set_variable("private_subnet_tags", 
                       private_subnet_tags,
                       tags="tfvar",
                       types="dict")

    stack.set_variable("timeout",600)

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
    arguments = {
        "src_resource_type": "vpc",
        "src_provider": "aws",
        "src_resource_name": stack.vpc_name,
        "dst_resource_type": "subnet",
        "dst_terraform_type": "aws_subnet"}

    # this will map the subnet_id to id
    arguments["mapping"] = json.dumps({"id": "subnet_id"})
    arguments["must_exists"] = True
    arguments["aws_default_region"] = stack.aws_default_region
    arguments["add_values"] = json.dumps({"vpc": stack.vpc_name})

    inputargs = {
        "arguments": arguments,
        "automation_phase": "infrastructure",
        "human_description": "Parse Terraform for subnets","display": True
    }

    inputargs["display_hash"] = stack.get_hash_object(inputargs)

    stack.parse_terraform.insert(**inputargs)

    # parse terraform and insert default/public route 
    arguments = {
        "src_resource_type": "vpc",
        "src_provider": "aws",
        "src_resource_name": stack.vpc_name,
        "dst_resource_type": "route_table",
        "dst_terraform_type": "aws_default_route_table"
    }

    # this will map the default_route_table to id
    # we assume the default route table is a public route table
    # for public subnets
    arguments["mapping"] = json.dumps({"id": "route_table_id"})
    arguments["must_exists"] = True
    arguments["aws_default_region"] = stack.aws_default_region

    arguments["add_values"] = json.dumps({
        "vpc": stack.vpc_name,
        "public_route_table":True
        }
    )

    inputargs = {
        "arguments": arguments,
        "automation_phase": "infrastructure",
        "human_description": "Parse Terraform for default route table",
        "display": True
    }

    inputargs["display_hash"] = stack.get_hash_object(inputargs)

    stack.parse_terraform.insert(**inputargs)

    # parse terraform and insert default/private route 
    # we assume it is used for private subnets
    arguments = {
        "src_resource_type": "vpc",
        "src_provider": "aws",
        "src_resource_name": stack.vpc_name,
        "dst_resource_type": "route_table",
        "dst_terraform_type": "aws_route_table"
    }

    # this will map the default_route_table to id
    arguments["mapping"] = json.dumps({"id": "route_table_id"})
    arguments["must_exists"] = True
    arguments["aws_default_region"] = stack.aws_default_region

    arguments["add_values"] = json.dumps({
        "vpc": stack.vpc_name,
        "private_route_table":True
        }
    )

    inputargs = {
        "arguments": arguments,
        "automation_phase": "infrastructure",
        "human_description": "Parse Terraform for route table","display": True
    }

    inputargs["display_hash"] = stack.get_hash_object(inputargs)

    stack.parse_terraform.insert(**inputargs)

    # add security groups
    arguments = {"vpc_name": stack.vpc_name,
                 "aws_default_region": stack.aws_default_region}

    if stack.get_attr("vpc_id"):
        arguments["vpc_id"] = stack.vpc_id

    if stack.get_attr("cloud_tags_hash"):
        arguments["cloud_tags_hash"] = stack.cloud_tags_hash

    if stack.get_attr("tier_level"):
        arguments["tier_level"] = stack.tier_level

    inputargs = {
        "arguments": arguments,
        "automation_phase": "infrastructure",
        "human_description": f'Creating security groups for VPC {stack.vpc_name}'
    }

    stack.aws_sg.insert(display=True, **inputargs)

    # publish info on dashboard
    arguments = {"vpc_name": stack.vpc_name}

    if stack.get_attr("vpc_id"):
        arguments["vpc_id"] = stack.vpc_id

    inputargs = {
        "arguments": arguments,
        "automation_phase": "infrastructure",
        "human_description": f'Publish VPC {stack.vpc_name}'
    }

    stack.publish_vpc.insert(display=True,
                             **inputargs)

    return stack.get_results()

def run(stackargs):

    # instantiate authoring stack
    stack = newStack(stackargs)

    # Add default variables
    stack.parse.add_required(key="vpc_name")

    stack.parse.add_optional(key="tier_level")
    stack.parse.add_optional(key="vpc_tags")
    stack.parse.add_optional(key="nat_gw_tags")
    stack.parse.add_optional(key="public_subnet_tags")
    stack.parse.add_optional(key="private_subnet_tags")
    stack.parse.add_optional(key="enable_nat_gateway")
    stack.parse.add_optional(key="single_nat_gateway")
    stack.parse.add_optional(key="enable_dns_hostnames")
    stack.parse.add_optional(key="reuse_nat_ips")
    stack.parse.add_optional(key="one_nat_gateway_per_az")

    stack.parse.add_optional(key="aws_default_region", default="us-east-1")
    stack.parse.add_optional(key="environment", default="dev")
    stack.parse.add_optional(key="main_network_block", default="10.9.0.0/16")
    stack.parse.add_optional(key="labels", default="null")
    stack.parse.add_optional(key="tags", default="null")
    stack.parse.add_optional(key="publish_to_saas", default="null")

    # add substacks
    stack.add_substack('config0-hub:::aws_vpc')
    stack.add_substack('config0-hub:::aws_sg')
    stack.add_substack('config0-hub:::publish_vpc_info')

    # init the stack namespace
    stack.init_variables()
    stack.init_substacks()

    _default_tags = {"vpc_name": stack.vpc_name}
    stack.set_variable("public_subnet_tags", _default_tags.copy())
    stack.set_variable("private_subnet_tags", _default_tags.copy())

    # Create VPC
    arguments = {"vpc_name": stack.vpc_name}

    if stack.get_attr("environment"):
        arguments["environment"] = stack.environment

    if stack.get_attr("main_network_block"):
        arguments["main_network_block"] = stack.main_network_block

    if stack.get_attr("vpc_tags"):
        arguments["vpc_tags"] = stack.vpc_tags

    if stack.get_attr("nat_gw_tags"):
        arguments["nat_gw_tags"] = stack.nat_gw_tags

    if stack.get_attr("public_subnet_tags"):
        arguments["public_subnet_tags"] = stack.public_subnet_tags

    if stack.get_attr("private_subnet_tags"):
        arguments["private_subnet_tags"] = stack.private_subnet_tags

    if stack.get_attr("enable_nat_gateway"):
        arguments["enable_nat_gateway"] = stack.enable_nat_gateway

    if stack.get_attr("single_nat_gateway"):
        arguments["single_nat_gateway"] = stack.single_nat_gateway

    if stack.get_attr("enable_dns_hostnames"):
        arguments["enable_dns_hostnames"] = stack.enable_dns_hostnames

    if stack.get_attr("reuse_nat_ips"):
        arguments["reuse_nat_ips"] = stack.reuse_nat_ips

    if stack.get_attr("one_nat_gateway_per_az"):
        arguments["one_nat_gateway_per_az"] = stack.one_nat_gateway_per_az

    if stack.get_attr("aws_default_region"):
        arguments["aws_default_region"] = stack.aws_default_region

    if stack.get_attr("labels"):
        arguments["labels"] = stack.labels

    if stack.get_attr("tags"):
        arguments["tags"] = stack.tags

    if stack.get_attr("publish_to_saas"):
        arguments["publish_to_saas"] = stack.publish_to_saas

    inputargs = {"arguments": arguments}
    inputargs["automation_phase"] = "infrastructure"
    inputargs["human_description"] = 'Creating VPC {}'.format(stack.vpc_name)

    stack.aws_vpc.insert(display=True, **inputargs)

    # Add security groups
    arguments = {"vpc_name": stack.vpc_name}

    if stack.get_attr("tier_level"):
        arguments["tier_level"] = stack.tier_level

    if stack.get_attr("aws_default_region"):
        arguments["aws_default_region"] = stack.aws_default_region

    if stack.get_attr("labels"):
        arguments["labels"] = stack.labels

    if stack.get_attr("tags"):
        arguments["tags"] = stack.tags

    inputargs = {"arguments": arguments}
    inputargs["automation_phase"] = "infrastructure"
    inputargs["human_description"] = 'Creating security groups for VPC {}'.format(
        stack.vpc_name)

    stack.aws_sg.insert(display=True, **inputargs)

    return stack.get_results()

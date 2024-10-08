def run(stackargs):

    # instantiate stack
    stack = newStack(stackargs)

    # add variables
    stack.parse.add_required(key="vpc_name",
                             types="str")

    stack.parse.add_optional(key="vpc_id",
                             types="str",
                             default="null")

    # init the stack namespace
    stack.init_variables()

    # get vpc info - this is a bit dangerous b/c it assumes each vpc_name is unique
    if not stack.get_attr("vpc_id"):
        vpc_id = stack.get_resource(name=stack.vpc_name,
                                    resource_type="vpc",
                                    must_exists=True)[0]["vpc_id"]

        stack.set_variable("vpc_id", vpc_id)

    # get subnet info
    _lookup = {
        "provider": "aws",
        "resource_type": "subnet",
        "vpc_id": stack.vpc_id,
        "search_keys": "vpc_id"
    }

    subnets_info = stack.get_resource(**_lookup)

    if not subnets_info:
        stack.logger.error("subnets not found to publish")

    # get security group info
    _lookup = {
        "provider": "aws",
        "resource_type": "security_group",
        "vpc_id": stack.vpc_id,
        "search_keys": "vpc_id"
    }

    security_groups = stack.get_resource(**_lookup)

    if not security_groups:
        stack.logger.error("security_groups not found to publish")

    publish_info = {"vpc_id": stack.vpc_id}

    if security_groups:

        for security_group in security_groups:

            if not security_group.get("sg_id"):
                continue

            if not security_group.get("name"):
                continue

            _name = "security_group:{}".format(security_group["name"])

            publish_info[security_group["sg_id"]] = _name

    if subnets_info:

        for subnet_info in subnets_info:

            if not subnet_info.get("subnet_id"):
                continue

            if not subnet_info.get("name"):
                continue

            _name = "environment:{}".format(subnet_info["name"])
            publish_info[subnet_info["subnet_id"]] = _name

    stack.publish(publish_info)

    return stack.get_results()



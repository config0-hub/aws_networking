import json
from config0_publisher.terraform import TFConstructor


def run(stackargs):

    # instantiate authoring stack
    stack = newStack(stackargs)

    # Add default variables
    stack.parse.add_required(key="vpc_name",
                             tags="tfvar,db,resource",
                             types="str")

    stack.parse.add_required(key="tier_level",
                             default="3",
                             types="str")

    stack.parse.add_optional(key="vpc_id",
                             tags="tfvar,resource",
                             types="str",
                             default="null")

    stack.parse.add_optional(key="aws_default_region",
                             default="eu-west-1",
                             tags="tfvar,db,resource,tf_exec_env",
                             types="str")

    # Add execgroup
    stack.add_execgroup("config0-publish:::aws_networking::sg_3tier")
    stack.add_execgroup("config0-publish:::aws_networking::sg_2tier")

    # Add substack
    stack.add_substack('config0-publish:::tf_executor')
    stack.add_substack('config0-publish:::parse_terraform')

    # Initialize
    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    # get vpc info - this is a bit dangerous b/c it assumes each vpc_name is unique
    if not stack.vpc_id:
        vpc_id = stack.get_resource(name=stack.vpc_name,
                                    resource_type="vpc",
                                    must_exists=True)[0]["vpc_id"]

        # set variables
        stack.set_variable("vpc_id", vpc_id,
                           tags="tfvar,resource",
                           types="str")

    stack.set_variable("tf_main_name", "{}-security-group-tf".format(stack.vpc_name),
                       tags="tfvar,resource",
                       types="str")

    stack.set_variable("_id", "sg-main-{}".format(stack.get_hash_object([stack.tf_main_name,
                                                                         stack.vpc_id])[0:7]),
                       tags="resource",
                       types="str")

    if str(stack.tier_level) == "2":
        stack.set_variable("tf_execgroup_name", stack.sg_2tier.name)
    else:
        stack.set_variable("tf_execgroup_name", stack.sg_3tier.name)

    stack.set_variable("timeout",600)

    # use the terraform constructor (helper)
    # but this is optional
    tf = TFConstructor(stack=stack,
                       execgroup_name=stack.tf_execgroup_name,
                       provider="aws",
                       resource_name="{}-security-group-tf".format(
                           stack.vpc_name),
                       resource_type="security_group",
                       terraform_type="aws_security_group")

    tf.include(maps={"name": "tf_main_name",
                     "region": "aws_default_region",
                     "vpc": "vpc_name",
                     "id": "tf_main_name"})

    tf.output(keys=["tf_main_name",
                    "arn"])

    # finalize the tf_executor
    stack.tf_executor.insert(display=True,
                             **tf.get())

    # parse terraform and insert security_group
    arguments = {
        "src_resource_type": "security_group",
        "src_provider": "aws",
        "src_resource_name": stack.tf_main_name,
        "dst_prefix_name": stack.vpc_name,
        "dst_resource_type": "security_group",
        "dst_terraform_type": "aws_security_group",
        "mapping": json.dumps({"id": "sg_id"}),
        "must_exists": True,
        "aws_default_region": stack.aws_default_region,
        "add_values": json.dumps({
            "vpc": stack.vpc_name
        })
    }

    inputargs = {
        "arguments": arguments,
        "automation_phase": "infrastructure",
        "human_description": "Parse Terraform for {}".format(
                     "aws_security_group"),
        "display": True}

    inputargs["display_hash"] = stack.get_hash_object(inputargs)

    stack.parse_terraform.insert(**inputargs)

    return stack.get_results()



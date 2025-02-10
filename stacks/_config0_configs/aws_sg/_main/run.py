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

    # Add substack
    stack.add_substack('config0-publish:::tf_executor')

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

    stack.set_variable("timeout",600)

    # use the terraform constructor (helper)
    # but this is optional
    tf = TFConstructor(
        stack=stack,
        tf_runtime="tofu:1.8.8",
        execgroup_name=stack.sg_3tier.name,
        provider="aws",
        resource_name=f"{stack.vpc_name}-security-groups",
        resource_type="security_group")

    tf.include(values={
        "aws_default_region":stack.aws_default_region,
        "name":f"{stack.vpc_name}-security-groups",
        "vpc_id":stack.vpc_id,
        "vpc":stack.vpc_name,
        "vpc_name":stack.vpc_name
    })

    # publish the info
    tf.output(keys=["aws_default_region",
                    "vpc_name",
                    "bastion_sg_id",
                    "web_sg_id",
                    "api_sg_id",
                    "db_sg_id",
                    "vpc_id"])

    # finalize the tf_executor
    stack.tf_executor.insert(display=True,
                             **tf.get())

    return stack.get_results()



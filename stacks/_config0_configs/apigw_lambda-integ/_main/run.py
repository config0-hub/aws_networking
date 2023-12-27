from config0_publisher.terraform import TFConstructor

# lookup lambda execution arn


def _get_lambda_arn(stack):

    _lookup = {"must_exists": True}
    _lookup["resource_type"] = "aws_lambda"
    _lookup["name"] = stack.lambda_name
    _lookup["region"] = stack.aws_default_region

    return list(stack.get_resource(**_lookup))[0]["invoke_arn"]


def run(stackargs):

    # instantiate authoring stack
    stack = newStack(stackargs)

    stack.parse.add_required(key="apigateway_name",
                             tags="tfvar,db",
                             types="str")

    stack.parse.add_required(key="lambda_name",
                             tags="tfvar,db",
                             types="str")

    stack.parse.add_optional(key="stage",
                             default="v1",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="aws_default_region",
                             default="eu-west-1",
                             tags="tfvar,db,resource,runtime_settings",
                             types="str")

    # Add execgroup
    stack.add_execgroup(
        "config0-hub:::aws_networking::apigw_lambda-integ", "tf_execgroup")

    # Add substack
    stack.add_substack('config0-hub:::tf_executor')

    # Initialize
    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    stack.set_variable("lambda_invoke_arn", _get_lambda_arn(stack),
                       tags="tfvar",
                       types="str")

    # use the terraform constructor (helper)
    # but this is optional
    tf = TFConstructor(stack=stack,
                       execgroup_name=stack.tf_execgroup.name,
                       provider="aws",
                       resource_name=stack.apigateway_name,
                       resource_type="apigateway_restapi_lambda",
                       terraform_type="aws_api_gateway_rest_api")

    tf.include(keys=["name",
                     "arn",
                     "description",
                     "execution_arn",
                     "root_resource_id",
                     "id"])

    tf.include(maps={"gateway_id": "arn"})

    tf.output(keys=["name",
                    "arn",
                    "execution_arn",
                    "root_resource_id",
                    "id"])

    # finalize the tf_executor
    stack.tf_executor.insert(display=True,
                             **tf.get())

    return stack.get_results()

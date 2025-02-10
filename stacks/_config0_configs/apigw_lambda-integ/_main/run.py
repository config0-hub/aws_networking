from config0_publisher.terraform import TFConstructor

# lookup lambda execution arn
def _get_lambda_arn(stack):

    _lookup = {
        "must_exists": True,
        "resource_type": "aws_lambda",
        "name": stack.lambda_name,
        "region": stack.aws_default_region }

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
                             tags="tfvar,db,resource,tf_exec_env",
                             types="str")

    # Add execgroup
    stack.add_execgroup(
        "config0-publish:::aws_networking::apigw_lambda-integ", "tf_execgroup")

    # Add substack
    stack.add_substack('config0-publish:::tf_executor')

    # Initialize
    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    stack.set_variable("lambda_invoke_arn",
                       _get_lambda_arn(stack),
                       tags="tfvar",
                       types="str")

    stack.set_variable("timeout",600)

    # use the terraform constructor (helper)
    # but this is optional
    tf = TFConstructor(stack=stack,
                       execgroup_name=stack.tf_execgroup.name,
                       provider="aws",
                       resource_name=stack.apigateway_name,
                       resource_type="apigateway_restapi_lambda")

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
"""
Copyright (C) 2025 Gary Leong <gary@config0.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

from config0_publisher.terraform import TFConstructor


def _get_lambda_arn(stack):
    """Lookup lambda execution ARN by name and region."""
    _lookup = {
        "must_exists": True,
        "resource_type": "aws_lambda",
        "name": stack.lambda_name,
        "region": stack.aws_default_region
    }

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

    stack.set_variable("timeout", 600)

    # Use the terraform constructor (helper)
    tf = TFConstructor(stack=stack,
                       execgroup_name=stack.tf_execgroup.name,
                       provider="aws",
                       resource_name=stack.apigateway_name,
                       resource_type="apigateway_restapi_lambda")

    tf.include(values={
        "aws_default_region": stack.aws_default_region,
        "name": stack.apigateway_name
    })

    tf.output(keys=["base_url", "arn"])

    # Finalize the tf_executor
    stack.tf_executor.insert(display=True,
                             **tf.get())

    return stack.get_results()
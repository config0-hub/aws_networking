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


def run(stackargs):
    stack = newStack(stackargs)

    stack.parse.add_required(key="vpc_peering_name",
                             tags="tfvar,db",
                             types="str")
    stack.parse.add_required(key="vpc_b_name",
                             tags="tfvar,db",
                             types="str")
    stack.parse.add_optional(key="vpc_b_cidr_block",
                             default="10.21.0.0/16",
                             tags="tfvar,db",
                             types="str")
    stack.parse.add_required(key="vpc_a_id",
                             tags="tfvar",
                             types="str")
    stack.parse.add_required(key="vpc_a_account_id",
                             tags="tfvar",
                             types="str")
    stack.parse.add_required(key="vpc_a_region",
                             tags="tfvar",
                             types="str")
    stack.parse.add_optional(key="aws_default_region",
                             default="eu-west-1",
                             tags="tfvar,db,resource,tf_exec_env",
                             types="str")

    stack.add_execgroup("config0-hub:::aws_networking::vpc_peering_request",
                        "tf_execgroup")
    stack.add_substack("config0-hub:::config0_core::tf_executor")

    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    stack.set_variable("timeout", 600)

    tf = TFConstructor(
        stack=stack,
        execgroup_name=stack.tf_execgroup.name,
        provider="aws",
        tf_runtime="tofu:1.10.6",
        resource_name=stack.vpc_peering_name,
        resource_type="vpc_peering_request",
    )

    tf.include(
        keys=[
            "vpc_b_id",
            "vpc_b_cidr_block",
            "vpc_b_route_table_id",
            "vpc_a_id",
            "vpc_a_cidr_block",
            "vpc_a_account_id",
            "vpc_a_region",
            "vpc_peering_connection_id",
            "vpc_peering_status",
        ],
        values={
            "aws_default_region": stack.aws_default_region,
            "name": stack.vpc_peering_name,
            "vpc_peering_name": stack.vpc_peering_name,
            "vpc_b_name": stack.vpc_b_name,
            "labels": {
                "provider": "aws",
                "component": "vpc-peering-request",
            },
        },
    )
    tf.output(keys=[
        "vpc_b_id",
        "vpc_b_cidr_block",
        "vpc_b_route_table_id",
        "vpc_a_id",
        "vpc_a_cidr_block",
        "vpc_a_account_id",
        "vpc_a_region",
        "vpc_peering_connection_id",
        "vpc_peering_status",
    ])

    stack.tf_executor.insert(display=True, **tf.get())

    return stack.get_results()

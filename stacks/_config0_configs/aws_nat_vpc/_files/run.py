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

    # instantiate authoring stack
    stack = newStack(stackargs)

    stack.parse.add_required(key="nat_gateway_name",
                             tags="tfvar",
                             types="str")

    # the nat needs to be attached to a public subnet
    stack.parse.add_required(key="public_subnet_ids",
                             types="str")

    # the route table is private one - not public - a bit nuanced
    stack.parse.add_required(key="private_route_table_id",
                             tags="tfvar",
                             types="str")

    stack.parse.add_optional(key="aws_default_region",
                             default="eu-west-1",
                             tags="tfvar,db,resource,tf_exec_env",
                             types="str")

    # add execgroup
    stack.add_execgroup("config0-publish:::aws_networking::natgw_vpc",
                        "tf_execgroup")

    # add substack
    stack.add_substack("config0-publish:::tf_executor")

    # initialize
    stack.init_variables()
    stack.init_execgroups()
    stack.init_substacks()

    stack.set_variable("timeout", 600)

    stack.set_variable("public_subnet_id",
                       sorted(stack.to_list(stack.public_subnet_ids))[0],
                       tags="tfvar",
                       types="str")

    tf = TFConstructor(stack=stack,
                       execgroup_name=stack.tf_execgroup.name,
                       provider="aws",
                       resource_name=stack.nat_gateway_name,
                       resource_type="nat_gateway")

    tf.include(values={
        "aws_default_region": stack.aws_default_region,
        "name": stack.nat_gateway_name,
        "nat_gateway_name": stack.nat_gateway_name,
    })

    tf.output(keys=["connectivity_type",
                    "network_interface_id",
                    "private_ip",
                    "public_ip",
                    "allocation_id"])

    # finalize the tf_executor
    stack.tf_executor.insert(display=True,
                             **tf.get())

    return stack.get_results()
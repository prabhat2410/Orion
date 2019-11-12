# -*- coding: utf-8 -*-

# Copyright 2015 Telefonica Investigacion y Desarrollo, S.A.U
#
# This file is part of Orion Context Broker.
#
# Orion Context Broker is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Orion Context Broker is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.
#
# For those usages not covered by this license please contact with
# iot_support at tid dot es
#
# author: 'Iván Arias León (ivan dot ariasleon at telefonica dot com)'

#
#  Note: the "skip" tag is to skip the scenarios that still are not developed or failed:
#        -t=-skip
#        the "too_slow" tag is used to mark scenarios that running are too slow, if would you like to skip these scenarios:
#        -t=-too_slow


Feature: list all entities with get request and queries parameters using NGSI v2. "GET" - /v2/entities/
  Queries parameters
  tested : q
  pending: mq
  As a context broker user
  I would like to list all entities with get request and queries parameter using NGSI v2
  So that I can manage and use them in my scripts

  Actions Before the Feature:
  Setup: update properties test file from "epg_contextBroker.txt" and sudo local "false"
  Setup: update contextBroker config file
  Setup: start ContextBroker
  Check: verify contextBroker is installed successfully
  Check: verify mongo is installed successfully

  Actions After each Scenario:
  Setup: delete database in mongo

  Actions After the Feature:
  Setup: stop ContextBroker

  # ------------------ queries parameters -------------------------------
  # --- q = <expression> ---
  @only_q_attribute @BUG_1589 @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with only q=attribute query parameter
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_id      | room3       |
      | attributes_name  | temperature |
      | attributes_value | 34          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room4l2     |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | vehicle   |
      | entities_id      | car       |
      | attributes_name  | speed     |
      | attributes_value | 89        |
      | attributes_type  | km_h      |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value  |
      | entities_id      | garden |
      | attributes_name  | roses  |
      | attributes_value | red    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | options   | count          |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | returned |
      | myAttr            | 0        |
      | !myAttr           | 19       |
      | roses             | 1        |
      | !speed;!timestamp | 14       |
      | temperature       | 13       |

  @only_q_parse_error @BUG_1592 @BUG_1754 @ISSUE_1751
  Scenario Outline:  try to list entities using NGSI v2 with only q query parameter but with parse errors
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value     |
      | entities_type    | vehicle   |
      | entities_id      | car       |
      | attributes_name  | speed     |
      | attributes_value | 89        |
      | attributes_type  | km_h      |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value         |
      | error       | BadRequest    |
      | description | <description> |
    Examples:
      | q_expression | description                     |
      | speed==      | empty right-hand-side in q-item |
      | speed!=      | empty right-hand-side in q-item |
      | speed>=      | empty right-hand-side in q-item |
      | speed<=      | empty right-hand-side in q-item |
      | speed>       | empty right-hand-side in q-item |
      | speed<       | empty right-hand-side in q-item |
    Examples:
      | q_expression | description                    |
      | ==speed      | empty left-hand-side in q-item |
      | !=speed      | empty left-hand-side in q-item |
      | >=speed      | empty left-hand-side in q-item |
      | <=speed      | empty left-hand-side in q-item |
      | >speed       | empty left-hand-side in q-item |
      | <speed       | empty left-hand-side in q-item |

  @only_q_value_boolean @BUG_1594
  Scenario Outline:  list entities using NGSI v2 with only q=attr==true query parameter (boolean values)
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | 34          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value             |
      | entities_type    | "vehicle"         |
      | entities_id      | "car"             |
      | attributes_name  | "temperature"     |
      | attributes_value | <attribute_value> |
    And create an entity in raw and "normalized" modes
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
    Then verify that receive an "OK" http code
    And verify that "1" entities are returned
    Examples:
      | q_expression       | attribute_value |
      | temperature==true  | true            |
      | temperature==false | false           |

  @only_q_string_numbers @BUG_1595
  Scenario Outline:  list entities using NGSI v2 with only q=attr=="89" query parameter (number in string)
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value     |
      | entities_type    | vehicle   |
      | entities_id      | car       |
      | attributes_name  | speed     |
      | attributes_value | 89        |
      | attributes_type  | km_h      |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And properties to entities
      | parameter        | value     |
      | entities_type    | "vehicle" |
      | entities_id      | "moto"    |
      | attributes_name  | "speed"   |
      | attributes_value | 89        |
    And create an entity in raw and "normalized" modes
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression | returned |
      | speed=='89'  | 5        |
      | speed==89    | 1        |

  @only_q_operators_errors @BUG_1607
  Scenario Outline:  try to list entities using NGSI v2 with only q query parameter, with range, but wrong operators
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value     |
      | entities_type    | vehicle   |
      | entities_id      | car       |
      | attributes_name  | speed     |
      | attributes_value | 89        |
      | attributes_type  | km_h      |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | "vehicle" |
      | entities_id      | "moto"    |
      | attributes_name  | "speed"   |
      | attributes_value | 89        |
    And create an entity in raw and "normalized" modes
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    And get all entities
      | parameter | value          |
      | q         | <q_expression> |
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                               |
      | error       | BadRequest                          |
      | description | ranges only valid for == and != ops |
    Examples:
      | q_expression  |
      | speed>=69..90 |
      | speed>69..90  |
      | speed<=69..79 |
      | speed<99..190 |

  @only_q @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with only q query parameter with several statements
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | 34          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | vehicle   |
      | entities_id      | bus       |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value  |
      | entities_id      | garden |
      | attributes_name  | roses  |
      | attributes_value | red    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "car"   |
      | attributes_name  | "speed" |
      | attributes_value | 79.2    |
    And create an entity in raw and "normalized" modes
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | home      |
      | entities_id      | bathroom  |
      | attributes_name  | humidity  |
      | attributes_value | high      |
      | attributes_type  | celsius   |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | home      |
      | entities_id      | kitchen   |
      | attributes_name  | humidity  |
      | attributes_value | medium    |
      | attributes_type  | celsius   |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | simple  |
      | attributes_name  | comma   |
      | attributes_value | one,two |
      | attributes_type  | celsius |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | options   | count          |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression                      | returned |
      | !myAttr                           | 20       |
      | myAttr                            | 0        |
      | speed                             | 2        |
      | speed==89.6                       | 1        |
      | speed==89.6;!myAttr               | 1        |
      | speed!=99.6                       | 2        |
      | speed>=89.6                       | 1        |
      | speed<=89.6                       | 2        |
      | speed<89.6                        | 1        |
      | speed>79.6                        | 1        |
      | speed!=99.6;!myAttr               | 2        |
      | speed<=89.6;!myAttr               | 2        |
      | speed<89.6                        | 1        |
      | speed>79.6                        | 1        |
      | speed!=23..56                     | 2        |
      | speed!=90..100                    | 2        |
      | speed==79..90                     | 2        |
      | speed==79..85                     | 1        |
      | speed!=23..56;!myAttr             | 2        |
      | speed!=23..56;myAttr              | 0        |
      | speed!=90..100;!myAttr            | 2        |
      | speed==79..90                     | 2        |
      | speed==79..85;!myAttr             | 1        |
      | humidity==high,low,medium         | 8        |
      | humidity!=high,low                | 3        |
      | humidity==high                    | 5        |
      | humidity!=high                    | 3        |
      | humidity==high,low,medium;!myAttr | 8        |
      | humidity!=high,low;!myAttr        | 3        |
      | humidity==high;!myAttr            | 5        |
      | humidity!=high;!myAttr            | 3        |
      | humidity!=high;myAttr             | 0        |
      | comma=='one,two',high             | 5        |
      | comma!='three,four',high          | 5        |
      | comma=='one,two',high;!myAttr     | 5        |
      | comma=='one,two';!myAttr          | 5        |

  @qp_q_and_limit @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with q and limit queries parameters
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | high        |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_id      | bus       |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "6" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | limit     | <limit>        |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | limit | returned |
      | !my_attr          | 3     | 3        |
      | seats             | 5     | 5        |
      | speed==89.6       | 3     | 1        |
      | speed!=79.6       | 8     | 1        |
      | speed<23          | 3     | 0        |
      | speed>99.6        | 8     | 0        |
      | speed==89..90     | 3     | 1        |
      | speed!=79..80     | 8     | 1        |
      | temperature==high | 2     | 2        |
      | temperature!=low  | 9     | 8        |

  @qp_q_and_offset @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with q and offset queries parameters
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | high        |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_id      | bus       |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | offset    | <offset>       |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | offset | returned |
      | !my_attr          | 8      | 8        |
      | seats             | 2      | 3        |
      | speed==89.6       | 3      | 0        |
      | speed!=79.6       | 0      | 1        |
      | speed<23          | 3      | 0        |
      | speed>99.6        | 8      | 0        |
      | speed==89..90     | 1      | 0        |
      | speed!=79..80     | 0      | 1        |
      | temperature==high | 2      | 3        |
      | temperature!=low  | 0      | 10       |

  @qp_q_limit_and_offset @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with q, limit and offset queries parameters
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | high        |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_id      | bus       |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    And record entity group
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | limit     | <limit>        |
      | offset    | <offset>       |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | offset | limit | returned |
      | !my_attr          | 3      | 6     | 6        |
      | seats             | 2      | 8     | 3        |
      | speed==89.6       | 3      | 3     | 0        |
      | speed!=79.6       | 0      | 8     | 1        |
      | speed<23          | 3      | 3     | 0        |
      | speed>99.6        | 0      | 1     | 0        |
      | speed==89..90     | 0      | 3     | 1        |
      | speed!=79..80     | 8      | 8     | 0        |
      | temperature==high | 2      | 2     | 2        |
      | temperature!=low  | 0      | 9     | 9        |

  @qp_q_limit_offset_and_id @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with q, limit offset and id queries parameters
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | high        |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_id      | bus       |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | limit     | <limit>        |
      | offset    | <offset>       |
      | id        | <id>           |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | offset | limit | id      | returned |
      | !my_attr          | 3      | 3     | bus_2   | 0        |
      | seats             | 0      | 8     | bus_3   | 1        |
      | speed==89.6       | 0      | 3     | moto    | 1        |
      | speed!=79.6       | 8      | 8     | car     | 0        |
      | speed<23          | 3      | 3     | moto    | 0        |
      | speed>99.6        | 8      | 8     | moto    | 0        |
      | speed==89..90     | 1      | 3     | moto    | 0        |
      | speed==89..90     | 0      | 3     | moto    | 1        |
      | speed!=79..80     | 8      | 8     | moto    | 0        |
      | temperature==high | 0      | 2     | room1_0 | 1        |
      | temperature!=low  | 0      | 9     | room2_1 | 1        |

  @qp_q_limit_offset_and_type @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with q, limit offset and type queries parameters
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | high        |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_id      | bus       |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | "vehicle" |
      | entities_id      | "moto"    |
      | attributes_name  | "speed"   |
      | attributes_value | 89.6      |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | limit     | <limit>        |
      | offset    | <offset>       |
      | type      | <type>         |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | offset | limit | type    | returned |
      | !my_attr          | 3      | 3     | house   | 2        |
      | seats             | 0      | 1     | house   | 0        |
      | speed==89.6       | 0      | 3     | vehicle | 1        |
      | speed!=79.6       | 8      | 8     | vehicle | 0        |
      | speed<23          | 3      | 3     | vehicle | 0        |
      | speed>99.6        | 8      | 8     | vehicle | 0        |
      | speed==89..90     | 0      | 3     | vehicle | 1        |
      | speed!=79..80     | 8      | 8     | vehicle | 0        |
      | temperature==high | 0      | 2     | home    | 2        |
      | temperature!=low  | 9      | 9     | home    | 0        |

  @qp_q_limit_offset_id_and_type @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with q, limit offset, id and type queries parameters
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | high        |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_id      | bus       |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | "vehicle" |
      | entities_id      | "moto"    |
      | attributes_name  | "speed"   |
      | attributes_value | 89.6      |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | limit     | <limit>        |
      | offset    | <offset>       |
      | id        | <id>           |
      | type      | <type>         |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | offset | limit | type    | id      | returned |
      | !my_attr          | 0      | 3     | house   | bus_2   | 0        |
      | seats             | 0      | 1     | house   | bus     | 0        |
      | speed==89.6       | 0      | 3     | vehicle | moto    | 1        |
      | speed!=79.6       | 2      | 8     | vehicle | moto    | 0        |
      | speed<23          | 3      | 3     | vehicle | moto    | 0        |
      | speed>99.6        | 8      | 8     | vehicle | moto    | 0        |
      | speed==89..90     | 3      | 3     | vehicle | car     | 0        |
      | speed!=79..80     | 0      | 8     | vehicle | moto    | 1        |
      | temperature==high | 0      | 1     | home    | room1_1 | 1        |
      | temperature!=low  | 9      | 9     | home    | room1_3 | 0        |

  @qp_q_limit_offset_idpattern_and_type @ISSUE_1751
  Scenario Outline:  list entities using NGSI v2 with q, limit offset, idPattern and type queries parameters
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | home        |
      | entities_id      | room1       |
      | attributes_name  | temperature |
      | attributes_value | high        |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room3       |
      | attributes_name  | temperature |
      | attributes_value | 78          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | random=10   |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_id      | room4     |
      | attributes_name  | seats     |
      | attributes_value | 37        |
      | metadatas_number | 2         |
      | metadatas_name   | very_hot  |
      | metadatas_type   | alarm     |
      | metadatas_value  | random=10 |
    And create entity group with "5" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value   |
      | entities_id      | "moto"  |
      | attributes_name  | "speed" |
      | attributes_value | 89.6    |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value     |
      | entities_type    | "vehicle" |
      | entities_id      | "moto"    |
      | attributes_name  | "speed"   |
      | attributes_value | 89.6      |
    And create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | limit     | <limit>        |
      | offset    | <offset>       |
      | idPattern | <idPattern>    |
      | type      | <type>         |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression      | offset | limit | type    | idPattern    | returned |
      | !my_attr          | 3      | 3     | house   | ^r.*         | 3        |
      | seats             | 0      | 1     | house   | .*us.*       | 0        |
      | speed==89.6       | 0      | 3     | vehicle | .*to$        | 1        |
      | speed!=79.6       | 8      | 8     | vehicle | ^mo+.*       | 0        |
      | speed<23          | 3      | 3     | vehicle | [A-Za-z0-9]* | 0        |
      | speed>99.6        | 8      | 8     | vehicle | \w*          | 0        |
      | speed==89..90     | 0      | 3     | vehicle | mo(to)       | 1        |
      | speed!=79..80     | 0      | 8     | vehicle | mo(\w)       | 1        |
      | temperature==high | 0      | 2     | home    | .*           | 2        |
      | temperature!=low  | 9      | 9     | home    | \a*          | 0        |

  @only_q_attribute_datetime  @ISSUE_2632
  Scenario Outline:  list entities using NGSI v2 with only q query parameter using datetime processing
    Given  a definition of headers
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
      | Content-Type       | application/json |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value                   |
      | entities_id      | room1                   |
      | attributes_name  | timestamp               |
      | attributes_value | 2016-11-01T19:00:00.00Z |
      | attributes_type  | DateTime                |
      | metadatas_name   | too_late                |
      | metadatas_type   | alarm                   |
      | metadatas_value  | night                   |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                        |
      | entities_type    | house                        |
      | entities_id      | room2                        |
      | attributes_name  | timestamp                    |
      | attributes_value | 2016-11-02T19:00:00.00+01:00 |
      | attributes_type  | DateTime                     |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                        |
      | entities_type    | home                         |
      | entities_id      | room3                        |
      | attributes_name  | timestamp                    |
      | attributes_value | 2016-11-02T19:00:00.00-02:00 |
      | attributes_type  | DateTime                     |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_type    | home                        |
      | entities_id      | room4                       |
      | attributes_name  | timestamp                   |
      | attributes_value | 2017-11-02T01:00:00.00+0100 |
      | attributes_type  | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_type    | home                        |
      | entities_id      | room5                       |
      | attributes_name  | timestamp                   |
      | attributes_value | 2017-11-02T19:00:00.00-0200 |
      | attributes_type  | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_type    | home                        |
      | entities_id      | room6                       |
      | attributes_name  | timestamp                   |
      | attributes_value | 2017-11-02T19:34:00.00-0200 |
      | attributes_type  | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_type    | home                        |
      | entities_id      | room7                       |
      | attributes_name  | timestamp                   |
      | attributes_value | 2017-11-02T19:34:45.00-0200 |
      | attributes_type  | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value            |
      | Fiware-Service     | test_list_only_q |
      | Fiware-ServicePath | /test            |
    When get all entities
      | parameter | value          |
      | q         | <q_expression> |
      | options   | count          |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression                   | returned |
      | timestamp>2015-11-02           | 7        |
      | timestamp<2017-10-02           | 3        |
      | timestamp:2017-11-02           | 1        |
      | timestamp:2017-11-02T21        | 1        |
      | timestamp:2017-11-02T21:34     | 1        |
      | timestamp>2017-11-02T21:34:44  | 1        |
      | timestamp:2017-11-02T2134      | 1        |
      | timestamp>2017-11-02T213444    | 1        |
      | timestamp>2017-11-02T21:34:44Z | 1        |

  @q_regexp @BUG_2226
  Scenario Outline: list entities using NGSI v2 with q and regular expression
    Given  a definition of headers
      | parameter          | value                   |
      | Fiware-Service     | test_list_only_q_regexp |
      | Fiware-ServicePath | /test                   |
      | Content-Type       | application/json        |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value                    |
      | entities_type    | "random=4"               |
      | entities_id      | "room1"                  |
      | attributes_name  | "temperature"&"humidity" |
      | attributes_value | 34&101                   |
      | attributes_type  | "celsius"&"absolute"     |
      | metadatas_name   | "very_high"              |
      | metadatas_type   | "alarm"                  |
      | metadatas_value  | "high"                   |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                 |
      | entities_type    | "random=4"            |
      | entities_id      | "room2"               |
      | attributes_name  | "pressure"&"humidity" |
      | attributes_value | 989&"101"             |
      | attributes_type  | "bar"                 |
      | metadatas_name   | "very_hard"           |
      | metadatas_type   | "alarm"               |
      | metadatas_value  | "high"                |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value              |
      | entities_type    | "random=4"         |
      | entities_id      | "room3"            |
      | attributes_name  | "speed"&"humidity" |
      | attributes_value | 80&103             |
      | attributes_type  | "kmh"              |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value              |
      | entities_type    | "random=4"         |
      | entities_id      | "room4"            |
      | attributes_name  | "speed"&"humidity" |
      | attributes_value | 80&"absolute"      |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    # the "X-Auth-Token" header is passed internally from previous step
    And modify headers and keep previous values "false"
      | parameter          | value                   |
      | Fiware-Service     | test_list_only_q_regexp |
      | Fiware-ServicePath | /test                   |
    Then get all entities
      | parameter | value          |
      | options   | count          |
      | q         | <q_expression> |
    And verify that receive a "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | q_expression   | returned |
      | humidity~=100  | 0        |
      | humidity~=101  | 1        |
      | humidity~=abso | 1        |

  @q_regexp_error @BUG_2226
  Scenario Outline: list entities using NGSI v2 with q and regular expression
    Given  a definition of headers
      | parameter          | value                   |
      | Fiware-Service     | test_list_only_q_regexp |
      | Fiware-ServicePath | /test                   |
      | Content-Type       | application/json        |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value                    |
      | entities_type    | "random=4"               |
      | entities_id      | "room1"                  |
      | attributes_name  | "temperature"&"humidity" |
      | attributes_value | 34&101                   |
      | attributes_type  | "celsius"&"absolute"     |
      | metadatas_name   | "very_high"              |
      | metadatas_type   | "alarm"                  |
      | metadatas_value  | "high"                   |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                 |
      | entities_type    | "random=4"            |
      | entities_id      | "room2"               |
      | attributes_name  | "pressure"&"humidity" |
      | attributes_value | 989&"101"             |
      | attributes_type  | "bar"                 |
      | metadatas_name   | "very_hard"           |
      | metadatas_type   | "alarm"               |
      | metadatas_value  | "high"                |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value              |
      | entities_type    | "random=4"         |
      | entities_id      | "room3"            |
      | attributes_name  | "speed"&"humidity" |
      | attributes_value | 80&103             |
      | attributes_type  | "kmh"              |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    # the "X-Auth-Token" header is passed internally from previous step
    And modify headers and keep previous values "false"
      | parameter          | value                   |
      | Fiware-Service     | test_list_only_q_regexp |
      | Fiware-ServicePath | /test                   |
    Then get all entities
      | parameter | value          |
      | options   | count          |
      | q         | <q_expression> |
    And verify that receive a "Bad Request" http code
    And verify an error response
      | parameter   | value                                 |
      | error       | BadRequest                            |
      | description | forbidden characters in String Filter |
    Examples:
      | q_expression      |
      | humidity~="101"   |
      | humidity~="dffdf" |

  # --- mq = <expression> ---

  @only_mq_attribute_datetime  @ISSUE_2632
  Scenario Outline:  list entities using NGSI v2 with only mq query parameter using datetime processing
    Given  a definition of headers
      | parameter          | value             |
      | Fiware-Service     | test_list_only_mq |
      | Fiware-ServicePath | /test             |
      | Content-Type       | application/json  |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value                   |
      | entities_id      | room1                   |
      | attributes_name  | temperature             |
      | attributes_value | 14                      |
      | attributes_type  | celsius                 |
      | metadatas_name   | timestamp               |
      | metadatas_value  | 2016-11-01T19:00:00.00Z |
      | metadatas_type   | DateTime                |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                        |
      | entities_id      | room2                        |
      | attributes_name  | temperature                  |
      | attributes_value | 24                           |
      | attributes_type  | celsius                      |
      | metadatas_name   | timestamp                    |
      | metadatas_value  | 2016-11-02T19:00:00.00+01:00 |
      | metadatas_type   | DateTime                     |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                        |
      | entities_id      | room3                        |
      | attributes_name  | temperature                  |
      | attributes_value | 34                           |
      | attributes_type  | celsius                      |
      | metadatas_name   | timestamp                    |
      | metadatas_value  | 2016-11-02T19:00:00.00-02:00 |
      | metadatas_type   | DateTime                     |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_id      | room4                       |
      | attributes_name  | temperature                 |
      | attributes_value | 44                          |
      | attributes_type  | celsius                     |
      | metadatas_name   | timestamp                   |
      | metadatas_value  | 2017-11-02T01:00:00.00+0100 |
      | metadatas_type   | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_id      | room5                       |
      | attributes_name  | temperature                 |
      | attributes_value | 54                          |
      | attributes_type  | celsius                     |
      | metadatas_name   | timestamp                   |
      | metadatas_value  | 2017-11-02T19:00:00.00-0200 |
      | metadatas_type   | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_id      | room6                       |
      | attributes_name  | temperature                 |
      | attributes_value | 64                          |
      | attributes_type  | celsius                     |
      | metadatas_name   | timestamp                   |
      | metadatas_value  | 2017-11-02T19:34:00.00-0200 |
      | metadatas_type   | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value                       |
      | entities_id      | room7                       |
      | attributes_name  | temperature                 |
      | attributes_value | 74                          |
      | attributes_type  | celsius                     |
      | metadatas_name   | timestamp                   |
      | metadatas_value  | 2017-11-02T19:34:45.00-0200 |
      | metadatas_type   | DateTime                    |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    And record entity group
    And modify headers and keep previous values "false"
      | parameter          | value             |
      | Fiware-Service     | test_list_only_mq |
      | Fiware-ServicePath | /test             |
    When get all entities
      | parameter | value           |
      | mq        | <mq_expression> |
      | options   | count           |
    Then verify that receive an "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | mq_expression                              | returned |
      | temperature.timestamp>2015-11-02           | 7        |
      | temperature.timestamp<2017-10-02           | 3        |
      | temperature.timestamp:2017-11-02           | 1        |
      | temperature.timestamp:2017-11-02T21        | 1        |
      | temperature.timestamp:2017-11-02T21:34     | 1        |
      | temperature.timestamp>2017-11-02T21:34:44  | 1        |
      | temperature.timestamp:2017-11-02T2134      | 1        |
      | temperature.timestamp>2017-11-02T213444    | 1        |
      | temperature.timestamp>2017-11-02T21:34:44Z | 1        |

  @mq_regexp @BUG_2226
  Scenario Outline: list entities using NGSI v2 with mq and regular expression
    Given  a definition of headers
      | parameter          | value                    |
      | Fiware-Service     | test_list_only_mq_regexp |
      | Fiware-ServicePath | /test                    |
      | Content-Type       | application/json         |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | "random=4"  |
      | entities_id      | "room1"     |
      | attributes_name  | "humidity"  |
      | attributes_value | 101         |
      | attributes_type  | "absolute"  |
      | metadatas_name   | "very_high" |
      | metadatas_type   | "alarm"     |
      | metadatas_value  | 101         |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | "random=4"  |
      | entities_id      | "room2"     |
      | attributes_name  | "humidity"  |
      | attributes_value | "101"       |
      | metadatas_name   | "very_high" |
      | metadatas_type   | "alarm"     |
      | metadatas_value  | "101"       |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | "random=4"  |
      | entities_id      | "room3"     |
      | attributes_name  | "humidity"  |
      | attributes_value | 103         |
      | metadatas_name   | "very_high" |
      | metadatas_type   | "alarm"     |
      | metadatas_value  | 103         |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | "random=4"  |
      | entities_id      | "room4"     |
      | attributes_name  | "humidity"  |
      | attributes_value | "absolute"  |
      | metadatas_name   | "very_high" |
      | metadatas_type   | "alarm"     |
      | metadatas_value  | "absolute"  |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    # the "X-Auth-Token" header is passed internally from previous step
    And modify headers and keep previous values "false"
      | parameter          | value                    |
      | Fiware-Service     | test_list_only_mq_regexp |
      | Fiware-ServicePath | /test                    |
    Then get all entities
      | parameter | value           |
      | options   | count           |
      | mq        | <mq_expression> |
    And verify that receive a "OK" http code
    And verify that "<returned>" entities are returned
    Examples:
      | mq_expression            | returned |
      | humidity.very_high~=100  | 0        |
      | humidity.very_high~=101  | 1        |
      | humidity.very_high~=abso | 1        |

  @mq_regexp_error @BUG_2226
  Scenario Outline: list entities using NGSI v2 with mq and regular expression
    Given  a definition of headers
      | parameter          | value                    |
      | Fiware-Service     | test_list_only_mq_regexp |
      | Fiware-ServicePath | /test                    |
      | Content-Type       | application/json         |
    And initialize entity groups recorder
    And properties to entities
      | parameter        | value       |
      | entities_type    | "random=4"  |
      | entities_id      | "room1"     |
      | attributes_name  | "humidity"  |
      | attributes_value | 101         |
      | attributes_type  | "absolute"  |
      | metadatas_name   | "very_high" |
      | metadatas_type   | "alarm"     |
      | metadatas_value  | 101         |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | "random=4"  |
      | entities_id      | "room2"     |
      | attributes_name  | "humidity"  |
      | attributes_value | "101"       |
      | metadatas_name   | "very_high" |
      | metadatas_type   | "alarm"     |
      | metadatas_value  | "101"       |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    And properties to entities
      | parameter        | value       |
      | entities_type    | "random=4"  |
      | entities_id      | "room3"     |
      | attributes_name  | "humidity"  |
      | attributes_value | 103         |
      | metadatas_name   | "very_high" |
      | metadatas_type   | "alarm"     |
      | metadatas_value  | 103         |
    When create an entity in raw and "normalized" modes
    And verify that receive a "Created" http code
    And record entity group
    # the "X-Auth-Token" header is passed internally from previous step
    And modify headers and keep previous values "false"
      | parameter          | value                    |
      | Fiware-Service     | test_list_only_mq_regexp |
      | Fiware-ServicePath | /test                    |
    Then get all entities
      | parameter | value           |
      | options   | count           |
      | mq        | <mq_expression> |
    And verify that receive a "Bad Request" http code
    And verify an error response
      | parameter   | value                                 |
      | error       | BadRequest                            |
      | description | forbidden characters in String Filter |
    Examples:
      | mq_expression     |
      | humidity~="101"   |
      | humidity~="dffdf" |

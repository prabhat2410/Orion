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
#  Note: the "skip" tag is to skip the scenarios that still are not developed or failed
#        -tg=-skip
#

# Missing Tests:
#   - verification of headers response
#   - verification of Special Attribute Types
#


Feature: create entities requests (POST) using NGSI v2. "POST" - /v2/entities/ plus payload and queries parameters
  As a context broker user
  I would like to  create entities requests using NGSI v2
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

   # ---------- attribute name --------------------------------

  @attributes_name @ISSUE_1090
  Scenario Outline:  create entities using NGSI v2 with several attributes names
    Given  a definition of headers
      | parameter          | value                |
      | Fiware-Service     | test_attributes_name |
      | Fiware-ServicePath | /test                |
      | Content-Type       | application/json     |
    And properties to entities
      | parameter        | value             |
      | entities_type    | house             |
      | entities_id      | room              |
      | attributes_name  | <attributes_name> |
      | attributes_value | 34                |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo
    Examples:
      | attributes_name |
      | temperature     |
      | 34              |
      | false           |
      | true            |
      | 34.4E-34        |
      | temp.34         |
      | temp_34         |
      | temp-34         |
      | TEMP34          |
      | house_flat      |
      | house.flat      |
      | house-flat      |
      | house@flat      |
      | random=10       |
      | random=100      |
      | random=256      |

  @attributes_name_not_allowed @ISSUE_1090
  Scenario Outline:  try to create entities using NGSI v2 with several attributes names with not plain ascii
    Given  a definition of headers
      | parameter          | value                |
      | Fiware-Service     | test_attributes_name |
      | Fiware-ServicePath | /test                |
      | Content-Type       | application/json     |
    And properties to entities
      | parameter        | value             |
      | entities_type    | house             |
      | entities_id      | room              |
      | attributes_name  | <attributes_name> |
      | attributes_value | 34                |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                                |
      | error       | BadRequest                           |
      | description | Invalid characters in attribute name |
    Examples:
      | attributes_name |
      | habitación      |
      | españa          |
      | barça           |

  @attributes_name_max_length @ISSUE_1601
  Scenario:  try to create entities using NGSI v2 with an attributes name that exceeds the maximum allowed (256)
    Given  a definition of headers
      | parameter          | value                |
      | Fiware-Service     | test_attributes_type |
      | Fiware-ServicePath | /test                |
      | Content-Type       | application/json     |
    And properties to entities
      | parameter        | value      |
      | entities_type    | house      |
      | entities_id      | room       |
      | attributes_name  | random=257 |
      | attributes_value | 56         |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                                                 |
      | error       | BadRequest                                            |
      | description | attribute name length: 257, max length supported: 256 |

  @attributes_name_error @BUG_1093 @BUG_1200 @BUG_1351 @BUG_1728
  Scenario Outline:  try to create entities using NGSI v2 with several wrong attributes names
    Given  a definition of headers
      | parameter          | value                      |
      | Fiware-Service     | test_attributes_name_error |
      | Fiware-ServicePath | /test                      |
      | Content-Type       | application/json           |
    And properties to entities
      | parameter        | value             |
      | entities_type    | house             |
      | entities_id      | <entities_id>     |
      | attributes_name  | <attributes_name> |
      | attributes_value | 34                |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                                |
      | error       | BadRequest                           |
      | description | Invalid characters in attribute name |
    And verify that entities are not stored in mongo
    Examples:
      | entities_id | attributes_name |
      | room_1      | house<flat>     |
      | room_2      | house=flat      |
      | room_3      | house"flat"     |
      | room_4      | house'flat'     |
      | room_5      | house;flat      |
      | room_6      | house(flat)     |
      | room_7      | house_?         |
      | room_8      | house_&         |
      | room_9      | house_/         |
      | room_10     | house_#         |
      | room_11     | my house        |

  @attributes_name_no_string_error
  Scenario Outline:  try to create an entity using NGSI v2 with several wrong attributes name (integer, boolean, no-string, etc)
    Given  a definition of headers
      | parameter          | value                       |
      | Fiware-Service     | test_attributes_name_error_ |
      | Fiware-ServicePath | /test                       |
      | Content-Type       | application/json            |
    And properties to entities
      | parameter        | value             |
      | entities_type    | "house"           |
      | entities_id      | <entity_id>       |
      | attributes_name  | <attributes_name> |
      | attributes_value | true              |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                |
      | error       | ParseError                           |
      | description | Errors found in incoming JSON buffer |
    Examples:
      | entity_id | attributes_name |
      | "room1"   | rewrewr         |
      | "room2"   | SDFSDFSDF       |
      | "room3"   | false           |
      | "room4"   | true            |
      | "room5"   | 34              |
      | "room6"   | {"a":34}        |
      | "room7"   | ["34", "a", 45] |
      | "room8"   | null            |

  @attributes_name_without
  Scenario:  create entities using NGSI v2 without attributes names
    Given  a definition of headers
      | parameter          | value                        |
      | Fiware-Service     | test_attributes_name_without |
      | Fiware-ServicePath | /test                        |
      | Content-Type       | application/json             |
    And properties to entities
      | parameter     | value |
      | entities_type | house |
      | entities_id   | room  |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo

  @attributes_name_empty
  Scenario:  try to create entities using NGSI v2 with empty attributes names
    Given  a definition of headers
      | parameter          | value                      |
      | Fiware-Service     | test_attributes_name_empty |
      | Fiware-ServicePath | /test                      |
      | Content-Type       | application/json           |
    And properties to entities
      | parameter        | value |
      | entities_type    | house |
      | entities_id      | room  |
      | attributes_name  |       |
      | attributes_value | 34    |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                          |
      | error       | BadRequest                     |
      | description | no 'name' for ContextAttribute |
    And verify that entities are not stored in mongo

  # ---------- attribute value --------------------------------

  @attributes_value
  Scenario Outline:  create entities using NGSI v2 with several attributes values
    Given  a definition of headers
      | parameter          | value                 |
      | Fiware-Service     | test_attributes_value |
      | Fiware-ServicePath | /test                 |
      | Content-Type       | application/json      |
    And properties to entities
      | parameter        | value              |
      | entities_type    | house              |
      | entities_id      | room               |
      | attributes_name  | temperature        |
      | attributes_value | <attributes_value> |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo
    Examples:
      | attributes_value |
      | fsdfsd           |
      | 34               |
      | 34.4E-34         |
      | temp.34          |
      | temp_34          |
      | temp-34          |
      | TEMP34           |
      | house_flat       |
      | house.flat       |
      | house-flat       |
      | house@flat       |
      | habitación       |
      | españa           |
      | barça            |
      | random=10        |
      | random=100       |
      | random=1000      |
      | random=10000     |
      | random=100000    |
      | random=500000    |
      | random=1000000   |

  @attributes_value_wrong @BUG_1093 @BUG_1200
  Scenario Outline:  try to create entities using NGSI v2 with several wrong attributes values
    Given  a definition of headers
      | parameter          | value                       |
      | Fiware-Service     | test_attributes_value_error |
      | Fiware-ServicePath | /test                       |
      | Content-Type       | application/json            |
    And properties to entities
      | parameter        | value              |
      | entities_type    | house              |
      | entities_id      | <entities_id>      |
      | attributes_name  | temperature        |
      | attributes_value | <attributes_value> |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                                 |
      | error       | BadRequest                            |
      | description | Invalid characters in attribute value |
    And verify that entities are not stored in mongo
    Examples:
      | entities_id | attributes_value |
      | room_1      | house<flat>      |
      | room_2      | house=flat       |
      | room_3      | house"flat"      |
      | room_4      | house'flat'      |
      | room_5      | house;flat       |
      | room_6      | house(flat)      |

  @attributes_value_without_attr_value @BUG_1789
  Scenario:  try to create entities using NGSI v2 without attributes values
    Given  a definition of headers
      | parameter          | value                         |
      | Fiware-Service     | test_attributes_value_without |
      | Fiware-ServicePath | /test                         |
      | Content-Type       | application/json              |
    And properties to entities
      | parameter       | value       |
      | entities_type   | house       |
      | entities_id     | room        |
      | attributes_name | temperature |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo

  @attributes_value_without_with_type @BUG_1195 @BUG_1789
  Scenario:  try to create entities using NGSI v2 without attributes values but with attribute type
    Given  a definition of headers
      | parameter          | value                         |
      | Fiware-Service     | test_attributes_value_without |
      | Fiware-ServicePath | /test                         |
      | Content-Type       | application/json              |
    And properties to entities
      | parameter       | value       |
      | entities_type   | house       |
      | entities_id     | room        |
      | attributes_name | temperature |
      | attributes_type | celsius     |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo

  @attributes_value_without_with_metadata @BUG_1195 @BUG_1789
  Scenario:  try to create entities using NGSI v2 without attributes values but with metadata
    Given  a definition of headers
      | parameter          | value                         |
      | Fiware-Service     | test_attributes_value_without |
      | Fiware-ServicePath | /test                         |
      | Content-Type       | application/json              |
    And properties to entities
      | parameter        | value       |
      | entities_type    | room        |
      | entities_id      | room2       |
      | attributes_name  | temperature |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | hot         |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo

  @attributes_value_special @BUG_1106
  Scenario Outline:  create an entity using NGSI v2 with several attributes special values without type (compound, vector, boolean, etc)
    Given  a definition of headers
      | parameter          | value                   |
      | Fiware-Service     | test_attributes_special |
      | Fiware-ServicePath | /test                   |
      | Content-Type       | application/json        |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "house"            |
      | entities_id      | <entity_id>        |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Created" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | "room1"   | true                                                                          |
      | "room2"   | false                                                                         |
      | "room3"   | 34                                                                            |
      | "room4"   | -34                                                                           |
      | "room5"   | 5.00002                                                                       |
      | "room6"   | -5.00002                                                                      |
      | "room7"   | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | "room8"   | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | "room9"   | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | "room10"  | {"x": "x1","x2": "b"}                                                         |
      | "room11"  | {"x": {"x1": "a","x2": "b"}}                                                  |
      | "room12"  | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | "room13"  | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | "room14"  | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | "room15"  | "41.3763726, 2.1864475,14"                                                    |
      | "room16"  | "2017-06-17T07:21:24.238Z"                                                    |
      | "room17"  | null                                                                          |

  @attributes_value_special_type @BUG_1106
  Scenario Outline:  create an entity using NGSI v2 with several attributes special values with type (compound, vector, boolean, etc)
    Given  a definition of headers
      | parameter          | value                             |
      | Fiware-Service     | test_attributes_special_with_type |
      | Fiware-ServicePath | /test                             |
      | Content-Type       | application/json                  |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "house"            |
      | entities_id      | <entity_id>        |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
      | attributes_type  | "example"          |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Created" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | "room1"   | true                                                                          |
      | "room2"   | false                                                                         |
      | "room3"   | 34                                                                            |
      | "room4"   | -34                                                                           |
      | "room5"   | 5.00002                                                                       |
      | "room6"   | -5.00002                                                                      |
      | "room7"   | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | "room8"   | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | "room9"   | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | "room10"  | {"x": "x1","x2": "b"}                                                         |
      | "room11"  | {"x": {"x1": "a","x2": "b"}}                                                  |
      | "room12"  | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | "room13"  | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | "room14"  | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | "room15"  | "41.3763726, 2.1864475,14"                                                    |
      | "room16"  | "2017-06-17T07:21:24.238Z"                                                    |
      | "room17"  | null                                                                          |

  @attributes_value_special_metadata @BUG_1106
  Scenario Outline:  create an entity using NGSI v2 with several attributes special values with metadata (compound, vector, boolean, etc)
    Given  a definition of headers
      | parameter          | value                             |
      | Fiware-Service     | test_attributes_special_with_meta |
      | Fiware-ServicePath | /test                             |
      | Content-Type       | application/json                  |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "house"            |
      | entities_id      | <entity_id>        |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
      | metadatas_name   | "very_hot"         |
      | metadatas_type   | "alarm"            |
      | metadatas_value  | "default"          |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Created" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | "room1"   | true                                                                          |
      | "room2"   | false                                                                         |
      | "room3"   | 34                                                                            |
      | "room4"   | -34                                                                           |
      | "room5"   | 5.00002                                                                       |
      | "room6"   | -5.00002                                                                      |
      | "room7"   | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | "room8"   | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | "room9"   | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | "room10"  | {"x": "x1","x2": "b"}                                                         |
      | "room11"  | {"x": {"x1": "a","x2": "b"}}                                                  |
      | "room12"  | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | "room13"  | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | "room14"  | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | "room15"  | "41.3763726, 2.1864475,14"                                                    |
      | "room16"  | "2017-06-17T07:21:24.238Z"                                                    |
      | "room17"  | null                                                                          |

  @attributes_value_special_type_and_metadata @BUG_1106
  Scenario Outline:  create an entity using NGSI v2 with several attributes special values with type and metadata (compound, vector, boolean, etc)
    Given  a definition of headers
      | parameter          | value                                      |
      | Fiware-Service     | test_attributes_special_with_type_and_meta |
      | Fiware-ServicePath | /test                                      |
      | Content-Type       | application/json                           |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "house"            |
      | entities_id      | <entity_id>        |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
      | attributes_type  | "example"          |
      | metadatas_name   | "very_hot"         |
      | metadatas_type   | "alarm"            |
      | metadatas_value  | "default"          |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Created" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | "room1"   | true                                                                          |
      | "room2"   | false                                                                         |
      | "room3"   | 34                                                                            |
      | "room4"   | -34                                                                           |
      | "room5"   | 5.00002                                                                       |
      | "room6"   | -5.00002                                                                      |
      | "room7"   | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | "room8"   | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | "room9"   | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | "room10"  | {"x": "x1","x2": "b"}                                                         |
      | "room11"  | {"x": {"x1": "a","x2": "b"}}                                                  |
      | "room12"  | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | "room13"  | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | "room14"  | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | "room15"  | "41.3763726, 2.1864475,14"                                                    |
      | "room16"  | "2017-06-17T07:21:24.238Z"                                                    |
      | "room17"  | null                                                                          |

  @attributes_value_wrong_without_type
  Scenario Outline:  try to create an entity using NGSI v2 with several wrong attributes special values without attribute type
    Given  a definition of headers
      | parameter          | value                       |
      | Fiware-Service     | test_attributes_value_error |
      | Fiware-ServicePath | /test                       |
      | Content-Type       | application/json            |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "room"             |
      | entities_id      | <entity_id>        |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                |
      | error       | ParseError                           |
      | description | Errors found in incoming JSON buffer |
    Examples:
      | entity_id | attributes_value |
      | "room_1"  | rwerwer          |
      | "room_2"  | True             |
      | "room_3"  | TRUE             |
      | "room_4"  | False            |
      | "room_5"  | FALSE            |
      | "room_6"  | 34r              |
      | "room_7"  | 5_34             |
      | "room_8"  | ["a", "b"        |
      | "room_9"  | ["a" "b"]        |
      | "room_10" | "a", "b"]        |
      | "room_11" | ["a" "b"}        |
      | "room_12" | {"a": "b"        |
      | "room_13" | {"a" "b"}        |
      | "room_14" | "a": "b"}        |

  @attributes_value_wrong_with_type
  Scenario Outline:  try to create an entity using NGSI v2 with several wrong attributes special values with attribute type
    Given  a definition of headers
      | parameter          | value                            |
      | Fiware-Service     | test_attributes_value_type_error |
      | Fiware-ServicePath | /test                            |
      | Content-Type       | application/json                 |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "room"             |
      | entities_id      | "<entity_id>"      |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
      | attributes_type  | "example"          |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                |
      | error       | ParseError                           |
      | description | Errors found in incoming JSON buffer |
    Examples:
      | entity_id | attributes_value |
      | room_1    | rwerwer          |
      | room_2    | True             |
      | room_3    | TRUE             |
      | room_4    | False            |
      | room_5    | FALSE            |
      | room_6    | 34r              |
      | room_7    | 5_34             |
      | room_8    | ["a", "b"        |
      | room_9    | ["a" "b"]        |
      | room_10   | "a", "b"]        |
      | room_11   | ["a" "b"}        |
      | room_12   | {"a": "b"        |
      | room_13   | {"a" "b"}        |
      | room_14   | "a": "b"}        |

  @attributes_value_wrong_with_metadata
  Scenario Outline:  try to create an entity using NGSI v2 with several wrong attributes special values with metadata
    Given  a definition of headers
      | parameter          | value                            |
      | Fiware-Service     | test_attributes_value_type_error |
      | Fiware-ServicePath | /test                            |
      | Content-Type       | application/json                 |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "room"             |
      | entities_id      | "<entity_id>"      |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
      | metadatas_name   | "very_hot"         |
      | metadatas_type   | "alarm"            |
      | metadatas_value  | "hot"              |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                |
      | error       | ParseError                           |
      | description | Errors found in incoming JSON buffer |
    Examples:
      | entity_id | attributes_value |
      | room_1    | rwerwer          |
      | room_2    | True             |
      | room_3    | TRUE             |
      | room_4    | False            |
      | room_5    | FALSE            |
      | room_6    | 34r              |
      | room_7    | 5_34             |
      | room_8    | ["a", "b"        |
      | room_9    | ["a" "b"]        |
      | room_10   | "a", "b"]        |
      | room_11   | ["a" "b"}        |
      | room_12   | {"a": "b"        |
      | room_13   | {"a" "b"}        |
      | room_14   | "a": "b"}        |

  @attributes_wrong_with_metadata_and_type
  Scenario Outline:  try to create an entity using NGSI v2 with several wrong attributes special values with type and metadata
    Given  a definition of headers
      | parameter          | value                            |
      | Fiware-Service     | test_attributes_value_type_error |
      | Fiware-ServicePath | /test                            |
      | Content-Type       | application/json                 |
    And properties to entities
      | parameter        | value              |
      | entities_type    | "room"             |
      | entities_id      | "<entity_id>"      |
      | attributes_name  | "temperature"      |
      | attributes_value | <attributes_value> |
      | attributes_type  | "example"          |
      | metadatas_name   | "very_hot"         |
      | metadatas_type   | "alarm"            |
      | metadatas_value  | "hot"              |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                |
      | error       | ParseError                           |
      | description | Errors found in incoming JSON buffer |
    Examples:
      | entity_id | attributes_value |
      | room_1    | rwerwer          |
      | room_2    | True             |
      | room_3    | TRUE             |
      | room_4    | False            |
      | room_5    | FALSE            |
      | room_6    | 34r              |
      | room_7    | 5_34             |
      | room_8    | ["a", "b"        |
      | room_9    | ["a" "b"]        |
      | room_10   | "a", "b"]        |
      | room_11   | ["a" "b"}        |
      | room_12   | {"a": "b"        |
      | room_13   | {"a" "b"}        |
      | room_14   | "a": "b"}        |

  # ---------- attribute type --------------------------------

  @attributes_type
  Scenario Outline:  create entities using NGSI v2 with several attributes type
    Given  a definition of headers
      | parameter          | value                |
      | Fiware-Service     | test_attributes_type |
      | Fiware-ServicePath | /test                |
      | Content-Type       | application/json     |
    And properties to entities
      | parameter        | value             |
      | entities_type    | house             |
      | entities_id      | room              |
      | attributes_name  | temperature       |
      | attributes_value | 56                |
      | attributes_type  | <attributes_type> |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo
    Examples:
      | attributes_type |
      | temperature     |
      | 34              |
      | false           |
      | true            |
      | 34.4E-34        |
      | temp.34         |
      | temp_34         |
      | temp-34         |
      | TEMP34          |
      | house_flat      |
      | house.flat      |
      | house-flat      |
      | house@flat      |
      | random=10       |
      | random=100      |
      | random=150      |
      | random=256      |

  @attributes_type_not_allowed
  Scenario Outline:  try to create entities using NGSI v2 with several attributes type with not plain ascii
    Given  a definition of headers
      | parameter          | value                |
      | Fiware-Service     | test_attributes_type |
      | Fiware-ServicePath | /test                |
      | Content-Type       | application/json     |
    And properties to entities
      | parameter        | value             |
      | entities_type    | house             |
      | entities_id      | room              |
      | attributes_name  | temperature       |
      | attributes_value | 56                |
      | attributes_type  | <attributes_type> |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                                |
      | error       | BadRequest                           |
      | description | Invalid characters in attribute type |
    Examples:
      | attributes_type |
      | habitación      |
      | españa          |
      | barça           |

  @attributes_type_max_length @ISSUE_1601
  Scenario:  try to create entities using NGSI v2 with an attributes type that exceeds the maximum allowed (256)
    Given  a definition of headers
      | parameter          | value                |
      | Fiware-Service     | test_attributes_type |
      | Fiware-ServicePath | /test                |
      | Content-Type       | application/json     |
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
      | attributes_type  | random=257  |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                                                 |
      | error       | BadRequest                                            |
      | description | attribute type length: 257, max length supported: 256 |

  @attributes_type_without
  Scenario:  create entities using NGSI v2 without attributes type
    Given  a definition of headers
      | parameter          | value                        |
      | Fiware-Service     | test_attributes_type_without |
      | Fiware-ServicePath | /test                        |
      | Content-Type       | application/json             |
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Created" http code
    And verify that entities are stored in mongo

  @attributes_type_wrong @BUG_1093 @BUG_1200 @BUG_1351 @BUG_1728
  Scenario Outline:  try to create entities using NGSI v2 with several wrong attributes types
    Given  a definition of headers
      | parameter          | value                      |
      | Fiware-Service     | test_attributes_type_error |
      | Fiware-ServicePath | /test                      |
      | Content-Type       | application/json           |
    And properties to entities
      | parameter        | value             |
      | entities_type    | house             |
      | entities_id      | <entities_id>     |
      | attributes_name  | temperature       |
      | attributes_value | 56                |
      | attributes_type  | <attributes_type> |
    When create entity group with "1" entities in "normalized" mode
    Then verify that receive several "Bad Request" http code
    And verify several error responses
      | parameter   | value                                |
      | error       | BadRequest                           |
      | description | Invalid characters in attribute type |
    And verify that entities are not stored in mongo
    Examples:
      | entities_id | attributes_type |
      | room_1      | house<flat>     |
      | room_2      | house=flat      |
      | room_3      | house"flat"     |
      | room_4      | house'flat'     |
      | room_5      | house;flat      |
      | room_6      | house(flat)     |
      | room_7      | house_?         |
      | room_8      | house_&         |
      | room_9      | house_/         |
      | room_10     | house_#         |
      | room_11     | my house        |

  @attributes_type_invalid @BUG_1109
  Scenario Outline:  try to create an entity using NGSI v2 with several invalid attributes type (integer, boolean, no-string, etc)
    Given  a definition of headers
      | parameter          | value                       |
      | Fiware-Service     | test_attributes_name_error_ |
      | Fiware-ServicePath | /test                       |
      | Content-Type       | application/json            |
    And properties to entities
      | parameter        | value             |
      | entities_type    | "room"            |
      | entities_id      | <entity_id>       |
      | attributes_name  | "temperature"     |
      | attributes_value | true              |
      | attributes_type  | <attributes_type> |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                |
      | error       | ParseError                           |
      | description | Errors found in incoming JSON buffer |
    Examples:
      | entity_id | attributes_type |
      | "room1"   | rewrewr         |
      | "room2"   | SDFSDFSDF       |

  @attributes_type_no_allowed @BUG_1109
  Scenario Outline:  try to create an entity using NGSI v2 with several not allowed attributes type (integer, boolean, no-string, etc)
    Given  a definition of headers
      | parameter          | value                       |
      | Fiware-Service     | test_attributes_name_error_ |
      | Fiware-ServicePath | /test                       |
      | Content-Type       | application/json            |
    And properties to entities
      | parameter        | value             |
      | entities_type    | "room"            |
      | entities_id      | <entity_id>       |
      | attributes_name  | "temperature"     |
      | attributes_value | true              |
      | attributes_type  | <attributes_type> |
    When create an entity in raw and "normalized" modes
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                |
      | error       | BadRequest                           |
      | description | invalid JSON type for attribute type |
    Examples:
      | entity_id | attributes_type |
      | "room3"   | false           |
      | "room4"   | true            |
      | "room5"   | 34              |
      | "room6"   | {"a":34}        |
      | "room7"   | ["34", "a", 45] |

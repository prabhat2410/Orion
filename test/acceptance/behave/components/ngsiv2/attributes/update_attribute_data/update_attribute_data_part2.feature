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


Feature: update an attribute by entity ID and attribute name if it exists using NGSI v2 API. "PUT" - /v2/entities/<entity_id>/attrs/<attr_name> plus payload
  queries parameters:
  tested: type
  As a context broker user
  I would like to update an attribute by entity ID and attribute name if it exists using NGSI v2 API
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

 # --------------------- attribute value  ------------------------------------

  @attribute_value_update_without_attribute_type
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with several attribute values and without attribute type nor metadatas
    Given  a definition of headers
      | parameter          | value                                    |
      | Fiware-Service     | test_update_attr_value_without_attr_type |
      | Fiware-ServicePath | /test                                    |
      | Content-Type       | application/json                         |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "room_1" and attribute name "temperature" if it exists
    Then verify that receive an "No Content" http code
    And verify that an entity is updated in mongo
    Examples:
      | attributes_value |
      | fdgdfgfd         |
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

  @attribute_value_update_with_attribute_type
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with several attribute values and with attribute type
    Given  a definition of headers
      | parameter          | value                                 |
      | Fiware-Service     | test_update_attr_value_with_attr_type |
      | Fiware-ServicePath | /test                                 |
      | Content-Type       | application/json                      |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
      | attributes_type  | celsius     |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "room_1" and attribute name "temperature" if it exists
    Then verify that receive an "No Content" http code
    And verify that an entity is updated in mongo
    Examples:
      | attributes_value |
      | gsdfggff         |
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
      | random=50000     |

  @attribute_value_update_with_metadatas
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with several attribute values and with metadatas
    Given  a definition of headers
      | parameter          | value                                |
      | Fiware-Service     | test_update_attr_value_with_metadata |
      | Fiware-ServicePath | /test                                |
      | Content-Type       | application/json                     |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | hot         |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "room_1" and attribute name "temperature" if it exists
    Then verify that receive an "No Content" http code
    And verify that an entity is updated in mongo
    Examples:
      | attributes_value |
      | tytryrty         |
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
      | random=50000     |

  @attribute_value_update_without_attribute_type_special @BUG_1106
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with special attribute values (compound, vector, boolean, etc) and without attribute type nor metadatas
    Given  a definition of headers
      | parameter          | value                               |
      | Fiware-Service     | test_update_attribute_value_special |
      | Fiware-ServicePath | /test                               |
      | Content-Type       | application/json                    |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | <entity_id> |
      | attributes_name  | temperature |
      | attributes_value | 56          |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "<entity_id>" and attribute name "temperature" if it exists in raw mode
    Then verify that receive an "No Content" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | room1     | true                                                                          |
      | room2     | false                                                                         |
      | room3     | 34                                                                            |
      | room4     | -34                                                                           |
      | room5     | 5.00002                                                                       |
      | room6     | -5.00002                                                                      |
      | room7     | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | room8     | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | room9     | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | room10    | {"x": "x1","x2": "b"}                                                         |
      | room11    | {"x": {"x1": "a","x2": "b"}}                                                  |
      | room12    | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | room13    | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | room14    | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | room15    | "41.3763726, 2.1864475,14"                                                    |
      | room16    | "2017-06-17T07:21:24.238Z"                                                    |
      | room17    | null                                                                          |
      | room18    | {"rt.ty": "5678"}                                                             |

  @attribute_value_update_with_attribute_type_special @BUG_1106
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with special attribute values (compound, vector, boolean, etc) and with attribute type
    Given  a definition of headers
      | parameter          | value                               |
      | Fiware-Service     | test_update_attribute_value_special |
      | Fiware-ServicePath | /test                               |
      | Content-Type       | application/json                    |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | <entity_id> |
      | attributes_name  | temperature |
      | attributes_value | 56          |
      | attributes_type  | celsius     |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "<entity_id>" and attribute name "temperature" if it exists in raw mode
    Then verify that receive an "No Content" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | room1     | true                                                                          |
      | room2     | false                                                                         |
      | room3     | 34                                                                            |
      | room4     | -34                                                                           |
      | room5     | 5.00002                                                                       |
      | room6     | -5.00002                                                                      |
      | room7     | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | room8     | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | room9     | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | room10    | {"x": "x1","x2": "b"}                                                         |
      | room11    | {"x": {"x1": "a","x2": "b"}}                                                  |
      | room12    | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | room13    | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | room14    | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | room15    | "41.3763726, 2.1864475,14"                                                    |
      | room16    | "2017-06-17T07:21:24.238Z"                                                    |
      | room17    | null                                                                          |

  @attribute_value_update_with_metadata_special @BUG_1106
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with special attribute values (compound, vector, boolean, etc) and with metadatas
    Given  a definition of headers
      | parameter          | value                               |
      | Fiware-Service     | test_update_attribute_value_special |
      | Fiware-ServicePath | /test                               |
      | Content-Type       | application/json                    |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | <entity_id> |
      | attributes_name  | temperature |
      | attributes_value | 56          |
      | attributes_type  | celsius     |
      | metadatas_number | 2           |
      | metadatas_name   | very_hot    |
      | metadatas_type   | alarm       |
      | metadatas_value  | hot         |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "<entity_id>" and attribute name "temperature" if it exists in raw mode
    Then verify that receive an "No Content" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | room1     | true                                                                          |
      | room2     | false                                                                         |
      | room3     | 34                                                                            |
      | room4     | -34                                                                           |
      | room5     | 5.00002                                                                       |
      | room6     | -5.00002                                                                      |
      | room7     | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | room8     | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | room9     | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | room10    | {"x": "x1","x2": "b"}                                                         |
      | room11    | {"x": {"x1": "a","x2": "b"}}                                                  |
      | room12    | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | room13    | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | room14    | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | room15    | "41.3763726, 2.1864475,14"                                                    |
      | room16    | "2017-06-17T07:21:24.238Z"                                                    |
      | room17    | null                                                                          |

  @attribute_value_update_with_attribute_type_in_update
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with several attribute values and without attribute type nor metadatas, but with attribute type in update
    Given  a definition of headers
      | parameter          | value                                           |
      | Fiware-Service     | test_update_attr_value_with_attr_type_in_update |
      | Fiware-ServicePath | /test                                           |
      | Content-Type       | application/json                                |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
      | attributes_type  | celsius            |
    When update an attribute by ID "room_1" and attribute name "temperature" if it exists
    Then verify that receive an "No Content" http code
    And verify that an entity is updated in mongo
    Examples:
      | attributes_value |
      | dfsff            |
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
      | random=50000     |

  @attribute_value_update_special_with_attr_type_in_update @BUG_1106
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with special attribute values (compound, vector, boolean, etc) without attribute type not metadata but with attribute type in update
    Given  a definition of headers
      | parameter          | value                               |
      | Fiware-Service     | test_update_attribute_value_special |
      | Fiware-ServicePath | /test                               |
      | Content-Type       | application/json                    |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | <entity_id> |
      | attributes_name  | temperature |
      | attributes_value | 45          |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
      | attributes_type  | "celsius"          |
    When update an attribute by ID "<entity_id>" and attribute name "temperature" if it exists in raw mode
    Then verify that receive an "No Content" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | room1     | true                                                                          |
      | room2     | false                                                                         |
      | room3     | 34                                                                            |
      | room4     | -34                                                                           |
      | room5     | 5.00002                                                                       |
      | room6     | -5.00002                                                                      |
      | room7     | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | room8     | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | room9     | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | room10    | {"x": "x1","x2": "b"}                                                         |
      | room11    | {"x": {"x1": "a","x2": "b"}}                                                  |
      | room12    | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | room13    | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | room14    | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | room15    | "41.3763726, 2.1864475,14"                                                    |
      | room16    | "2017-06-17T07:21:24.238Z"                                                    |
      | room17    | null                                                                          |

  @attribute_value_update_with_metadata_in_update
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with several attribute values and without attribute type nor metadatas, but with metadatas in update
    Given  a definition of headers
      | parameter          | value                            |
      | Fiware-Service     | test_update_attr_value_with_meta |
      | Fiware-ServicePath | /test                            |
      | Content-Type       | application/json                 |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
      | attributes_type  | celsius            |
      | metadatas_name   | very_hot           |
      | metadatas_type   | alarm              |
      | metadatas_value  | hot                |
    When update an attribute by ID "room_1" and attribute name "temperature" if it exists
    Then verify that receive an "No Content" http code
    And verify that an entity is updated in mongo
    Examples:
      | attributes_value |
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
      | random=50000     |

  @attribute_value_update_special_with_metadata_in_update @BUG_1106
  Scenario Outline:  update an attribute by entity ID and attribute name using NGSI v2 with special attribute values (compound, vector, boolean, etc) without attribute type not metadata but with metadatas in update
    Given  a definition of headers
      | parameter          | value                               |
      | Fiware-Service     | test_update_attribute_value_special |
      | Fiware-ServicePath | /test                               |
      | Content-Type       | application/json                    |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | <entity_id> |
      | attributes_name  | temperature |
      | attributes_value | 45          |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
      | attributes_type  | "celsius"          |
      | metadatas_name   | "very_hot"         |
      | metadatas_type   | "alarm"            |
      | metadatas_value  | "hot"              |
    When update an attribute by ID "<entity_id>" and attribute name "temperature" if it exists in raw mode
    Then verify that receive an "No Content" http code
    Examples:
      | entity_id | attributes_value                                                              |
      | room1     | true                                                                          |
      | room2     | false                                                                         |
      | room3     | 34                                                                            |
      | room4     | -34                                                                           |
      | room5     | 5.00002                                                                       |
      | room6     | -5.00002                                                                      |
      | room7     | [ "json", "vector", "of", 6, "strings", "and", 2, "integers" ]                |
      | room8     | [ "json", ["a", 34, "c", ["r", 4, "t"]], "of", 6]                             |
      | room9     | [ "json", ["a", 34, "c", {"r": 4, "t":"4", "h":{"s":"3", "g":"v"}}], "of", 6] |
      | room10    | {"x": "x1","x2": "b"}                                                         |
      | room11    | {"x": {"x1": "a","x2": "b"}}                                                  |
      | room12    | {"a":{"b":{"c":{"d": {"e": {"f": 34}}}}}}                                     |
      | room13    | {"x": ["a", 45, "rt"],"x2": "b"}                                              |
      | room14    | {"x": [{"a":78, "b":"r"}, 45, "rt"],"x2": "b"}                                |
      | room15    | "41.3763726, 2.1864475,14"                                                    |
      | room16    | "2017-06-17T07:21:24.238Z"                                                    |
      | room17    | null                                                                          |

  @attribute_value_error_without
  Scenario:  update an attribute by entity ID and attribute name using NGSI v2 without attribute value
    Given  a definition of headers
      | parameter          | value                        |
      | Fiware-Service     | test_update_attr_value_error |
      | Fiware-ServicePath | /test                        |
      | Content-Type       | application/json             |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | room        |
      | attributes_name  | temperature |
      | attributes_value | 56          |
    And create entity group with "3" entities in "normalized" mode
      | entity | prefix |
      | id     | true   |
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter       | value    |
      | attributes_type | celsius  |
      | metadatas_name  | very_hot |
      | metadatas_type  | alarm    |
      | metadatas_value | hot      |
    When update an attribute by ID "room_1" and attribute name "temperature" if it exists
    Then verify that receive an "No Content" http code
    And verify that an entity is updated in mongo

  @attribute_value_invalid_2 @BUG_1424
  Scenario Outline:  try to update an attribute by entity ID and attribute name using NGSI v2 without invalid attribute values in update request
    Given  a definition of headers
      | parameter          | value                        |
      | Fiware-Service     | test_update_attr_value_error |
      | Fiware-ServicePath | /test                        |
      | Content-Type       | application/json             |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | <entity_id> |
      | attributes_name  | temperature |
      | attributes_value | 56          |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "<entity_id>" and attribute name "temperature" if it exists
    Then verify that receive an "Bad Request" http code
    And verify an error response
      | parameter   | value                                 |
      | error       | BadRequest                            |
      | description | Invalid characters in attribute value |
    Examples:
      | entity_id | attributes_value |
      | room_2    | house<flat>      |
      | room_3    | house=flat       |
      | room_4    | house"flat"      |
      | room_5    | house'flat'      |
      | room_6    | house;flat       |
      | room_8    | house(flat)      |

  @attribute_value_error_special
  Scenario Outline:  try to update an attribute by entity ID and attribute name using NGSI v2 with wrong attribute values in update request (compound, vector, boolean, etc)
    Given  a definition of headers
      | parameter          | value                               |
      | Fiware-Service     | test_update_attribute_value_special |
      | Fiware-ServicePath | /test                               |
      | Content-Type       | application/json                    |
    # These properties below are used in create request
    And properties to entities
      | parameter        | value       |
      | entities_type    | house       |
      | entities_id      | <entity_id> |
      | attributes_name  | temperature |
      | attributes_value | 45          |
    And create entity group with "1" entities in "normalized" mode
    And verify that receive several "Created" http code
    # These properties below are used in update request
    And properties to entities
      | parameter        | value              |
      | attributes_value | <attributes_value> |
    When update an attribute by ID "<entity_id>" and attribute name "temperature" if it exists in raw mode
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

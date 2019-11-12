/*
*
* Copyright 2013 Telefonica Investigacion y Desarrollo, S.A.U
*
* This file is part of Orion Context Broker.
*
* Orion Context Broker is free software: you can redistribute it and/or
* modify it under the terms of the GNU Affero General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* Orion Context Broker is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
* General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.
*
* For those usages not covered by this license please contact with
* iot_support at tid dot es
*
* Author: Ken Zangelin
*/
#include <string.h>
#include <string>
#include <sstream>

#include "logMsg/logMsg.h"
#include "logMsg/traceLevels.h"

#include "common/MimeType.h"
#include "common/wsStrip.h"



/* ****************************************************************************
*
* mimeTypeToString - 
*/
const char* mimeTypeToString(MimeType mimeType)
{
  switch (mimeType)
  {  
  case JSON:     return "JSON";
  case TEXT:     return "TEXT";
  case HTML:     return "HTML";
  case NOMIMETYPE: return "NOMIMETYPE";
  }

  return "Unknown mimeType";
}



/* ****************************************************************************
*
* stringToMimeType
*/
MimeType stringToMimeType(const std::string& s)
{
  if (s == "JSON")
  {
    return JSON;
  }

  return NOMIMETYPE;
}



/* ****************************************************************************
*
* mimeTypeParse - 
*/
MimeType mimeTypeParse(const std::string& mimeTypeString, std::string* charsetP)
{
  char* s;
  char* cP = (char*) mimeTypeString.c_str();

  if ((s = strstr(cP, ";")) != NULL)
  {
    *s = 0;
    ++s;
    s = wsStrip(s);
    if (strncmp(s, "charset=", 8) == 0)
    {
      if (charsetP != NULL)
        *charsetP = std::string(&s[8]);
    }
  }

  std::string mimeType(wsStrip(cP));

  if      (mimeType == "*/*")                               return JSON;
  else if (mimeType == "text/json")                         return JSON;
  else if (mimeType == "application/json")                  return JSON;
  else if (mimeType == "text/plain")                        return TEXT;

  return JSON;
}

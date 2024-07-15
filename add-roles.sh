#!/bin/bash

# Define the XML file and roles
xml_file="/etc/opt/rh/eap7/wildfly/standalone/configuration/standalone-full.xml"
roles_to_add='
<role name="TDWFP_PLANNERREQ_READ"/>
<role name="TDWFP_PLANNERREQ_WRITE"/>
<role name="TDWFP_PLANNERREQMGR_READ"/>
<role name="TDWFP_PLANNERREQMGR_WRITE"/>
'

# Check if the XML file exists
if [ ! -f "$xml_file" ]; then
    echo "Error: XML file $xml_file not found."
    exit 1
fi

# Add roles using sed
sed -i '/<constant-role-mapper name="default-roles-mapper">/a '"$roles_to_add" "$xml_file"

echo "Roles added successfully."

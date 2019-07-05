#!/usr/bin/env bash

my_dir="$(dirname "$0")"
PIENI_POC_VERSION=0.0.12

echo "Using Version 0.0.12"


#-- switch to pieni project
oc project u210645-pieni

#-- all teamplate files needed
templates=()
templates[1]="./template/pieni-template.yml"

#-- run all template files
for template in ${templates[@]}; do
    echo "Install Template: ${template}"

    #-- read required parameters
    requiredParams=$(oc process -f ${template} --parameters=true | tail -n +2 | awk '{ print $1 }')
    pat=$(echo ${requiredParams[@]}|tr " " "|")

    #-- read values for required parameters
    params=$(cat ./default/config.list | grep -Ew "$pat" |tr "\n" ", ")
    echo "Parameters: ${params}"

    #-- apply templates
    cat ./default/config.list | grep -Ew "$pat" | oc process -f ${template} --param-file=- | oc apply -f -



    #-- new line separator
    echo "";
done

#-- remove PIENI_POC_VERSION from env
unset PIENI_POC_VERSION
#!/bin/bash
#   Script file for running ASReml
# Set the path to point to the location of the License file
# and the location of the program.

ASREML_DIR=/opt/vsni/asreml/latest
if [ ! -d ${ASREML_DIR} ];then
  ASREML_DIR=${HOME}/asreml
fi

export ASREML_DIR
#  If a license is not found in the current users home folder set up a default path 
if [ ! -f ${HOME}/asreml.lic ];then
#  This sets the default license filename. If the file exists
#  it will use it, overriding any setting of environment variables
   default=${ASREML_DIR}/bin/asreml.lic
   if [ -f $default ]; then
     ASREML_LICENSE_FILE=$default
     export ASREML_LICENSE_FILE
   fi
fi

#
#  Create a temporary directory unique to this process
#
#  ASREMLTEMP=/tmp/asreml.$$
ASREMLTEMP=/tmp/asreml.`hostname`.`whoami`.$$
rm -Rf $ASREMLTEMP
mkdir $ASREMLTEMP
export ASREMLTEMP

#  The -32 and -64 options are no longer supported, so remove if necessary
if [ "$1" == "-32" -o "$1" == "-64" ]; then
 echo Argument $1 ignored
 shift
fi

#Ensure that we have an asreml work folder in the current users home directory
ASREML_WRK=${HOME}/.asreml4
if [ ! -d ${ASREML_WRK} ]; then
  mkdir -p ${ASREML_WRK} > /dev/null 2>&1
fi
#Ensure that we have an appropriate symbolic link referencing a valid asreml executable
if [ ! -L ${ASREML_WRK}/asreml_active -o ! -e ${ASREML_WRK}/asreml_active ]; then
#No valid link found, so try to create one...
pushd ${ASREML_DIR}/bin
for exename in asreml-*; do
   if [ -L ${ASREML_WRK}/asreml_active ]; then
      rm ${ASREML_WRK}/asreml_active
   fi
   ln -s ${ASREML_DIR}/bin/$exename ${ASREML_WRK}/asreml_active
done
popd
fi
#  run asreml
${ASREML_WRK}/asreml_active $*

#  Clean up any temporaries
rm -Rf $ASREMLTEMP


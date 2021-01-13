#!/bin/bash
#
# Script file to select a version of asreml for use.
#
# Usage: 
#
# asreml_select latest  or
# asreml_select 4.x.0.b  or
# 
SELECT=$1
#SELECT=${SELECT:=latest}

#Ensure that we have an asreml work folder in the current users home directory
if [ ! -d ${HOME}/.asreml ]; then
  mkdir -p ${HOME}/.asreml > /dev/null 2>&1
fi

ASREML_DIR=/opt/vsni/asreml
export ASREML_DIR

if [ "${SELECT}" == "" ]; then
    echo "	Available versions are :-"
    for ver in `ls ${ASREML_DIR}`; do
        echo "		 ${ver}"
    done
    exit 0
fi

if [ ${SELECT} == "prev" ]; then
    if [ -L ${HOME}/.asreml/asreml_previous ]; then
      echo "Restoring previous version"
      if [ -L ${HOME}/.asreml/asreml_active ]; then
        mv ${HOME}/.asreml/asreml_active ${HOME}/.asreml/asreml_tmp
      fi
      mv ${HOME}/.asreml/asreml_previous ${HOME}/.asreml/asreml_active
      if [ -L ${HOME}/.asreml/asreml_tmp ]; then
        mv ${HOME}/.asreml/asreml_tmp ${HOME}/.asreml/asreml_previous
      fi
      exit 0
    else
      echo "	No previous version found."
      exit 1
    fi
else
    if [ ! -f ${ASREML_DIR}/${SELECT}/bin/asreml.sh ]; then
      echo "	No such version exists."
      exit 1
    fi
fi

#Preserve the active symbolic link to support switching back
if [ -L ${HOME}/.asreml/asreml_active ]; then
  mv ${HOME}/.asreml/asreml_active ${HOME}/.asreml/asreml_previous
fi
#create new active link ...
ln -s ${ASREML_DIR}/${SELECT}/bin/asreml-* ${HOME}/.asreml/asreml_active

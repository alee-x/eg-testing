#!/usr/bin/env bash

if [ "${EG_IMPERSONATION_ENABLED}" = "True" ]; then
        IMPERSONATION_OPTS="--proxy-user ${KERNEL_USERNAME:-UNSPECIFIED}"
        USER_CLAUSE="as user ${KERNEL_USERNAME:-UNSPECIFIED}"
else
        IMPERSONATION_OPTS=""
        USER_CLAUSE="on behalf of user ${KERNEL_USERNAME:-UNSPECIFIED}"
fi

echo
echo "Starting IRkernel for Spark Cluster mode ${USER_CLAUSE}"
echo

if [ -z "${SPARK_HOME}" ]; then
  echo "SPARK_HOME must be set to the location of a Spark distribution!"
  exit 1
fi

PROG_HOME="$(cd "`dirname "$0"`"/..; pwd)"

# Add server_listener.py to files for spark-opts
ADDITIONAL_OPTS="--files ${PROG_HOME}/scripts/server_listener.py"

eval exec \
     "${SPARK_HOME}/bin/spark-submit" \
     "${SPARK_OPTS}" \
     "${ADDITIONAL_OPTS}" \
     "${IMPERSONATION_OPTS}" \
     "${PROG_HOME}/scripts/launch_IRkernel.R" \
     "${LAUNCH_OPTS}" \
     "$@"

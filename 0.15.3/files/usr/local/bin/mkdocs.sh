#!/bin/sh

ARG1=$1
shift
case $ARG1 in
	'serve')
		ARGS="-a 0.0.0.0:8000"
		;;

	*)
		ARGS=""
		;;
esac

echo /usr/local/bin/mkdocs $ARG1 $ARGS "$@"
exec /usr/local/bin/mkdocs $ARG1 $ARGS "$@"

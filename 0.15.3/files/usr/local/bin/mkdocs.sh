#!/bin/sh

ARG1=$1
shift
case $ARG1 in
	'build'|'gh-deploy'|'new')
		ARGS=""
		;;

	'serve')
		ARGS="-a 0.0.0.0:8000"
		;;

	*)
		ARG1="serve"
		ARGS="-a 0.0.0.0:8000"
		;;
esac

echo /usr/local/bin/mkdocs $ARG1 $ARGS "$@"
exec /usr/local/bin/mkdocs $ARG1 $ARGS "$@"

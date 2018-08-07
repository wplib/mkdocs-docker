#!/bin/sh

if [ "$1" == "interactive" ]
then
	shift
	ARG1=$1
	shift
	case $ARG1 in
		'build'|'gh-deploy'|'new')
			ARGS=""
			;;

		'serve')
			echo "WPLib Box: Warning - Can only serve from container."
			exit
			;;

		*)
			ARGS=""
			;;
	esac
else
	ARG1="serve"
	ARGS="-a 0.0.0.0:8000"
fi

# echo /usr/local/bin/mkdocs $ARG1 $ARGS "$@"
exec /usr/local/bin/mkdocs $ARG1 $ARGS "$@"

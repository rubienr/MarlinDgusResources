#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME=`basename "$0"`


function read_args()
{
  if [ "$#" -eq 0 ] ; then
    NOARGS=1
  fi

  while [[ "$#" -gt 0 ]]; do
    case $1 in
      -h|--help) HELP=1 ;;
      -g|--generate) CREATE_CONFIG_FROM="$2"; shift ;;
      -d|--dryrun) CREATE_CONFIG_FROM="$2"; DRYRUN=1; shift ;;
      *) echo "$SCRIPT_NAME Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
  done
}


function usage()
{
  if [ ! -z "$1" ] ; then
    echo "$SCRIPT_NAME [ -h | -g <file.txt> | -d ]"
    echo "   -h, --help                 prints this help text"
    echo "   -g, --generate <file.txt>  compile configuration file to binary format"
    echo "   -d, --dryrun <file.txt>    same as -g but without touching anything"
    exit 1
  fi
}


# creates .cfg file in the current working directory
# $1 ... .txt source config file
function compile_configuration()
{
  filepath="$1"
  f_basename=`basename $filepath`
  f_name_wo_extension=${f_basename%%.*}    
  f_compiled="./${f_name_wo_extension}.cfg"

  echo "create configuration from $f_basename"
  echo "  -> $f_compiled"

  if [ "x$DRYRUN" != "x1" ] ; then
    cat $1 | xxd -c 1 -r > $f_compiled
  fi
}


function main()
{
  read_args "$@"
  usage $HELP

  if  [ x"$NOARGS" == "x1" ] ; then
    usage 1
  fi

  if  [ -z "$CREATE_CONFIG_FROM" ] ; then
    usage 1
  fi

  compile_configuration "$CREATE_CONFIG_FROM"
}

main "$@"

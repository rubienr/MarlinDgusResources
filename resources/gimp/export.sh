#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# $1 ... .xcf filename
function export_file_groups_to_bmp()
{
  gimp "$1" -i -b - < ../export.sch
}


function export_all_file_groups_to_bmp()
{
  source $SCRIPT_DIR/export.cfg
  for f in "${XCF_FILES_TO_EXPORT_FROM[@]}" ; do
    echo "exporting groups from $f ..."
    export_file_groups_to_bmp $f
    echo "done"
  done
}

function convert_all_exported_files()
{
  # convert groups
  for f in `find . -maxdepth 1 -name "*.bmp"` ; do
    echo "convert $f to 8 bit"
    convert $f -type truecolor $f
  done
}
  
function main()
{
  echo -e "\nExport from .xcf -> `pwd`/generated"
  pushd "$SCRIPT_DIR" > /dev/null
  rm -drf "generated"
  mkdir -p "generated"
  pushd "$SCRIPT_DIR/generated" > /dev/null

  export_all_file_groups_to_bmp "../"
  convert_all_exported_files
  
  popd > /dev/null
  popd > /dev/null
}

main

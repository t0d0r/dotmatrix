# the tmp directory to use.
tmpdir="$HOME/tmp/mutt_attach"

# the name of the debug file if debugging is turned on.
debug_file=$tmpdir/debug

# debug.  yes or no.  
debug="no"
#debug="yes"

type=$2
open_with=$3

# make sure the tmpdir exists.
mkdir -p $tmpdir

# clean it out.  Remove this if you want the directory
# to accumulate attachment files.
rm -f $tmpdir/*

# Mutt puts everything in /tmp by default. 
# This gets the basic filename from the full pathname.
filename=`basename $1`

# get rid of the extenson and save the name for later.
file=`echo $filename | cut -d"." -f1`

if [ $debug = "yes" ]; then
    echo "1:" $1 " 2:" $2 " 3:" $3 > $debug_file
    echo "Filename:"$filename >> $debug_file
    echo "File:"$file >> $debug_file
    echo "===========================" >> $debug_file
fi

# if the type is empty then try to figure it out.
if [ -z $type ]; then
    type=`file -bi $1 | cut -d"/" -f2`
fi

# if the type is '-' then we don't want to mess with type.
# Otherwise we are rebuilding the name.  Either from the
# type that was passed in or from the type we discerned.
if [ $type = "-" ]; then
    newfile=$filename
else
    newfile=$file.$type
fi

newfile=$tmpdir/$newfile

# Copy the file to our new spot so mutt can't delete it
# before the app has a chance to view it.
cp $1 $newfile

if [ $debug = "yes" ]; then
    echo "File:" $file "TYPE:" $type >> $debug_file
    echo "Newfile:" $newfile >> $debug_file
    echo "Open With:" $open_with >> $debug_file
fi

# If there's no 'open with' then we can let preview do it's thing.
# Otherwise we've been told what to use.  So do an open -a.

if [ -z $open_with ]; then
    open $newfile
else
    open -a "$open_with" $newfile
fi

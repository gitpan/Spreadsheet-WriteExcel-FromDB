package Spreadsheet::WriteExcel::FromDB::Pg;

use strict;
use base qw/Spreadsheet::WriteExcel::FromDB::column_finder/;
use vars qw/$VERSION/;
$VERSION = 0.03;

#######################################################
# taken from postgresql 7.1.2 src/bin/psql/describe.c
# lines 588-596 (with some editing . . .)
#######################################################
sub query {
   return qq{
      SELECT a.attname
        FROM pg_class c, pg_attribute a
       WHERE c.relname = \'$_[1]\'
         AND a.attnum > 0
         AND a.attrelid = c.oid
   };
}

1;

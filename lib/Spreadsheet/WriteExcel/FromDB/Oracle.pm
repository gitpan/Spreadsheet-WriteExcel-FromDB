package Spreadsheet::WriteExcel::FromDB::Oracle;

use strict;
use base qw/Spreadsheet::WriteExcel::FromDB::column_finder/;
use vars qw/$VERSION/;
$VERSION = 0.01;

sub query {
   my $name = uc $_[1];
   return qq{
      SELECT column_name 
        FROM user_col_comments 
       WHERE table_name = \'$name\' 
   };
}

1;

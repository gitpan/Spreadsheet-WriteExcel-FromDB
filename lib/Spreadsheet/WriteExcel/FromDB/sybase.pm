package Spreadsheet::WriteExcel::FromDB::sybase;

use strict;
use base qw/Spreadsheet::WriteExcel::FromDB::column_finder/;
use vars qw/$VERSION/;
$VERSION = 0.02;

sub query { 
  return qq{
   SELECT c.name 
     FROM syscolumns c, sysobjects o 
    WHERE c.id = o.id 
      AND o.type IN ('S','U')
      AND o.name = '$_[1]' 
    ORDER BY colid
  };
}

1;

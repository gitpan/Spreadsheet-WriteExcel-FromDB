package Spreadsheet::WriteExcel::FromDB::mysql;

use strict;
use base qw/Spreadsheet::WriteExcel::FromDB::column_finder/;
use vars qw/$VERSION/;
$VERSION = 0.01;

sub query { "DESCRIBE $_[1]" }

1;

package Spreadsheet::WriteExcel::FromDB::column_finder;

use strict;
use vars qw/$VERSION/;
$VERSION = 0.01;

# For now we'll assume that every subclass can provide a query in sub 
# query() which will return the column names as the first column. Any 
# that can't can provide their own columns_in_table function.

sub columns_in_table {
  my ($self, $dbh, $table) = @_;
  return @{ $dbh->selectcol_arrayref($self->query($table)) };
}

sub query { die "query() must be defined in subclass\n" }

1;

package Spreadsheet::WriteExcel::FromDB::mysql;

use strict;
use vars qw/$VERSION/;
$VERSION = 0.01;

sub columns_in_table {
  my ($self, $dbh, $table) = @_;
  my $query = sprintf "DESCRIBE %s", $table;
  return @{ $dbh->selectcol_arrayref($query) };
}

1;

package Spreadsheet::WriteExcel::FromDB;

use strict;
use vars qw/$VERSION/;
$VERSION = 0.07;

use Spreadsheet::WriteExcel::Simple 0.02;

sub croak { require Carp; Carp::croak(@_) }

=head1 NAME

Spreadsheet::WriteExcel::FromDB - Convert a database table to an Excel spreadsheet

=head1 SYNOPSIS

  use Spreadsheet::WriteExcel::FromDB;

  my $dbh = DBI->connect(...);

  my $ss = Spreadsheet::WriteExcel::FromDB->read($dbh, $table_name);
     $ss->ignore_columns(qw/foo bar/);

  print $ss->as_xls;

=head1 DESCRIPTION

This module exports a database table as an Excel Spreadsheet.

The data is not returned in any particular order, as it is a simple
task to perform this in Excel. However, you may choose to ignore certain
columns, using the 'ignore_columns' method.

This relies on us knowing how to access the table information for
this database. This is done by delegating the call 'columns_in_table'
to an appropriate subclass. (At the moment this only exists for MySQL,
PostgreSQL, Oracle and Sybase, but please send me more!)

=head1 METHODS

=head2 read

Creates a spreadsheet object from a database handle and a table name.

=cut

sub read {
   my $class = shift;
   my $dbh   = shift or croak "Need a dbh";
   my $table = shift or croak "Need a table";
   my $self = {
     _table          => $table,
     _dbh            => $dbh,
     _ignore_columns => [],
   };
   bless $self, $class;
}

=head2 dbh / table

Accessor / mutator methods for the database handle and table name.

=cut

sub dbh {
  my $self = shift;
  $self->{_dbh} = shift if $_[0];
  $self->{_dbh};
}

sub table {
  my $self = shift;
  $self->{_table} = shift if $_[0];
  $self->{_table};
}

=head2 ignore_columns

  $ss->ignore_columns(qw/foo bar/);

Do not output these columns into the spreadsheet.

=cut

sub ignore_columns {
  my $self = shift;
  $self->{_ignore_columns} = [ @_ ];
}

=head2 as_xls

Return the table as an Excel spreadsheet.

=cut

sub as_xls {
  my $self  = shift;
  my $ss = Spreadsheet::WriteExcel::Simple->new;
     $ss->write_bold_row([$self->_columns_wanted]);
     $ss->write_row($_)
       foreach @{$self->dbh->selectall_arrayref($self->_data_query)};
  return $ss->data;
}

sub _data_query {
  my $self   = shift;
  return sprintf 'SELECT %s FROM %s',
           (join ', ', $self->_columns_wanted),
           $self->table;
}

sub _columns_wanted {
  my $self   = shift;
  my %ignore_columns = map { $_ => 1 } @{$self->{_ignore_columns}};
  return grep !$ignore_columns{$_}, $self->_columns_in_table;
}

sub _columns_in_table {
  my $self = shift;
  my $helper_type = $self->dbh->{Driver}->{Name}
       or die 'I cannot work out what kind of database we have';
  my $helper = join "::", ref $self, $helper_type;
  eval "require $helper";
  die "We have no handler for $helper_type tables: $@\n" if $@;

  return $helper->columns_in_table($self->dbh, $self->table);
}

=head1 BUGS

Dates are handled as strings, rather than dates.

=head1 AUTHOR

Tony Bowden, E<lt>kasei@tmtm.comE<gt>.

=head1 SEE ALSO

L<Spreadsheet::WriteExcel::Simple>. L<Spreadsheet::WriteExcel>. L<DBI>

=head1 COPYRIGHT

Copyright (C) 2001 Tony Bowden. All rights reserved.

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;


package Data::TableReader::Decoder::IdiotCSV;

use Moo 2;
use Try::Tiny;
use Carp;
use Log::Any '$log';

extends 'Data::TableReader::Decoder::CSV';

# ABSTRACT: Access rows of a badly formatted comma-delimited test file

=head1 DESCRIPTION

This decoder deals with those special people who think that encoding CSV is
as simple as

  print join(',', map { qq{"$_"} } @row)."\n";

regardless of their data containing quote characters or newlines, resulting in
garbage like

  "First Name","Last Name","Full Name"
  "Joe","Smith","Joe "Bossman" Smith"

This can actually be processed by the L<Text::CSV> module with the following
configuration:

  {
    binary => 1,
    allow_loose_quotes => 1,
    allow_whitespace => 1,
    escape_char => undef,
  }

And so this module is simply a subclass of L<Data::TableReader::Decoder::CSV>
which provides those defaults to the parser.

=cut

sub _build_parser {
	my $args= shift->_parser_args || {};
	Data::TableReader::Decoder::CSV->_csv_class->new({
		binary => 1,
		allow_loose_quotes => 1,
		allow_whitespace => 1,
		auto_diag => 1,
		escape_char => undef,
		%$args,
	});
}

1;

package Compress::LeadingBlankSpaces;

use 5.004;
use strict;

use vars qw($VERSION);
$VERSION = '0.02';

sub new { # class/instance constructor, ready to sub-class
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = {};
	bless ($self, $class);

	$self->{TAGS} = [];	# a reference to the array of special tags
	$self->{TAGS}->[0]->{HEADER} = '<PRE>';
	$self->{TAGS}->[0]->{FOOTER} = '</PRE>';
	$self->{TAGS}->[1]->{HEADER} = '<TEXTAREA>';
	$self->{TAGS}->[1]->{FOOTER} = '</TEXTAREA>';

	$self->{FORMATTED}   = -1;	# index of currently active special tag.
					# we should never compress blank spaces within the FORMATTED content.
	return $self;
}

# sub format_status takes one optional parameter.
# If called with an argument, it sets the FORMATTED field;
# otherwise it just returns the value held by that field,
#
sub format_status {
	my $self = shift;
	my $val = shift;
	$self->{FORMATTED} = $val if defined ($val);
	return $self->{FORMATED};
}

sub squeeze_string {
	my $self = shift;
	my $buf = shift;
	return '' unless $buf; # empty, zero or undefined input...
	chop $buf;
	if ( $self->{FORMATTED} >= 0 ){
		# no compression:
		my $end_tag = $self->{TAGS}->[$self->{FORMATTED}]->{FOOTER};
		$self->{FORMATTED} = -1 if uc $buf =~ /$end_tag/;	# resume the compression
									# since the next input
	} else { # try to compress
		while ($buf =~ /\r/o){
			$buf =~ s/\r+//o;
		}
		$buf =~ s/^\s+(\S.*)/$1/;
		while ($buf =~ /^\s/o){
			$buf =~ s/^\s+//o;
		}
		my $index = 0;
		foreach ( @{ $self->{TAGS} } ){
			
			my $beg_tag = $self->{TAGS}->[$index]->{HEADER};
			$self->{FORMATTED} = $index if uc $buf =~ /$beg_tag/;	# hold on the compression
										# since the next input
			last if $self->{FORMATTED} >= 0;
			$index += 1;
		}
	}
	return '' unless length($buf) > 0;
	return $buf."\n";
}

1;
__END__

=head1 NAME

Compress::LeadingBlankSpaces - Perl class to compress leading blank spaces in (HTML, JavaScript, etc.) web content.

=head1 SYNOPSIS

  use Compress::LeadingBlankSpaces;

  my $lco_r = LeadingBlankSpaces->new();
  . . .
  my $source_string = '     some content'."\n";
  . . .
  my $outgoing_string = $lco_r->squeeze_string ($source_string);
  . . .
  my $squeeze_status = $lco_r->format_status(); # to check later...

=head1 DESCRIPTION

This class provides the functionality for the most simple web content compression.

Basically, the outgoing web content (HTML, JavaScript, etc.) contains a lot of leading blank spaces,
because of being structured on development stage.
Usually, the client browser ignores leading blank spaces.
Indeed, the amount of those blank spaces is significant
and could be estimated as 10 to 20 percent of the length of regular web page.
We can reduce this part of the web traffic on busy servers
with no visible impact on transferred web content. This could be helpful
especially for those old browsers which fail to understand the modern content compression.

The main functionality of this class is concentrated within the C<squeeze_string> member function
that is supposed to be used inside the data transfer loop on server side.
The rest of the class is developed to serve possible exceptions, like pre-formatted data within HTML.

In this version of the class, there are two tags those produce compression exceptions:

<PRE> ... </PRE>

<TEXTAREA> ... </TEXTAREA>

case insensitive in implementation.

=head1 EXPORT

None.

=head1 AUTHOR

Slava Bizyayev E<lt>slava@cpan.orgE<gt> - Freelance Software Developer & Consultant.

=head1 COPYRIGHT AND LICENSE

I<Copyright (C) 2002-2004 Slava Bizyayev. All rights reserved.>

This package is free software.
You can use it, redistribute it, and/or modify it under the same terms as Perl itself.
The latest version of this module can be found on CPAN.

=head1 SEE ALSO

C<Web Content Compression FAQ> at F<http://perl.apache.org/docs/tutorials/client/compression/compression.html>

C<Apache::Dynagzip> module can be found on CPAN.

=cut

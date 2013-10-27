package Sphinx::Config::Simple;

use strict;
use warnings;

our $VERSION = '0.01';

sub new {
  my $pkg = shift;
  my $self = {
    indexes => [], # container of ::Index references 
    sources => [], # container of ::Source references
    indexer => Sphinx::Config::Entry::Indexer->new(),
    searchd => Sphinx::Config::Entry::Searchd->new(),
  };

  bless $self, $pkg;
  return $self;
}

sub push_index {
  my $self = shift;
  push @{$self->{indexes}}, @_;
  return;
}

sub pop_index {
  my $self = shift;
  return pop @{$self->{indexes}};
}

sub push_source {
  my $self = shift;
  push @{$self->{sources}}, @_;
  return;
}

sub pop_source {
  my $self = shift;
  return pop @{$self->{sources}};
}

sub index_list {
  my $self = shift;
  return $self->{indexes};
}

sub source_list {
  my $self = shift;
  return $self->{sources};
} 

sub indexer {
  my $self = shift;
  return $self->{indexer};
}

sub searchd {
  my $self = shift;
  return $self->{searchd};
}

# bless array of singleton key/value hash refs
package Sphinx::Config::Entry;

sub new {
  my $pkg = shift;
  my $self = { 
    kv_pairs => [],
  };

  bless $self, $pkg;
  return $self;
}

sub push {
  my $self = shift;
  return push @{$self->{kv_pairs}}, @_;
}

sub pop {
  my $self = shift;
  return pop @{$self->{kv_pairs}};
}

sub to_string {

}

package Sphinx::Config::Entry::Source;

our @ISA = q{Sphinx::Config::Entry};

sub name {
  my $self = shift;
  $self->{name} = $_[0] if $_[0];
  return $self->{name};
}

sub to_string {

}

package Sphinx::Config::Entry::Index;

our @ISA = q{Sphinx::Config::Entry};

sub name {
  my $self = shift;
  $self->{name} = $_[0] if $_[0];
  return $self->{name};
}

sub to_string {

}

package Sphinx::Config::Entry::Indexer;

our @ISA = q{Sphinx::Config::Entry};

sub to_string {

}

package Sphinx::Config::Entry::Searchd;

our @ISA = q{Sphinx::Config::Entry};

sub to_string {

}

1;

__END__
=head1 NAME

Sphinx::Config::Simple - Perl extension creating dynamic Sphinx configuration files. 

=head1 SYNOPSIS

  use Sphinx::Config::Simple;
  

=head1 DESCRIPTION

Stub documentation for Sphinx::Config::Simple, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

User &, E<lt>patchbaz@nonetE<gt>

=head1 CoPYRIGHT AND LICENSE

Copyright (C) 2013 by User &

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.4 or,
at your option, any later version of Perl 5 you may have available.


=cut

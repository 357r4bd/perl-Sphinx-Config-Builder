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
    searchd => Sphinx::Config::Entry::Searchd->new(),,
  };

  bless $self, $pkg;
  return $self;
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
  my $self = [ ];

  bless $self, $pkg;
  return $self;
}

sub push {
  my $self = shift;
  warn q{Not a hash reference} if ref $_[0] ne q{HASH};
  return push @{$self}, $_[0];
}

sub pop {
  my $self = shift;
  return pop @{$self};
}

sub to_string {

}

package Sphinx::Config::Entry::Source;

our @ISA = q{Sphinx::Config::Config::Entry};

sub name {
  my $self = shift;
  $self->{name} = $_ if ref $_ eq q{SCALAR};
  return $self->{name};
}

sub to_string {

}

package Sphinx::Config::Entry::Index;

our @ISA = q{Sphinx::Config::Config::Entry};

sub name {
  my $self = shift;
  $self->{name} = $_ if ref $_ eq q{SCALAR};
  return $self->{name};
}

sub to_string {

}

package Sphinx::Config::Entry::Indexer;

our @ISA = q{Sphinx::Config::Config::Entry};

sub to_string {

}

package Sphinx::Config::Entry::Searchd;

our @ISA = q{Sphinx::Config::Config::Entry};

sub to_string {

}

1;
__END__
=head1 NAME

Sphinx::Config::Simple - Perl extension creating dynamic Sphinx configuration files. 

=head1 SYNOPSIS

  use Sphinx::Config::Simple;

  my $cfg = Sphinx::Config::Simple->new(); 

  for my $i (1 .. 10) {
    my $index   = Sphinx::Config::Simple::Entry::Index->new({name => qq{index$i});
    #$index->push_kvpair({ src => q{...});
    #...

    my $source  = Sphinx::Config::Simple::Entry::Source->new({name => qq{source$i});
    #$source->push_kvpair({ x => q{...});
    #...

    $cfg->push_index($index);
    $cfg->push_source($source);
  }

  my $indexer = $cfg->indexer();
  my $searchd = $cfg->searchd();

  print $cfg->to_string();
  

=head1 DESCRIPTION

Stub documentation for Sphinx::Config::Simple, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

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

B. Estrade, E<lt>estrabd@gmail.com<gt>

=head1 CoPYRIGHT AND LICENSE

Copyright (C) 2013 by B. Estrade 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.4 or,
at your option, any later version of Perl 5 you may have available.


=cut

package Sphinx::Config::Builder;

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

sub as_string {
  my $self = shift;
  my $ret = q{};
  foreach my $source (@{$self->source_list}) {
    $ret .= $source->as_string();
  }
  foreach my $index (@{$self->index_list}) {
    $ret .= $index->as_string();
  }
  $ret .= $self->indexer->as_string();
  $ret .= $self->searchd->as_string();
  return $ret;
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

sub as_string {

}

package Sphinx::Config::Entry::Source;

our @ISA = q{Sphinx::Config::Entry};

sub name {
  my $self = shift;
  $self->{name} = $_[0] if $_[0];
  return $self->{name};
}

sub as_string {
  my $self = shift;
  my $name = $self->{name};
  my $ret =  qq/
source $name 
{ 
/;
  foreach my $kv_pair (@{$self->{kv_pairs}}) {
    my @k = keys %$kv_pair;
    my $k = pop @k;
    my $v = $kv_pair->{$k}; 
    $ret .= qq{    $k = $v\n};
  }
  $ret .= qq/
}/;
  return $ret;
}

package Sphinx::Config::Entry::Index;

our @ISA = q{Sphinx::Config::Entry};

sub name {
  my $self = shift;
  $self->{name} = $_[0] if $_[0];
  return $self->{name};
}

sub as_string {
  my $self = shift;
  my $name = $self->{name};
  my $ret =  qq/
index $name 
{ 
/;
  foreach my $kv_pair (@{$self->{kv_pairs}}) {
    my @k = keys %$kv_pair;
    my $k = pop @k;
    my $v = $kv_pair->{$k}; 
    $ret .= qq{    $k = $v\n};
  }
  $ret .= qq/
}/;
  return $ret;
}

package Sphinx::Config::Entry::Indexer;

our @ISA = q{Sphinx::Config::Entry};

sub as_string {
  my $self = shift;
  my $ret =  qq/
indexer 
{ 
/;
  foreach my $kv_pair (@{$self->{kv_pairs}}) {
    my @k = keys %$kv_pair;
    my $k = pop @k;
    my $v = $kv_pair->{$k}; 
    $ret .= qq{    $k = $v\n};
  }
  $ret .= qq/
}/;
  return $ret;
}

package Sphinx::Config::Entry::Searchd;

our @ISA = q{Sphinx::Config::Entry};

sub as_string {
  my $self = shift;
  my $ret =  qq/
searchd 
{ 
/;
  foreach my $kv_pair (@{$self->{kv_pairs}}) {
    my @k = keys %$kv_pair;
    my $k = pop @k;
    my $v = $kv_pair->{$k}; 
    $ret .= qq{    $k = $v\n};
  }
  $ret .= qq/
}/;
  return $ret;
}

1;

__END__
=head1 NAME

Sphinx::Config::Builder - Perl extension creating dynamic Sphinx configuration files. 

=head1 SYNOPSIS

  use Sphinx::Config::Builder;

=head1 DESCRIPTION

This module allows one to systematically construct a Sphinx configuration file that
contains so many entries that it is best created dynamically.

This module doesn't read in Sphinx configuration files, it simply allows one
to construct and output a configuration file programmtically.

=head1 AUTHOR

B. Estrade, E<lt>estrabd@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Same terms as Perl itself.

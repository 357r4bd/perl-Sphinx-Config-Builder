package Sphinx::Config::Builder;

use strict;
use warnings;

our $VERSION = '0.01';

sub new {
    my $pkg  = shift;
    my $self = {
        indexes => [],    # container of ::Index references
        sources => [],    # container of ::Source references
        indexer => Sphinx::Config::Entry::Indexer->new(),
        searchd => Sphinx::Config::Entry::Searchd->new(),
    };

    bless $self, $pkg;
    return $self;
}

sub push_index {
    my $self = shift;
    push @{ $self->{indexes} }, @_;
    return;
}

sub pop_index {
    my $self = shift;
    return pop @{ $self->{indexes} };
}

sub push_source {
    my $self = shift;
    push @{ $self->{sources} }, @_;
    return;
}

sub pop_source {
    my $self = shift;
    return pop @{ $self->{sources} };
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
    my $ret  = q{};
    foreach my $source ( @{ $self->source_list } ) {
        $ret .= $source->as_string();
    }
    foreach my $index ( @{ $self->index_list } ) {
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
    my $self = { kv_pairs => [], };

    bless $self, $pkg;
    return $self;
}

sub push {
    my $self = shift;
    return push @{ $self->{kv_pairs} }, @_;
}

sub pop {
    my $self = shift;
    return pop @{ $self->{kv_pairs} };
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
    my $ret  = qq/
source $name 
{ 
/;
    foreach my $kv_pair ( @{ $self->{kv_pairs} } ) {
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
    my $ret  = qq/
index $name 
{ 
/;
    foreach my $kv_pair ( @{ $self->{kv_pairs} } ) {
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
    my $ret  = qq/
indexer 
{ 
/;
    foreach my $kv_pair ( @{ $self->{kv_pairs} } ) {
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
    my $ret  = qq/
searchd 
{ 
/;
    foreach my $kv_pair ( @{ $self->{kv_pairs} } ) {
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

=head1 VERSION

=head1 SYNOPSIS

	use Sphinx::Config::Builder;
	my $builder = Sphinx::Config::Builder->new();
        my $INDEXPATH = q{/path/to/indexes};
        my $XMLPATH = q{/path/to/xmlpipe2/output};
	
	foreach my $category (@categorys) {
	    foreach my $document_set (keys $config->{$category}) {
		my $xmlfile = qq{$document_set-$category} . q{.xml};
		my $source_name  = qq{$document_set-$category} . q{_xml};
		my $index_name   = qq{$document_set-$category};
		my $src   = Sphinx::Config::Entry::Source->new();
		my $index = Sphinx::Config::Entry::Index->new();
	
		$src->name($source_name);
		$src->push(
		    { type => q{xmlpipe}},
		    { xmlpipe_command => qq{/bin/cat $XMLPATH/$xmlfile} },
		);
		$builder->push_source($src);
	
		$index->name($index_name);
		$index->push(
		    { source => qq{$source_name} }, 
		    { path => qq{$INDEXPATH/$document_set} },
		    { charset_type => q{utf-8} },
		);
	
                $builder->push_index($index);
	    }
	}
	$builder->indexer->push({ mem_limit => q{64m} });
	$builder->searchd->push(
	    { compat_sphinxql_magics => 0 },
	    { listen          => q{192.168.0.41:9312} },
	    { listen          => q{192.168.0.41:9306:mysql41} },
	    { log             => q{/var/log/sphinx/searchd.log} },
	    { query_log       => q{/var/log/sphinx/log/query.log} },
	    { read_timeout    => 30 },
	    { max_children    => 30 },
	    { pid_file        => q{/var/log/sphinx/searchd.pid} },
	    { seamless_rotate => 1 },
	    { preopen_indexes => 1 },
	    { unlink_old      => 1 },
	    { workers         => q{threads} }, # for RT to work
	    { binlog_path     => q{/var/log/sphinx} },
	  );
	  
          # output entire configuration 
	  print $builder->as_string();

=head1 DESCRIPTION

This module allows one to systematically construct a Sphinx configuration file that
contains so many entries that it is best created dynamically.

This module doesn't read in Sphinx configuration files, it simply allows one
to construct and output a configuration file programmtically.

=head1 SUBROUTINES/METHODS

=head1 DEPENDENCIES

None.

=head1 DIAGNOSTICS

None.

=head1 CONFIGURATION AND ENVIRONMENT

None.

=head1 INCOMPATIBILITIES

None.

=head1 BUGS AND LIMITATIONS

Please report - L<https://github.com/estrabd/perl-Sphinx-Config-Builder/issues> 

=head1 AUTHOR

B. Estrade, E<lt>estrabd@gmail.com<gt>

=head1 LICENSE AND COPYRIGHT

Same terms as Perl itself.

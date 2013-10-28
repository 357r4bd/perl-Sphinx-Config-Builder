#!/usr/bin/perl 

use warnings;
use strict;

use lib q{/home/patchbaz/git/perl-Sphinx-Config-Simple/lib};

use File::Path qw/mkpath/;
use Config::Tiny;
use Sphinx::Config::Simple;
use Data::Dumper;

my $config = Config::Tiny->read(q{/home/patchbaz/sphinx/indexer.conf}) or die q{can't find indexer.conf};

my $builder = Sphinx::Config::Simple->new();

my @cats = keys $config->{categories};
foreach my $cat (@cats) {
    foreach my $store (keys $config->{$cat}) {
        my $xmlfile = qq{$store-$cat} . q{.xml};
        my $source_name  = qq{$store-$cat} . q{_xml};
        my $index_name   = qq{$store-$cat};
        my $src   = Sphinx::Config::Entry::Source->new();
        my $index = Sphinx::Config::Entry::Index->new();

        $src->name($source_name);
        $src->push(
            { type => q{xmlpipe}},
            { xmlpipe_command => qq{/bin/cat /home/patchbaz/sphinx/$cat/$xmlfile} },
        );
        $builder->push_source($src);

        $index->name($index_name);
        $index->push(
            { source => qq{$source_name} }, 
            { path => qq{/home/patchbaz/sphinx/$cat/$store} },
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
    { log             => q{/home/patchbaz/sphinx/log/searchd.log} },
    { query_log       => q{/home/patchbaz/sphinx/log/query.log} },
    { read_timeout    => 30 },
    { max_children    => 30 },
    { pid_file        => q{/home/patchbaz/sphinx/log/searchd.pid} },
    { max_matches     => 1000000 },
    { seamless_rotate => 1 },
    { preopen_indexes => 1 },
    { unlink_old      => 1 },
    { workers         => q{threads} }, # for RT to work
    { binlog_path     => q{/home/patchbaz/sphinx} },
  );

print $builder->to_string();

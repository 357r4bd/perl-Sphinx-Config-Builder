perl-Sphinx-Config-Builder
=========================

The motivation behind this module is the need to manage many indexes and corresponding sources
handled by a single Sphinx searchd instance.  Managing a configuration file with many indexes
and sources quickly becomes unweildy, and a programatic solution is necessary. 

We take advantage of the fact that Sphinx will treat a configuration file as a program if there
is a shebang line to utilize. Perl is an obvious choice for creating such dynamic configuration
files.

Using Sphinx::Config::Builder, one may more easily manage Sphinx configurations using a more
appropriate backend (e.g., a simple .ini file or even a  MySQL database).

This is particularly useful if one is frequently adding or deleting indexes and sources.

This approach is also particularly useful for managing non-natively supported Sphinx data sources
that require the additional step of generating XMLPipe/Pipe2 sources.

Note: the module doesn't read in Sphinx configuration files, it simply allows one to write a program
that dynamically outputs a configuration for Sphinx to read at runtime.

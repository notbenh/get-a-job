#!/usr/bin/env perl
use strict;
use warnings;
#use Config::Any;
use YAML::XS qw{LoadFile};
use Getopt::Std;
use Data::Dumper; sub DUMP (@){print Dumper(@_)};
use Template;

sub help {
   print <<END;
 USEAGE :
 resume.pl -i myresume.yaml -t html > resume.html

   -i : input data file, expected to be YAML, JSON, or any thing else read by Config::Any.
   -t : template, '.tt2' is appended to this value if not supplied.

 output is streamed to STDOUT

END
   exit;
}

our($opt_i, $opt_t);
getopts('i:t:');

&help unless defined $opt_i && defined $opt_t;

# well this is discusting !!!!
#my (undef, $data) = %{ Config::Any->load_files({files => [$opt_i], use_ext => 1 })->[0] };
my $data = LoadFile($opt_i);
my $template = $opt_t =~ m/\.tt2$/ ? $opt_t : qq{$opt_t.tt2} ;
my $t = Template->new($template =~ m/^txt/ ? {} : {PRE_CHOMP=>1});
$t->process($template, $data) or die $t->error();


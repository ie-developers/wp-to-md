#!/usr/bin/perl

use strict;
use warnings;

use File::Find;
use File::Path;
# use File::Slurp;

# input and output directory
my $html_dir = '/mnt/cephfs/ie-web/ie/';
my $md_dir = '/mnt/cephfs/ie-web/ie-hugo/content/ja/';

my @files = <>;
chop @files;

foreach my $file ( @files ) {
	find(\&wanted, $html_dir . $file);
}

sub wanted {
    # Only proceed for HTML files
    if (m/\.html$/) {
        my $html_file = $File::Find::name;

        # Generate output markdown filename
        my $md_file = $html_file;
	# $md_file =~ s/index.html/_index.html/;
        $md_file =~ s/^$html_dir/$md_dir/;
        $md_file =~ s/\.html$/.md/;
	$md_file =~ s/%([0-9A-Fa-f]{2})/pack('C', hex($1))/ge;

        # Create directory path if it doesn't exist
        my $md_dirname = $md_file;
        $md_dirname =~ s/\/[^\/]+$//;
        mkpath($md_dirname) unless (-d $md_dirname);

	system  "perl /ie-ryukyu/podman/web-servers/web-to-md/html-to-md.pl $html_file > $md_file\n";
    }
}

print "Conversion complete\n";


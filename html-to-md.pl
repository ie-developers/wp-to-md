#!/usr/bin/perl

my ($title);

my ($url) = $ARGV[0];

$url =~ s!/mnt/cephfs/ie-web/ie/!!;
$url =~ s!index.html!!;
$url =~ s/%([0-9A-Fa-f]{2})/pack('C', hex($1))/ge;

while (<>) {
   if (/\<title\>(.*)\<\/title\>/) {
       $title = $1;
	 $title =~ s/\&\#8211\;/-/g;
	 $title =~ s/\&\#8212\;/—/g;
	 $title =~ s/\&lt\;/</g;
	 $title =~ s/\&gt\;/>/g;
	 $title =~ s/\&smp\;/&/g;
	 $title =~ s/\&nbsp\;//g;
print <<"EOFEOF";
---
title: "$1"
url: /ja/$url
paginate: 0
---
EOFEOF
       print "# $1\n\n";
       last;
   } 
}

while (<>) {
   if (/\<section class\=\"wrapper wrap-detail-page\"\>|\<main id=\"main\" class=\"post-main-content\" role=\"main\"\>/ .. /\<div id=\"wp-browsing-history-title\" style\="display\:none\;\"\>/) {
      if (/\<h2\>(.*)\<\/h2\>/) {
	  print "\n# $1\n\n";
      } else {
	 s/\<li\>/- /g;
	 s/\&\#8211\;/-/g;
	 s/\&\#8212\;/—/g;
	 s/\&lt\;/</g;
	 s/\&gt\;/>/g;
	 s/\&smp\;/&/g;
	 s/\&nbsp\;//g;
	 if (s/\<a href=\"([^"]*?)\"[^>]*?\>(.*?)\<\/a\>/[$2]($1)/) {
              s/%([0-9A-Fa-f]{2})/pack('C', hex($1))/ge;
	 }
	 s/\<img src=\"([^"]*?)\"[^>]*?\>>/![image]($1)/;
         s/\<[^\>]*\>//g;
	 print;
      }
   }
}



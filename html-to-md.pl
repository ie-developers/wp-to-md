#!/usr/bin/perl

my ($title);

while (<>) {
   if (/\<title\>(.*)\<\/title\>/) {
       $title = $1;
       print "# $1\n\n";
       last;
   } 
}

while (<>) {
   if (/\<section class\=\"wrapper wrap-detail-page\"\>/ .. /\<div id=\"wp-browsing-history-title\" style\="display\:none\;\"\>/) {
      if (/\<h2\>(.*)\<\/h2\>/) {
	  print "\n# $1\n\n";
      } else {
	 s/\<li\>/- /g;
	 s/\<a href=\"([^"]*?)\"[^>]*?\>(.*?)\<\/a\>/[$2]($1)/;
         s/\<[^\>]*\>//g;
	 print;
      }
   }
}


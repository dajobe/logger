#!/usr/bin/perl -Tw
#
# IRC Chat search CGI script
#
# $Id$
#
# (C) Copyright 2004 Dave Beckett, ILRT, University of Bristol
# http://purl.org/net/dajobe/
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License
#   as published by the Free Software Foundation; either version 2
#   of the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# This is a CGI script.  However, you can invoke it from the command line
# due to the CGI.pm module feature.  The parameters to the script are
#
#  q       search query   =perl regex (no default)
#  channel IRC channel    =one of @channels (no default)
#  case    case sensitive =yes|no (default yes)
#  count   result count   =number (default $default_count)

use warnings;
use strict;

# Helps with broken web requests (missing headers)
$ENV{'Content-Length'}||=0;

# Tainting, dontcha know
$ENV{'PATH'}="/bin:/usr/bin:/usr/local/bin";
$ENV{TZ}='UTC';
delete $ENV{'BASH_ENV'};

# Standard perl modules
use CGI;

# Configuration
my $home='/wherever';
my $logs="$home/chat-logs";
my $indexes="$home/indexes";
my $root="$logs/servers";
my $base_uri='http://www.ilrt.bris.ac.uk/discovery/chatlogs/';
my $default_count=10;

my(@channels)=qw(your-channels-here);

######################################################################
# Subroutines

sub end_page($) {
  my $q=shift;

print <<"EOT";
    <p>
      <small>Provided by <a href="http://purl.org/net/dajobe/">Dave Beckett</a>,
 <a href="http://www.ilrt.bristol.ac.uk/">Institute for Learning and Research Technology</a>, <a href="http://www.bristol.ac.uk/">University of Bristol</a></small>
    </p>

</body>
</html>
EOT
}


sub format_literal ($) {
  my($string)=@_;
  return 'UNDEFINED' if !defined $string;
  # No need for HTML::Entities here for four things

  $string =~ s/\&/\&amp;/g;
  $string =~ s/</\&lt;/g;
  $string =~ s/>/\&gt;/g;
  $string =~ s/"/\&quot;/g; #"
  $string;
}

######################################################################
my $query = new CGI;

# CGI parameter paranoia
my $val;


my $q;
my $orig_q;
$val=$query->param('q');
if(defined $val) {
  # Only allow a few regexes
  $orig_q=$val;

  # Remove (?...) blocks since they can do evals
  $val =~ s/\(\?[^)]+\)//g;
  # Remove backticks since they can run processes
  $val =~ s/\`//g;
  # Remove variable references
  $val =~ s/\$//g;
  # Quote '/'s
  $val =~ s%/%\\/%g;

  # Stop errors in regexes with leading qualifiers
  # Was found with a search for *thing*
  $val =~ s%^[+*?]%%;

  if (length $val && $val =~ /^(.+)$/) {
    $val=$1;
  } else {
    $val=undef;
  }
  $q=$val;
} else {
  $q=undef;
}


my $channel;
if($channel=$query->param('channel')) {
  if (grep($channel eq $_, @channels)) {
    if($channel =~ /^(\w+)$/) {
      $channel=$1;
    } else {
      $channel=undef;
    }
  } else {
    $channel=undef;
  }
}


my $count;
if($count=$query->param('count')) {
  if ($count =~ /^(\d+)$/) {
    $count=$1;
    $count=undef if $count<0 || $count>100;
  } else {
    $count=undef;
  }
}


my $case;
if($case=$query->param('case')) {
  if ($case eq 'no') {
    $case='no';
  } else {
    $case=undef;
  }
}

my $empty=(!$q || !$channel);


# Zap remaining parameters
$query->delete('Go');
$query->delete_all;

# End of parameter decoding


######################################################################
# Emit content

my $type='text/html';
my $xhtml_type='application/xhtml+xml';

if(grep($_ eq $xhtml_type, $query->Accept())) {
  $type=$xhtml_type if $query->Accept($xhtml_type) > 0.0;
}

print $query->header(-type => $type, -charset=>'utf-8');


# Always print header
print <<"EOT";
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <title>IRC Chat Logs Search</title>
    <link rel="alternate stylesheet" type="text/css" media="screen" title="old" href="http://www.ilrt.bris.ac.uk/discovery/2003/09/ircstyle/old.css" />
    <link rel="stylesheet" type="text/css" media="screen" title="main" href="http://www.ilrt.bris.ac.uk/discovery/2003/09/ircstyle/stylesheet.css" />
    <meta http-equiv="Content-type" content="$type; charset=utf-8" />
<script type="text/javascript">
<!--
function qf(){document.f.q.focus();}
// -->
</script>
</head>
<body bgcolor="#ffffff" text="#000085" onload="qf()">
   <h1>IRC Chat Logs Search</h1>

<p>Enter a search query and select a channel (you can use a limited
Perl regex subset).</p>

EOT

# Restore values
$query->delete_all;

$query->param('q', $q) if $q;
$query->param('channel', $channel) if $channel;
$query->param('count', $count) if $count;
$query->param('case', $case) if $case;


# use q->url() to get URL of this script without any query parameters
# since we are using a POST here and don't want them added to the
# submission URL.
my $action_url="/discovery/chatlogs/search";

print $query->start_form(-name => 'f', -method=>'GET', -action => $action_url),"\n";

print "<p>Query: ";
print $query->textfield(-name=>'q',
		    -default=>'',
		    -size=>60,
		    -maxlength=>1024);
print '&#160;', $query->submit('Go');

print "<br />\nChannel: ";
print $query->popup_menu(-name=>'channel',
                     -values=>\@channels, -default=>'rdfig');
print "&#160; number of results: ";
print $query->popup_menu(-name=>'count',
                     -values=>['10','20', '50', '100'], -default=>$default_count);
print "&#160; ignore case: ";
print $query->popup_menu(-name=>'case',
                     -values=>['yes', 'no'], -default=>'yes');


print "</p>\n\n";

print $query->endform,"\n\n";

# Any parameters?
if($empty) {

  print <<"EOT";
<!-- blah blah -->
EOT

  end_page($query);
  exit 0;
}


######################################################################


my(@t)=reverse ((gmtime(time))[3..5]);
$t[0]+=1900; $t[1]++;
my $today=sprintf("%04d-%02d-%02d", @t);


my $dir="$root/$channel";
my $index_file=$indexes."/".$channel;

my $today_file="$dir/$today.txt";

my(@results);
my(@lines)=();

$q='(?i)'.$q unless defined $case;

if(-r $today_file && open(IN, "<$today_file")) {
  @lines=reverse map {chomp; $_="$today ".$_; $_;} <IN>;
  close(IN);

  eval "\@results=grep(/$q/, \@lines);";
}

$count ||= $default_count;

if(@results < $count) { 
  open(IN, "<$index_file") or die "Cannot read $index_file\n";
  while(<IN>) { 
    if(/$q/) {
      push(@results, $_);
      last if @results >= $count;
    }
  }
  close(IN);
}


print <<"EOT" if $channel;
<hr />

<p><a href="$base_uri$channel/">$channel channel logs</a> &gt;
(<a href="$base_uri$channel/latest">Latest</a>)
</p>

EOT



if(!@results) {
  print "<p>Sorry, nothing found for '$orig_q'.</p>\n";
} else {
  print qq{<div class="log">\n};
  my $i=1;
  for my $result (@results) {
    my($date,$time,$line)=split(/ /, $result, 3);
    my $id="T$time"; $id =~ s/:/-/g;
    my $url=$base_uri.$channel."/".$date.".html";
    
    my $nick;
    if($line =~ s%^<([^>]+)>\s*(.*)$%$2%) {
      $nick=format_literal($1);
    } elsif($line =~ s%\* (\S+)\s*(.*)$%$2%) {
      $nick=format_literal($1);
    } else {
      $nick='&#160;';
    }

    $line=format_literal($line);

    eval "\$line =~ s/($q)/<span class=\"match\">\$1<\\/span>/g;";

    print qq{<p><span class="time"><b>$i</b>&#160;</span> <span class="time"><a href="$url">$date</a> <a href="$url#$id">$time</a></span> <span class="nick">&lt;$nick&gt;</span> <span class="comment">$line</span></p>\n};
    $i++;
  }
  print qq{</div>\n};
}

print <<"EOT";
<hr />

<p>The IRC chat here was automatically logged without editing and
contains content written by the chat participants identified by their
IRC nick.  No other identity is recorded.</p>
EOT


end_page($query);



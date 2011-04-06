#!/usr/local/bin/perl
#
# Makefile.PL - perl Extutils::MakeMaker makefile for logger bot
#
# See README.html for license terms.
# 
# USAGE: perl Makefile.PL
# then to build dist - 'make help.html README'; 'make dist'
# 

use ExtUtils::MakeMaker;

sub MY::postamble {
  return <<'EOT';
SUFFIXES = .html

README: README.html
	TERM=vt100 lynx -dump -nolist $< > $@

help.html: logger
	pod2html --noindex --infile=$< > $@ && rm -f pod2htm*
EOT
}

use POSIX qw(strftime);
my $version=strftime("%Y-%m-%d", gmtime);



WriteMakefile(
    'DISTNAME'	=> "logger",
    'NAME'	=> "logger",
    'AUTHOR'    => 'Dave Beckett <http://www.dajobe.org/>, Ralph Swick <swick@w3.org>',
    'ABSTRACT'  => "IRC Logger bot",
    'VERSION'   => $version,

    'EXE_FILES' => ['bin/logger', 'bin/indexly', 'bin/rebuild-indexes' ],
    'clean'     => { FILES => "README help.html logger.1" },
);


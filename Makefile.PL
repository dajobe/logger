#!/usr/local/bin/perl
#
# Makefile.PL - perl Extutils::MakeMaker makefile for logger bot
#
# $Id$
#
# See README.html for license terms.
# 
# USAGE: perl Makefile.PL
# then to build dist - 'make help.html README'; 'make dist'
# 

use ExtUtils::MakeMaker;

sub MY::postamble {
  return <<'EOT';
LYNX=lynx
LYNXARGS=-dump -nolist

SUFFIXES = .html

README: README.html
	$(LYNX) $(LYNXARGS) $< > $@

help.html: logger
	pod2html --noindex --infile=$< > $@ && rm -f pod2htm*
EOT
}



WriteMakefile(
    'DISTNAME'	=> "logger",
    'NAME'	=> "logger",
    'AUTHOR'    => 'Dave Beckett <Dave.Beckett@bristol.ac.uk>  Ralph Swick <swick@w3.org>',
    'ABSTRACT'  => "IRC Logger bot",
    'VERSION'   => "1.0",

    'EXE_FILES' => ['logger' ],
    'clean'     => { FILES => "README help.html logger.1" },
);


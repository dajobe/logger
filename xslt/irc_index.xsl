<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:wn="http://xmlns.com/wordnet/1.6/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:foaf="http://xmlns.com/foaf/0.1/">


<!--

XSLT stylesheet for transforming IRC chat logs main index page into XHTML
Dave Beckett, http://www.dajobe.org/

-->


<xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no" />

<xsl:variable name="period" select="/rdf:RDF/rdf:Seq/dc:title" />
<xsl:variable name="year" select="substring($period,0,5)" />
<xsl:variable name="ym" select="substring($period,0,8)" />

<xsl:template match="rdf:Seq">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <title><xsl:value-of select="$title"/> IRC Chat Logs for <xsl:value-of select="$period" /></title>
    <link rel="stylesheet" type="text/css" media="screen" title="main" href="/style/stylesheet.css" />
    <link rel="alternate stylesheet" type="text/css" media="screen" title="old" href="/style/old.css" />
    <link rel="alternate" type="application/rdf+xml" title="RDF Version" href="{$period}.rdf" />
    <link rel="alternate" type="text/plain" title="Text Version" href="{$period}.txt" />
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <meta name="robots" content="noindex, nofollow" />
    </head>
  <body>

  <h1><xsl:value-of select="$title"/> IRC Chat Logs for <xsl:value-of select="$period" /></h1>

<p>This is an automatically generated IRC chat log made by the
<a href="http://www.dajobe.org/software/logger/">perl IRC logger bot</a>
from the 
<a href="{$url}"><xsl:value-of select="$title"/></a>
<xsl:text> </xsl:text>
<a href="http://esw.w3.org/topic/InternetRelayChat">IRC</a> chat at
<a href="irc://{$ircserver}/{$ircchannel}">server <xsl:value-of select="$ircserver"/> channel #<xsl:value-of select="$ircchannel"/></a>.
Provided by <a href="http://planetrdf.com/">Planet RDF</a>.
</p>

<xsl:choose>
<xsl:when test="$ircchannel = 'rdfig'">
<p><b>NOTICE:</b> You might like to use the all new and
shiny <code>#swig</code> channel for Semantic Web Interest Group chat.
Change your client to <code>#swig</code> and enjoy the new experience.
Or <a href="/swig/latest">read the latest #swig logs</a>
to see what you've been missing :)
</p>
</xsl:when>

<xsl:when test="$ircchannel = 'www2004'">
<p>See also the
<a href="http://www2004.xmlhack.com/" title="WWW2004 Community Coverage">WWW2004
 Community Coverage</a>
for the collaboratively written weblog and
<a href="http://esw.w3.org/topic/WWW2004">WWW2004 on the ESW wiki</a>.</p>
</xsl:when>
</xsl:choose>

<hr />

<p><a href="../{$ircchannel}/"><xsl:value-of select="$title"/> Logs</a> &gt;
<xsl:choose>
  <xsl:when test="$period = recent">
  </xsl:when>
  <xsl:when test="$period = $year">
    <strong><xsl:value-of select="$year" /></strong>
  </xsl:when>
  <xsl:when test="$period = $ym">
    <a href="{$year}.html"><xsl:value-of select="$year" /></a> &gt;
    <strong><xsl:value-of select="$ym" /></strong>
  </xsl:when>
  <xsl:otherwise>
    <a href="{$year}.html"><xsl:value-of select="$year" /></a> &gt;
    <a href="{$ym}.html"><xsl:value-of select="$ym" /></a>
  </xsl:otherwise>
</xsl:choose>

<xsl:choose>
<xsl:when test="$latest = 'yes'">
(<a href="latest">Latest</a>)
</xsl:when>
</xsl:choose>
(<a href="../search?channel={$ircchannel}">Search</a>)
</p>

<ul>
    <xsl:apply-templates select="./rdf:li" />
</ul>

<hr />

<p>Alternate versions:
<a href="{$period}.rdf" title="RDF Resource Description Framework"><img border="0" width="36" height="14" src="/images/rdf.png" alt="RDF Resource Description Framework Metadata" /></a>
and
<a href="{$period}.txt">Text</a>
</p>

<p><small>Provided by <a href="http://www.dajobe.org/">Dave Beckett</a> as part of <a href="http://planetrdf.com/">Planet RDF</a></small></p>

</body>
</html>
</xsl:template>

<xsl:template match="rdf:li" name="regular">
  <xsl:variable name="url" select="./rdf:Description/@rdf:about" />
  <xsl:variable name="prefix" select="substring-before($url,'.rdf')" />
  <xsl:variable name="desc" select="./rdf:Description/dc:title" />
     <li><a href="{$prefix}.html"><xsl:value-of select="$desc" /></a>
         <!-- <a href="{$url}">RDF</a> --> 
     </li>
</xsl:template>


</xsl:stylesheet>


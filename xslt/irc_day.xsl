<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:wn="http://xmlns.com/wordnet/1.6/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
	        xmlns="http://www.w3.org/1999/xhtml">


<!--

XSLT stylesheet for transforming IRC chat logs daily page into XHTML
Dave Beckett, http://www.dajobe.org/

-->


<xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no" />

<xsl:variable name="date" select="substring(/rdf:RDF/foaf:ChatChannel/foaf:chatEventList/rdf:Seq/rdf:li/foaf:chatEvent/dc:date,0,11)" />
<xsl:variable name="year" select="substring($date,0,5)" />
<xsl:variable name="month" select="substring($date,6,2)" />
<xsl:variable name="day" select="substring($date,9,2)" />

<xsl:template match="foaf:chatEventList">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <title><xsl:value-of select="$title"/> IRC Chat Logs for <xsl:value-of select="$date" /></title>
    <link rel="stylesheet" type="text/css" media="screen" title="main" href="/style/stylesheet.css" />
    <link rel="alternate stylesheet" type="text/css" media="screen" title="old" href="/style/old.css" />
    <link rel="alternate" type="application/rdf+xml" title="RDF Version" href="{$date}.rdf" />
    <link rel="alternate" type="text/plain" title="Text Version" href="{$date}.txt" />
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <meta name="robots" content="noindex, nofollow" />
    </head>
  <body>

  <h1><xsl:value-of select="$title"/> IRC Chat Logs for <xsl:value-of select="$date" /></h1>

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
<p><b>NOTICE:</b> #rdfig logs were turned off 2004-12-03.  Please
switch to the new and
shiny <code>#swig</code> channel for Semantic Web Interest Group chat.
Change your client to <code>#swig</code> and enjoy the new experience.
Or <a href="/swig/latest">read the latest #swig logs</a>
to see what you've been missing :)
</p>
</xsl:when>
<xsl:when test="$ircchannel = 'redland'">
<p>See the <a href="http://librdf.org/">Redland home page</a>
for more information.</p>
</xsl:when>
<xsl:when test="$ircchannel = 'swig'">
<p>See also the
<a href="http://swig.xmlhack.com/"><xsl:value-of select="$title"/>IRC Scratchpad</a>
for the collaboratively written weblog and
<a href="http://esw.w3.org/topic/FrontPage">ESW wiki</a>.</p>
</xsl:when>
<xsl:when test="$ircchannel = 'www2004'">
<p>See also the
<a href="http://www2004.xmlhack.com/" title="WWW2004 Community Coverage">WWW2004 Community Coverage</a>
for the collaboratively written weblog and
<a href="http://esw.w3.org/topic/WWW2004">WWW2004 on the ESW wiki</a>.</p>
</xsl:when>
</xsl:choose>

<!--
<p>Lines starting with a linked @user are converted from a Twitter to
IRC bot (sioc-bot) that passes in some twitter lines that are related
to the channel by hash tag or search.  The raw text and RDF logs do not
contain this interpretation.</p>
-->

<hr />

<p><a href="../{$ircchannel}/"><xsl:value-of select="$title"/> Logs</a> &gt;
<a href="{$year}.html"><xsl:value-of select="$year" /></a> &gt;
<a href="{$year}-{$month}.html"><xsl:value-of select="$year" />-<xsl:value-of select="$month" /></a> &gt;
<strong><xsl:value-of select="$date" /></strong>

<xsl:choose>
<xsl:when test="$latest = 'yes'">
(<a href="latest">Latest</a>)
</xsl:when>
</xsl:choose>
(<a href="../search?channel={$ircchannel}">Search</a>)
</p>


<div class="log">
  <xsl:for-each select="rdf:Seq">
    <xsl:apply-templates select="./rdf:li" />
  </xsl:for-each>
</div>

<hr />

<p>The IRC chat here was automatically logged without editing and
contains content written by the chat participants identified by their
IRC nick.  No other identity is recorded.</p>

<p>Alternate versions:
<a href="{$date}.rdf" title="RDF Resource Description Framework"><img border="0" width="36" height="14" src="/images/rdf.png" alt="RDF Resource Description Framework Metadata" /></a>
and
<a href="{$date}.txt">Text</a>
</p>

<p><small>Provided by <a href="http://www.dajobe.org/">Dave Beckett</a> as part of <a href="http://planetrdf.com/">Planet RDF</a></small></p>

</body>
</html>
</xsl:template>

<xsl:template match="rdf:li" name="regular">
  <xsl:variable name="id" select="./foaf:chatEvent/@rdf:ID" />
  <xsl:variable name="desc" select="./foaf:chatEvent/dc:description" />
  <xsl:variable name="time" select="substring(./foaf:chatEvent/dc:date, 12, 8)" />
  
  <xsl:variable name="nick" select="./foaf:chatEvent/dc:creator/wn:Person/@foaf:nick" />
  <xsl:variable name="uri" select="./foaf:chatEvent/dc:relation/@rdf:resource" />

<p>
<span class="time" id="{$id}"><a href="#{$id}"><xsl:value-of select="$time" /></a></span>
<xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="starts-with($desc,'* ')">
        <span class="nick"><xsl:text> </xsl:text></span><span class="comment"><span class="action"><xsl:value-of select="$desc" /></span></span>
      </xsl:when>

      <xsl:when test="starts-with($desc,'topic is: ')">
        <span class="nick"><xsl:text> </xsl:text></span><span class="comment">Topic now <span class="newtopic"><xsl:value-of select="substring-after($desc,'topic is: ')" /></span></span>
      </xsl:when>

      <xsl:when test="starts-with($desc,'has changed the topic to: ')">
        <span class="nick"><xsl:text> </xsl:text></span><span class="comment">Topic now <span class="newtopic"><xsl:value-of select="substring-after($desc,'has changed the topic to: ')" /></span></span><br />
      </xsl:when>

      <xsl:when test="starts-with($desc,'Users on')">
        <span class="nick"><xsl:text> </xsl:text></span><span class="comment"><xsl:value-of select="$desc" /></span><br />
      </xsl:when>

      <xsl:when test="starts-with($desc,'Disconnected from')">
        <span class="nick"><xsl:text> </xsl:text></span><span class="comment"><xsl:value-of select="$desc" /></span><br />
      </xsl:when>

      <xsl:when test="starts-with($desc,'Attempting to reconnect')">
        <span class="nick"><xsl:text> </xsl:text></span><span class="comment"><xsl:value-of select="$desc" /></span><br />
      </xsl:when>

      <xsl:when test="$uri = $desc">
        <xsl:text> </xsl:text><span class="nick">&lt;<xsl:value-of select="$nick" />&gt;</span><span class="comment"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="$uri" /></xsl:attribute><xsl:value-of select="$uri" /></xsl:element></span>
      </xsl:when>

<!--
      <xsl:when test="starts-with($desc,'Tw [') and $nick = 'sioc-bot'">
        <xsl:variable name="twuser" select="substring(substring(substring-before($desc,']'), 3), 3)" />
        <xsl:variable name="twlink" select="substring-after($desc,' &lt;&lt;&lt; ')" />
        <xsl:variable name="desc2" select="substring-after(substring-before($desc,' &lt;&lt;&lt; '), '] ')" />
        <span class="nick"><a href="{$twlink}"><em>@<xsl:value-of select="$twuser" /></em></a></span>
        <xsl:text> </xsl:text>
        <span class="comment"><xsl:value-of select="$desc2" /></span>
      </xsl:when>
-->

      <xsl:otherwise>
        <span class="nick">&lt;<xsl:value-of select="$nick" />&gt;</span>
        <xsl:text> </xsl:text>
        <span class="comment"><xsl:value-of select="$desc" /></span>
      </xsl:otherwise>
    </xsl:choose>
</p>

    <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="rdf:li">
  <xsl:variable name="desc" select="." />
  <xsl:variable name="nick" select="./foaf:chatEvent/dc:creator/wn:Person/@foaf:nick" />

  <xsl:choose>
    <xsl:when test="contains($desc,concat($nick,' has quit')) or contains($desc,concat($nick,' has joined')) or contains($desc,concat($nick,' has left'))">
    </xsl:when>

    <xsl:otherwise>        
       <xsl:call-template name="regular"/>                         
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


</xsl:stylesheet>


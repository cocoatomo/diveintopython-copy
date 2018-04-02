<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  exclude-result-prefixes="#default">

<xsl:import href="html.xsl"/>

<xsl:template match="/">
  <xsl:apply-templates select="//revhistory"/>
</xsl:template>

<xsl:template match="revhistory">
  <feed version="0.2" xmlns="http://purl.org/atom/ns#" xml:lang="en" xml:base="http://diveintopython.org/xml/">
    <title>Dive Into Python</title>
    <tagline>Python from novice to pro</tagline>
    <link>http://diveintopython.org/</link>
    <id>urn:diveintopython-org:en</id>
    <modified><xsl:apply-templates select="revision[0]/date"/></modified>
    <author>
      <name>Mark Pilgrim</name>
      <url>http://diveintomark.org/</url>
      <email>f8dy@diveintomark.org</email>
    </author>
    <xsl:apply-templates select="revision"/>
  </feed>
</xsl:template>

<xsl:template match="revision">
  <item>
    <xsl:apply-templates select="revnumber"/>
    <link>http://diveintopython.org/history.html#<xsl:value-of select="revnumber"/></link>
    <id>urn:diveintopython-org:en:<xsl:value-of select="date"/></id>
    <issued><xsl:apply-templates select="date"/></issued>
    <modified><xsl:apply-templates select="date"/></modified>
    <content type="application/xhtml+xml" xml:lang="en">
      <body xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates select="revdescription"/></body>
    </content>
  </item>
</xsl:template>

<xsl:template match="revnumber">
  <title>Revision <xsl:value-of select="."/></title>
</xsl:template>

<xsl:template match="date">
  <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>

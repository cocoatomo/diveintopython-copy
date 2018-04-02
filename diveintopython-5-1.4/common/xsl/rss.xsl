<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/"
  version='1.0'
  exclude-result-prefixes="#default">

<xsl:template match="/">
  <xsl:apply-templates select="//revhistory"/>
</xsl:template>

<xsl:template match="revhistory">
  <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
      <title>Dive Into Python</title>
      <link>http://diveintopython.org/</link>
      <description>Python from novice to pro</description>
      <language>en</language>
      <xsl:apply-templates select="revision"/>
    </channel>
  </rss>
</xsl:template>

<xsl:template match="revision">
  <xsl:if test="position() &lt; 15">
  <item>
    <xsl:apply-templates select="revnumber"/>
    <link>http://diveintopython.org/appendix/history.html#<xsl:value-of select="revnumber"/></link>
    <xsl:apply-templates select="date"/>
  </item>
  </xsl:if>
</xsl:template>

<xsl:template match="revnumber">
  <title>Revision <xsl:value-of select="."/></title>
</xsl:template>

<xsl:template match="date">
  <dc:date><xsl:value-of select="."/></dc:date>
</xsl:template>

</xsl:stylesheet>

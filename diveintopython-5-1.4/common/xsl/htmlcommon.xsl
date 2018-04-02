<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  exclude-result-prefixes="#default">

<xsl:import href="common.xsl"/>

<xsl:param name="html.stylesheet">diveintopython.css</xsl:param>
<xsl:param name="admon.style"/>
<xsl:param name="css.decoration">0</xsl:param>
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="callout.graphics" select="1"/>
<xsl:param name="spacing.paras" select="0"/>

<!-- suppress line on title page -->
<xsl:template name="book.titlepage.separator"/>

<!-- suppress attributes on body tag -->
<xsl:template name="body.attributes"/>

<!-- use real header tags for example titles -->
<xsl:template name="formal.object.heading">
  <xsl:param name="object" select="."/>
  <h3 class="title">
    <xsl:apply-templates select="$object" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<!-- add Google-based search box to each page -->
<!-- see http://www.google.com/services/free.html for details about adding Google to your site -->
<xsl:template name="search.box">
  <form id="search" method="GET" action="http://www.google.com/custom">
    <p>
      <label for="q" accesskey="4">Find:&#160;</label>
      <input type="text" id="q" name="q" size="20" maxlength="255" value=" " />
      <xsl:text> </xsl:text>
      <input type="submit" value="Search"/>
      <input type="hidden" name="cof" value="LW:752;L:http://diveintopython.org/images/diveintopython.png;LH:42;AH:left;GL:0;AWFID:3ced2bb1f7f1b212;"/>
      <input type="hidden" name="domains" value="diveintopython.org"/>
      <input type="hidden" name="sitesearch" value="diveintopython.org"/>
    </p>
  </form>
</xsl:template>

<xsl:template name="navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <td id="breadcrumb" colspan="5" align="left">
    <xsl:text>&#160;</xsl:text>
  </td>
  <td id="navigation" align="right">
    <xsl:text>&#160;</xsl:text>
  </td>
</xsl:template>

<xsl:template name="logo">
  <h1 id="logo">
    <a href="../index.html" accesskey="1"><xsl:value-of select="/book/bookinfo/title"/></a>
  </h1>
</xsl:template>

<xsl:template name="tagline">
  <p id="tagline">
    <xsl:value-of select="//subtitle"/>
  </p>
</xsl:template>

<xsl:template name="header.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>

    <table id="Header" width="100%" border="0" cellpadding="0" cellspacing="0" summary="">
      <tr>
        <xsl:call-template name="navigation">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
        </xsl:call-template>
      </tr>
      <tr>
        <td colspan="3" id="logocontainer">
          <xsl:call-template name="logo"/>
          <xsl:call-template name="tagline"/>
        </td>
        <td colspan="3" align="right">
          <xsl:call-template name="search.box"/>
        </td>
      </tr>
    </table>
    <xsl:comment>#include virtual="/inc/ads" </xsl:comment>
</xsl:template>

<!--
Behavior:    callout text overlaps callout graphic
Environment: Netscape 6
Workaround:  specify width of callout graphic <td> in absolute pixels to match image width
-->
<xsl:template match="callout">
  <tr>
    <td width="12" valign="top" align="left">
      <xsl:call-template name="callout.arearefs">
        <xsl:with-param name="arearefs" select="@arearefs"/>
      </xsl:call-template>
    </td>
    <td valign="top" align="left">
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>

</xsl:stylesheet>

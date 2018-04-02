<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  exclude-result-prefixes="#default">

<xsl:import href="../docbook/xsl/html/docbook.xsl"/>
<xsl:import href="htmlcommon.xsl"/>

<xsl:output indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<xsl:param name="generate.component.toc" select="0"/>
<xsl:param name="section.autolabel" select="0"/>
<xsl:param name="chapter.autolabel" select="0"/>
<xsl:param name="admon.graphics.path">images/</xsl:param>
<xsl:param name="callout.graphics.path">images/callouts/</xsl:param>

<xsl:template name="navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <td id="breadcrumb" colspan="6">&#160;</td>
</xsl:template>

<xsl:template name="user.head.content">
  <link rel="alternate" type="application/rss+xml" title="RSS" href="http://diveintopython.org/history.xml"/>
<!--
  <link rel="alternate" type="application/atom+xml" title="Atom" href="xml/atom.xml"/>
-->
</xsl:template>

<xsl:template name="user.header.content">
  <xsl:call-template name="header.navigation"/>
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
</xsl:template>

<xsl:template name="user.footer.content">
  <br/>
  <div class="Footer">
    <xsl:apply-templates select="//copyright" mode="titlepage.mode"/>
  </div>
<!--
  <div id="crosssitenavigation"><div class="inner">
    Dive Into Python | 
    <a title="Free repository for Mac OS X system administrators" href="http://diveintoosx.org/">Dive Into OS X</a> | 
    <a title="Free J2EE training material" href="http://j2ee.masslight.com/">J2EE training</a> | 
    <a title="Author's personal weblog" href="http://diveintomark.org/">dive into mark</a> | 
    <a title="J2EE, Mac OS X, Python contract work and training" href="http://diveintomark.org/resume/">resume</a>
  </div></div>
-->
</xsl:template>

<xsl:template name="article.titlepage"/>

<xsl:template match="*" mode="process.root">
  <xsl:variable name="doc" select="self::*"/>
  <html lang="en">
    <head>
      <xsl:call-template name="head.content">
        <xsl:with-param name="node" select="$doc"/>
      </xsl:call-template>
      <xsl:call-template name="user.head.content"/>
    </head>
    <body>
      <xsl:call-template name="user.header.content">
        <xsl:with-param name="node" select="$doc"/>
      </xsl:call-template>
      
      <div id="wrapper"><div id="main">
        <xsl:apply-templates select="section"/>

        <xsl:call-template name="user.footer.content">
          <xsl:with-param name="node" select="$doc"/>
        </xsl:call-template>
      </div></div>
      
      <div id="menu">
        <xsl:apply-templates select="appendix"/>
      </div>
      
    </body>
  </html>
</xsl:template>

<xsl:template match="appendix">
  <div class="{name(.)}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="appendix/title">
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="appendix/itemizedlist/listitem">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template name="generate.colgroup"/>

<xsl:template match="token[@role='br']">
  <br/>
</xsl:template>

<xsl:template match="para[@id='selfad']">
  <div class="selfad">
    <p>
      <xsl:apply-templates/>
    </p>
  </div>
</xsl:template>

<xsl:template match="token[@id='updated']">
  <strong>
    <xsl:text>Updated </xsl:text>
    <xsl:value-of select="//pubdate"/>
  </strong>
</xsl:template>

<xsl:template name="logo">
  <h1 id="logo"><xsl:value-of select="/article/articleinfo/title"/></h1>
</xsl:template>

<xsl:template name="tagline">
  <p id="tagline"><xsl:value-of select="//subtitle"/></p>
</xsl:template>

</xsl:stylesheet>

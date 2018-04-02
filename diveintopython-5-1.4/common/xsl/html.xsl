<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  exclude-result-prefixes="#default">

<xsl:import href="../docbook/xsl/html/chunk.xsl"/>
<xsl:import href="htmlcommon.xsl"/>
<xsl:param name="html.stylesheet">../diveintopython.css</xsl:param>

<xsl:param name="using.chunker" select="1"/>
<xsl:param name="base.dir">dist/html/</xsl:param>
<xsl:param name="admon.graphics.path">../images/</xsl:param>
<xsl:param name="callout.graphics.path">../images/callouts/</xsl:param>

<xsl:param name="generate.toc">
appendix  toc
article   toc
book      toc
chapter   toc
part      toc
preface   toc
qandadiv  toc
qandaset  toc
reference toc
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc
</xsl:param>
<xsl:param name="generate.section.toc.level" select="1"/>

<xsl:param name="chunker.output.method" select="'html'"/>
<xsl:param name="chunker.output.encoding" select="'iso-8859-1'"/>
<xsl:param name="chunker.output.indent" select="'yes'"/>
<xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>
<xsl:param name="chunker.output.standalone" select="'no'"/>
<xsl:param name="chunker.output.doctype-public" select="'-//W3C//DTD HTML 4.01 Transitional//EN'"/>
<xsl:param name="chunker.output.doctype-system" select="'http://www.w3.org/TR/html4/loose.dtd'"/>
<xsl:param name="chunker.output.media-type"/>
<xsl:param name="chunker.output.cdata-section-elements"/>

<!--
<xsl:param name="rootid">soap</xsl:param>
-->

<!-- provide breadcrumb-style navigation back to chapter/main TOC -->
<xsl:template name="breadcrumb.trail.separator">
  <xsl:text>&#160;&gt;&#160;</xsl:text>
</xsl:template>

<xsl:template name="breadcrumb.trail">
  <xsl:param name="node" select="."/>
  <xsl:param name="link" select="0"/>

  <xsl:variable name="title">
    <xsl:apply-templates select="$node" mode="title.markup.textonly"/>
  </xsl:variable>
  
  <xsl:if test="$node!=/*[1]">
    <xsl:call-template name="breadcrumb.trail">
      <xsl:with-param name="node" select="$node/.."/>
      <xsl:with-param name="link" select="1"/>
    </xsl:call-template>
  </xsl:if>
  
  <xsl:choose>
    <xsl:when test="$link!='0'">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$node"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:value-of select="$title"/>
      </a>
      <xsl:call-template name="breadcrumb.trail.separator"/>
    </xsl:when>
    <xsl:otherwise>
      <span class="thispage">
        <xsl:apply-templates select="$node" mode="title.markup.textonly"/>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>

  <td id="breadcrumb" colspan="5" align="left" valign="top">
    <xsl:text>You are here: </xsl:text>
    <a href="../index.html">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">nav-home</xsl:with-param>
      </xsl:call-template>
    </a>
    <xsl:call-template name="breadcrumb.trail.separator"/>
    <xsl:call-template name="breadcrumb.trail"/>
  </td>
  <td id="navigation" align="right" valign="top">
    <xsl:if test="count($prev)>0">
      <xsl:text>&#160;&#160;&#160;</xsl:text>
      <a>
	<xsl:attribute name="href">
	  <xsl:call-template name="href.target">
	    <xsl:with-param name="object" select="$prev"/>
	  </xsl:call-template>
	</xsl:attribute>
	<xsl:attribute name="title">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">nav-prev</xsl:with-param>
          </xsl:call-template>
          <xsl:text>: </xsl:text>
          <xsl:call-template name="gentext.startquote"/>
	  <xsl:apply-templates select="$prev" mode="title.markup.textonly"/>
          <xsl:call-template name="gentext.endquote"/>
        </xsl:attribute>
        <xsl:text>&lt;&lt;</xsl:text>
      </a>
    </xsl:if>
    <xsl:if test="count($next)>0">
      <xsl:text>&#160;&#160;&#160;</xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$next"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">nav-next</xsl:with-param>
          </xsl:call-template>
          <xsl:text>: </xsl:text>
          <xsl:call-template name="gentext.startquote"/>
          <xsl:apply-templates select="$next" mode="title.markup.textonly"/>
          <xsl:call-template name="gentext.endquote"/>
        </xsl:attribute>
        <xsl:text>&gt;&gt;</xsl:text>
      </a>
    </xsl:if>
  </td>
</xsl:template>

<!-- list section numbers along bottom -->
<xsl:template match="section" mode="footer-number">
  <xsl:param name="current" select=".."/>
  <xsl:choose>
    <xsl:when test="generate-id(.)=generate-id($current)">
      <span class="thispage">
        <xsl:number format="1"/>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="."/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
        </xsl:attribute>
        <xsl:number format="1"/>
      </a>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="position()!=last()">
    <xsl:text> </xsl:text>
    <span class="divider">|</span>
    <xsl:text> </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="footer.navigation">
  <xsl:param name="prev" select="/foo"/>
  <xsl:param name="next" select="/foo"/>
  <table class="Footer" width="100%" border="0" cellpadding="0" cellspacing="0" summary="">
    <tr>
    <td width="35%" align="left">
      <br/>
      <xsl:if test="count($prev)>0">
        <a class="NavigationArrow">
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="$prev"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>&lt;&lt;&#160;</xsl:text>
          <xsl:apply-templates select="$prev" mode="title.markup.textonly"/>
        </a>
      </xsl:if>
    </td>
    <td width="30%" align="center">
      <br/>
      <xsl:text>&#160;</xsl:text>
      <span class="divider">|</span>
      <xsl:text>&#160;</xsl:text>
      <xsl:choose>
        <xsl:when test="name(.)='chapter'">
          <xsl:apply-templates select="section" mode="footer-number">
            <xsl:with-param name="current" select="section[1]"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="name(.)='appendix'">
          <xsl:apply-templates select="section" mode="footer-number">
            <xsl:with-param name="current" select="section[1]"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="name(.)='section'">
          <xsl:apply-templates select="../section" mode="footer-number">
            <xsl:with-param name="current" select="."/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
      <xsl:text>&#160;</xsl:text>
      <span class="divider">|</span>
      <xsl:text>&#160;</xsl:text>
    </td>
    <td width="35%" align="right">
      <br/>
      <xsl:if test="count($next)>0">
        <a class="NavigationArrow">
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object" select="$next"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:apply-templates select="$next" mode="title.markup.textonly"/>
          <xsl:text>&#160;&gt;&gt;</xsl:text>
        </a>
      </xsl:if>
    </td>
    </tr>
    <tr>
      <td colspan="3">
        <br/>
      </td>
    </tr>
  </table>
  <div class="Footer">
    <xsl:apply-templates select="//copyright" mode="titlepage.mode"/>
  </div>
</xsl:template>
    
<!-- utility template used by navigation links to procedure plain-text version of link target titles -->
<xsl:template match="*" mode="title.markup.textonly">
  <xsl:variable name="markup">
    <xsl:apply-templates select="." mode="title.markup"/>
  </xsl:variable>
  <xsl:value-of select="$markup"/>
</xsl:template>

<!-- display footnotes with stylized caption -->
<xsl:template name="process.footnotes">
  <xsl:variable name="footnotes" select=".//footnote"/>
  <xsl:variable name="fcount">
    <xsl:call-template name="count.footnotes.in.this.chunk">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="footnotes" select="$footnotes"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Only bother to do this if there's at least one non-table footnote -->
  <xsl:if test="$fcount &gt; 0">
    <div class="footnotes">
      <h3 class="footnotetitle">Footnotes</h3>
      <xsl:call-template name="process.footnotes.in.this.chunk">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="footnotes" select="$footnotes"/>
      </xsl:call-template>
    </div>
  </xsl:if>
</xsl:template>

<!-- display "further reading" lists with stylized caption -->
<xsl:template match="itemizedlist">
  <xsl:variable name="customclass">
    <xsl:choose>
      <xsl:when test="@role='furtherreading'">furtherreading</xsl:when>
      <xsl:otherwise><xsl:value-of select="name(.)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="{$customclass}">
    <xsl:apply-templates select="title"/>
    <ul>
      <xsl:apply-templates select="listitem"/>
    </ul>
  </div>
</xsl:template>

<xsl:template match="itemizedlist/title">
  <h3>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<!-- display revision history with stylized caption -->
<xsl:template match="revhistory" mode="titlepage.mode">
  <div class="{name(.)}">
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="revhistory/revision" mode="titlepage.mode">
  <xsl:param name="numcols" select="'2'"/>
  <xsl:variable name="revnumber" select=".//revnumber"/>
  <xsl:variable name="revdate"   select=".//date"/>
  <xsl:variable name="revauthor" select=".//authorinitials"/>
  <xsl:variable name="revremark" select=".//revremark|.//revdescription"/>
  <a>
    <xsl:attribute name="name"><xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/></xsl:attribute>
  </a>
  <h3 class="revdate">
    <xsl:apply-templates select="$revdate[1]" mode="titlepage.mode"/>
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/>
    <xsl:text>)</xsl:text>
  </h3>
  <xsl:if test="$revremark">
    <xsl:apply-templates select="$revremark[1]" mode="titlepage.mode"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

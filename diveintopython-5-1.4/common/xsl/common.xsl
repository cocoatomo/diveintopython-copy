<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  exclude-result-prefixes="#default">

<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>

<!-- By default, ulink.target is "_top", but we don't use frames, so leave it empty -->
<xsl:param name="ulink.target"/>

<!-- Provide contact information (this ends up in a <link rev="made"> tag, and is
used elsewhere where we want a link to the author -->
<xsl:param name="link.mailto.url">mailto:f8dy@diveintopython.org</xsl:param>

<!-- support for traceback role in computeroutput (displayed in different font by CSS) -->
<xsl:template match="screen/computeroutput">
  <xsl:choose>
    <xsl:when test="@role='traceback'">
      <span class="traceback"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:otherwise>
      <span class="computeroutput"><xsl:apply-templates/></span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="itemizedlist">
<!--
  <xsl:variable name="itemsymbol">
    <xsl:call-template name="list.itemsymbol"/>
  </xsl:variable>
-->

  <div class="{name(.)}">
    <xsl:call-template name="anchor"/>
    <xsl:if test="title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <xsl:apply-templates select="*[not(self::listitem or self::title)]"/>

    <ul>
      <xsl:if test="@spacing='compact'">
        <xsl:attribute name="compact">
          <xsl:value-of select="@spacing"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="listitem"/>
    </ul>
  </div>
</xsl:template>

<!-- Now, work around various browser bugs (sigh) -->

<!--
Behavior:    table of contents is not indented properly
Environment: Netscape 6
Workaround:  change TOC type to <ul> (from default <dl>)
-->
<xsl:param name="toc.list.type">ul</xsl:param>

<!--
Behavior:    extra spacing above and below text in list items and callouts
Environment: w3m
Workaround:  don't add <p> tag inside list items or callouts
-->
<xsl:template match="listitem/para|callout/para">
  <xsl:apply-templates/>
</xsl:template>

<!--
Behavior:    extra spacing above text in admonitions
Environment: Netscape 6
Workaround:  don't add <p> tag inside tip/note/warning/caution/important
-->
<xsl:template match="tip/para|note/para|warning/para|caution/para|important/para">
  <xsl:apply-templates/>
</xsl:template>

<!--
Behavior:    nested pre tags are displayed in wrong font (replaceable within literal, literal within literal, userinput within screen, etc.)
Environment: IE5 Mac
Workaround:  
-->
<xsl:template match="literal/replaceable">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="literal/literal">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="screen/userinput">
  <span class="userinput"><xsl:apply-templates/></span>
</xsl:template>

<!-- provide <META> description tag; this content should be in the XML somewhere but I
don't know where it belongs -->
<xsl:template name="user.head.content">
  <meta name="description" content="Python from novice to pro"/>
</xsl:template>

<!-- display errorcode/errorname tag as monospaced -->
<xsl:template match="errorname|errorcode">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<!-- never display abstract title -->
<xsl:template match="abstract">
  <div class="{name(.)}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template name="admon.graphic.width">
  <xsl:param name="node" select="."/>
  <xsl:text>24</xsl:text>
</xsl:template>

<!-- Never show admonition title; never use admon.style; put class directly on table instead of
on separate DIV element; put WIDTH and HEIGHT in IMG -->
<xsl:template name="graphical.admonition">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <a name="{$id}"/>
  <table class="{name(.)}" border="0" summary="">
    <tr>
      <td rowspan="2" align="center" valign="top" width="1%">
        <img>
          <xsl:attribute name="src">
            <xsl:call-template name="admon.graphic"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:call-template name="gentext.element.name"/>
          </xsl:attribute>
          <xsl:attribute name="title"/>
          <xsl:attribute name="width">
            <xsl:call-template name="admon.graphic.width"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:call-template name="admon.graphic.width"/>
          </xsl:attribute>
        </img>
      </td>
    </tr>
    <tr>
      <td colspan="2" align="left" valign="top" width="99%">
        <xsl:apply-templates/>
      </td>
    </tr>
  </table>
</xsl:template>

<!-- set width/height of callout bug -->
<xsl:template name="callout-bug">
  <xsl:param name="conum" select='1'/>

  <xsl:choose>
    <xsl:when test="$callout.graphics = '0'
                    or $conum > $callout.graphics.number.limit">

      <xsl:text>(</xsl:text>
      <xsl:value-of select="$conum"/>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <img src="{$callout.graphics.path}{$conum}{$callout.graphics.extension}"
        alt="{$conum}" border="0" width="12" height="12"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- hard-code formatting of xrefs -->
<!--
<xsl:template match="chapter|section|sect1|preface|appendix" mode="xref-to">
  <i>
    <xsl:apply-templates select="." mode="object.xref.markup"/>
  </i>
</xsl:template>

<xsl:template match="chapter|section|sect1|preface|appendix" mode="object.xref.template">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'xref'"/>
    <xsl:with-param name="name" select="'book'"/>
  </xsl:call-template>
</xsl:template>
-->

<!-- add "Tip: " to beginning of tip title (displayed with tip in non-HTML output, and in HTML when we link to a tip) -->
<xsl:template match="tip|note|warning|caution|important" mode="object.title.template">
  <xsl:call-template name="gentext"/>
  <xsl:text>: </xsl:text>
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'title'"/>
    <xsl:with-param name="name" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="tip|note|warning|caution|important" mode="xref-to">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'title'"/>
    <xsl:with-param name="name" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<!-- provide abbreviated title page information -->
<xsl:template name="book.titlepage.recto">
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="(bookinfo/title|title)[1]"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/copyright"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/abstract"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/legalnotice"/>
</xsl:template>

<!-- add support for title attribute of ulinks -->
<!-- note: this is probably tag abuse -->
<xsl:template match="ulink">
  <a>
    <xsl:if test="@id">
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
    <xsl:if test="$ulink.target != ''">
      <xsl:attribute name="target">
        <xsl:value-of select="$ulink.target"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@type">
      <xsl:attribute name="title"><xsl:value-of select="@type"/></xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
	<xsl:value-of select="@url"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<!-- add support for summary appendices -->
<!-- this is really XML abuse, but I don't care because it's cool -->

<xsl:template name="summary.link">
  <xsl:param name="context"/>
  <xsl:param name="node" select="."/>
  <a>
    <xsl:attribute name="href">
      <xsl:text>../</xsl:text>
      <xsl:call-template name="href.target">
        <xsl:with-param name="context" select="$context"/>
        <xsl:with-param name="object" select="$node"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="$node" mode="object.title.markup"/>
  </a>
</xsl:template>

<xsl:template match="chapter" mode="summary.mode">
  <xsl:param name="context"/>
  <xsl:param name="section.mode" select="''"/>
  <p>
    <xsl:choose>
      <xsl:when test="$section.mode='furtherreading.summary.mode'">
        <xsl:call-template name="summary.link">
          <xsl:with-param name="context" select="//furtherreading"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$section.mode='abstract.summary.mode'">
        <xsl:call-template name="summary.link">
          <xsl:with-param name="context" select="//abstracts"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$section.mode='tip.summary.mode'">
        <xsl:call-template name="summary.link">
          <xsl:with-param name="context" select="//tips"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$section.mode='example.summary.mode'">
        <xsl:call-template name="summary.link">
          <xsl:with-param name="context" select="//examples"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </p>
  <ul>
    <xsl:choose>
      <xsl:when test="$section.mode='furtherreading.summary.mode'">
        <xsl:apply-templates select=".//section" mode="furtherreading.summary.mode"/>
      </xsl:when>
      <xsl:when test="$section.mode='abstract.summary.mode'">
        <xsl:apply-templates select=".//section" mode="abstract.summary.mode"/>
      </xsl:when>
      <xsl:when test="$section.mode='tip.summary.mode'">
        <xsl:apply-templates select=".//section" mode="tip.summary.mode"/>
      </xsl:when>
      <xsl:when test="$section.mode='example.summary.mode'">
        <xsl:apply-templates select=".//section" mode="example.summary.mode"/>
      </xsl:when>
    </xsl:choose>
  </ul>
</xsl:template>

<!-- further reading summary -->
<xsl:template match="appendix[@id='furtherreading']/para">
  <xsl:apply-templates select="//chapter" mode="summary.mode">
    <xsl:with-param name="section.mode" select="'furtherreading.summary.mode'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="section" mode="furtherreading.summary.mode">
  <xsl:if test="itemizedlist[@role='furtherreading']">
    <li>
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//furtherreading"/>
      </xsl:call-template>
      <p/>
      <ul>
        <xsl:apply-templates select="itemizedlist[@role='furtherreading']/listitem"/>
      </ul>
      <p/>
    </li>
  </xsl:if>
</xsl:template>

<!-- abstract summary -->
<xsl:template match="appendix[@id='abstracts']/para">
  <xsl:apply-templates select="//chapter" mode="summary.mode">
    <xsl:with-param name="section.mode" select="'abstract.summary.mode'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="section" mode="abstract.summary.mode">
  <xsl:if test="(count(abstract) > 0) and (string-length(title) > 0)">
    <li>
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//abstracts"/>
      </xsl:call-template>
      <blockquote>
        <xsl:apply-templates select="abstract"/>
      </blockquote>
    </li>
  </xsl:if>
</xsl:template>

<!-- tips summary -->
<xsl:template match="appendix[@id='tips']/para">
  <xsl:apply-templates select="//chapter" mode="summary.mode">
    <xsl:with-param name="section.mode" select="'tip.summary.mode'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="section" mode="tip.summary.mode">
  <xsl:if test="count(tip|note|warning|caution|important) > 0">
    <li>
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//tips"/>
      </xsl:call-template>
      <xsl:apply-templates select="tip|note|warning|caution|important"/>
      <p/>
    </li>
  </xsl:if>
</xsl:template>

<!-- example summary -->
<xsl:template match="appendix[@id='examples']/para">
  <xsl:apply-templates select="//chapter" mode="summary.mode">
    <xsl:with-param name="section.mode" select="'example.summary.mode'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="section" mode="example.summary.mode">
  <xsl:if test="count(example) > 0">
    <li>
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//examples"/>
      </xsl:call-template>
      <p/>
      <ul>
        <xsl:apply-templates select="example" mode="example.summary.mode"/>
      </ul>
      <p/>
    </li>
  </xsl:if>
</xsl:template>

<xsl:template match="example" mode="example.summary.mode">
  <li>
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//examples"/>
    </xsl:call-template>
  </li>
</xsl:template>

<!-- add support for revision history in its own appendix -->
<xsl:template match="appendix[@id='revhistory']/para">
  <xsl:apply-templates select="//revhistory" mode="titlepage.mode"/>
</xsl:template>

</xsl:stylesheet>

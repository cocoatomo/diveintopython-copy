<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'
  exclude-result-prefixes="#default">

<xsl:import href="../docbook/xsl/htmlhelp/htmlhelp.xsl"/>
<xsl:import href="nonhtmlcommon.xsl"/>

<xsl:param name="generate.toc">
appendix  
article   
book      
chapter   
part      
preface   
qandadiv  
qandaset  
reference 
sect1     
sect2     
sect3     
sect4     
sect5     
section   
set       
</xsl:param>

<xsl:param name="using.chunker" select="1"/>
<xsl:param name="base.dir">dist/htmlhelp/</xsl:param>
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.graphics.path">images/</xsl:param>
<xsl:param name="admon.graphics.extension">.jpg</xsl:param>
<xsl:param name="callout.graphics" select="1"/>
<xsl:param name="callout.graphics.path">images/callouts/</xsl:param>
<xsl:param name="callout.graphics.extension">.jpg</xsl:param>

<xsl:param name="htmlhelp.autolabel">1</xsl:param>
<xsl:param name="htmlhelp.chm">diveintopython.chm</xsl:param>
<xsl:param name="htmlhelp.hhp">diveintopython.hhp</xsl:param>
<xsl:param name="htmlhelp.hhc">toc.hhc</xsl:param>

</xsl:stylesheet>

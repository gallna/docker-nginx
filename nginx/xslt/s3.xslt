<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:exsl="http://exslt.org/common" xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:s3="http://s3.amazonaws.com/doc/2006-03-01/" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xsl s3 xhtml">
  <xsl:variable name="xhtml" select="'http://s3.amazonaws.com/doc/2006-03-01/'"/>
  <xsl:output method="html" media-type="text/html" omit-xml-declaration="yes" indent="yes" />

  <!-- transform a size in bytes into a human readable representation -->
  <xsl:template name="size">
    <xsl:param name="bytes"/>
    <xsl:choose>
      <xsl:when test="$bytes &lt; 1000"><xsl:value-of select="$bytes" />B</xsl:when>
      <xsl:when test="$bytes &lt; 1048576"><xsl:value-of select="format-number($bytes div 1024, '0.0')" />K</xsl:when>
      <xsl:when test="$bytes &lt; 1073741824"><xsl:value-of select="format-number($bytes div 1048576, '0.0')" />M</xsl:when>
      <xsl:otherwise><xsl:value-of select="format-number(($bytes div 1073741824), '0.00')" />G</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="s3:Size">
    <xsl:call-template name="size"><xsl:with-param name="bytes" select="." /></xsl:call-template>
  </xsl:template>

  <!-- transform an ISO 8601 timestamp into a human readable representation -->
  <xsl:template name="timestamp">
    <xsl:param name="iso-timestamp" />
    <xsl:value-of select="concat(substring($iso-timestamp, 0, 11), ' ', substring($iso-timestamp, 12, 5))" />
  </xsl:template>

  <xsl:template match="s3:LastModified">
    <xsl:call-template name="timestamp"><xsl:with-param name="iso-timestamp" select="." /></xsl:call-template>
    <xsl:value-of select="str:padding(33 - string-length(.))"/>
  </xsl:template>

  <xsl:variable name="key_lengths">
    <xsl:for-each select="//s3:Key">
      <key_length><xsl:value-of select="string-length(.)"/></key_length>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="max_key_width" select="math:max(exsl:node-set($key_lengths)/key_length) + 5"/>

  <xsl:template match="s3:Key">
    <a href="/{current()}"><xsl:value-of select="." /></a>
    <xsl:value-of select="str:padding($max_key_width - string-length(.))"/>
  </xsl:template>

  <xsl:template match="s3:ETag"></xsl:template>
  <xsl:template match="s3:StorageClass"></xsl:template>
  <xsl:template match="s3:IsTruncated"></xsl:template>
  <xsl:template match="s3:MaxKeys"></xsl:template>
  <xsl:template match="s3:Marker"></xsl:template>
  <xsl:template match="s3:Name"></xsl:template>

  <xsl:template match="s3:Prefix">
    <a href="{$prev}">../</a>
    <xsl:value-of select="str:padding($max_key_width - string-length(.))"/>
    <xsl:value-of select="concat('-', str:padding(32), '-')"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="s3:Contents">
    <xsl:apply-templates select="s3:Key"/>
    <xsl:apply-templates select="s3:LastModified"/>
    <xsl:apply-templates select="s3:Size"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:variable name="current" select="concat('/', //s3:Prefix)"/>
  <xsl:variable name="prev" select="str:replace($current, concat('/', str:tokenize($current,'/')[last()]), '')"/>

  <xsl:template match="s3:ListBucketResult">
    <html>
    <head><title>Index of <xsl:value-of select="concat(//s3:Name, $current)"/></title></head>
      <body bgcolor="white">
        <h1>Index of <xsl:value-of select="$current"/></h1>
        <hr/><pre><xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="s3:Prefix"/>
        <xsl:apply-templates select="s3:Contents"/>
        </pre><hr/>
      </body>
    </html>
  </xsl:template>

<xsl:template match="@* | node()">
<xsl:apply-templates/>
</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:tax="http://www.taxonx.org/schema/v1" xmlns:dwc="http://digir.net/schema/conceptual/darwin/2003/1.0" xmlns:dwcranks="http://rs.tdwg.org/UBIF/2006/Schema/1.1" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="descendant-or-self::document"/>
	</xsl:template>
	
	<xsl:template match="document">
		<html>
			<head>
				<title><xsl:value-of select="./@docTitle"/></title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
			</head>
			<body>
				<xsl:apply-templates select=".//treatment"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="treatment">
		<xsl:apply-templates select=".//paragraph"/>
	</xsl:template>
	
	<xsl:template match="paragraph">
		<p> <!-- TODO font size -->
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	<xsl:template match="emphasis[./@bold and ./@italics]">
		<xsl:choose>
			<xsl:when test="./ancestor::emphasis[./@bold]">
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:when test="./ancestor::emphasis[./@italics]">
				<b>
					<xsl:apply-templates/>
				</b>
			</xsl:when>
			<xsl:otherwise>
				<b><i>
					<xsl:apply-templates/>
				</i></b>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="emphasis[./@bold]">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	
	<xsl:template match="emphasis[./@italics]">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
	
	<xsl:template match="superScript">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
	
	<xsl:template match="subScript">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	
	<xsl:template match="table">
		<table>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="tr">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
	<xsl:template match="td">
		<td>
			<!-- TODO colspan, rowspan -->
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	
	<xsl:template match="normalizedToken">
		<xsl:text disable-output-escaping="yes">&#x20;</xsl:text>
		<xsl:value-of select="./@originalValue"/>
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:call-template name="spaceBefore">
			<xsl:with-param name="p"><xsl:value-of select="normalize-space(string(./preceding::text()))"/></xsl:with-param>
			<xsl:with-param name="s"><xsl:value-of select="normalize-space(string(.))"/></xsl:with-param>
		</xsl:call-template>
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>
	<xsl:template name="spaceBefore">
		<xsl:param name="p"/>
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when test="not($p)"></xsl:when>
			<xsl:when test="contains('.,:;!?)]}', substring($s, 1, 1))"></xsl:when>
			<xsl:when test="contains('([{', substring($p, (string-length($p) - 1), 1))"></xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&#x20;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>

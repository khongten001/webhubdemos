<?xml version='1.0' encoding='UTF-8'?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	version="1.0"
>

<xsl:template match='/rss'>
	<html>
		<head>
			<title>RSS Feed for <xsl:value-of select='channel/title'/></title>
			<style type="text/css">
				body { margin-top:10px; margin-bottom:25px; text-align:center; font-family: verdana, sans-serif; font-size: 80%; line-height: 1.45em; } 
				#block { margin:0px auto; width:600px; text-align:left; }
				p { padding-top: 0px; margin-top: 0px; }
				h1 { font-size: 120%; padding-bottom: 0px; margin-bottom: 0px; }
				h2 { font-size: 100%; margin-bottom: 0px; } 
			</style>
		</head>
		<body>
			<div id='block'>
			<h1>RSS Feed for <xsl:value-of select='channel/title'/></h1>
			<hr />
			<xsl:apply-templates select='channel/item' />
			</div>
		</body>
	</html>
</xsl:template>

<xsl:template match='item'>
		<h2>
			<a href='{link}'>
				<xsl:value-of select='title'/>
			</a>
		</h2>
		<p>
			<xsl:value-of select='description' disable-output-escaping='yes' />
			<br />
			<strong>Author: </strong><xsl:value-of select='author' />
			<br />
			<strong>Published Date: </strong><xsl:value-of select='pubDate' />
			<br />
			<font color='gray'>
		<xsl:for-each select='category'>
			<xsl:value-of select='.' /> | 
		</xsl:for-each>
			</font>
			<br />
		</p>
</xsl:template>

<xsl:template match='category'>
		<xsl:value-of select='.'/> |  
</xsl:template>


</xsl:stylesheet>
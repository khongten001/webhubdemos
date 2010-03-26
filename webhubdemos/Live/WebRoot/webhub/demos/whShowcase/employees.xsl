<?xml version="1.0" encoding="utf-8"?>
<!-- original here: http://www.ibm.com/developerworks/library/x-think41/ -->
<!-- A -->
<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:math="http://exslt.org/math"
  xmlns:regex="http://exslt.org/regular-expressions"
  xmlns:set="http://exslt.org/sets"
  xmlns:str="http://exslt.org/strings"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="set math regex str">
  <!-- Notice the namespace declarations for EXSLT.
       Notice also exclude-result-prefixes, since you don't want those
       namespace declarations in the result XHTML
   -->

  <!-- Use XML mode to approximate XHTML output
       (notice the doc type declaration info) -->
  <xsl:output method="xml" encoding="utf-8"
              doctype-public="-//W3C//DTD XHTML 1.1//EN"
              doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>

  <xsl:template match="employees">
    <!-- Put the presentation style into a separate file,
         specified using a processing instruction in the output -->
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>type="text/css" href="/webhub/demos/whShowcase/employees.css"</xsl:text>
    </xsl:processing-instruction>
    <html xml:lang="en">
      <head>
        <title>Employee report</title>
      </head>
      <body>
        <h1>Employee report</h1>
        <table>
          <xsl:apply-templates/>
        </table>
        <hr/>
        <xsl:call-template name="stats"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="stats">
    <xsl:variable name="execs"
      select="department[title='Executive']/employee"/>
    <xsl:variable name="employees-in-china"
      select="department/employee[location='China']"/>
    <!-- Use set:has-same-node to check whether the two separate
         XPath queries have any node sets in common -->
    <xsl:if test="set:has-same-node($execs, $employees-in-china)">
      <p>Note: At least one executive presently works in China</p>
    </xsl:if>
    <dl>
      <dt>Countries where employees presently work</dt>
      <dd>
        <!-- Use set:distinct to eliminate duplicate country names
             from the query result -->
        <xsl:for-each select="set:distinct(department/employee/location)">
          <xsl:value-of select="."/>
          <xsl:if test="not(position()=last())">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </dd>
      <dt>Newest employee</dt>
      <!-- Use math:highest to determine the highest numerical value of employee ID -->
      <dd><xsl:value-of select="math:highest(department/employee/@id)"/></dd>
    </dl>
  </xsl:template>

  <xsl:template match="department">
    <tr>
      <td colspan="4">
        <!-- Use regular expressions to sniff out URLs from unstructured content -->
        <!-- [1] ensues that if multiple URLs are detected, only the first is used -->
        <a href="{regex:match(info, 'http://[a-zA-Z0-9-_/\.]*', '')[1]}">
          <xsl:value-of select="title"/>
        </a>
      </td>
    </tr>
    <xsl:apply-templates select="employee"/>
  </xsl:template>

  <xsl:template match="employee">
    <tr>
      <td>
        <xsl:value-of select="name/given"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="name/family"/>
      </td>
      <td>
        <!-- Use str:concat to construct a composite ID from ancestor -->
        <!-- If, for example you added an id attribute to the root element,
             the value would be appended for each employee -->
        <xsl:value-of select="str:concat(ancestor-or-self::*/@id)"/>
      </td>
      <td>
        <xsl:value-of select="title"/>
      </td>
      <td>
        <!-- Standard concat assembles a string from a fixed sequence of expressions -->
        <xsl:value-of select="concat(location, '(', location/@building, ')')"/>
      </td>
    </tr>
  </xsl:template>

</xsl:transform>

<cfparam name="form.xml" default="">
<cfif len(form.xml)>
	<cfset xp = new SafeXmlParse()>
	<cftry>
		<cfset tick=getTickCount()>
		<cfset result = xp.parse(form.xml)>
		<cfset tock=getTickCount()>
		<cfdump var="#result#" label="SafeXmlParse [#tock-tick#ms]">
	<cfcatch type="any">
		<cfdump var="#cfcatch#" label="Error in SafeXmlParse">
	</cfcatch>
	</cftry>
	
	<cfset tick=getTickCount()>
	<cfset result = xmlParse(form.xml)>
	<cfset tock=getTickCount()>
	<cfdump var="#result#" label="XmlParse [#tock-tick#ms]">
<cfelse>
	<cfsavecontent variable="form.xml"><?xml version="1.0" encoding="utf-8" ?>
<root>
  <child test='true'>
  	<grandkid />
  </child>
</root>
</cfsavecontent>
</cfif>
<form method="post">
	<textarea name="xml" rows="20" cols="50"><cfoutput>#encodeForHTML(form.xml)#</cfoutput></textarea>
	<input type="submit" value="Parse">
</form>
# SafeXmlParse

[![Build Status](https://travis-ci.org/foundeo/safexmlparse.svg?branch=master)](https://travis-ci.org/foundeo/safexmlparse)


A simple, lightweight XML Parser Implementation written purely in CFML. 

This parser purposly does not implement features such as external entities, remote schemas, DTDs to
mitigate the security risks related to parsing untrusted XML.

## Example Usage

	sxp = new SafeXmlParse();
	xml = "<dad name='pete'><child/></dad>"
	xmlObject = sxp.parse(xml);

	writeOutput( xmlObject.XmlRoot.XmlAttributes.name ); //pete

## Options

You can specify the following options in the `options` struct argument of the `parse` function:

	xsp.parse(xml, {tagLimit=100});

Here are the supported options:

* `nestingLimit` - The number of nested tags allowed. This value can be specified to prevent _Coercive Parsing_ attacks. Default Value: `1000`
* `tagLimit` - The maximum number of tags allowed. in the XML document This value can be specified to prevent _Coercive Parsing_ attacks and Jumbo. Default Value: `1000000`


## Exceptions

Throws exceptions with the following `type` specified in the `cfcatch` struct:

* `safexmlparse.invalidxml` - Thrown if it encounters invalid XML, unclosed tags, etc.
* `safexmlparse.nestinglimit` - Thrown if the XML has reached the configured `nestingLimit`
* `safexmlparse.taglimit` - Thrown if the XML has more tags than the configured `tagLimit`
* `safexmlparse.doctype` - Thrown if the XML has a `!DOCTYPE` defined
* `safexmlparse.entity` - Thrown if the XML has a `!ENTITY` defined
* `safexmlparse.element` - Thrown if the XML has a `!ELEMENT` defined

The exception `message` will be generic such as `Invalid XML` or `Unsupported XML` and the `detail` of the exception will contain more technical details intended for the developer.

References: [OWSAP XML Security CheatSheet](https://cheatsheetseries.owasp.org/cheatsheets/XML_Security_Cheat_Sheet.html)

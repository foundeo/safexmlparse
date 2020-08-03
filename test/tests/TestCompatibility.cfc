component extends="BaseTest" {



	function run(testResults, testBox) {
		
		describe("Test Compatibility", function() {
			var files = directoryList(getTestFilePath(), true, "array");
			var f = "";
			
			for (f in files) {
				var xml = fileRead(f);
				var fileName = replace(f, getTestFilePath(), "");
				var parsed = {cf={}, sxp={}};
				var sxpResult = "";
				it(title="#fileName# should be valid XML", data={xml=xml}, body=function(data) {
					expect(isXML(xml)).toBeTrue();		
				});

				parsed.cf = xmlParse(xml);
				parsed.sxp = getSafeXmlParse().parse(xml);
				it(title="#fileName# should have the same XmlName for XmlRoot", data={parsed=parsed}, body=function(data) {
					expect(data.parsed.cf.XmlRoot.XmlName).toBe(data.parsed.sxp.XmlRoot.XmlName);		
				});

				it(title="#fileName# should have the same number of children in XmlRoot", data={parsed=parsed}, body=function(data) {
					expect(arrayLen(data.parsed.cf.XmlRoot.XmlChildren)).toBe(arrayLen(data.parsed.sxp.XmlRoot.XmlChildren));		
				});

				/*
				it(title="#fileName# should have the same attribute names in XmlRoot", data={parsed=parsed}, body=function(data) {
					expect(listSort(structKeyList(data.parsed.cf.XmlRoot.XmlAttributes), "text")).toBe(listSort(structKeyList(data.parsed.sxp.XmlRoot.XmlAttributes), "text"));		
				});*/
				matchingNodes(parsed.cf.XmlRoot, parsed.sxp.XmlRoot, fileName& "/");

					
			}
			
		});
	}

	private function matchingNodes(a, b, name) {
		if (structKeyExists(arguments.a, "XmlName")) {
			name &= arguments.a.XmlName & "/";
		}
		it(title="#name# should have a XmlName", data=arguments, body=function(data) {
			expect(data.a).toHaveKey( "XmlName" );
			expect(data.b).toHaveKey( "XmlName" );
		});

		it(title="#name# should have the same attribute names", data=arguments, body=function(data) {
			expect(listSort(structKeyList(data.a.XmlAttributes), "text")).toBe(listSort(structKeyList(data.b.XmlAttributes), "text"));		
		});

		it(title="#name# should have the same attribute values", data=arguments, body=function(data) {
			for (local.key in data.a.XmlAttributes) {
				expect(data.a.XmlAttributes[local.key]).toBe(data.b.XmlAttributes[local.key]);
			}
		});

		it(title="#name# should have the same number of children", data=arguments, body=function(data) {
			expect(arrayLen(data.a.XmlChildren)).toBe(arrayLen(data.b.XmlChildren));		
		});

		if (arrayLen(arguments.a.XmlChildren) == arrayLen(arguments.b.XmlChildren)) {
			//now run recursivly for each child
			var i=0;
			for (local.child in arguments.a.XmlChildren) {
				i++;
				matchingNodes(local.child, arguments.b.XmlChildren[i], name & "[#i#]/");
			}
		}

	}


}
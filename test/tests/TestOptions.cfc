component extends="BaseTest" {

	function run(testResults, testBox) {
		
		describe("Test Options", function() {
			it(title="Should support nestingLimit", data={}, body=function(data) {
				var xml = generateNestedXML(10);
				var nestingLimit = 1000;
				debug(xml);
				try {
					//this should not throw
					getSafeXmlParse().parse(xml, {nestingLimit=nestingLimit});
					nestingLimit = 5;
					//this should throw
					getSafeXmlParse().parse(xml, {nestingLimit=nestingLimit});
					
					expect(false).toBeTrue("Should have thrown an exception");
				} catch (any e) {
					debug(e);
					expect(nestingLimit).toBe(5);
					expect(e.type).toBe("safexmlparse.nestinglimit");
				}
			});
			it(title="Should support tagLimit", data={}, body=function(data) {
				var xml = generateNestedXML(10);
				var tagLimit = 1000;
				try {
					//this should not throw
					getSafeXmlParse().parse(xml, {tagLimit=tagLimit});
					tagLimit = 5;
					//this should throw
					getSafeXmlParse().parse(xml, {tagLimit=tagLimit});
					expect(false).toBeTrue("Should have thrown an exception");
				} catch (any e) {
					
					expect(tagLimit).toBe(5);
					expect(e.type).toBe("safexmlparse.taglimit");
				}
			});
		});

	}

	private function generateNestedXML(numeric elements) {
		var xml = "";
		
		for (var i=0;i<elements;i++) {
			xml &= "<i#i#>";
		}
		for (var i=elements-1;i>=0;--i) {
			xml &= "</i#i#>";
		}
		return xml;
	}
}
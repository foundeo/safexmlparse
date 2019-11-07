component extends="BaseTest" {

	function run(testResults, testBox) {
		
		describe("Test Options", function() {
			it(title="Should not allow unclosed tags", data={}, body=function(data) {
				var xml = "<foo<moo>";
				try {
					//this should throw
					getSafeXmlParse().parse(xml);
					expect(false).toBeTrue("Should have thrown an exception");
				} catch (any e) {
					
					expect(e.type).toBe("safexmlparse.invalidxml");
				}
			});
			it(title="Should not allow space after tag opening", data={}, body=function(data) {
				var xml = "< foo/>";
				try {
					//this should throw
					getSafeXmlParse().parse(xml);
					expect(false).toBeTrue("Should have thrown an exception");
				} catch (any e) {
					expect(e.type).toBe("safexmlparse.invalidxml");
				}
			});
			it(title="Should not allow tab after tag opening", data={}, body=function(data) {
				var xml = "<#chr(9)#foo/>";
				try {
					//this should throw
					getSafeXmlParse().parse(xml);
					expect(false).toBeTrue("Should have thrown an exception");
				} catch (any e) {
					expect(e.type).toBe("safexmlparse.invalidxml");
				}
			});
			it(title="Should not allow newline after tag opening", data={}, body=function(data) {
				var xml = "<#chr(10)#foo/>";
				try {
					//this should throw
					getSafeXmlParse().parse(xml);
					expect(false).toBeTrue("Should have thrown an exception");
				} catch (any e) {
					expect(e.type).toBe("safexmlparse.invalidxml");
				}
			});
		});

	}

	
}
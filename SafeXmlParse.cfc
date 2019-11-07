component {

	variables.defaultOptions = { 
		nestingLimit = 1000,
		tagLimit = 1000000
	};

	

	public function parse(string xml, struct options={}) {
		var ltPos = find("<", xml);
		var xmlLen = len(xml);
		var result = {"XmlComment"="", "XmlRoot"=createNode()};
		var node = result.XmlRoot;
		var parent = result;
		var gtPos = 0;
		var nextLtPos = 0;
		var hasChildren = false;
		var parentStack = [];
		var lastGt = 0;
		var innerContent = "";
		var tagPrefix = "";
		var option = duplicate(variables.defaultOptions);
		var tagCount = 0;
		var nestLevel = 0;
		if (!structIsEmpty(arguments.options)) {
			structAppend(option, arguments.options);
		}
		if (ltPos == 0) {
			throw(message="Invalid XML", detail="No tags found.", type="safexmlparse.invalidxml");
		}
		while (ltPos != 0) {
			lastGt = gtPos;
			if (gtPos != 0) {
				innerContent = trim(mid(xml, gtPos+1, ltPos-gtPos-1));
				if (len(innerContent)) {
					if (structKeyExists(parent, "XmlText")) {
						parent.XmlText &=innerContent;
					}
				}	
			}
			
			gtPos = find(">", xml, ltPos);
			tagPrefix = mid(xml, ltPos+1, 3);
			if (tagPrefix == "!--") {
				//xml comment
				local.commentEnd = find("-->", xml, ltPos);
				if (local.commentEnd == 0) {
					throw(message="Invalid XML", detail="XML Comment was not closed. Pos:#ltPos#", type="safexmlparse.invalidxml");	
				}
				parent.XmlComment &= trim(mid(xml, ltPos+4, local.commentEnd - ltPos - 4));
				gtPos = local.commentEnd+2;
				ltPos = find("<", xml, local.commentEnd);
				continue;
			} else if (tagPrefix == "!DO") {
				throw(message="Unsupported XML", detail="XML !DOCTYPE declarations are not supported.", type="safexmlparse.doctype");	
			} else if (tagPrefix == "!EL") {
				throw(message="Unsupported XML", detail="XML !ELEMENT declarations are not supported.", type="safexmlparse.element");	
			} else if (tagPrefix == "!EN") {
				throw(message="Unsupported XML", detail="XML !ENTITY declarations are not supported.", type="safexmlparse.entity");	
			} else if ( trim(left(tagPrefix, 1)) == "" ) {
				//space after opening tag is not allowed
				throw(message="Invalid XML", detail="The content of elements must consist of well-formed character data or markup.", type="safexmlparse.invalidxml");
			}

			if (gtPos == 0) {
				throw(message="Invalid XML", detail="Found a LT with no matching GT symbol. Pos:#ltPos#", type="safexmlparse.invalidxml");	
			}
			nextLtPos = find("<", xml, ltPos+1);
			if (nextLtPos != 0 && gtPos > nextLtPos) {
				throw(message="Invalid XML", detail="The next GT was before the next LT. Pos:#ltPos#", type="safexmlparse.invalidxml");
			}
			if (tagCount >= option.tagLimit) {
				throw(message="Unsupported XML", detail="The XML contained a number of tags greater than or equal to #int(option.tagLimit)# which is the tagLimit.", type="safexmlparse.taglimit");
			}
			node = createNodeAtLTPosition(xml, ltPos, gtPos, nextLtPos, parent);
			tagCount++;
			if (left(node.XmlName, 1) == "/") {
				//end tag
				if (arrayLen(parentStack)) {
					//pop the stack
					parent = parentStack[arrayLen(parentStack)];
					arrayDeleteAt(parentStack, arrayLen(parentStack));
				}
				nestLevel--;
			} else {

				hasChildren = mid(xml, gtPos-1, 1) != "/";
				if (parent.keyExists("XmlRoot")) {
					if (node.XmlName != "?xml") {
						//if not the xml declaration then it is the root tag
						parent.XmlRoot = node;
						if (hasChildren) {
							
							parent = node;
							arrayAppend(parentStack, node);
							nestLevel++;
						}
					}
				} else {
					if (nestLevel >= option.nestingLimit) {
						throw(message="Unsupported XML", detail="The XML contained a number of nested elements greater than or equal to #int(option.nestingLimit)# which is the nestingLimit.", type="safexmlparse.nestinglimit");
					}
					arrayAppend(parent.XmlChildren, node);
					
					if (hasChildren) {
						parent = node;
						nestLevel++;
					}
				}
			}
			
			ltPos = nextLtPos;
		}
		return result;
	}

	private struct function createNode() {
		return {"XmlName"="","XmlNsPrefix"="","XmlNsURI"="","XmlText"="","XmlComment"="","XmlAttributes"={}, "XmlChildren"=[]};
	}

	private struct function createNodeAtLTPosition(xml, ltPos, gtPos, nextLtPos, parent) {
		var i = 0;
		var node = createNode();
		var c = "";
		var tagName = true;
		var attributeName = false;
		var attributeValue = false;
		var attributeQuote = "";
		var buffer = "";
		var currentAttributeName = "";
		node["XmlPosition"] = ltPos;
		for (i=ltPos+1;i<gtPos;i++) {
			c = mid(xml, i, 1);
			if (trim(c) == "") {
				//space
				if (tagName) {
					if (len(buffer) == 0) {
						continue;
					}
					node.XmlName = buffer;
					tagName = false;
					attributeName = true;
					buffer = "";
				}
			} else if (attributeName && c == "=") {
				currentAttributeName = trim(buffer);
				node.XmlAttributes[currentAttributeName] = "";
				attributeName = false;
				attributeValue = true;
				attributeQuote = "";
				buffer = "";
				continue;
			} else if (c == """" || c == "'") {
				if (attributeValue) {
					if (attributeQuote == "") {
						//beginning of attribute value
						attributeQuote = c;
						buffer = "";
						continue;
					} else if (c == attributeQuote) {
						//end of attribute value
						node.XmlAttributes[currentAttributeName] = buffer;
						//reset state for next attribute
						buffer="";
						attributeValue=false;
						attributeName=true;
						continue;
					}
				}
			}
			buffer &= c;
		}
		if (tagName && len(buffer)) {
			node.XmlName = buffer;
		}

		return node;
	} 
}
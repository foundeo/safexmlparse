component {
	this.name="safeXmlParseTests";
	this.clientManagement=false;
	this.sessionManagement=false;

	this.mappings = { 
		
		"/testbox" = getDirectoryFromPath(getCurrentTemplatePath()) & "testbox",
		"/tests" = getDirectoryFromPath(getCurrentTemplatePath()) & "tests",
		"/safexmlparse" = replace(getDirectoryFromPath(getCurrentTemplatePath()), "/test/", "/")
	};
	
	public function onApplicationStart() {
		application.testFiles = getDirectoryFromPath(getCurrentTemplatePath()) & "files/";
		
	}

	public function onRequestStart() {
		application.mode = "local"; //cloud or local
	}
}
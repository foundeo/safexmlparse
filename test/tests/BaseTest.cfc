component extends="testbox.system.BaseSpec" {

	public function getTestFilePath() {
		return application.testFiles;
	}

	public function getSafeXmlParse() {
		return new safexmlparse.SafeXmlParse();
	}

	


}
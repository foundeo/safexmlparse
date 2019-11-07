component {

    this.name = "SafeXmlParse";
    this.author = "";
    this.webUrl = "https://github.com/foundeo/safexmlparse";
    this.autoMapModels = false;
    this.cfmapping = "safexmlparse";

    function configure() {
        binder.map( "SafeXmlParse@SafeXmlParse" )
            .to( "#moduleMapping#.SafeXmlParse" )
            
    }
}

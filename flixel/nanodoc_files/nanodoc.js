
function hideModules() {
	var divs = document.getElementsByTagName("div");
	for(var i=0; i < divs.length; i++) {
		if(divs[i].className == "modules")
			divs[i].style.display = "none";
	}
}

function doSearch() {
	var searchVal = document.getElementById('searchbox').value;
	var divs = document.getElementsByTagName("div");

	for(var i=0; i < divs.length; i++) {
		if(divs[i].className == "modulelist") {
			if(divs[i].id.indexOf(searchVal.toLowerCase()) != -1) {
				showModuleContents(divs[i].id);
				return;
			}
		}
	}

	for(var i=0; i < divs.length; i++) {
		if(divs[i].className == "moduledetail") {
			if(divs[i].id.indexOf(searchVal.toLowerCase()) != -1) {
				showSubContents(divs[i].id);
				return;
			}
		}
	}

	alert("Couldn't find "+searchVal);

}

function showModules(moduleid) {
	hideModules();
	hideSubs();
	hideSubContents();
	document.getElementById(moduleid).style.display = "block";
}

function hideSubs() {
	var divs = document.getElementsByTagName("div");
	for(var i=0; i < divs.length; i++) {
		if(divs[i].className == "modulelist")
			divs[i].style.display = "none";
	}
}

function showModuleContents(moduleid) {
	hideSubs();
	hideSubContents();
	document.getElementById(moduleid).style.display = "block";
}

function hideSubContents() {
	var divs = document.getElementsByTagName("div");
	for(var i=0; i < divs.length; i++) {
		if(divs[i].className == "moduledetail")
			divs[i].style.display = "none";
	}
}

function showSubContents(moduleid) {
	hideSubContents();
	document.getElementById(moduleid).style.display = "block";
}

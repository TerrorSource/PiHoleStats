import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: root

	property url trayUrl : "PiholestatsTray.qml";
	property url thumbnailIcon: "qrc:/tsc/pihole_logo_40x40.png"
	property url menuScreenUrl : "PiholestatsSettings.qml"
	property url piholeScreenUrl : "PiholestatsScreen.qml"
	property url piholeTileUrl : "PiholestatsTile.qml"
	property PiholestatsSettings piholeSettings
	property PiholestatsScreen piholeScreen
	property bool dialogShown : false  //shown when changes have been. Shown only once.
	
	property SystrayIcon piholeTray
	property bool showAppIcon : true
	property bool firstTimeShown : true
	property variant piholeConfigJSON
	property bool piholeDataRead: false
	
// app settings
	property string connectionPath
	property string ipadres
	property string poortnummer : "80"
    property int refreshrate  : 60	// interval to retrieve data
	property string authtoken

//data vars
	property string tmp_ads_blocked_today
	property string tmp_ads_percentage_today

// user settings from config file
	property variant userSettingsJSON : {
		'connectionPath': [],
		'ShowTrayIcon': "",
		'refreshrate': "",
		'authtoken': ""
	}

// location of settings file
	FileIO {
		id: userSettingsFile
		source: "file:///mnt/data/tsc/piholestats.userSettings.json"
 	}

	function init() {
		registry.registerWidget("systrayIcon", trayUrl, this, "piholeTray");
		registry.registerWidget("screen", piholeScreenUrl, this, "piholeScreen");
		registry.registerWidget("screen", menuScreenUrl, this, "piholeSettings");
		registry.registerWidget("menuItem", null, this, null, {objectName: "AppMenuItem", label: qsTr("Pi-Hole"), image: thumbnailIcon, screenUrl: menuScreenUrl, weight: 120});
		registry.registerWidget("tile", piholeTileUrl, this, null, {thumbLabel: "PiHole", thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
	}

//this function needs to be started after the app is booted.
	Component.onCompleted: {
		// read user settings
		try {
			userSettingsJSON = JSON.parse(userSettingsFile.read());
			showAppIcon  = (userSettingsJSON['ShowTrayIcon'] == "yes") ? true : false
			connectionPath = userSettingsJSON['connectionPath'];
			var splitVar = connectionPath.split(":")
			ipadres = splitVar[0];
			poortnummer = splitVar[1];
			if (poortnummer.length < 2) poortnummer = "80";
			refreshrate = userSettingsJSON['refreshrate'];
			authtoken = userSettingsJSON['authtoken'];
		} catch(e) {
		}
		refreshScreen();
	}

// refresh screen
	function refreshScreen() {
		piholeDataRead = false;
		readPiHolePHPData();
	}

// save user settings
	function saveSettings(){
		connectionPath = ipadres + ":" + poortnummer;

 		var tmpUserSettingsJSON = {
			"connectionPath" : ipadres + ":" + poortnummer,
			"refreshrate" : refreshrate,
			"authtoken" : authtoken,
			"ShowTrayIcon" : (showAppIcon) ? "yes" : "no"
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/piholestats.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJSON));
	}

// read json file
    function readPiHolePHPData()  {
//		console.log("*****PiHole connectionPath:" + connectionPath);
		if ( connectionPath.length > 4 ) {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.open("GET", "http://"+connectionPath+"/admin/api.php", true);
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == XMLHttpRequest.DONE) {

					if (xmlhttp.status === 200) {
//					console.log("*****PiHole response:" + xmlhttp.responseText);
//       	         saveJSON(xmlhttp.responseText);
					piholeConfigJSON = JSON.parse(xmlhttp.responseText);
					
					tmp_ads_blocked_today = piholeConfigJSON['ads_blocked_today'];
//					console.log("*****PiHole tmp_ads_blocked_today: " + tmp_ads_blocked_today);
// last				tmp_ads_percentage_today = piholeConfigJSON['ads_percentage_today'];
					tmp_ads_percentage_today = Math.round(piholeConfigJSON['ads_percentage_today']) + " %";
//					console.log("*****PiHole tmp_ads_percentage_today: " + tmp_ads_percentage_today);
					} else {
					tmp_ads_blocked_today = "server incorrect";
//					console.log("*****PiHole tmp_ads_blocked_today: "+ tmp_ads_blocked_today);
					tmp_ads_percentage_today = "server incorrect";
//					console.log("*****PiHole tmp_ads_percentage_today: "+ tmp_ads_percentage_today);

					}
				}
			}
		} else {
			tmp_ads_blocked_today = "empty settings";
//			console.log("*****PiHole tmp_ads_blocked_today: "+ tmp_ads_blocked_today);
			tmp_ads_percentage_today = "empty settings";
//			console.log("*****PiHole tmp_ads_percentage_today: "+ tmp_ads_percentage_today);
		}
        xmlhttp.send();
    }

// save json data in json file. Optional, see readPiHolePHPData
	function saveJSON(text) {
		
  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///var/volatile/tmp/pihole_retrieved_data.json");
   		doc3.send(text);
	}
	
// Timer in s * 1000
	Timer {
		id: datetimeTimer
		interval: refreshrate * 1000;
		running: false
		repeat: true
		onTriggered: refreshScreen()
	}
}

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

	property SystrayIcon piholeTray
	property bool showAppIcon : true
	property bool firstTimeShown : true
	property variant piholeConfigJSON
//	property variant piholePHPData

// data in XML string format
	property bool piholeDataRead: false
//	property string timeStr
//	property string dateStr
	property string connectionPath
	property string ipadres
	property string poortnummer : "80"

// data vars


// user settings from config file
	property variant userSettingsJSON : {
		'connectionPath': [],
		'ShowTrayIcon': ""
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
		} catch(e) {
		}

		datetimeTimer.start();
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
			"ShowTrayIcon" : (showAppIcon) ? "yes" : "no"
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/piholestats.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJSON));
	}

// read json file
    function readPiHolePHPData()  {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.open("GET", "http://"+connectionPath+"/admin/api.php", true);
		xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == XMLHttpRequest.DONE) {
//				console.log("*****PiHole response:" + xmlhttp.responseText);

                saveInbox(xmlhttp.responseText);
                piholeConfigJSON = JSON.parse(xmlhttp.responseText);
//				console.log("*****PiHole JSON value ['gravity_last_updated']['file_exists']:" + piholeConfigJSON['gravity_last_updated']['file_exists']);
//				tmp_domains_being_blocked = piholeConfigJSON['domains_being_blocked'];
//				console.log("***** PiHole tmp_domains_being_blocked: " + piholeConfigJSON['domains_being_blocked']);

            }
        }
        xmlhttp.send();
    }

// save json data in json file
	function saveInbox(text) {
		
  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///var/volatile/tmp/pihole_retrieved_data.json");
   		doc3.send(text);
	}
	
// Timer in s * 1000
	Timer {
		id: datetimeTimer
		interval: isNxt ? 5000 : 5000
		running: false
		repeat: true
		onTriggered: refreshScreen()
	}
}

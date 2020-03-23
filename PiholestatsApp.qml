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
	property variant piholeConfigJSON

	// data in XML string format
	property bool piholeDataRead: false
	
	property string timeStr
	property string dateStr
	property string connectionPath
	property string ipadres
	property string poortnummer : "80"

	property bool firstTimeShown : true

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
			if (poortnummer.length < 2) poortnummer = "8080";		
		} catch(e) {
		}

		datetimeTimer.start();
	}

// refresh screen
	function refreshScreen() {
		piholeDataRead = false;
		readpiholeConfig();
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
	function readpiholeConfig() {

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					piholeConfigJSON = JSON.parse(xmlhttp.responseText); 
					convertToXML();
				}
			}
		}
		xmlhttp.open("GET", "http://"+connectionPath+"/json.htm?type=devices&filter=all&used=true&order=Name", true);
//		xmlhttp.open("GET", "http://127.0.0.1/hdrv_zwave/piholeconfig.txt", true);
		xmlhttp.send();
	}

// Timer
	Timer {
		id: datetimeTimer
		interval: isNxt ? 15000 : 60000
		running: false
		repeat: true
		onTriggered: refreshScreen()
	}
}

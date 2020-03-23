import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: root

	property url trayUrl : "DomoticzboardTray.qml";
	property url thumbnailIcon: "qrc:/tsc/DomoticzSystrayIcon.png"
	property url menuScreenUrl : "DomoticzboardSettings.qml"
	property url domoticzScreenUrl : "DomoticzboardScreen.qml"
	property url domoticzTileUrl : "DomoticzboardTile.qml"
	property DomoticzboardSettings domoticzSettings
	property DomoticzboardScreen domoticzScreen

	property SystrayIcon domoticzTray
	property bool showDBIcon : true
	property variant domoticzConfigJSON

	// Domoticz data in XML string format
	property bool domoticzDataRead: false
	
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
		source: "file:///mnt/data/tsc/domoticzboard.userSettings.json"
 	}

// Domoticz signals, used to update the listview and filter enabled button
//	signal domoticzUpdated()

	function init() {
		registry.registerWidget("systrayIcon", trayUrl, this, "domoticzTray");
		registry.registerWidget("screen", domoticzScreenUrl, this, "domoticzScreen");
		registry.registerWidget("screen", menuScreenUrl, this, "domoticzSettings");
		registry.registerWidget("menuItem", null, this, null, {objectName: "DBMenuItem", label: qsTr("DB-settings"), image: thumbnailIcon, screenUrl: menuScreenUrl, weight: 120});
		registry.registerWidget("tile", domoticzTileUrl, this, null, {thumbLabel: "Domoticz", thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
	}

//this function needs to be started after the app is booted.
	Component.onCompleted: {
		// read user settings
		try {
			userSettingsJSON = JSON.parse(userSettingsFile.read());
			showDBIcon  = (userSettingsJSON['ShowTrayIcon'] == "yes") ? true : false
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
		domoticzDataRead = false;
		readDomoticzConfig();
	}

// save user settings
	function saveSettings(){
		connectionPath = ipadres + ":" + poortnummer;

 		var tmpUserSettingsJSON = {
			"connectionPath" : ipadres + ":" + poortnummer,
			"ShowTrayIcon" : (showDBIcon) ? "yes" : "no"
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/domoticzboard.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJSON));
	}

// read json file
	function readDomoticzConfig() {

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					domoticzConfigJSON = JSON.parse(xmlhttp.responseText); 
					convertToXML();
				}
			}
		}
		xmlhttp.open("GET", "http://"+connectionPath+"/json.htm?type=devices&filter=all&used=true&order=Name", true);
//		xmlhttp.open("GET", "http://127.0.0.1/hdrv_zwave/domoticzconfig.txt", true);
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

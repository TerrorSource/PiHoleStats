import QtQuick 2.1
import SimpleXmlListModel 1.0
import qb.components 1.0
import qb.base 1.0

Screen {
	id: root
	
	screenTitleIconUrl: "qrc:/tsc/pihole_logo_40x40.png"
	screenTitle: "Pi-Hole Stats"
//	property int currentIndex : -1


// Open settings screen when empty settingsfile detected
	onShown: {
		addCustomTopRightButton("Instellingen");
		if (app.connectionPath.length < 5) {
			 app.piholeSettings.show();
		}
	}
// Open settings screen
	onCustomButtonClicked: {
		if (app.piholeSettings) {
			 app.piholeSettings.show();
		}
	}

// Refresh button
	Item {
		id: header
		height: isNxt ? 55 : 45
		width: parent.width

// header
		Text {
			id: headerText
			text: "Pi-Hole stats:" 
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: parent.left
				leftMargin: isNxt ? 62 : 50
				bottom: parent.headerText2
			}
		}
// line 1
		Text {
			id: info_line1
			text: "domains_being_blocked: " + app.piholeConfigJSON['domains_being_blocked'];
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: parent.left
				leftMargin: isNxt ? 62 : 50
				top: headerText.bottom
				topMargin: isNxt ? 20 : 15
			}
		}
// line 2
		Text {
			id: info_line2
			text: "dns_queries_today: " + app.piholeConfigJSON['dns_queries_today'];
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: parent.left
				leftMargin: isNxt ? 62 : 50
				top: info_line1.bottom
				topMargin: isNxt ? 20 : 15
			}
		}
// line 3
		Text {
			id: info_line3
			text: "ads_blocked_today: " + app.piholeConfigJSON['ads_blocked_today'];
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: parent.left
				leftMargin: isNxt ? 62 : 50
				top: info_line2.bottom
				topMargin: isNxt ? 20 : 15
			}
		}
// refresh icon
		IconButton {
			id: refreshButton
			anchors.right: parent.right
			anchors.rightMargin: isNxt ? 15 : 12
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 5
			leftClickMargin: 3
			bottomClickMargin: 5
			iconSource: "qrc:/tsc/refresh.svg"
			onClicked: app.refreshScreen()
		}
	}


// Timer
//	Timer {
//		id: pause1Second
//		interval: 1000
//		running: false
//		repeat: false
//	}

}
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

		Text {
			id: headerText
			text: "Informatie:" 
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: parent.left
				leftMargin: isNxt ? 25 : 20
				bottom: parent.bottom
			}
		}

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
import QtQuick 2.1
import qb.components 1.0


Tile {
	id: piholeTile
	property bool dimState: screenStateController.dimmedColors

	onClicked: {
		stage.openFullscreen(app.piholeScreenUrl);
	}

// Title
	Text {
		id: tiletitle
		text: "PiHole Status"
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 30 : 24
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
       		visible: !dimState || (app.piholeConfigJSON['status'] == "geen connectie")
	}
// line 1 text
	Text {
		id: tileline1
		text: "In de laatste 24 uur is"
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
		anchors {
			top: tiletitle.bottom
			topMargin: isNxt ? 25 : 20
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 22 : 18
		}
		visible: (app.piholeConfigJSON['status'] !== "geen connectie")
	}

// line 2 text
	Text {
		id: tileline2
		text: app.tmp_ads_percentage_today + " van het DNS"
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
		anchors {
			top: tileline1.bottom 
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 22 : 18
		}
		visible: (app.piholeConfigJSON['status'] !== "geen connectie")
	}

// line 4 text
	Text {
		id: tileline4
		text: "verkeer geblokkeerd."
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
		anchors {
			top: tileline2.bottom 
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 22 : 18
		}
		visible: (app.piholeConfigJSON['status'] !== "geen connectie")
	}

// line 5 text
	Rectangle {
    		color: (app.piholeConfigJSON['status'] == "geen connectie") ? "#FF0000" : dimmableColors.background
		anchors {
			top: tileline4.bottom 
			topMargin: 15
			horizontalCenter: parent.horizontalCenter
		}
    		Text {
			id: tileline5
			text: "status: " + app.piholeConfigJSON['status']
			color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
			font {
				family: qfont.regular.name
				pixelSize: isNxt ? 22 : 18
			}
		}
   		width: childrenRect.width
    		height: childrenRect.height
    	}
}

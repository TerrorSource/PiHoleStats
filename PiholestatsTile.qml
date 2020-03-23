import QtQuick 2.1
import qb.components 1.0


Tile {
	id: piholeTile
	property bool dimState: screenStateController.dimmedColors

	onClicked: {
		stage.openFullscreen(app.piholeScreenUrl);
	}

	function simpleSynchronous(request) {
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", request, true);
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					app.refreshScreen();
				}
			}
		}
		xmlhttp.send();
	}
	
//	function iconToShow(status) {
//
//		if (status == "On") {
//			return app.tilebulb_onvar;
//		} else {
//			return app.tilebulb_offvar;
//		}
//	}
	
//	function iconToShowDim(status) {
//
//		if (status == "On") {
//			return app.dimtilebulb_onvar;
//		} else {
//			return app.dimtilebulb_offvar;
//		}
//	}

// Title
	Text {
		id: tiletitle
		text: "PiHole Stats"
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 30 : 24
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.waTileTextColor
       	visible: !dimState
	}
// line 1 text
	Text {
		id: tileline1
		text: "Status: "
		color: colors.clockTileColor
		anchors {
			top: tiletitle.bottom
			baseline: parent.top
			baselineOffset: isNxt ? 62 : 50
			left: parent.left
			leftMargin:  isNxt ? 10 : 8  
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}
// line 1 value
	Text {
		id: valueline1
		text: app.piholeConfigJSON['status'];
		color: colors.clockTileColor
		anchors {
			top: tileline1.top
			right: parent.right
			rightMargin:  isNxt ? 25 : 20 
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}

// line 2 text
	Text {
		id: tileline2
		text: "Ads blocked today: "
		color: colors.clockTileColor
		anchors {
			left: tileline1.left
			top: tileline1.bottom 
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}
// line 2 value
	Text {
		id: valueline2
		text: app.piholeConfigJSON['ads_blocked_today'];
		color: colors.clockTileColor
		anchors {
			top: tileline2.top
			left: valueline1.left
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}

// line 3 text
	Text {
		id: tileline3
		text: "Percentage blocked: "
		color: colors.clockTileColor
		anchors {
			left: tileline2.left
			top: tileline2.bottom 
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}
// line 3 value
	Text {
		id: valueline3
		text: app.piholeConfigJSON['ads_percentage_today'];
		color: colors.clockTileColor
		anchors {
			top: tileline3.top
			left: valueline2.left
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
		clip: true
	}

}

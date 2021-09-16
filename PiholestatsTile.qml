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
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
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
		visible: (app.status !== "geen connectie")
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
		visible: (app.status !== "geen connectie")
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
		visible: (app.status !== "geen connectie")
	}

// line 5 text
	Text {
		id: tileline5
		text: "status: " + app.status
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
		anchors {
			top: tileline4.bottom 
			topMargin: 15
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 22 : 18
		}
	}
}

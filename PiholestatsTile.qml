import QtQuick 2.1
import qb.components 1.0


Tile {
	id: piholeTile
	property bool dimState: screenStateController.dimmedColors

	onClicked: {
		stage.openFullscreen(app.piholeScreenUrl);
	}

	Item {  //listener to respond realtime to property changes
    		property string tileColor: app.tileColor
    		property string textColor: app.textColor
    		property string textBgColor: app.textBgColor

    		onTileColorChanged: piholeTile.bgColor = tileColor;
    		onTextColorChanged: tileline5.color = textColor;
   		onTextBgColorChanged: text5Rect.color = textBgColor;
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
		id: text5Rect
    		color: app.stringBackcolor
		anchors {
			top: tileline4.bottom 
			topMargin: 15
			horizontalCenter: parent.horizontalCenter
		}
    		Text {
			id: tileline5
			text: "status: " + app.piholeConfigJSON['status']
			color: app.stringColor
			font {
				family: qfont.regular.name
				pixelSize: isNxt ? 22 : 18
			}
		}
   		width: childrenRect.width
    		height: childrenRect.height
		visible: (app.piholeConfigJSON['status'] !== "enabled")
    	}
}

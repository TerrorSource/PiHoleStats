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

    Text {
        	id: switch1Title
       		anchors {
         	   top: parent.top
         	   topMargin: isNxt ? 25 : 20
         	   left: parent.left
         	   leftMargin: isNxt ? 25 : 20
        	}
			horizontalAlignment: Text.AlignHCenter
        	font {
            		family: qfont.semiBold.name
             		pixelSize: isNxt ? 20 : 16
        	}
        	color: colors.clockTileColor
//        	text: "text"
			text: "ads_blocked_today: " + app.piholeConfigJSON['ads_blocked_today'];

    	}

}

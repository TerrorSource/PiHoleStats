import QtQuick 2.1

import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: piholeSystrayIcon
	visible: true
	posIndex: 8000

	property string objectName: "piholeSystrayIcon"
	
	onClicked: {
		stage.openFullscreen(app.piholeScreenUrl);
	}

	Image {
		id: imgPihole
		anchors.centerIn: parent
		source: "qrc:/tsc/pihole_logo_30x30.png"
	}
}

import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

Screen {
	id: root
	screenTitle: qsTr("Pi-Hole Instellingen")
	screenTitleIconUrl: "qrc:/tsc/pihole_logo_40x40.png"

	property bool messageShown : false

// Save button
	onShown: {
		addCustomTopRightButton("Opslaan");
		showAppIconToggle.isSwitchedOn = app.showAppIcon;
		ipadresLabel.inputText = app.ipadres;
		poortnummerLabel.inputText = app.poortnummer;
		refreshrateLabel.inputText = app.refreshrate;
		messageShown = false;
	}

	onCustomButtonClicked: {
		app.saveSettings();
		app.firstTimeShown = true; 
		app.piholeDataRead = false;
		app.readPiHolePHPData();
		hide();
	}

// not used
	function showMessage() {
		if (!app.dialogShown) {
				qdialog.showDialog(qdialog.SizeLarge, "Pi-Hole mededeling", "Als U op 'Opslaan' drukt zal de configuratie opnieuw worden ingeladen,\nde Toon heeft even wat tijd nodig om dit uit te voeren." , "Sluiten");
				messageShown = true;
		}
	}
	
// Save IP Address
	function saveIpadres(text) {
		if (text) {
			ipadresLabel.inputText = text;
			app.ipadres = text;
		}
	}
// Save Port Number
	function savePoortnummer(text) {
		if (text) {
			poortnummerLabel.inputText = text;
			app.poortnummer = text;
		}
	}

// Save Refresh rate
	function saveRefreshRate(text) {
		if (text) {
			refreshrateLabel.inputText = text;
			app.refreshrate = text;
		}
	}
	
// systray icon toggle
	Text {
		id: systrayText
		anchors {
			left: parent.left
			leftMargin: isNxt ? 62 : 50
            		top: parent.top
            		topMargin: isNxt ? 19 : 15
		}
		font {
			pixelSize: isNxt ? 25 : 20
			family: qfont.bold.name
		}
		wrapMode: Text.WordWrap
		text: "Pi-Hole icoon zichtbaar in systray?"
	}
	
	OnOffToggle {
		id: showAppIconToggle
		height: 36
		anchors {
			right: parent.right
			rightMargin: isNxt ? 125 : 100
			top: systrayText.top
		}
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			app.showAppIcon = isSwitchedOn
		}
	}

// IP address
	EditTextLabel4421 {
		id: ipadresLabel
		height: editipAdresButton.height
		width: isNxt ? 800 : 600
		leftText: qsTr("IP-adres Pi-Hole")
		leftTextAvailableWidth: isNxt ? 600 : 480
		anchors {
			left:parent.left
			leftMargin: isNxt ? 62 : 50
			top: systrayText.bottom
			topMargin: isNxt ? 25 : 20
		}
	}
			
	IconButton {
		id: editipAdresButton
		width: isNxt ? 50 : 40
		anchors {
			left:ipadresLabel.right
			leftMargin: isNxt ? 12 : 10
			top: ipadresLabel.top
		}
		iconSource: "qrc:/tsc/edit.png"
		onClicked: {
			qkeyboard.open("Voer hier het ip-adres van Pi-Hole in", ipadresLabel.inputText, saveIpadres)
		}
	}

// Port number
	EditTextLabel4421 {
		id: poortnummerLabel
		height: editportNumberButton.height
		width: isNxt ? 800 : 600
		leftTextAvailableWidth: isNxt ? 600 : 480
		leftText: qsTr("Port (default is 80)")
		anchors {
			left:parent.left
			leftMargin: isNxt ? 62 : 50
			top: ipadresLabel.bottom
			topMargin: isNxt ? 25 : 20
		}
	}
	
	IconButton {
		id: editportNumberButton
		width: isNxt ? 50 : 40
		anchors {
			left:poortnummerLabel.right
			leftMargin: isNxt ? 12 : 10
			top: poortnummerLabel.top
		}
		iconSource: "qrc:/tsc/edit.png"
			onClicked: {
			qkeyboard.open("Voer hier de poort in", poortnummerLabel.inputText, savePoortnummer);
		}
	}
// refresh rate
	EditTextLabel4421 {
		id: refreshrateLabel
		height: editRefreshRateButton.height
		width: isNxt ? 800 : 600
		leftTextAvailableWidth: isNxt ? 600 : 480
		leftText: qsTr("Refresh rate in seconds (default is 60)")
		anchors {
			left:parent.left
			leftMargin: isNxt ? 62 : 50
			top: poortnummerLabel.bottom
			topMargin: isNxt ? 25 : 20
		}
	}
	
	IconButton {
		id: editRefreshRateButton
		width: isNxt ? 50 : 40
		anchors {
			left:refreshrateLabel.right
			leftMargin: isNxt ? 12 : 10
			top: refreshrateLabel.top
		}
		iconSource: "qrc:/tsc/edit.png"
			onClicked: {
			qkeyboard.open("Voer hier de refresh rate in", refreshrateLabel.inputText, saveRefreshRate);
		}
	}
// end port number		
}

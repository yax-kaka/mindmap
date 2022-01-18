import QtQuick 2.9
import QtQuick.Window 2.2

import QtQuick.Controls 2.2
Window {
    visible: true
    width: 1000
    height: 600
    title: qsTr("Mind Map")

    Rectangle{
       id: maimMap
       anchors{
           left: parent.left
           top: parent.top
           bottom: parent.bottom
           margins: 20
       }
       width: parent.width-200
       border.color: "black"
       ScrollView{
           id:mapView
           anchors.centerIn: parent
           clip: true
           width: Math.min(parent.width, visualizer.width)
           height: Math.min(parent.height, visualizer.height)
           contentWidth: visualizer.width; contentHeight: visualizer.height
           Visualizer{
               id: visualizer
               anchors.centerIn: parent
           }
       }
    }
    Button{
        id: visualizeButton
        text: qsTr("开始")
        anchors{
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: 10

        }
        onClicked: {

            if(visualizer.rootNode !== null){
                $hub.destroyNode(visualizer.rootNode);
                console.log("colorButton: ", this.text)
            }

            visualizer.rootNode = $hub.mapinit(visualizer);
        }
    }
}

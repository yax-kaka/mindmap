import QtQuick 2.7
import QtQuick.Layouts 1.3

Item{
    id: root
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    property alias nodeRect: nodeContentRect
    property alias text: nodeText.text
    property alias childrenLayout: childrenLayout
    property string color
    property int states:0 //节点状态
    property bool  texting: false //是否在编辑
    property bool addNode:false //添加节点
    property int level:0 //颜色级别
    RowLayout {
        id: rowLayout

        spacing: 50

        Rectangle{//结点
            function not(x){
                return !x
            }
            visible: not(root.texting)
            id: nodeContentRect
            implicitWidth: nodeText.contentWidth + 15
            implicitHeight: nodeText.contentHeight + 15
            color: root.color
            radius: 5
            Text{
                id: nodeText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font{
                    family: "Arial"
                    pointSize: 15
                }
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onExited: {
                    root.states = 0
                }
                onClicked: {
                    root.states +=1
                    function textingChang(states){
                        root.texting = states ===2?true:false
                    }
                    console.log("状态",root.states)
                    var s = root.states
                    if(s===1){//添加节点
                        console.log("进入",nodeText.text)
                        root.addNode = true
                    }
                    if(s===2){//切换成输入框
                        root.addNode = false
                        console.log("进入")
                        textingChang(s)
                        //$hub.changeText(nodeText,nodeText.text)
                    }
                }
            }

        }
        Rectangle{//输入框
            id:inputRect
            visible: root.texting
            implicitWidth: nodeText.contentWidth + 15
            implicitHeight: nodeText.contentHeight + 15
            color: root.color
            radius: 5
            TextInput {
                id:searchInput
                visible: root.texting
                width:parent
                anchors.verticalCenter: parent.verticalCenter
                font:nodeText.font
                color:"white"
                text: nodeText.text
                mouseSelectionMode :SelectWords
                overwriteMode :true
                readOnly:false
            }

        }
        Rectangle{//完成按钮
            id:finishRect
            visible: root.texting
            anchors{
                top: inputRect.top
                bottom: inputRect.bottom
                left: inputRect.right
            }
            width: 50
            color: "#35ea60"
            radius: 5
            Text {
                id: finishText
                text: qsTr("完成")
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font{
                    family: "Arial"
                    pointSize: 15
                }
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onClicked: {
                    root.states = 0
                    console.log("退出")
                    root.texting = states ===2?true:false
                    $hub.changeText(nodeText,searchInput.text)
                }
           }
        }
        Rectangle{//添加按钮
            id:addRect
            visible: root.addNode
            anchors{
                top: nodeContentRect.top
                bottom: nodeContentRect.bottom
                left: nodeContentRect.right
            }
            width: 50
            color: "#53ef78"
            radius: 5
            Text {
                id: addText
                text: qsTr("添加")
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font{
                    family: "Arial"
                    pointSize: 15
                }
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onClicked: {
                    console.log("退出")
                    root.addNode = false
                    $hub.addNode(root.color,root)
                }
           }
        }
        Rectangle{//删除按钮
            id:delRect
            visible: root.addNode
            anchors{
                top: nodeContentRect.top
                bottom: nodeContentRect.bottom
                left: addRect.right
            }
            width: 50
            color: "#f72525"
            radius: 5
            Text {
                id: delText
                text: qsTr("删除")
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font{
                    family: "Arial"
                    pointSize: 15
                }
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled:true
                onClicked: {
                    console.log("退出")
                    root.addNode = false
                    $hub.delNode(root)
                }
           }
        }
        ColumnLayout{
            id: childrenLayout
            spacing: 10     //布局间隔
            onHeightChanged: lineCanvas.requestPaint();
            onWidthChanged: lineCanvas.requestPaint();
        }
    }
    Canvas{
        id: lineCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var pt1 = mapFromItem(nodeContentRect, nodeContentRect.width, nodeContentRect.height / 2);
            for(var i = 0; i !== childrenLayout.children.length; ++i){
                var item = childrenLayout.children[i];
                var pt2 = mapFromItem(item.nodeRect, 0, item.nodeRect.height / 2);
                ctx.moveTo(pt1.x, pt1.y);
                ctx.bezierCurveTo(pt1.x + 20, pt1.y, pt2.x - 20, pt2.y, pt2.x, pt2.y);
            }
            ctx.strokeStyle = "#969f95";
            ctx.lineWidth = 2;
            ctx.stroke();
        }
    }

}



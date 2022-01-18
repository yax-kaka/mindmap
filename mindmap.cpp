#include "mindmap.h"
#include <QFile>
#include <QtDebug>
#include <QQmlProperty>
#include <string>
MindMap::MindMap(QQmlEngine *engine, QObject *parent)
    : QObject(parent),
      m_engine(engine)
{

}

QQuickItem* MindMap::mapinit(QQuickItem *rootItem){
    auto component = new QQmlComponent(m_engine, QUrl::fromLocalFile(":/Node.qml"));
    if(component->status() == QQmlComponent::Error){
        qWarning()<<"Component create error!"<<component->errorString();
        return nullptr;
    }
    m_levelComponents.push_back(component);
    //初始化颜色队列
    m_levelColors.push_back("#205374");
    m_levelColors.push_back("#27a09e");
    m_levelColors.push_back("#27c4af");
    m_levelColors.push_back("#92d626");
    m_levelColors.push_back("#c5e539");
    m_levelColors.push_back("#ef934c");
    m_levelColors.push_back("#f77b7b");


    auto firstItem = qobject_cast<QQuickItem*>(component->create());
    if(firstItem == nullptr){
        qWarning()<<"Create level item error!"<<component->errorString();
        return nullptr;
    }
    QQmlProperty layoutProp(rootItem, "childrenLayout");
    if(layoutProp.type() == QQmlProperty::Invalid){
        firstItem->setParentItem(rootItem);
    }else{
        auto layout = layoutProp.read().value<QQuickItem*>();
        Q_ASSERT(layout);
        firstItem->setParentItem(layout);
    }
    QQmlProperty colorProp(firstItem, "color");
    colorProp.write("#205374");
    QQmlProperty textProp(firstItem, "text");
    textProp.write("从这里开始");
    return firstItem;
}
//添加节点
QQuickItem *MindMap::createNode(QString color, QQuickItem *parentItem)
{
    auto *component = 1 >= m_levelComponents.count()?
                m_levelComponents.back() : m_levelComponents[1];
    auto item = qobject_cast<QQuickItem*>(component->create());

    if(item == nullptr){
        qWarning()<<"Create level item error!"<<component->errorString();
        return nullptr;
    }
    QQmlProperty layoutProp(parentItem, "childrenLayout");
    if(layoutProp.type() == QQmlProperty::Invalid){
        item->setParentItem(parentItem);
    }else{
        auto layout = layoutProp.read().value<QQuickItem*>();
        Q_ASSERT(layout);
        item->setParentItem(layout);
    }

    QQmlProperty colorProp(item, "color");
    colorProp.write(levelColor(color));
    QQmlProperty textProp(item, "text");
    textProp.write("编辑");
    return item;
}


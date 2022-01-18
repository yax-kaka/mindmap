#ifndef MINDMAP_H
#define MINDMAP_H

#endif // MINDMAP_H
#include <QObject>
#include <QQuickItem>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QQmlEngine>
#include <QQmlProperty>
#include <QList>
#include <QColor>

class MindMap:public QObject{
    Q_OBJECT
private:
    QQmlEngine *m_engine = nullptr;
    QList<QQmlComponent*> m_levelComponents;
    QList<QString> m_levelColors;    

    inline void setNodeText(QQuickItem *item, const QString &text){
        QQmlProperty nodeTextProp(item, "text");
        nodeTextProp.write(text);
    }
    inline QString levelColor(QString color){
        int level = 0;
        for(int i = 0;i<m_levelColors.length();i++){
            if(color == m_levelColors[i]){
                level=i+1;break;
            }else{level=i;}
        }
        return level >= m_levelColors.size()? m_levelColors.back() : m_levelColors[level];
    }
    QQuickItem *createNode(QString color, QQuickItem *parentItem);
public:
    explicit MindMap(QQmlEngine* engine, QObject *parent = nullptr);
    Q_INVOKABLE QQuickItem *mapinit(QQuickItem *rootItem);

public slots://信号槽函数
    //重置
    void destroyNode(QQuickItem *rootNode){
        delete rootNode;
    }
    //输入完成按钮
    void changeText(QQuickItem *Nodeitem, QString newtext){
        QQmlProperty nodeTextProp(Nodeitem,"text");
        nodeTextProp.write(newtext);
    }
    //添加按钮
    QQuickItem *addNode(QString color, QQuickItem *parentItem){
        createNode(color,parentItem);
    }
    //删除按钮
    void delNode(QQuickItem *item){
        delete item;
    }
};

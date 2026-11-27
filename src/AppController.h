#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

// Application state and actions exposed to QML via QML_ELEMENT.
// Do not mark QML_ELEMENT classes final; Qt's QML registration subclasses them.
class AppController : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString status READ status NOTIFY countChanged)

public:
    explicit AppController(QObject* parent = nullptr);

    int count() const;
    QString status() const;

    Q_INVOKABLE void increment();
    Q_INVOKABLE void reset();

signals:
    void countChanged();

private:
    int m_count = 0;
};

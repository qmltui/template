#include "AppController.h"

AppController::AppController(QObject* parent) : QObject(parent) {}

int AppController::count() const {
    return m_count;
}

QString AppController::status() const {
    if (m_count == 0) {
        return QStringLiteral("Ready");
    }
    return QStringLiteral("Clicked %1 time(s)").arg(m_count);
}

void AppController::increment() {
    ++m_count;
    emit countChanged();
}

void AppController::reset() {
    if (m_count == 0) {
        return;
    }
    m_count = 0;
    emit countChanged();
}

#!/bin/bash
# Установка переменных окружения для Qt
export QT_QPA_PLATFORM=xcb
export QT_DEBUG_PLUGINS=1  # Для диагностики

# Проверка доступных плагинов
python -c "from PyQt6.QtCore import QCoreApplication; app = QCoreApplication([]); print('Qt plugins:', app.libraryPaths())"

# Запуск приложения
python main.py run DeepFaceLive --userdata-dir /data/

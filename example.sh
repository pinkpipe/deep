#!/bin/bash
# Установка переменных окружения для Qt
export QT_QPA_PLATFORM=xcb
export QT_DEBUG_PLUGINS=0

# Проверка и создание папки данных
DATA_DIR="${1:-/data}"
mkdir -p "$DATA_DIR"

# Запуск приложения
exec python main.py run DeepFaceLive --userdata-dir "$DATA_DIR"

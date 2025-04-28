#!/bin/bash

# Проверка и создание папки данных
if [ ! -d "/data" ]; then
    mkdir -p "/data"
fi

# Запуск приложения
exec python main.py run DeepFaceLive --userdata-dir /data

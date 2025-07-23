#!/bin/bash

# Скрипт для создания иконок приложения разных размеров
# Требует установленный ImageMagick

echo "🎨 Создание иконок приложения..."

# Создаем папку для иконок если её нет
mkdir -p TravelExpenses/Assets.xcassets/AppIcon.appiconset

# Размеры иконок для iOS
declare -a sizes=(
    "20x20" "40x40" "60x60" "29x29" "58x58" "87x87" 
    "80x80" "120x120" "180x180" "1024x1024"
)

# Создаем базовую иконку (можно заменить на вашу)
convert -size 1024x1024 \
    -background "linear-gradient(45deg, #4CAF50, #FF9800)" \
    -fill white \
    -gravity center \
    -pointsize 200 \
    -annotate 0 "✈️" \
    -font "Arial-Bold" \
    -pointsize 100 \
    -annotate +0+100 "Travel\nExpenses" \
    temp_icon.png

echo "✅ Базовая иконка создана"

# Создаем иконки разных размеров
for size in "${sizes[@]}"; do
    convert temp_icon.png -resize "${size}!" "icon_${size}.png"
    echo "✅ Создана иконка ${size}"
done

# Перемещаем иконки в нужные папки
mv icon_1024x1024.png metadata/app_store_connect/app_icon.png
echo "✅ Иконка для App Store сохранена"

# Очищаем временные файлы
rm temp_icon.png
rm icon_*.png

echo "🎉 Все иконки созданы успешно!"
echo "📱 Иконка для App Store: metadata/app_store_connect/app_icon.png" 
#!/bin/bash

# Тестовый скрипт для демонстрации работы с иконками
echo "🧪 Тестирование скрипта создания иконок..."

# Проверяем наличие ImageMagick
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick не установлен"
    echo "Установите: brew install imagemagick"
    exit 1
fi

echo "✅ ImageMagick найден"

# Создаем тестовую иконку
echo "🎨 Создаем тестовую иконку..."
convert -size 1024x1024 \
    -background "linear-gradient(45deg, #4CAF50, #FF9800)" \
    -fill white \
    -gravity center \
    -pointsize 200 \
    -annotate 0 "✈️" \
    -font "Arial-Bold" \
    -pointsize 100 \
    -annotate +0+100 "Travel\nExpenses" \
    test_icon.png

echo "✅ Тестовая иконка создана: test_icon.png"

# Запускаем основной скрипт
echo "🚀 Запускаем скрипт создания иконок..."
./scripts/create_app_icon.sh test_icon.png

# Проверяем результат
echo ""
echo "📋 Проверяем созданные файлы:"
ls -la metadata/app_store_connect/app_icon.png 2>/dev/null && echo "✅ App Store иконка создана"
ls -la TravelExpenses/Assets.xcassets/AppIcon.appiconset/ 2>/dev/null && echo "✅ Xcode иконки созданы"

# Очищаем тестовый файл
rm -f test_icon.png

echo ""
echo "🎉 Тест завершен!"
echo "Теперь вы можете использовать свой файл иконки:"
echo "  ./scripts/create_app_icon.sh your_icon.png" 
#!/bin/bash

# Скрипт для создания иконок приложения из пользовательского файла
# Требует установленный ImageMagick

echo "🎨 Создание иконок приложения из вашего файла..."

# Проверяем наличие ImageMagick
if ! command -v convert &> /dev/null; then
    echo "❌ Ошибка: ImageMagick не установлен"
    echo "Установите ImageMagick: brew install imagemagick"
    exit 1
fi

# Проверяем аргументы
if [ $# -eq 0 ]; then
    echo "📋 Использование: $0 <путь_к_вашей_иконке>"
    echo ""
    echo "Примеры:"
    echo "  $0 icon.png"
    echo "  $0 /path/to/my_icon.jpg"
    echo "  $0 ~/Downloads/app_icon.png"
    echo ""
    echo "Поддерживаемые форматы: PNG, JPG, JPEG, SVG, TIFF"
    echo ""
    echo "💡 Рекомендации:"
    echo "  - Используйте квадратное изображение (например, 1024x1024)"
    echo "  - Формат PNG для лучшего качества"
    echo "  - Убедитесь, что иконка хорошо выглядит в маленьком размере"
    exit 1
fi

ICON_FILE="$1"

# Проверяем существование файла
if [ ! -f "$ICON_FILE" ]; then
    echo "❌ Ошибка: Файл '$ICON_FILE' не найден"
    exit 1
fi

echo "📁 Обрабатываем файл: $ICON_FILE"

# Создаем папки если их нет
mkdir -p TravelExpenses/Assets.xcassets/AppIcon.appiconset
mkdir -p metadata/app_store_connect

# Получаем информацию о файле
FILE_INFO=$(identify "$ICON_FILE" 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "❌ Ошибка: Не удается прочитать файл '$ICON_FILE'"
    echo "Убедитесь, что файл является изображением"
    exit 1
fi

echo "✅ Файл успешно прочитан"

# Создаем временную рабочую копию в PNG формате
TEMP_ICON="temp_icon_$(date +%s).png"
convert "$ICON_FILE" -resize 1024x1024 "$TEMP_ICON"

echo "✅ Создана рабочая копия (1024x1024)"

# Размеры иконок для iOS App Store и приложения
declare -a sizes=(
    # App Store
    "1024x1024"
    
    # iPhone
    "20x20" "40x40" "60x60" "29x29" "58x58" "87x87" 
    "80x80" "120x120" "180x180"
    
    # iPad
    "20x20" "40x40" "29x29" "58x58" "76x76" "152x152"
    "167x167"
    
    # Settings
    "29x29" "58x58" "87x87"
    
    # Spotlight
    "40x40" "80x80" "120x120"
)

# Создаем иконки разных размеров
echo "🔄 Создаем иконки разных размеров..."
for size in "${sizes[@]}"; do
    output_file="icon_${size}.png"
    convert "$TEMP_ICON" -resize "${size}!" "$output_file"
    echo "  ✅ ${size}"
done

# Создаем Contents.json для AppIcon.appiconset
cat > TravelExpenses/Assets.xcassets/AppIcon.appiconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Перемещаем иконки в правильные места
echo "📁 Распределяем иконки по папкам..."

# App Store иконка (1024x1024)
cp icon_1024x1024.png metadata/app_store_connect/app_icon.png

# iPhone иконки
cp icon_40x40.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_20x20@2x.png
cp icon_60x60.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_20x20@3x.png
cp icon_58x58.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_29x29@2x.png
cp icon_87x87.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_29x29@3x.png
cp icon_80x80.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_40x40@2x.png
cp icon_120x120.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_40x40@3x.png
cp icon_120x120.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_60x60@2x.png
cp icon_180x180.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_60x60@3x.png

# iPad иконки
cp icon_20x20.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_20x20@1x.png
cp icon_40x40.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_20x20@2x_ipad.png
cp icon_29x29.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_29x29@1x.png
cp icon_58x58.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_29x29@2x_ipad.png
cp icon_40x40.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_40x40@1x.png
cp icon_80x80.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_40x40@2x_ipad.png
cp icon_152x152.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_76x76@2x.png
cp icon_167x167.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_83.5x83.5@2x.png

# App Store иконка
cp icon_1024x1024.png TravelExpenses/Assets.xcassets/AppIcon.appiconset/icon_1024x1024.png

# Очищаем временные файлы
rm "$TEMP_ICON"
rm icon_*.png

echo ""
echo "🎉 Все иконки созданы успешно!"
echo ""
echo "📱 Созданные файлы:"
echo "  ✅ App Store иконка: metadata/app_store_connect/app_icon.png"
echo "  ✅ Xcode иконки: TravelExpenses/Assets.xcassets/AppIcon.appiconset/"
echo ""
echo "🚀 Следующие шаги:"
echo "  1. Откройте проект в Xcode"
echo "  2. Проверьте иконки в Assets.xcassets"
echo "  3. Запустите сборку для проверки"
echo ""
echo "💡 Если иконки не отображаются в Xcode:"
echo "  - Очистите проект (Product → Clean Build Folder)"
echo "  - Перезапустите Xcode" 
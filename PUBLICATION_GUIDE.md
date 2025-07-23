# 🚀 Руководство по публикации TravelExpenses в App Store

## 📋 Предварительные требования

### 1. Apple Developer Account
- ✅ Активная подписка Apple Developer Program ($99/год)
- ✅ Доступ к App Store Connect
- ✅ Сертификаты разработки и распространения

### 2. App Store Connect настройка
- ✅ Создать новое приложение в App Store Connect
- ✅ Настроить Bundle ID: `com.ifly.TravelExpenses.TravelExpenses`
- ✅ Загрузить иконку приложения (1024x1024)
- ✅ Заполнить метаданные приложения

## 🔧 Настройка App Store Connect

### 1. Создание приложения
1. Войдите в [App Store Connect](https://appstoreconnect.apple.com)
2. Перейдите в "My Apps" → "+" → "New App"
3. Заполните информацию:
   - **Platforms**: iOS
   - **Name**: TravelExpenses
   - **Primary language**: English
   - **Bundle ID**: com.ifly.TravelExpenses.TravelExpenses
   - **SKU**: travel-expenses-2024
   - **User Access**: Full Access

### 2. Загрузка иконки
1. В разделе "App Information" → "App Icon"
2. Загрузите файл: `metadata/app_store_connect/app_icon.png`

### 3. Заполнение метаданных
Используйте файлы из папки `metadata/app_store_connect/`:

- **App Name**: `TravelExpenses`
- **Subtitle**: `Smart Travel Expense Tracker`
- **Description**: Содержимое `description.txt`
- **Keywords**: Содержимое `keywords.txt`
- **Support URL**: Содержимое `support_url.txt`
- **Privacy Policy URL**: Содержимое `privacy_url.txt`

## 🔑 Настройка Codemagic

### 1. Подключение к Codemagic
1. Зайдите на [codemagic.io](https://codemagic.io)
2. Подключите GitHub репозиторий
3. Выберите проект TravelExpenses

### 2. Настройка переменных окружения
В настройках проекта добавьте:

```bash
# Apple Developer Account
APPLE_DEVELOPER_EMAIL=your-email@example.com
APPLE_DEVELOPER_APP_SPECIFIC_PASSWORD=your-app-specific-password

# App Store Connect API
APP_STORE_CONNECT_ISSUER_ID=your-issuer-id
APP_STORE_CONNECT_API_KEY_ID=your-api-key-id
APP_STORE_CONNECT_API_PRIVATE_KEY=your-private-key

# Code Signing
CM_CERTIFICATE=your-certificate-base64
CM_CERTIFICATE_PASSWORD=your-certificate-password
CM_PROVISIONING_PROFILE=your-provisioning-profile-base64
```

### 3. Получение App Store Connect API ключей
1. В App Store Connect → Users and Access → Keys
2. Создайте новый API ключ с правами "App Manager"
3. Скачайте .p8 файл
4. Запишите:
   - Issuer ID
   - Key ID
   - Private Key (содержимое .p8 файла)

## 🚀 Процесс публикации

### Вариант 1: Автоматическая публикация через Codemagic

1. **Создайте новый релиз**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Codemagic автоматически**:
   - Соберет приложение
   - Подпишет код
   - Загрузит в App Store Connect
   - Отправит на проверку

### Вариант 2: Ручная публикация через Xcode

1. **Подготовка к архивированию**:
   ```bash
   # Очистка проекта
   xcodebuild clean -scheme TravelExpenses
   
   # Архивирование
   xcodebuild archive -scheme TravelExpenses -archivePath build/TravelExpenses.xcarchive
   ```

2. **Экспорт IPA**:
   - Откройте Xcode → Window → Organizer
   - Выберите архив
   - Нажмите "Distribute App"
   - Выберите "App Store Connect"
   - Следуйте инструкциям

## 📱 Проверка и публикация

### 1. Тестирование
- ✅ Приложение работает на симуляторе
- ✅ Иконки отображаются корректно
- ✅ Все функции работают
- ✅ Нет критических ошибок

### 2. Отправка на проверку
1. В App Store Connect → "Prepare for Submission"
2. Заполните все обязательные поля
3. Загрузите скриншоты (минимум 3)
4. Добавьте описание и ключевые слова
5. Нажмите "Submit for Review"

### 3. Ожидание проверки
- ⏱️ Время проверки: 1-7 дней
- 📧 Уведомления приходят на email
- 🔍 Статус можно отслеживать в App Store Connect

## 🎯 После публикации

### 1. Мониторинг
- Отслеживайте отзывы пользователей
- Анализируйте метрики использования
- Следите за рейтингами

### 2. Обновления
- Используйте тот же процесс для обновлений
- Увеличивайте версию в Info.plist
- Обновляйте release notes

### 3. Маркетинг
- Продвигайте приложение в социальных сетях
- Создайте landing page
- Используйте ASO (App Store Optimization)

## 📞 Поддержка

Если возникнут проблемы:
1. Проверьте логи сборки в Codemagic
2. Ознакомьтесь с [Apple Developer Guidelines](https://developer.apple.com/app-store/review/guidelines/)
3. Обратитесь в поддержку Apple Developer Program

## 🎉 Поздравляем!

После успешной публикации ваше приложение будет доступно в App Store для миллионов пользователей по всему миру!

---

**Следующие шаги:**
1. Настройте App Store Connect
2. Подключите Codemagic
3. Создайте первый релиз
4. Отправьте на проверку
5. Опубликуйте приложение 
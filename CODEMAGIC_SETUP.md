# Настройка Codemagic для публикации в App Store

## 📋 Предварительные требования

### 1. Apple Developer Account
- Активная подписка Apple Developer Program ($99/год)
- Доступ к App Store Connect
- Team ID (находится в Apple Developer Portal)

### 2. Сертификаты и профили
- **Distribution Certificate** (.p12 файл)
- **Provisioning Profile** для App Store
- **App Store Connect API Key**

## 🔧 Настройка Codemagic

### Шаг 1: Подключение репозитория
1. Зайдите на [codemagic.io](https://codemagic.io)
2. Создайте аккаунт или войдите
3. Нажмите "Add application"
4. Подключите ваш GitHub/GitLab репозиторий
5. Выберите ветку (обычно `main` или `master`)

### Шаг 2: Настройка переменных окружения

В настройках приложения в Codemagic добавьте следующие переменные:

#### App Store Connect API
```
APP_STORE_CONNECT_ISSUER_ID = [ваш_issuer_id]
APP_STORE_CONNECT_API_KEY_ID = [ваш_key_id]
APP_STORE_CONNECT_API_KEY = [ваш_private_key]
```

#### Сертификаты
```
BUILD_CERTIFICATE_BASE64 = [base64_encoded_p12_certificate]
CERTIFICATE_PASSWORD = [пароль_от_сертификата]
CERTIFICATE_PRIVATE_KEY = [base64_encoded_private_key]
KEYCHAIN_PASSWORD = [любой_пароль_для_keychain]
```

#### Provisioning Profile
```
PROVISIONING_PROFILE_BASE64 = [base64_encoded_provisioning_profile]
PROVISIONING_PROFILE_SPECIFIER = [имя_профиля]
```

#### Team и Code Signing
```
TEAM_ID = [ваш_team_id]
CODE_SIGN_IDENTITY = "iPhone Distribution: [ваше_имя]"
```

#### App Store Connect (для публикации)
```
APP_STORE_CONNECT_USERNAME = [ваш_apple_id]
APP_STORE_CONNECT_APP_SPECIFIC_PASSWORD = [app_specific_password]
```

## 📱 Подготовка приложения

### 1. Обновите Bundle Identifier
Убедитесь, что в `TravelExpenses.xcodeproj` указан правильный Bundle ID:
```
com.ifly.TravelExpenses.TravelExpenses
```

### 2. Настройте версию приложения
В Xcode:
- Project Settings → General → Version
- Установите версию (например, 1.0.0)
- Установите Build number (например, 1)

### 3. Подготовьте метаданные для App Store
Создайте папку `metadata` в корне проекта:
```
metadata/
├── app_store_connect/
│   ├── app_icon.png (1024x1024)
│   ├── description.txt
│   ├── keywords.txt
│   ├── name.txt
│   ├── privacy_url.txt
│   ├── release_notes.txt
│   └── support_url.txt
```

## 🚀 Запуск сборки

### Автоматическая сборка
После настройки переменных:
1. Каждый push в основную ветку запустит сборку
2. Codemagic автоматически:
   - Соберет приложение
   - Подпишет его
   - Загрузит в TestFlight
   - Отправит уведомление

### Ручная сборка
1. В Codemagic Dashboard нажмите "Start new build"
2. Выберите ветку и workflow
3. Нажмите "Start build"

## 📊 Мониторинг

### Логи сборки
- Все логи доступны в реальном времени
- Можно скачать артефакты (.ipa файл)
- Уведомления о статусе сборки

### TestFlight
После успешной сборки:
1. Приложение появится в App Store Connect
2. В TestFlight можно добавить тестеров
3. После тестирования можно отправить на ревью в App Store

## 🔍 Устранение проблем

### Частые ошибки

#### Code Signing Issues
```
Error: No code signing identity found
```
**Решение**: Проверьте переменные `BUILD_CERTIFICATE_BASE64` и `CERTIFICATE_PASSWORD`

#### Provisioning Profile Issues
```
Error: No provisioning profile found
```
**Решение**: Проверьте переменную `PROVISIONING_PROFILE_BASE64`

#### App Store Connect Issues
```
Error: Authentication failed
```
**Решение**: Проверьте App Store Connect API ключи

### Полезные команды для отладки
```bash
# Проверка сертификатов
security find-identity -v -p codesigning

# Проверка provisioning profiles
ls ~/Library/MobileDevice/Provisioning\ Profiles/

# Проверка keychain
security list-keychains
```

## 📈 Оптимизация

### Ускорение сборки
- Используйте кэширование зависимостей
- Оптимизируйте размер проекта
- Используйте параллельные сборки

### Безопасность
- Все секреты хранятся в Codemagic
- Используйте app-specific passwords
- Регулярно обновляйте сертификаты

## 🎯 Следующие шаги

1. **Настройте App Store Connect**:
   - Создайте приложение в App Store Connect
   - Заполните метаданные
   - Настройте цены и доступность

2. **Подготовьте материалы**:
   - Скриншоты приложения
   - Описание и ключевые слова
   - Политика конфиденциальности

3. **Тестирование**:
   - Протестируйте через TestFlight
   - Исправьте найденные баги
   - Подготовьте к ревью

4. **Публикация**:
   - Отправьте на ревью в App Store
   - Дождитесь одобрения
   - Опубликуйте приложение

## 📞 Поддержка

- [Codemagic Documentation](https://docs.codemagic.io/)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

---

**Удачи с публикацией! 🚀** 
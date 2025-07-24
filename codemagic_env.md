# 🔧 Переменные окружения для Codemagic

## 📋 Добавьте эти переменные в настройках проекта Codemagic:

### Основные переменные:
```
XCODE_PROJECT = TravelExpenses.xcodeproj
XCODE_SCHEME = TravelExpenses
BUNDLE_ID = com.Travon.TravelExpenses
TEAM_ID = 74335G6GZ5
```

### Object IDs в проекте:
```
DEBUG_CONFIG_ID = F21C12C82E212CD800C7DB37
RELEASE_CONFIG_ID = F21C12C92E212CD800C7DB37
```

### App Store Connect API:
```
APP_STORE_CONNECT_ISSUER_ID = 74335G6GZ5
APP_STORE_CONNECT_API_KEY_ID = 8NJVRV8NU7
APP_STORE_CONNECT_API_KEY = [содержимое .p8 файла]
CERTIFICATE_ID = [ID вашего Distribution сертификата]
```

### Code Signing (если используете ручные сертификаты):
```
BUILD_CERTIFICATE_BASE64 = [base64 сертификата]
CERTIFICATE_PRIVATE_KEY = [base64 приватного ключа]
CERTIFICATE_PASSWORD = [пароль сертификата]
PROVISIONING_PROFILE_BASE64 = [base64 профиля]
PROVISIONING_PROFILE_SPECIFIER = TravelExpenses_AppStore
CODE_SIGN_IDENTITY = iPhone Distribution
KEYCHAIN_PASSWORD = codemagic
```

## 🚀 Как добавить в Codemagic:

1. **Откройте проект** в Codemagic
2. **Settings** → **Environment variables**
3. **Добавьте каждую переменную** с соответствующим значением
4. **Сохраните настройки**

## 📝 Примечания:

- **APP_STORE_CONNECT_API_KEY**: Содержимое .p8 файла (включая BEGIN и END строки)
- **TEAM_ID**: Ваш Team ID из Apple Developer Portal
- **BUNDLE_ID**: Должен совпадать с настройками в Xcode проекте
- **-allowProvisioningUpdates**: Позволяет Xcode автоматически создавать профили

## 🚀 Что делает -allowProvisioningUpdates:

✅ Позволяет Xcode автоматически создавать профили
✅ Обновляет существующие профили при необходимости
✅ Работает с App Store Connect API
✅ Упрощает процесс подписи кода в CI/CD 
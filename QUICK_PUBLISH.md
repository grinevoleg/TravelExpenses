# ⚡ Быстрый старт публикации TravelExpenses

## 🎯 Что нужно сделать СЕЙЧАС

### 1. Apple Developer Account (5 минут)
- [ ] Зайдите на [developer.apple.com](https://developer.apple.com)
- [ ] Проверьте, что подписка активна ($99/год)
- [ ] Убедитесь, что есть доступ к App Store Connect

### 2. App Store Connect (10 минут)
- [ ] Войдите в [App Store Connect](https://appstoreconnect.apple.com)
- [ ] Нажмите "+" → "New App"
- [ ] Заполните:
  - **Platforms**: iOS
  - **Name**: TravelExpenses
  - **Bundle ID**: com.ifly.TravelExpenses.TravelExpenses
  - **SKU**: travel-expenses-2024
- [ ] Загрузите иконку: `metadata/app_store_connect/app_icon.png`

### 3. Codemagic (15 минут)
- [ ] Зайдите на [codemagic.io](https://codemagic.io)
- [ ] Подключите GitHub репозиторий
- [ ] Выберите проект TravelExpenses
- [ ] Настройте переменные окружения (см. ниже)

## 🔑 Переменные окружения для Codemagic

Добавьте в настройки проекта:

```bash
# Apple Developer
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

## 🚀 Первый релиз

### 1. Создайте тег
```bash
git add .
git commit -m "Ready for App Store release v1.0.0"
git tag v1.0.0
git push origin main
git push origin v1.0.0
```

### 2. Codemagic автоматически:
- ✅ Соберет приложение
- ✅ Подпишет код
- ✅ Загрузит в App Store Connect
- ✅ Отправит на проверку

### 3. В App Store Connect:
- [ ] Заполните описание (используйте `metadata/app_store_connect/description.txt`)
- [ ] Добавьте ключевые слова (используйте `metadata/app_store_connect/keywords.txt`)
- [ ] Загрузите скриншоты (минимум 3)
- [ ] Нажмите "Submit for Review"

## 📱 Скриншоты (обязательно)

Создайте скриншоты приложения:
- **iPhone**: 3-5 скриншотов (1170x2532 px)
- **iPad**: 3-5 скриншотов (2048x2732 px)

Рекомендуемые экраны:
1. Главный экран со списком расходов
2. Добавление нового расхода
3. Детали расхода
4. Список поездок
5. Статистика

## ⏱️ Временные рамки

- **Сегодня**: Настройка Apple Developer + App Store Connect
- **Завтра**: Подключение Codemagic + первая сборка
- **Через 2-3 дня**: Загрузка скриншотов + отправка на проверку
- **Через 1-7 дней**: Ответ от Apple
- **После одобрения**: Публикация в App Store

## 🆘 Если что-то не работает

### Проблемы с Apple Developer
- Проверьте статус подписки
- Убедитесь, что есть права на публикацию
- Обратитесь в поддержку Apple

### Проблемы с Codemagic
- Проверьте логи сборки
- Убедитесь, что все переменные настроены
- Проверьте сертификаты

### Проблемы с App Store Connect
- Проверьте Bundle ID
- Убедитесь, что иконка загружена
- Проверьте все обязательные поля

## 📞 Экстренная помощь

- **Apple Developer Support**: developer.apple.com/contact
- **Codemagic Support**: codemagic.io/contact
- **Документация**: docs.codemagic.io

---

**Время до публикации: ~1-2 недели** 🚀

Начните с Apple Developer Account прямо сейчас! 
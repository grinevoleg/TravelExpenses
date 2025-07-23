# 🚀 Быстрый старт с Codemagic

## ⚡ 5 минут до публикации в App Store

### 1. Подготовка (2 минуты)
```bash
# Клонируйте репозиторий
git clone https://github.com/your-username/TravelExpenses.git
cd TravelExpenses

# Создайте иконку приложения
./scripts/create_app_icon.sh

# Закоммитьте изменения
git add .
git commit -m "Add Codemagic configuration"
git push origin main
```

### 2. Настройка Codemagic (3 минуты)

1. **Перейдите на [codemagic.io](https://codemagic.io)**
2. **Подключите репозиторий**
3. **Добавьте переменные окружения:**

#### Обязательные переменные:
```
TEAM_ID = [ваш_team_id]
BUNDLE_ID = com.ifly.TravelExpenses.TravelExpenses
```

#### Для подписи (если есть):
```
BUILD_CERTIFICATE_BASE64 = [ваш_сертификат]
CERTIFICATE_PASSWORD = [пароль]
PROVISIONING_PROFILE_BASE64 = [ваш_профиль]
```

### 3. Запуск сборки
- Нажмите "Start new build"
- Выберите ветку `main`
- Дождитесь завершения (5-10 минут)

### 4. Результат
- ✅ Приложение собрано
- ✅ Загружено в TestFlight
- ✅ Готово к тестированию

## 🔧 Если что-то пошло не так

### Ошибка: "No code signing identity"
```bash
# Проверьте переменные
echo $BUILD_CERTIFICATE_BASE64
echo $CERTIFICATE_PASSWORD
```

### Ошибка: "No provisioning profile"
```bash
# Проверьте профиль
echo $PROVISIONING_PROFILE_BASE64
```

### Ошибка: "Team ID not found"
```bash
# Найдите ваш Team ID в Apple Developer Portal
# https://developer.apple.com/account/
```

## 📞 Нужна помощь?

- 📖 [Подробная инструкция](CODEMAGIC_SETUP.md)
- 🐛 [GitHub Issues](https://github.com/your-username/TravelExpenses/issues)
- 📧 Email: support@yourapp.com

---

**Удачи! Ваше приложение скоро будет в App Store! 🎉** 
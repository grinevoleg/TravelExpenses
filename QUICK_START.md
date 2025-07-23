# 🚀 Quick Start with Codemagic

## ⚡ 5 minutes to App Store publication

### 1. Preparation (2 minutes)
```bash
# Clone the repository
git clone https://github.com/your-username/TravelExpenses.git
cd TravelExpenses

# Create app icon
./scripts/create_app_icon.sh

# Commit changes
git add .
git commit -m "Add Codemagic configuration"
git push origin main
```

### 2. Codemagic Setup (3 minutes)

1. **Go to [codemagic.io](https://codemagic.io)**
2. **Connect repository**
3. **Add environment variables:**

#### Required variables:
```
TEAM_ID = [your_team_id]
BUNDLE_ID = com.ifly.TravelExpenses.TravelExpenses
```

#### For signing (if available):
```
BUILD_CERTIFICATE_BASE64 = [your_certificate]
CERTIFICATE_PASSWORD = [password]
PROVISIONING_PROFILE_BASE64 = [your_profile]
```

### 3. Start Build
- Press "Start new build"
- Select `main` branch
- Wait for completion (5-10 minutes)

### 4. Result
- ✅ App built
- ✅ Uploaded to TestFlight
- ✅ Ready for testing

## 🔧 If something went wrong

### Error: "No code signing identity"
```bash
# Check variables
echo $BUILD_CERTIFICATE_BASE64
echo $CERTIFICATE_PASSWORD
```

### Error: "No provisioning profile"
```bash
# Check profile
echo $PROVISIONING_PROFILE_BASE64
```

### Error: "Team ID not found"
```bash
# Find your Team ID in Apple Developer Portal
# https://developer.apple.com/account/
```

## 📞 Need help?

- 📖 [Detailed instructions](CODEMAGIC_SETUP.md)
- 🐛 [GitHub Issues](https://github.com/your-username/TravelExpenses/issues)
- 📧 Email: support@yourapp.com

---

**Good luck! Your app will be in App Store soon! 🎉** 
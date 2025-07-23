# Travel Expenses - Expense Tracking App for Travelers

iOS app built with Swift and SwiftUI for tracking expenses during travels.

## 🚀 Quick Start

### Local Development
```bash
# Clone the repository
git clone https://github.com/your-username/TravelExpenses.git
cd TravelExpenses

# Open in Xcode
open TravelExpenses.xcodeproj

# Run on simulator
# ⌘+R in Xcode
```

### App Store Publication
```bash
# Create app icon from your file
./scripts/create_app_icon.sh your_icon.png

# Follow instructions
open QUICK_START.md
```

## 🎨 App Icon Setup

### Quick Setup
```bash
# 1. Place your icon file in the project
cp /path/to/your/icon.png ./my_icon.png

# 2. Create all icon sizes
./scripts/create_app_icon.sh my_icon.png

# 3. Open project to verify
open TravelExpenses.xcodeproj
```

### Requirements
- **Size**: 1024x1024 pixels (recommended)
- **Format**: PNG (best quality)
- **Supported**: PNG, JPG, JPEG, SVG, TIFF
- **Design**: Square image, no transparency

### What's Created
- ✅ **App Store icon**: `metadata/app_store_connect/app_icon.png`
- ✅ **Xcode assets**: All sizes for iPhone & iPad
- ✅ **Contents.json**: Automatically generated

See [ICON_SETUP.md](ICON_SETUP.md) for detailed instructions.

## 📱 Features

### Core Features:
- ✅ Add expenses with category selection
- ✅ View all expenses list
- ✅ Group and calculate by categories
- ✅ Total sum of all expenses
- ✅ Delete expenses
- ✅ Data persistence between launches
- ✅ Create and manage trips
- ✅ Detailed trip statistics

### Expense Categories:
- 🍽️ **Food** - restaurants, cafes, groceries
- 🚗 **Transport** - taxis, buses, trains
- 🏠 **Accommodation** - hotels, hostels, rentals
- 🎮 **Entertainment** - museums, tours, activities

## 🏗️ Architecture

- **Framework**: SwiftUI
- **Pattern**: MVVM (Model-View-ViewModel)
- **Data Storage**: UserDefaults with JSON encoding
- **Minimum iOS Version**: 15.0
- **CI/CD**: Codemagic for automatic publication

## 📁 Project Structure

```
TravelExpenses/
├── TravelExpenses/
│   ├── TravelExpensesApp.swift      # Main app file
│   ├── ContentView.swift            # Main screen with tabs
│   ├── TripListView.swift           # Trips list
│   ├── AddTripView.swift            # Add trip
│   ├── TripDetailView.swift         # Trip details
│   ├── ExpenseListView.swift        # Expenses list
│   ├── AddExpenseView.swift         # Add expense
│   ├── ExpenseSummaryView.swift     # Category summary
│   ├── TripSummaryView.swift        # Trip summary
│   ├── Trip.swift                   # Trip model
│   ├── Expense.swift                # Expense model
│   ├── ExpenseCategory.swift        # Category model
│   ├── TripViewModel.swift          # Trips ViewModel
│   ├── ExpenseViewModel.swift       # Expenses ViewModel
│   └── Assets.xcassets/             # App resources
├── codemagic.yaml                   # CI/CD configuration
├── metadata/                        # App Store metadata
├── scripts/                         # Automation scripts
│   ├── create_app_icon.sh          # Icon generation
│   └── test_icon_script.sh         # Icon testing
├── CODEMAGIC_SETUP.md              # Codemagic instructions
├── QUICK_START.md                  # Quick start guide
├── ICON_SETUP.md                   # Icon setup guide
├── PRIVACY.md                      # Privacy policy
└── TravelExpenses.xcodeproj/        # Xcode project
```

## 🚀 App Store Publication

### Automatic Publication via Codemagic

1. **Preparation** (5 minutes):
   ```bash
   # Create app icon from your file
   ./scripts/create_app_icon.sh your_icon.png
   
   git add . && git commit -m "Add App Store metadata"
   git push origin main
   ```

2. **Codemagic Setup**:
   - Connect repository on [codemagic.io](https://codemagic.io)
   - Add environment variables (see `CODEMAGIC_SETUP.md`)
   - Start build

3. **Result**:
   - ✅ Automatic build on each push
   - ✅ TestFlight upload
   - ✅ Ready for App Store publication

### Manual Publication

1. Open `TravelExpenses.xcodeproj` in Xcode
2. Select "Any iOS Device" as target
3. Product → Archive
4. Organizer → Distribute App → App Store Connect

## 🎯 Usage

### Adding a Trip:
1. Go to "Trips" tab
2. Press "+" button
3. Enter trip name and dates
4. Press "Save"

### Adding an Expense:
1. Select trip on "Expenses" tab
2. Press "+" button
3. Enter amount, description and select category
4. Press "Save"

### Viewing Statistics:
1. Go to "Summary" tab
2. Select trip for detailed statistics
3. Explore breakdown by categories

## 🔧 Development

### Requirements:
- Xcode 15.0+
- iOS 15.0+
- macOS 12.0+

### Dependencies:
```bash
# Project doesn't use external dependencies
# All components written in pure SwiftUI
```

### Running Tests:
```bash
# In Xcode: ⌘+U
# Or via terminal:
xcodebuild test -project TravelExpenses.xcodeproj -scheme TravelExpenses -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 📊 Features

- **Auto-save**: All data automatically saved
- **Color coding**: Each category has its own color
- **SF Symbols icons**: Modern system icons
- **Adaptive design**: Works on iPhone and iPad
- **Localization**: Interface in English
- **Offline work**: No internet required
- **Privacy**: All data stored locally

## 🔒 Privacy

The app **does not collect** personal data:
- ✅ All data stored locally
- ✅ No data transmission to servers
- ✅ No internet required
- ✅ Detailed policy in `PRIVACY.md`

## 🚀 Possible Improvements

- [ ] Add currencies and conversion
- [ ] Export data to CSV/PDF
- [ ] Charts and diagrams
- [ ] Budget planning
- [ ] iCloud synchronization
- [ ] Multiple trips support
- [ ] Budget exceed notifications
- [ ] Bank app integration

## 📞 Support

- 🐛 [GitHub Issues](https://github.com/your-username/TravelExpenses/issues)
- 📧 Email: support@yourapp.com
- 📖 [Documentation](CODEMAGIC_SETUP.md)

## 📄 License

MIT License - see [LICENSE](LICENSE) file

---

**Created with ❤️ for travelers** ✈️🌍📱

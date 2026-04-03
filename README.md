# Burnrate - Personal Expense Tracker

A modern, minimal iOS app built with SwiftUI for fast and intuitive personal expense tracking.

## Features

### 📊 Daily Entry Screen
- **Quick entry interface**: Log expenses in under 2 seconds
- **Auto-populated date**: Defaults to today, changeable via date picker
- **Smart category selection**: Most-used categories appear first
- **Real-time summary**: Today's total instantly updates as you add entries
- **Entry management**: View, delete, and edit expenses
- **Day completion**: Mark days as complete to lock entries

### 📈 Monthly Reports
- **Total spending visualization**: Large, prominent spending totals
- **Category breakdown**: Visual bar charts showing spending by category
- **Smart insights**:
  - Most spent category with emoji
  - Suggestions to reduce top spending areas
  - Year-over-year comparison
  - Spending status (Controlled, Moderate, High)
- **Month navigation**: Easy switching between months

### 🎨 UI/UX
- Clean, minimal Apple-inspired design
- Full light and dark mode support
- Smooth animations and transitions
- Rounded cards with subtle shadows
- Responsive layout for all iOS screen sizes

## Architecture

### MVVM Pattern
- **Models**: `Expense`, `ExpenseCategory`, `DayData`
- **ViewModels**: `DailyEntryViewModel`, `ReportsViewModel`
- **Views**: `DailyEntryView`, `ReportsView`, `BurnrateApp`
- **Persistence**: `PersistenceManager` (UserDefaults)

### File Structure
```
Sources/DailyExpenseTracker/
├── Models/
│   ├── Expense.swift
│   └── DayData.swift
├── ViewModels/
│   ├── DailyEntryViewModel.swift
│   └── ReportsViewModel.swift
├── Views/
│   ├── DailyEntryView.swift
│   └── ReportsView.swift
├── Persistence/
│   └── PersistenceManager.swift
└── BurnrateApp.swift
```

## Data Models

### Expense
```swift
struct Expense: Identifiable, Codable {
    let id: UUID
    let date: Date
    let amount: Double
    let category: ExpenseCategory
    let timestamp: Date
}
```

### ExpenseCategory
12 predefined categories:
- Zepto, Zomato, Dining, Petrol, Family, SIP
- Shopping, Friends, Other, Greens, Eating Out, Rent

Each category includes:
- Emoji for visual identification
- Hex color for UI theming

### DayData
```swift
struct DayData: Identifiable, Codable {
    let id: UUID
    let date: Date
    var isCompleted: Bool
}
```

## Persistence

Uses **UserDefaults** with JSON encoding for lightweight, fast persistence:
- Expenses stored in `burnrate_expenses`
- Day completion status in `burnrate_day_data`
- Automatic sync on every change

## Getting Started

### Requirements
- iOS 15+
- Xcode 15+
- Swift 5.9

### Installation

1. **Clone/Open the project**
   ```bash
   cd /Users/arpit/Desktop/Track
   ```

2. **Open in Xcode**
   ```bash
   open -a Xcode .
   ```

3. **Build and Run**
   - Select target device/simulator
   - Press Cmd+R to build and run

### Development

The app is structured for easy expansion:

**To add a new expense category:**
1. Add case to `ExpenseCategory` enum in `Expense.swift`
2. Add emoji and color to the case
3. Category automatically available in UI

**To add reports features:**
- Extend `ReportsViewModel` with new computed properties
- Add new view components to `ReportsView`

**To modify persistence:**
- Edit `PersistenceManager` methods
- All changes auto-persist to UserDefaults

## Usage

### Adding an Expense
1. Launch app (defaults to Today tab)
2. Enter amount
3. Select category from dropdown (most-used first)
4. Tap "Done"
5. Entry appears instantly in list

### Viewing Reports
1. Tap "Reports" tab
2. Navigate months with arrow buttons
3. View:
   - Total spending
   - Spending status
   - Category breakdown
   - Smart insights

### Completing a Day
1. On Daily Entry screen
2. Add at least one expense
3. Tap "Complete Day" button
4. Day becomes read-only
5. Can reopen if needed

## Performance

- **Entry speed**: Under 2 seconds (optimized data flow)
- **Instant updates**: ReactiveSwiftUI binding
- **Efficient storage**: Lightweight JSON serialization
- **Smooth animations**: Hardware-accelerated transitions

## Customization

### Color Scheme
Modify category colors in `ExpenseCategory` enum:
```swift
case shopping = "Shopping"
var color: String { return "FF1493" } // Hex color
```

### Date Format
Edit formatters in:
- `Expense.swift`: `dateString`, `timeString`
- `ReportsViewModel.swift`: `getMonthString()`

### Insights Logic
Adjust thresholds in `ReportsViewModel`:
- `getSpendingStatus()`: Modify percentage multipliers
- `getPercentageChangeString()`: Custom comparison logic

## Future Enhancements

Potential features for expansion:
- 📱 Widgets for quick expenses
- 🔔 Budget alerts
- 📤 CSV export
- 📊 Advanced charts
- 🌍 Multi-currency
- 👥 Sharing/sync

## License

Private - Educational Project

## Contact

Built for iOS 26+ with SwiftUI and MVVM architecture.

---

**Built with Swift** | **Minimal by Design** | **Fast by Default**

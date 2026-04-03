# Burnrate - Setup Guide

## Quick Start

### Step 1: Open in Xcode
```bash
cd /Users/arpit/Desktop/Track
open -a Xcode .
```

### Step 2: Configure Project
1. Open the Xcode project navigator
2. Select the "Burnrate" scheme
3. Select an iOS 15+ simulator or device
4. Press Cmd+B to build

### Step 3: Run the App
- Press Cmd+R to run
- App launches on Today tab
- Start logging expenses!

## Project Structure

```
Track/
├── README.md                          # This file
├── SETUP.md                           # Setup instructions
├── BurnrateApp.swift                  # Main app entry point
├── Sources/
│   └── DailyExpenseTracker/
│       ├── Models/
│       │   ├── Expense.swift          # Expense data model
│       │   └── DayData.swift          # Day completion tracking
│       ├── ViewModels/
│       │   ├── DailyEntryViewModel.swift
│       │   └── ReportsViewModel.swift
│       ├── Views/
│       │   ├── DailyEntryView.swift   # Daily entry UI
│       │   └── ReportsView.swift      # Monthly reports UI
│       └── Persistence/
│           └── PersistenceManager.swift
```

## Building from Source

### Requirements
- **macOS**: 12.0+
- **Xcode**: 15.0+
- **iOS Target**: 15.0+
- **Swift**: 5.9+

### Build Steps

1. **Clone/Access Repository**
   ```bash
   cd /Users/arpit/Desktop/Track
   ```

2. **Open Xcode Project**
   ```bash
   open -a Xcode .
   ```

3. **Select Target**
   - Scheme: Burnrate
   - Device: iPhone 15 Pro (or any iOS 15+ simulator)

4. **Build**
   ```bash
   # Or use Cmd+B in Xcode
   xcodebuild -scheme Burnrate -configuration Debug
   ```

5. **Run**
   ```bash
   # Or use Cmd+R in Xcode
   xcodebuild -scheme Burnrate -configuration Debug -run
   ```

## Testing the App

### Test Flow

1. **Add Expenses**
   - Enter: 450
   - Category: Zomato
   - Tap Done
   - Entry appears immediately

2. **Add Multiple**
   - Amount: 150, Category: Petrol
   - Amount: 500, Category: Rent
   - Amount: 1200, Category: Shopping
   - Daily total updates instantly

3. **Complete Day**
   - Tap "Complete Day" button
   - Day becomes read-only
   - Can still "Reopen Day" if needed

4. **View Reports**
   - Tap "Reports" tab
   - See total spending
   - View category breakdown
   - Read smart insights

## Troubleshooting

### "Cannot find 'DailyEntryViewModel' in scope"
- Ensure all files are added to the target
- Check that Models, ViewModels, and Views are in correct folders

### "Build fails with SwiftUI errors"
- Verify iOS deployment target is 15.0 or higher
- Clean build folder: Cmd+Shift+K
- Delete derived data: ~/Library/Developer/Xcode/DerivedData

### "No data persists between launches"
- Check that `PersistenceManager` is initialized
- Verify UserDefaults is accessible
- Try deleting and reinstalling app

### "Animations feel choppy"
- Disable live preview rendering
- Build for Release: Cmd+Shift+K then Cmd+B
- Test on physical device (more reliable)

## Key Shortcuts

| Action | Shortcut |
|--------|----------|
| Build | Cmd+B |
| Run | Cmd+R |
| Clean | Cmd+Shift+K |
| Stop | Cmd+. |
| Pause | Cmd+Y |
| Resume | Cmd+Y |

## Environment Variables

No environment variables required. All configuration is done through:
- `Expense.swift`: Category definitions
- `PersistenceManager.swift`: Storage keys and logic
- `ColorHelper`: Color palette customization

## First Time Use Walkthrough

1. **Launch the app** → Today tab opens
2. **Add first expense** → Amount + Category + Done
3. **Watch total update** → Daily total refreshes
4. **Add more expenses** → List builds up
5. **Complete the day** → Button becomes available
6. **Switch to Reports** → View monthly insights
7. **Navigate months** → Use arrow buttons

## Performance Tips

1. **Fast Entry**: Use numeric keyboard for quick amount entry
2. **Category Memory**: Most-used categories prioritized
3. **Scrolling**: Smooth due to optimized view hierarchy
4. **Storage**: Automatic persistence doesn't block UI

## Customization Quick Start

### Change App Colors
Edit in `ExpenseCategory` in `Expense.swift`:
```swift
case shopping = "Shopping"
var color: String { return "FF1493" } // Change this hex code
```

### Add New Category
1. Add case to `ExpenseCategory` enum
2. Add emoji and color
3. Done! Available immediately in UI

### Modify Insights
Edit `ReportsViewModel.swift`:
- `getSpendingStatus()`: Adjust thresholds
- `getPercentageChangeString()`: Custom messages

## Support

For issues or questions:
1. Check error messages in Xcode console
2. Verify all files are in correct directories
3. Ensure iOS deployment target is 15.0+
4. Try Clean Build Folder and rebuild

---

**Ready to build?** Press Cmd+R in Xcode and start tracking!

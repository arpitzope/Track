import SwiftUI

@main
struct BurnrateApp: App {
    @StateObject private var persistenceManager = PersistenceManager.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                // Today Tab
                DailyEntryView()
                    .tabItem {
                        Label("Today", systemImage: "calendar.badge.plus")
                    }
                
                // Reports Tab
                ReportsView()
                    .tabItem {
                        Label("Reports", systemImage: "chart.bar.fill")
                    }
            }
            .preferredColorScheme(nil) // Supports both light and dark mode
        }
    }
}

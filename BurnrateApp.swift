import SwiftUI

@main
struct BurnrateApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DailyEntryView()
                    .tabItem {
                        Label("Today", systemImage: "calendar.badge.plus")
                    }
                
                ReportsView()
                    .tabItem {
                        Label("Reports", systemImage: "chart.bar.fill")
                    }
            }
            .preferredColorScheme(nil)
        }
    }
}

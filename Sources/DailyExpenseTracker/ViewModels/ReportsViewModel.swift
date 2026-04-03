import Foundation
import SwiftUI

// MARK: - Reports View Model
class ReportsViewModel: ObservableObject {
    @Published var selectedMonth: Date = Date()
    @Published var totalExpenses: Double = 0
    @Published var categoryTotals: [ExpenseCategory: Double] = [:]
    @Published var topCategories: [(category: ExpenseCategory, amount: Double)] = []
    @Published var monthlyExpenses: [Expense] = []
    @Published var percentageChange: Double = 0
    @Published var lastMonthTotal: Double = 0
    
    private let persistenceManager = PersistenceManager.shared
    
    init() {
        updateReportData()
    }
    
    // MARK: - Data Updates
    func updateReportData() {
        DispatchQueue.main.async {
            self.monthlyExpenses = self.persistenceManager.getExpenses(forMonth: self.selectedMonth)
            self.totalExpenses = self.persistenceManager.getTotalExpenses(forMonth: self.selectedMonth)
            self.categoryTotals = self.persistenceManager.getCategoryTotals(forMonth: self.selectedMonth)
            self.topCategories = self.persistenceManager.getTopCategories(forMonth: self.selectedMonth)
            self.lastMonthTotal = self.persistenceManager.getLastMonthTotal()
            self.percentageChange = self.persistenceManager.getPercentageChange()
        }
    }
    
    // MARK: - Month Navigation
    func goToPreviousMonth() {
        let calendar = Calendar.current
        selectedMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
        updateReportData()
    }
    
    func goToNextMonth() {
        let calendar = Calendar.current
        selectedMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
        updateReportData()
    }
    
    func goToCurrentMonth() {
        selectedMonth = Date()
        updateReportData()
    }
    
    // MARK: - Insights
    func getMostSpentCategory() -> ExpenseCategory? {
        return topCategories.first?.category
    }
    
    func getMostSpentAmount() -> Double {
        return topCategories.first?.amount ?? 0
    }
    
    func getLeastSpentCategory() -> ExpenseCategory? {
        return categoryTotals.min(by: { $0.value < $1.value })?.key
    }
    
    func getSpendingStatus() -> String {
        let lastMonthAvg = lastMonthTotal
        if totalExpenses < lastMonthAvg * 0.8 {
            return "😊 Controlled"
        } else if totalExpenses < lastMonthAvg * 1.2 {
            return "😐 Moderate"
        } else {
            return "😟 High"
        }
    }
    
    func getPercentageChangeString() -> String {
        if percentageChange > 0 {
            return String(format: "↑ %.0f%% more than last month", percentageChange)
        } else if percentageChange < 0 {
            return String(format: "↓ %.0f%% less than last month", abs(percentageChange))
        } else {
            return "→ Same as last month"
        }
    }
    
    func getMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }
    
    func getSortedCategoryTotals() -> [(category: ExpenseCategory, amount: Double)] {
        return categoryTotals.sorted { $0.value > $1.value }
    }
}

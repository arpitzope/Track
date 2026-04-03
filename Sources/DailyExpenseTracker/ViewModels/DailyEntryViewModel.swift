import Foundation
import SwiftUI

// MARK: - Daily Entry View Model
class DailyEntryViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var amountInput: String = ""
    @Published var selectedCategory: ExpenseCategory = .other
    @Published var todayExpenses: [Expense] = []
    @Published var dailyTotal: Double = 0
    @Published var isDayCompleted: Bool = false
    
    private let persistenceManager = PersistenceManager.shared
    private var categoryOrder: [ExpenseCategory] = []
    
    init() {
        updateDailyData()
        setupCategoryOrder()
    }
    
    // MARK: - Setup
    private func setupCategoryOrder() {
        categoryOrder = ExpenseCategory.allCases
    }
    
    // MARK: - Category Sorting
    func getSortedCategories() -> [ExpenseCategory] {
        let mostUsed = persistenceManager.getMostUsedCategories(forDate: selectedDate)
        let remaining = ExpenseCategory.allCases.filter { !mostUsed.contains($0) }
        return mostUsed + remaining
    }
    
    // MARK: - Data Updates
    func updateDailyData() {
        DispatchQueue.main.async {
            self.todayExpenses = self.persistenceManager.getExpenses(forDate: self.selectedDate)
            self.dailyTotal = self.persistenceManager.getTotalExpenses(forDate: self.selectedDate)
            self.isDayCompleted = self.persistenceManager.isDayCompleted(date: self.selectedDate)
        }
    }
    
    // MARK: - Entry Management
    func addExpense() {
        guard let amount = Double(amountInput), amount > 0 else { return }
        
        let expense = Expense(
            date: selectedDate,
            amount: amount,
            category: selectedCategory,
            timestamp: Date()
        )
        
        persistenceManager.addExpense(expense)
        updateDailyData()
        resetInput()
    }
    
    func deleteExpense(withId id: UUID) {
        persistenceManager.deleteExpense(withId: id)
        updateDailyData()
    }
    
    func resetInput() {
        amountInput = ""
        selectedCategory = .other
    }
    
    // MARK: - Day Management
    func completeDay() {
        persistenceManager.markDayAsCompleted(date: selectedDate)
        isDayCompleted = true
    }
    
    func reopenDay() {
        persistenceManager.markDayAsActive(date: selectedDate)
        isDayCompleted = false
    }
    
    // MARK: - Date Management
    func changeDate(_ newDate: Date) {
        selectedDate = newDate
        updateDailyData()
    }
}

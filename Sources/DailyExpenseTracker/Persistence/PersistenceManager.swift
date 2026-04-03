import Foundation

// MARK: - Persistence Manager
final class PersistenceManager: NSObject {
    static let shared = PersistenceManager()
    
    var expenses: [Expense] = [] {
        didSet {
            saveExpenses()
        }
    }
    
    var dayDataMap: [String: Bool] = [:] {
        didSet {
            saveDayData()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let expensesKey = "burnrate_expenses"
    private let dayDataKey = "burnrate_day_data"
    
    override init() {
        super.init()
        loadData()
    }
    
    // MARK: - Load Data
    func loadData() {
        loadExpenses()
        loadDayData()
    }
    
    private func loadExpenses() {
        if let data = userDefaults.data(forKey: expensesKey) {
            do {
                var loadedExpenses = try JSONDecoder().decode([Expense].self, from: data)
                loadedExpenses.sort { $0.timestamp > $1.timestamp } // Most recent first
                self.expenses = loadedExpenses
            } catch {
                print("Failed to decode expenses: \(error)")
                self.expenses = []
            }
        }
    }
    
    private func loadDayData() {
        if let data = userDefaults.data(forKey: dayDataKey) {
            do {
                self.dayDataMap = try JSONDecoder().decode([String: Bool].self, from: data)
            } catch {
                print("Failed to decode day data: \(error)")
                self.dayDataMap = [:]
            }
        }
    }
    
    // MARK: - Save Data
    private func saveExpenses() {
        do {
            let data = try JSONEncoder().encode(expenses)
            userDefaults.set(data, forKey: expensesKey)
            userDefaults.synchronize()
        } catch {
            print("Failed to encode expenses: \(error)")
        }
    }
    
    private func saveDayData() {
        do {
            let data = try JSONEncoder().encode(dayDataMap)
            userDefaults.set(data, forKey: dayDataKey)
            userDefaults.synchronize()
        } catch {
            print("Failed to encode day data: \(error)")
        }
    }
    
    // MARK: - Expense Operations
    func addExpense(_ expense: Expense) {
        expenses.insert(expense, at: 0) // Add to top (most recent first)
    }
    
    func deleteExpense(withId id: UUID) {
        expenses.removeAll { $0.id == id }
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }
    
    // MARK: - Day Operations
    func markDayAsCompleted(date: Date) {
        let dateKey = getDateKey(date)
        dayDataMap[dateKey] = true
    }
    
    func markDayAsActive(date: Date) {
        let dateKey = getDateKey(date)
        dayDataMap[dateKey] = false
    }
    
    func isDayCompleted(date: Date) -> Bool {
        let dateKey = getDateKey(date)
        return dayDataMap[dateKey] ?? false
    }
    
    // MARK: - Query Operations
    func getExpenses(forDate date: Date) -> [Expense] {
        let dateKey = getDateKey(date)
        return expenses.filter { getDateKey($0.date) == dateKey }
    }
    
    func getTotalExpenses(forDate date: Date) -> Double {
        return getExpenses(forDate: date).reduce(0) { $0 + $1.amount }
    }
    
    func getExpenses(forMonth month: Date) -> [Expense] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)
        
        return expenses.filter { expense in
            let expenseComponents = calendar.dateComponents([.year, .month], from: expense.date)
            return expenseComponents.year == components.year && expenseComponents.month == components.month
        }
    }
    
    func getTotalExpenses(forMonth month: Date) -> Double {
        return getExpenses(forMonth: month).reduce(0) { $0 + $1.amount }
    }
    
    func getCategoryTotals(forMonth month: Date) -> [ExpenseCategory: Double] {
        let monthExpenses = getExpenses(forMonth: month)
        var totals: [ExpenseCategory: Double] = [:]
        
        for expense in monthExpenses {
            totals[expense.category, default: 0] += expense.amount
        }
        
        return totals
    }
    
    func getTopCategories(forMonth month: Date, count: Int = 3) -> [(category: ExpenseCategory, amount: Double)] {
        let categoryTotals = getCategoryTotals(forMonth: month)
        let sorted = categoryTotals.sorted { $0.value > $1.value }
        let sliced = sorted.prefix(count)
        return sliced.map { (category: $0.key, amount: $0.value) }
    }
    
    func getMostUsedCategories(forDate date: Date, count: Int = 5) -> [ExpenseCategory] {
        let dayExpenses = getExpenses(forDate: date)
        var categoryCount: [ExpenseCategory: Int] = [:]
        
        for expense in dayExpenses {
            categoryCount[expense.category, default: 0] += 1
        }
        
        return categoryCount
            .sorted { $0.value > $1.value }
            .prefix(count)
            .map { $0.key }
    }
    
    // MARK: - Utilities
    private func getDateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getLastMonthTotal() -> Double {
        let calendar = Calendar.current
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: Date())!
        return getTotalExpenses(forMonth: lastMonth)
    }
    
    func getPercentageChange() -> Double {
        let currentMonth = getTotalExpenses(forMonth: Date())
        let lastMonth = getLastMonthTotal()
        
        guard lastMonth > 0 else { return 0 }
        return ((currentMonth - lastMonth) / lastMonth) * 100
    }
}

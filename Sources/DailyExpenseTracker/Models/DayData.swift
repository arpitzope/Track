import Foundation

// MARK: - Day Data Model
struct DayData: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    var isCompleted: Bool
    
    init(id: UUID = UUID(), date: Date, isCompleted: Bool = false) {
        self.id = id
        self.date = date
        self.isCompleted = isCompleted
    }
    
    // Get date string for comparison
    var dateKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

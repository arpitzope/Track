import Foundation

// MARK: - Category Enum
enum ExpenseCategory: String, CaseIterable, Codable, Hashable {
    case zepto = "Zepto"
    case zomato = "Zomato"
    case dining = "Dining"
    case petrol = "Petrol"
    case family = "Family"
    case sip = "SIP"
    case shopping = "Shopping"
    case friends = "Friends"
    case other = "Other"
    case greens = "Greens"
    case eatingOut = "Eating Out"
    case rent = "Rent"
    
    var emoji: String {
        switch self {
        case .zepto: return "🛒"
        case .zomato: return "🍔"
        case .dining: return "🍽️"
        case .petrol: return "⛽"
        case .family: return "👨‍👩‍👧‍👦"
        case .sip: return "💰"
        case .shopping: return "🛍️"
        case .friends: return "👯"
        case .other: return "📌"
        case .greens: return "🥗"
        case .eatingOut: return "🍜"
        case .rent: return "🏠"
        }
    }
    
    var color: String {
        switch self {
        case .zepto: return "FF6B6B"
        case .zomato: return "FF6B35"
        case .dining: return "F7B32B"
        case .petrol: return "4A90E2"
        case .family: return "7B68EE"
        case .sip: return "50C878"
        case .shopping: return "FF1493"
        case .friends: return "FFB347"
        case .other: return "A9A9A9"
        case .greens: return "3CB371"
        case .eatingOut: return "DC143C"
        case .rent: return "8B4513"
        }
    }
}

// MARK: - Expense Model
struct Expense: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let amount: Double
    let category: ExpenseCategory
    let timestamp: Date
    
    init(id: UUID = UUID(), date: Date, amount: Double, category: ExpenseCategory, timestamp: Date = Date()) {
        self.id = id
        self.date = date
        self.amount = amount
        self.category = category
        self.timestamp = timestamp
    }
    
    // Get time string for display
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    // Get date string for display
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

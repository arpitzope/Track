import SwiftUI

// MARK: - Color Helper
struct ColorHelper {
    static func hex(_ hexString: String) -> Color {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespaces)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double((rgb) & 0xFF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
}

// MARK: - Reports View
struct ReportsView: View {
    @StateObject var viewModel = ReportsViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("Monthly Report")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Month Navigation
                    HStack {
                        Button(action: viewModel.goToPreviousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        
                        Text(viewModel.getMonthString())
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                        
                        Button(action: viewModel.goToNextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        
                        Spacer(minLength: 8)
                        
                        Button(action: viewModel.goToCurrentMonth) {
                            Text("Today")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }
                    }
                }
                .padding(16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Total Spending Card
                        VStack(spacing: 8) {
                            Text("Total Spending")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            
                            Text("₹\(String(format: "%.2f", viewModel.totalExpenses))")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text(viewModel.getPercentageChangeString())
                                .font(.caption)
                                .foregroundColor(viewModel.percentageChange > 0 ? .red : .green)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        // Spending Status
                        HStack {
                            Text(viewModel.getSpendingStatus())
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        // Category Breakdown
                        VStack(alignment: .leading, spacing: 12) {
                            Text("By Category")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            if viewModel.getSortedCategoryTotals().isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "chart.bar")
                                        .font(.system(size: 24))
                                        .foregroundColor(.secondary)
                                    
                                    Text("No data for this month")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(32)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(viewModel.getSortedCategoryTotals(), id: \.category) { item in
                                        CategoryBarRow(
                                            category: item.category,
                                            amount: item.amount,
                                            total: viewModel.totalExpenses
                                        )
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        // Top 3 Categories Insights
                        if !viewModel.topCategories.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Insights")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    // Most spent
                                    if let topCategory = viewModel.getMostSpentCategory() {
                                        HStack(spacing: 8) {
                                            Text(topCategory.emoji)
                                                .font(.system(size: 18))
                                            
                                            Text("Most spent on: \(topCategory.rawValue)")
                                                .font(.callout)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Text("₹\(String(format: \"%.2f\", viewModel.getMostSpentAmount()))")
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                                .foregroundColor(ColorHelper.hex(topCategory.color))
                                        }
                                        .padding(12)
                                        .background(ColorHelper.hex(topCategory.color).opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                    
                                    // Try reducing top spending category
                                    if let topCategory = viewModel.getMostSpentCategory() {
                                        HStack(spacing: 8) {
                                            Image(systemName: "lightbulb")
                                                .font(.system(size: 16))
                                                .foregroundColor(.orange)
                                            
                                            Text("Try reducing \(topCategory.rawValue)")
                                                .font(.callout)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(Color.orange.opacity(0.1))
                                        .cornerRadius(10)
                                    }
                                    
                                    // Good control insight
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle")
                                            .font(.system(size: 16))
                                            .foregroundColor(.green)
                                        
                                        Text("Good expense tracking!")
                                            .font(.callout)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(16)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

// MARK: - Category Bar Row
struct CategoryBarRow: View {
    let category: ExpenseCategory
    let amount: Double
    let total: Double
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return (amount / total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                HStack(spacing: 8) {
                    Text(category.emoji)
                        .font(.system(size: 16))
                    
                    Text(category.rawValue)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("₹\(String(format: "%.2f", amount))")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(String(format: "%.0f%%", percentage))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.tertiarySystemBackground))
                    
                    Capsule()
                        .fill(ColorHelper.hex(category.color))
                        .frame(width: geometry.size.width * percentage / 100)
                }
            }
            .frame(height: 6)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ReportsView()
}

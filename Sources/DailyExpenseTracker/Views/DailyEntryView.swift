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

// MARK: - Daily Entry View
struct DailyEntryView: View {
    @StateObject var viewModel = DailyEntryViewModel()
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case amount
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with date and title
                VStack(spacing: 12) {
                    Text("Burnrate")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                        
                        DatePicker(
                            "Select Date",
                            selection: $viewModel.selectedDate,
                            displayedComponents: .date
                        )
                        .onChange(of: viewModel.selectedDate) { newDate in
                            viewModel.changeDate(newDate)
                        }
                        .labelsHidden()
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding(16)
                .background(Color(.systemBackground))
                
                // Daily Total Card
                VStack(spacing: 8) {
                    Text("Today's Total")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    Text("₹\(String(format: "%.2f", viewModel.dailyTotal))")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(16)
                
                if viewModel.isDayCompleted {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                            
                            Text("Day Completed")
                                .font(.callout)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Button(action: viewModel.reopenDay) {
                            Text("Reopen Day")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color(.tertiarySystemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(16)
                } else {
                    VStack(spacing: 12) {
                        HStack {
                            Text("₹")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            TextField("0.00", text: $viewModel.amountInput)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 18, weight: .semibold, design: .default))
                                .focused($focusedField, equals: .amount)
                        }
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Category")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Menu {
                                ForEach(viewModel.getSortedCategories(), id: \.self) { category in
                                    Button(action: { viewModel.selectedCategory = category }) {
                                        HStack {
                                            Text(category.emoji)
                                            Text(category.rawValue)
                                        }
                                    }
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Text(viewModel.selectedCategory.emoji)
                                        .font(.system(size: 18))
                                    
                                    Text(viewModel.selectedCategory.rawValue)
                                        .font(.callout)
                                        .foregroundColor(.primary)
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        
                        Button(action: viewModel.addExpense) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Done")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(16)
                }
                
                ScrollView {
                    VStack(spacing: 8) {
                        if viewModel.todayExpenses.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "doc.text")
                                    .font(.system(size: 24))
                                    .foregroundColor(.secondary)
                                
                                Text("No expenses yet")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(32)
                        } else {
                            ForEach(viewModel.todayExpenses) { expense in
                                ExpenseCard(expense: expense) {
                                    viewModel.deleteExpense(withId: expense.id)
                                }
                                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                            }
                        }
                    }
                    .padding(16)
                }
                
                if !viewModel.isDayCompleted && !viewModel.todayExpenses.isEmpty {
                    Button(action: viewModel.completeDay) {
                        Text("Complete Day")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(16)
                }
            }
        }
        .onAppear {
            focusedField = .amount
        }
    }
}

// MARK: - Expense Card Component
struct ExpenseCard: View {
    let expense: Expense
    let onDelete: () -> Void
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack(spacing: 12) {
            VStack {
                Text(expense.category.emoji)
                    .font(.system(size: 24))
            }
            .frame(width: 50, height: 50)
            .background(ColorHelper.hex(expense.category.color).opacity(0.15))
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.category.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(expense.timeString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("₹\(String(format: "%.2f", expense.amount))")
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(ColorHelper.hex(expense.category.color))
            
            Button(action: { showDeleteConfirmation = true }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .font(.system(size: 18))
            }
            .confirmationDialog("Delete Expense?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        onDelete()
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}


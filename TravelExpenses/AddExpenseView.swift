//
//  AddExpenseView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @Environment(\.dismiss) private var dismiss

    
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: ExpenseCategory = .food
    @State private var date: Date = Date()
    
    var body: some View {
        ZStack {
            // Main background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Beautiful gradient header
                GradientHeaderView(
                    title: "New Expense",
                    colors: [.green, .orange]
                )
                
                // Main content
                ScrollView {
                    VStack(spacing: 24) {
                        // Beautiful header icon
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .orange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .shadow(color: .green.opacity(0.3), radius: 15, x: 0, y: 8)
                                
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Add a new expense")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, -10)
                        
                        // Input form
                        VStack(spacing: 20) {
                            // Amount
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Expense Amount", systemImage: "dollarsign.circle")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    TextField("0", text: $amount)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .font(.body)
                                    
                                    Text("$")
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 8)
                                }
                            }
                            
                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Description", systemImage: "text.cursor")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("e.g., Lunch at cafe", text: $description)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                            }
                            
                            // Date
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Expense Date", systemImage: "calendar")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                                    .datePickerStyle(.compact)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                        )
                        
                        // Category selection
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Category", systemImage: "tag")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(ExpenseCategory.allCases) { category in
                                    CategoryCard(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        onTap: {
                                            selectedCategory = category
                                        }
                                    )
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                        )
                        
                        // Buttons
                        VStack(spacing: 12) {
                            // Save button
                            Button {
                                saveExpense()
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                    Text("Save Expense")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: isValidInput ? [.green, .orange] : [.gray.opacity(0.6), .gray.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: isValidInput ? .green.opacity(0.4) : .clear, radius: 15, x: 0, y: 8)
                            }
                            .disabled(!isValidInput)
                            
                            // Cancel button
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(UIColor.secondarySystemBackground))
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, -30)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var isValidInput: Bool {
        !amount.isEmpty && !description.isEmpty && Double(amount) != nil
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        
        let newExpense = Expense(
            amount: amountValue,
            description: description,
            category: selectedCategory,
            date: date
        )
        
        expenseViewModel.addExpense(newExpense)
        dismiss()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: ExpenseCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            isSelected 
                            ? LinearGradient(colors: [.green, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [category.color.opacity(0.2), category.color.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 50, height: 50)
                    
                    Text(category.icon)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : category.color)
                }
                
                // Name
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected 
                        ? category.color.opacity(0.1)
                        : Color(UIColor.secondarySystemBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? category.color : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddExpenseView()
        .environmentObject(ExpenseViewModel())
}

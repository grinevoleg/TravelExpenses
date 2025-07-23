//
//  ExpenseListView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct ExpenseListView: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel

    @State private var showingAddExpense = false
    
    var body: some View {
        ZStack {
            // Main background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Beautiful gradient header
                GradientHeaderView(
                    title: "My Expenses",
                    colors: [.green, .orange]
                )
                
                // Main content
                if expenseViewModel.expenses.isEmpty {
                    VStack(spacing: 24) {
                        // Beautiful animated icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.green, Color.orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: .green.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            Image(systemName: "list.bullet.clipboard")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 12) {
                            Text("No expenses yet")
                                .font(.title)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green, .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Add your first expense\nand start tracking spending")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        
                        // Beautiful button
                        Button {
                            showingAddExpense = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Add Expense")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.green, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: .green.opacity(0.4), radius: 15, x: 0, y: 8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Total amount
                            VStack(spacing: 12) {
                                Text("Total Expenses")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text("$\(Int(expenseViewModel.totalAmount))")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.green, .orange],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("\(expenseViewModel.expenses.count) expense\(expenseViewModel.expenses.count == 1 ? "" : "s")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(UIColor.systemBackground))
                                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                            )
                            .padding(.horizontal, 16)
                            .padding(.top, -30)
                            
                            // Expenses list
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("All Expenses")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                
                                LazyVStack(spacing: 8) {
                                    ForEach(expenseViewModel.expenses.sorted(by: { $0.date > $1.date })) { expense in
                                        ExpenseRowView(expense: expense)
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                            .padding(.bottom, 100) // Spacing for floating button
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(alignment: .bottomTrailing) {
            // Beautiful floating button
            Button {
                showingAddExpense = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: [.green, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: .green.opacity(0.4), radius: 15, x: 0, y: 8)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView()
                .environmentObject(expenseViewModel)
        }
    }
}

// MARK: - Expense Row View
struct ExpenseRowView: View {
    let expense: Expense
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, HH:mm"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: expense.category.icon)
                    .font(.title3)
                    .foregroundColor(expense.category.color)
            }
            
            // Expense information
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(expense.category.rawValue)
                        .font(.caption)
                        .foregroundColor(expense.category.color)
                    
                    Spacer()
                    
                    Text(expense.date, formatter: dateFormatter)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Amount
            Text("$\(Int(expense.amount))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    ExpenseListView()
        .environmentObject(ExpenseViewModel())
}

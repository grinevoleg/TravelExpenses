//
//  ExpenseSummaryView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct ExpenseSummaryView: View {
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        ZStack {
            // Main background
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Beautiful gradient header
                GradientHeaderView(
                    title: "Expense Summary",
                    colors: [Color.orange, Color.red]
                )
                
                // Main content
                if expenseViewModel.expenses.isEmpty {
                    VStack(spacing: 24) {
                        // Beautiful animated icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange, Color.red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: .orange.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            Image(systemName: "chart.pie")
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 12) {
                            Text("No data for summary")
                                .font(.title)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.orange, Color.red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Add expenses to trips\nto see statistics")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
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
                                            colors: [Color.orange, Color.red],
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
                            
                            // Summary by category
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("By Category")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(ExpenseCategory.allCases) { category in
                                        let amount = expenseViewModel.totalForCategory(category)
                                        let percentage = expenseViewModel.totalAmount > 0 ? (amount / expenseViewModel.totalAmount) * 100 : 0
                                        
                                        VStack(spacing: 12) {
                                            // Icon and name
                                            HStack {
                                                Text(category.icon)
                                                    .font(.title2)
                                                Text(category.rawValue)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                Spacer()
                                            }
                                            
                                            // Amount and percentage
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Text("$\(Int(amount))")
                                                        .font(.title3)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.primary)
                                                    Spacer()
                                                    if amount > 0 {
                                                        Text("\(percentage, specifier: "%.1f")%")
                                                            .font(.caption)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                                
                                                if amount > 0 {
                                                    // Progress bar
                                                    ProgressView(value: percentage, total: 100)
                                                        .progressViewStyle(LinearProgressViewStyle(tint: category.color))
                                                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                                                }
                                            }
                                        }
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(amount > 0 ? category.color.opacity(0.1) : Color(UIColor.secondarySystemBackground))
                                        )
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ExpenseSummaryView()
        .environmentObject(ExpenseViewModel())
}

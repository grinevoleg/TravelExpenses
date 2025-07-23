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
            // Основной фон
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Красивый градиентный заголовок
                GradientHeaderView(
                    title: "Сводка расходов",
                    colors: [.orange, .red]
                )
                
                // Основной контент
                if expenseViewModel.expenses.isEmpty {
                    VStack(spacing: 24) {
                        // Красивая иконка с анимацией
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
                            Text("Нет данных для сводки")
                                .font(.title)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Добавьте расходы в поездки\nчтобы увидеть статистику")
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
                            // Общая сумма
                            VStack(spacing: 12) {
                                Text("Общие расходы")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(Int(expenseViewModel.totalAmount)) ₽")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.orange, .red],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("\(expenseViewModel.expenses.count) расход\(expenseViewModel.expenses.count == 1 ? "" : expenseViewModel.expenses.count < 5 ? "а" : "ов")")
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
                            
                            // Сводка по категориям
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("По категориям")
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
                                            // Иконка и название
                                            HStack {
                                                Text(category.icon)
                                                    .font(.title2)
                                                                                                 Text(category.rawValue)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                Spacer()
                                            }
                                            
                                            // Сумма и процент
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Text("\(Int(amount)) ₽")
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
                                                    // Прогресс бар
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

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
            // Основной фон
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Красивый градиентный заголовок
                GradientHeaderView(
                    title: "Мои расходы",
                    colors: [.green, .orange]
                )
                
                // Основной контент
                if expenseViewModel.expenses.isEmpty {
                    VStack(spacing: 24) {
                        // Красивая иконка с анимацией
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
                            Text("Расходов пока нет")
                                .font(.title)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green, .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Добавьте первый расход\nи начните отслеживать траты")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        
                        // Красивая кнопка
                        Button {
                            showingAddExpense = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Добавить расход")
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
                                            colors: [.green, .orange],
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
                            
                            // Список расходов
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Все расходы")
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
                            .padding(.bottom, 100) // Отступ для плавающей кнопки
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(alignment: .bottomTrailing) {
            // Красивая плавающая кнопка
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
            // Иконка категории
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: expense.category.icon)
                    .font(.title3)
                    .foregroundColor(expense.category.color)
            }
            
            // Информация о расходе
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
            
            // Сумма
            Text("\(Int(expense.amount)) ₽")
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

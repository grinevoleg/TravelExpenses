//
//  ExpenseViewModel.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import Foundation
import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    
    init() {
        // Загружаем сохраненные данные или используем примеры
        loadExpenses()
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        expenses.remove(atOffsets: indexSet)
        saveExpenses()
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        saveExpenses()
    }
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    func totalForCategory(_ category: ExpenseCategory) -> Double {
        expenses.filter { $0.category == category }
                .reduce(0) { $0 + $1.amount }
    }
    
    func expensesForCategory(_ category: ExpenseCategory) -> [Expense] {
        expenses.filter { $0.category == category }
    }
    
    private func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: "SavedExpenses")
        }
    }
    
    func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: "SavedExpenses"),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        } else {
            // Если нет сохраненных данных, используем примеры
            expenses = Expense.sampleData
        }
    }
}

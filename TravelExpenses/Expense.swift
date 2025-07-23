//
//  Expense.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import Foundation

struct Expense: Identifiable, Codable, Equatable {
    let id: UUID
    var amount: Double
    var description: String
    var category: ExpenseCategory
    var date: Date
    
    init(amount: Double, description: String, category: ExpenseCategory, date: Date = Date()) {
        self.id = UUID()
        self.amount = amount
        self.description = description
        self.category = category
        self.date = date
    }
}

extension Expense {
    static let sampleData: [Expense] = [
        Expense(amount: 1500, description: "Обед в ресторане", category: .food),
        Expense(amount: 800, description: "Такси до отеля", category: .transport),
        Expense(amount: 5000, description: "Отель на 2 ночи", category: .accommodation),
        Expense(amount: 2000, description: "Билеты в музей", category: .entertainment)
    ]
}

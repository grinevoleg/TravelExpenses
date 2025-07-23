//
//  Trip.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import Foundation

struct Trip: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var budget: Double
    var expenses: [Expense]
    var isCompleted: Bool
    
    init(name: String, destination: String, startDate: Date, endDate: Date, budget: Double = 0, expenses: [Expense] = [], isCompleted: Bool = false) {
        self.id = UUID()
        self.name = name
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.budget = budget
        self.expenses = expenses
        self.isCompleted = isCompleted
    }
    
    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    // Псевдоним для совместимости с существующим кодом
    var totalExpenses: Double {
        totalAmount
    }
    
    var expensesByCategory: [ExpenseCategory: Double] {
        Dictionary(grouping: expenses, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate && !isCompleted
    }
    
    // Остаток бюджета
    var remainingBudget: Double {
        budget - totalExpenses
    }
    
    // Процент использованного бюджета
    var budgetUsagePercentage: Double {
        guard budget > 0 else { return 0 }
        let percentage = (totalExpenses / budget) * 100
        return percentage.isNaN || percentage.isInfinite ? 0 : min(percentage, 100)
    }
}

extension Trip {
    static let sampleData: [Trip] = []
}

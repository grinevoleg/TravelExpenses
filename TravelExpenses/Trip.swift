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
    static let sampleData: [Trip] = [
        Trip(name: "Отпуск в Сочи", destination: "Сочи, Россия", 
             startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
             endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
             budget: 50000,
             expenses: [
                Expense(amount: 1500, description: "Обед в ресторане", category: .food, date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()),
                Expense(amount: 800, description: "Такси до отеля", category: .transport, date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()),
                Expense(amount: 5000, description: "Отель на 2 ночи", category: .accommodation, date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()),
                Expense(amount: 2000, description: "Билеты в музей", category: .entertainment, date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date())
             ],
             isCompleted: false), // Активная поездка
        Trip(name: "Выходные в Питере", destination: "Санкт-Петербург, Россия",
             startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
             endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
             budget: 25000,
             expenses: [
                Expense(amount: 3000, description: "Билеты на поезд", category: .transport, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
                Expense(amount: 8000, description: "Отель", category: .accommodation, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date())
             ],
             isCompleted: false), // Еще одна активная поездка
        Trip(name: "Командировка в Москву", destination: "Москва, Россия",
             startDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
             endDate: Calendar.current.date(byAdding: .day, value: 35, to: Date()) ?? Date(),
             budget: 30000,
             expenses: [],
             isCompleted: false), // Будущая поездка
        Trip(name: "Орфограмма", destination: "Три",
             startDate: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
             endDate: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(),
             budget: 10000,
             expenses: [
                Expense(amount: 7889, description: "Проживание", category: .accommodation, date: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date())
             ],
             isCompleted: true) // Завершенная поездка
    ]
}

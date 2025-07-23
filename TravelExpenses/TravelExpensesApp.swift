//
//  TravelExpensesApp.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

@main
struct TravelExpensesApp: App {
    @StateObject private var expenseViewModel = ExpenseViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(expenseViewModel)
        }
    }
}

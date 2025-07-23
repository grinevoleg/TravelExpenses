//
//  AddExpenseToTripView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct AddExpenseToTripView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var tripViewModel: TripViewModel
    let tripId: UUID
    
    @State private var description = ""
    @State private var amount = ""
    @State private var category: ExpenseCategory = .food
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Информация о расходе")) {
                    TextField("Описание", text: $description)
                    
                    HStack {
                        Text("Сумма")
                        Spacer()
                        TextField("0", text: $amount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("₽")
                    }
                    
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Категория")) {
                    Picker("Категория", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundColor(category.color)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .navigationTitle("Новый расход")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveExpense()
                    }
                    .disabled(description.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) else {
            return
        }
        
        let newExpense = Expense(
            amount: amountValue,
            description: description,
            category: category,
            date: date
        )
        
        tripViewModel.addExpenseToTrip(newExpense, tripId: tripId)
        dismiss()
    }
}

#Preview {
    AddExpenseToTripView(tripViewModel: TripViewModel(), tripId: UUID())
}

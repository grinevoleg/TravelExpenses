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
                Section(header: Text("Expense Information")) {
                    TextField("Description", text: $description)
                    
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("0", text: $amount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("$")
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $category) {
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
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
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

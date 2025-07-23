//
//  TripDetailView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @ObservedObject var tripViewModel: TripViewModel

    @State private var showingAddExpense = false
    @State private var showingDeleteAlert = false
    @State private var showingCompleteAlert = false
    @Environment(\.dismiss) var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            // Main background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Beautiful gradient header
                GradientHeaderView(
                    title: trip.name,
                    colors: [.blue, .purple]
                )
                
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        // Trip information
                        tripInfoCard
                        
                        // Budget information
                        if trip.budget > 0 {
                            budgetCard
                        }
                        
                        // Expenses by category
                        if !trip.expensesByCategory.isEmpty {
                            categoriesCard
                        }
                        
                        // Expenses list
                        expensesCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100) // Spacing for floating button
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .alert("Complete trip?", isPresented: $showingCompleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Complete", role: .destructive) {
                tripViewModel.completeTrip(trip)
                dismiss()
            }
        } message: {
            Text("The trip will be marked as completed.")
        }
        .alert("Delete trip?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                tripViewModel.deleteTrip(trip)
                dismiss()
            }
        } message: {
            Text("The trip and all its expenses will be permanently deleted.")
        }
        .overlay(alignment: .bottomTrailing) {
            // Beautiful floating add expense button
            Button {
                showingAddExpense = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.title3)
                        
                    Text("Expense")
                        
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .blue.opacity(0.4), radius: 15, x: 0, y: 8)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseToTripView(tripViewModel: tripViewModel, tripId: trip.id)
        }
        .onAppear {
            tripViewModel.selectTrip(trip)
        }
    }
    
    // MARK: - Trip Info Card
    private var tripInfoCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Destination")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        Text(trip.destination)
                            .font(.headline)
                    }
                }
                
                Spacer()
                
                // Trip status
                statusBadge
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(trip.startDate, formatter: dateFormatter)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("End")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(trip.endDate, formatter: dateFormatter)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    private var statusBadge: some View {
        let status = tripStatus
        return Text(status.text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: status.colors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
    }
    
    private var tripStatus: (text: String, colors: [Color]) {
        if trip.isCompleted {
            return ("Completed", [.gray, .gray.opacity(0.6)])
        } else if trip.startDate > Date() {
            return ("Planned", [.orange, .yellow])
        } else if trip.endDate < Date() {
            return ("Past", [.red, .pink])
        } else {
            return ("Active", [.green, .blue])
        }
    }

    // MARK: - Budget Card
    private var budgetCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Budget")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Planned")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("$\(Int(trip.budget))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Text("Spent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("$\(Int(trip.totalAmount))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("$\(Int(trip.remainingBudget))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(trip.remainingBudget >= 0 ? .green : .red)
                }
            }
            
            // Progress bar
            ProgressView(value: min(trip.budgetUsagePercentage, 100), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: trip.budgetUsagePercentage > 100 ? .red : .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    // MARK: - Categories Card
    private var categoriesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Array(trip.expensesByCategory.keys), id: \.self) { category in
                    let amount = trip.expensesByCategory[category] ?? 0
                    
                    VStack(spacing: 12) {
                        // Icon and category name
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(category.color.opacity(0.2))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: category.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(category.color)
                            }
                            
                            Text(category.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        // Amount
                        HStack {
                            Text("$\(Int(amount))")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: category.color.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    // MARK: - Expenses Card
    private var expensesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Expenses")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !trip.expenses.isEmpty {
                    Text("\(trip.expenses.count) expense\(trip.expenses.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if trip.expenses.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.6))
                    
                    Text("No expenses yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Tap the \"+\" button to add your first expense")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(30)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(trip.expenses.sorted(by: { $0.date > $1.date })) { expense in
                        EnhancedExpenseRowView(expense: expense)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
}

// MARK: - Enhanced Expense Row View
struct EnhancedExpenseRowView: View {
    let expense: Expense
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, HH:mm"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            ZStack {
                Circle()
                    .fill(expense.category.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: expense.category.icon)
                    .font(.title3)
                    .foregroundColor(expense.category.color)
            }
            
            // Expense information
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
            
            // Amount
            Text("$\(Int(expense.amount))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        TripDetailView(trip: Trip.sampleData[0], tripViewModel: TripViewModel())
    }
}

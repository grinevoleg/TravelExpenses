//
//  TripSummaryView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct TripSummaryView: View {
    let trip: Trip
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        // Main content without duplicating header and background
        VStack(spacing: 20) {
            // Trip information
            tripOverviewSection
            
            if !trip.expensesByCategory.isEmpty {
                categoryChartSection
            }
            
            if !trip.expenses.isEmpty {
                dailyExpensesSection
            }
            
            statisticsSection
        }
        .padding(.top, 20)
        .padding(.bottom, 40)
    }
    
    // MARK: - Trip Overview Section
    private var tripOverviewSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(trip.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.orange)
                        Text(trip.destination)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("\(trip.startDate, formatter: dateFormatter) - \(trip.endDate, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Total amount
                VStack(spacing: 8) {
                    Text("$\(Int(trip.totalAmount))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Total Expenses")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
    
    // MARK: - Category Chart Section
    private var categoryChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expenses by Category")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Array(trip.expensesByCategory.keys.sorted(by: { trip.expensesByCategory[$0] ?? 0 > trip.expensesByCategory[$1] ?? 0 })), id: \.self) { category in
                    let amount = trip.expensesByCategory[category] ?? 0
                    let percentage = trip.totalAmount > 0 ? (amount / trip.totalAmount) * 100 : 0
                    
                    VStack(spacing: 12) {
                        // Icon and name
                        HStack {
                            Image(systemName: category.icon)
                                .font(.title2)
                                .foregroundColor(category.color)
                            Text(category.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        
                        // Amount and percentage
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("$\(Int(amount))")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(percentage, specifier: "%.1f")%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Progress bar
                            ProgressView(value: percentage, total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: category.color))
                                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(category.color.opacity(0.1))
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
    
    // MARK: - Daily Expenses Section
    private var dailyExpensesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Expenses")
                .font(.headline)
                .foregroundColor(.primary)
            
            let dailyExpenses = Dictionary(grouping: trip.expenses, by: { Calendar.current.startOfDay(for: $0.date) })
                .mapValues { expenses in expenses.reduce(0) { $0 + $1.amount } }
                .sorted { $0.key > $1.key }
            
            if dailyExpenses.isEmpty {
                Text("No expense data")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(dailyExpenses.prefix(7), id: \.key) { date, amount in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(date, formatter: DateFormatter.dayAndMonth)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(date, formatter: DateFormatter.weekday)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("$\(Int(amount))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.secondarySystemBackground))
                        )
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
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(.primary)
            
            let daysCount = max(1, Calendar.current.dateComponents([.day], from: trip.startDate, to: min(trip.endDate, Date())).day ?? 1)
            let averagePerDay = trip.totalAmount / Double(daysCount)
            
            VStack(spacing: 12) {
                StatisticRow(
                    title: "Number of Expenses",
                    value: "\(trip.expenses.count)",
                    icon: "list.number",
                    color: .blue
                )
                
                StatisticRow(
                    title: "Average Expense",
                    value: trip.expenses.isEmpty ? "$0" : "$\(Int(trip.totalAmount / Double(trip.expenses.count)))",
                    icon: "chart.bar",
                    color: .green
                )
                
                StatisticRow(
                    title: "Average per Day",
                    value: "$\(Int(averagePerDay))",
                    icon: "calendar.day.timeline.leading",
                    color: .orange
                )
                
                if trip.budget > 0 {
                    StatisticRow(
                        title: "Budget Used",
                        value: "\(Int(trip.budgetUsagePercentage))%",
                        icon: "percent",
                        color: trip.budgetUsagePercentage > 100 ? .red : .purple
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
}

// MARK: - Statistic Row
struct StatisticRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - DateFormatter Extensions
extension DateFormatter {
    static let dayAndMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    static let weekday: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
}

#Preview {
    TripSummaryView(trip: Trip.sampleData[0])
}

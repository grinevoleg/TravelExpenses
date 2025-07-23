//
//  ContentView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tripViewModel = TripViewModel()
    @StateObject private var expenseViewModel = ExpenseViewModel()
    @State private var selectedTab = 1
    @State private var selectedSummaryTripId: UUID? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TripListView(tripViewModel: tripViewModel)
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Поездки")
                }
                .tag(0)
            
            ExpenseView()
                .environmentObject(tripViewModel)
                .environmentObject(expenseViewModel)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Расходы")
                }
                .tag(1)
            
            TripSummaryWrapperView(selectedSummaryTripId: $selectedSummaryTripId)
                .environmentObject(tripViewModel)
                .environmentObject(expenseViewModel)
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Сводка")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .onAppear {
            tripViewModel.loadTrips()
        }
    }
}

struct ExpenseView: View {
    @EnvironmentObject var tripViewModel: TripViewModel
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    @State private var showingAddExpense = false
    @State private var showingAddExpenseToTrip = false
    
    var body: some View {
        ZStack {
            // Основной фон
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Красивый градиентный заголовок
                GradientHeaderView(
                    title: "Расходы",
                    colors: [.green, .blue]
                )
                
                // Основной контент
                ScrollView {
                    VStack(spacing: 20) {
                        // Выбор поездки для расходов
                        VStack(spacing: 8) {
                            Text("Выберите поездку для расходов")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if tripViewModel.trips.isEmpty {
                                VStack(spacing: 15) {
                                    Image(systemName: "airplane.departure")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                    Text("Нет поездок")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    Text("Создайте первую поездку на вкладке 'Поездки'")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .top, spacing: 16) {
                                        ForEach(tripViewModel.trips) { trip in
                                            TripSelectorCard(
                                                trip: trip,
                                                isSelected: tripViewModel.selectedTripId == trip.id,
                                                onTap: {
                                                    tripViewModel.selectedTripId = trip.id
                                                }
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(UIColor.systemBackground))
                                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                                    )
                                }
                            }
                        }
                        .padding(.top, 0)
                        
                        // Секция деталей поездки и расходов
                        if let selectedTrip = tripViewModel.selectedTrip {
                            VStack(spacing: 20) {
                                // Детали поездки
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text(selectedTrip.name)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Button(action: {
                                            showingAddExpenseToTrip = true
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.blue)
                                        Text("\(selectedTrip.startDate, formatter: DateFormatter.shortDate) - \(selectedTrip.endDate, formatter: DateFormatter.shortDate)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    HStack {
                                        Image(systemName: "location")
                                            .foregroundColor(.blue)
                                        Text(selectedTrip.destination)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(20)
                                .background(Color(.systemBackground))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                
                                // Список расходов
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text("Расходы")
                                            .font(.headline)
                                        Spacer()
                                        if !tripExpenses.isEmpty {
                                            Text("Всего: \(totalAmount, specifier: "%.2f") ₽")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    
                                    if tripExpenses.isEmpty {
                                        VStack(spacing: 15) {
                                            Image(systemName: "creditcard")
                                                .font(.system(size: 40))
                                                .foregroundColor(.gray)
                                            Text("Нет расходов")
                                                .font(.title3)
                                                .foregroundColor(.gray)
                                            Text("Добавьте первый расход для этой поездки")
                                                .font(.body)
                                                .foregroundColor(.secondary)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 30)
                                    } else {
                                        LazyVStack(spacing: 12) {
                                            ForEach(tripExpenses) { expense in
                                                EnhancedExpenseRowView(expense: expense)
                                                    .environmentObject(expenseViewModel)
                                            }
                                        }
                                    }
                                }
                                .padding(20)
                                .background(Color(.systemBackground))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        // Отступ снизу
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddExpenseToTrip) {
            if let selectedTrip = tripViewModel.selectedTrip {
                AddExpenseToTripView(tripViewModel: tripViewModel, tripId: selectedTrip.id)
                    .environmentObject(expenseViewModel)
            }
        }
        .onAppear {
            expenseViewModel.loadExpenses()
            if tripViewModel.selectedTripId == nil && !tripViewModel.trips.isEmpty {
                tripViewModel.selectedTripId = tripViewModel.trips.first?.id
            }
        }
    }
    
    private var tripExpenses: [Expense] {
        return tripViewModel.selectedTrip?.expenses ?? []
    }
    
    private var totalAmount: Double {
        tripExpenses.reduce(0) { $0 + $1.amount }
    }
}



// MARK: - Trip Selector Card with fixed alignment
struct TripSelectorCard: View {
    let trip: Trip
    let isSelected: Bool
    let onTap: () -> Void
    
    private var tripType: TripType {
        if trip.isCompleted {
            return .completed
        } else if trip.isActive {
            return .active
        } else if trip.startDate > Date() {
            return .upcoming
        } else {
            return .past
        }
    }
    
    private enum TripType {
        case active, upcoming, past, completed
        
        var iconName: String {
            switch self {
            case .active: return "airplane.departure"
            case .upcoming: return "calendar.badge.clock"
            case .past: return "clock.arrow.circlepath"
            case .completed: return "checkmark.seal.fill"
            }
        }
        
        var gradientColors: [Color] {
            switch self {
            case .active: return [.green, .blue]
            case .upcoming: return [.orange, .yellow]
            case .past: return [.red, .pink]
            case .completed: return [.gray, .gray.opacity(0.6)]
            }
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .center, spacing: 8) {
                // Иконка поездки
                ZStack {
                    Circle()
                        .fill(
                            isSelected 
                            ? LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: tripType.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 40, height: 40) // Уменьшаем размер иконки
                    
                    Image(systemName: tripType.iconName)
                        .font(.title3) // Уменьшаем размер иконки
                        .foregroundColor(.white)
                }
                
                // Название поездки - одна строка с обрезанием
                Text(trip.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .primary : .secondary)
                    .lineLimit(1) // Только одна строка
                    .truncationMode(.tail) // Обрезание в конце
                    .multilineTextAlignment(.center)
                    .frame(width: 100, height: 20, alignment: .center) // Уменьшаем высоту и центрируем
                
                // Количество расходов - всегда в одном месте
                Group {
                    if !trip.expenses.isEmpty {
                        Text("\(trip.expenses.count)")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color.blue : Color.gray)
                            )
                    } else {
                        // Пустое место чтобы все карточки были одинаковой высоты
                        Text(" ")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .opacity(0)
                    }
                }
            }
            .frame(width: 120, height: 100) // Увеличиваем высоту карточки
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Trip Summary Wrapper View
struct TripSummaryWrapperView: View {
    @EnvironmentObject var tripViewModel: TripViewModel
    @Binding var selectedSummaryTripId: UUID?
    
    var selectedSummaryTrip: Trip? {
        tripViewModel.trips.first { $0.id == selectedSummaryTripId }
    }
    
    var body: some View {
        ZStack {
            // Основной фон теперь серый
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Красивый градиентный заголовок
                GradientHeaderView(
                    title: "Сводка",
                    colors: [.purple, .blue]
                )
                Divider().opacity(0.06)
                
                // Основной контент
                if tripViewModel.trips.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "chart.pie")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("Нет поездок")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("Создайте поездку на вкладке \"Поездки\"")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Выбор поездки для сводки
                            VStack(spacing: 8) {
                                Text("Выберите поездку для сводки")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .top, spacing: 16) {
                                        ForEach(tripViewModel.trips) { trip in
                                            TripSelectorCard(
                                                trip: trip,
                                                isSelected: selectedSummaryTripId == trip.id,
                                                onTap: {
                                                    selectedSummaryTripId = trip.id
                                                }
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(UIColor.systemBackground))
                                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                                    )
                                }
                            }
                            .padding(.top, 0)
                            
                            // Сводка выбранной поездки
                            if let selectedTrip = selectedSummaryTrip {
                                TripSummaryView(trip: selectedTrip)
                                    .padding(.horizontal, 15)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            // Устанавливаем первую поездку при первом появлении
            if selectedSummaryTripId == nil && !tripViewModel.trips.isEmpty {
                selectedSummaryTripId = tripViewModel.trips.first?.id
            }
        }
        .onChange(of: tripViewModel.trips) { _ in
            // Обновляем выбранную поездку при изменении списка поездок
            if selectedSummaryTripId == nil || !tripViewModel.trips.contains(where: { $0.id == selectedSummaryTripId }) {
                selectedSummaryTripId = tripViewModel.trips.first?.id
            }
        }
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    ContentView()
}

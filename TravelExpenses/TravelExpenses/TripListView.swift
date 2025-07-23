import SwiftUI

// MARK: - Gradient Header View
struct GradientHeaderView: View {
    let title: String
    let colors: [Color]
    
    var body: some View {
        VStack(spacing: 0) {
            // Градиентный фон
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 120)
            .overlay(
                // Заголовок
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
            )
        }
    }
}

struct TripListView: View {
    @ObservedObject var tripViewModel: TripViewModel
    @State private var isAddTripPresented = false
    
    var body: some View {
        ZStack {
            // Основной фон
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Красивый градиентный заголовок
                    GradientHeaderView(
                        title: "Мои Поездки",
                        colors: [.blue, .purple]
                    )
                    
                    // Основной контент
                    if tripViewModel.trips.isEmpty {
                        VStack(spacing: 24) {
                            // Красивая иконка с анимацией
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.blue, Color.purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                                
                                Image(systemName: "airplane.departure")
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Добро пожаловать!")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Создайте свою первую поездку\nи начните отслеживать расходы")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            
                            // Красивая кнопка
                            Button {
                                isAddTripPresented = true
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                    Text("Создать поездку")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: .blue.opacity(0.4), radius: 12, x: 0, y: 6)
                            }
                            .scaleEffect(1.0)
                            .animation(.easeInOut(duration: 0.2), value: isAddTripPresented)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                // Активные поездки
                                if !tripViewModel.activeTrips.isEmpty {
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            HStack(spacing: 8) {
                                                Image(systemName: "star.fill")
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.blue, .purple],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                Text("АКТИВНЫЕ ПОЕЗДКИ")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.blue, .purple],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                        
                                        LazyVStack(spacing: 12) {
                                            ForEach(tripViewModel.activeTrips) { trip in
                                                NavigationLink(destination: TripDetailView(trip: trip, tripViewModel: tripViewModel)) {
                                                    EnhancedTripRowView(trip: trip, isActive: true)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .background(Color(.systemBackground))
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .padding(.horizontal, 15)
                                    .padding(.top, 10)
                                }
                                
                                // Запланированные поездки
                                if !tripViewModel.upcomingTrips.isEmpty {
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            HStack(spacing: 8) {
                                                Image(systemName: "calendar.badge.clock")
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.orange, .yellow],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                Text("ЗАПЛАНИРОВАННЫЕ ПОЕЗДКИ")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.orange, .yellow],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                        
                                        LazyVStack(spacing: 12) {
                                            ForEach(tripViewModel.upcomingTrips) { trip in
                                                NavigationLink(destination: TripDetailView(trip: trip, tripViewModel: tripViewModel)) {
                                                    EnhancedTripRowView(trip: trip, isActive: false)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .background(Color(.systemBackground))
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .padding(.horizontal, 15)
                                }
                                
                                // Прошедшие поездки
                                if !tripViewModel.pastTrips.isEmpty {
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            HStack(spacing: 8) {
                                                Image(systemName: "clock.arrow.circlepath")
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.red, .pink],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                Text("ПРОШЕДШИЕ ПОЕЗДКИ")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.red, .pink],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                        
                                        LazyVStack(spacing: 12) {
                                            ForEach(tripViewModel.pastTrips) { trip in
                                                NavigationLink(destination: TripDetailView(trip: trip, tripViewModel: tripViewModel)) {
                                                    EnhancedTripRowView(trip: trip, isActive: false)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .background(Color(.systemBackground))
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .padding(.horizontal, 15)
                                }
                                
                                // Завершенные поездки
                                if !tripViewModel.completedTrips.isEmpty {
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            HStack(spacing: 8) {
                                                Image(systemName: "checkmark.seal.fill")
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.green, .mint],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                Text("ЗАВЕРШЕННЫЕ ПОЕЗДКИ")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.green, .mint],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.top, 20)
                                        
                                        LazyVStack(spacing: 12) {
                                            ForEach(tripViewModel.completedTrips) { trip in
                                                NavigationLink(destination: TripDetailView(trip: trip, tripViewModel: tripViewModel)) {
                                                    EnhancedTripRowView(trip: trip, isActive: false)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .background(Color(.systemBackground))
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .padding(.horizontal, 15)
                                }
                            }
                            .padding(.bottom, 120)
                        }
                        
                        // Плавающая кнопка добавления
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    isAddTripPresented = true
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .frame(width: 56, height: 56)
                                        .background(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .clipShape(Circle())
                                        .shadow(color: .blue.opacity(0.4), radius: 12, x: 0, y: 6)
                                }
                                .padding(.trailing, 20)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isAddTripPresented) {
            AddTripView(tripViewModel: tripViewModel)
        }
        .onAppear {
            tripViewModel.loadTrips()
        }
    }
}

// MARK: - Trip Row Views

// Красивая карточка поездки
struct EnhancedTripRowView: View {
    let trip: Trip
    let isActive: Bool
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }
    
    // Определяем тип поездки
    private var tripType: TripType {
        if trip.isCompleted {
            return .completed
        } else if trip.startDate > Date() {
            return .upcoming
        } else if trip.endDate < Date() {
            return .past
        } else {
            return .active
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
        
        var statusText: String {
            switch self {
            case .active: return "АКТИВНА"
            case .upcoming: return "ЗАПЛАНИРОВАНА"
            case .past: return "ПРОШЕДШАЯ"
            case .completed: return "ЗАВЕРШЕНА"
            }
        }
        
        var statusColor: Color {
            switch self {
            case .active: return .green
            case .upcoming: return .orange
            case .past: return .red
            case .completed: return .gray
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                // Иконка и статус
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: tripType.gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: tripType.iconName)
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Text(tripType.statusText)
                        .font(.caption2)
                        .foregroundColor(tripType.statusColor)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    // Название поездки
                    Text(trip.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    // Место назначения с иконкой
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(trip.destination)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    // Даты
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("\(trip.startDate, formatter: dateFormatter) - \(trip.endDate, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Сумма и валюта
                VStack(alignment: .trailing, spacing: 4) {
                    if !trip.expenses.isEmpty {
                        Text("\(trip.totalExpenses, specifier: "%.0f")₽")
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("\(trip.expenses.count) расход" + (trip.expenses.count == 1 ? "" : trip.expenses.count < 5 ? "а" : "ов"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }
}

#Preview {
    TripListView(tripViewModel: TripViewModel())
} 
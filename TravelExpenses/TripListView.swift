import SwiftUI

// MARK: - Gradient Header View
struct GradientHeaderView: View {
    let title: String
    let colors: [Color]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)
            
            Text(title)
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
        }
        .frame(height: 120)
        .padding(.bottom, 10)
    }
}

struct TripListView: View {
    @ObservedObject var tripViewModel: TripViewModel

    @State private var isAddTripPresented = false
    @State private var selectedTrip: Trip?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                Color(.systemBackground)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        GradientHeaderView(
                            title: "My Trips",
                            colors: [.blue, .purple]
                        )
                        
                        Spacer()
                        

                    }
                if tripViewModel.trips.isEmpty {
                    // ... previous welcome screen ...
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue, .purple],
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
                            Text("Welcome!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Text("Create your first trip\nand start tracking expenses")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        Button {
                            isAddTripPresented = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Create Trip")
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
                    // --- Fixed ScrollView ---
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            if !tripViewModel.activeTrips.isEmpty {
                                SectionCard(
                                    icon: "star.fill",
                                    iconGradient: [.blue, .purple],
                                    title: "ACTIVE TRIPS",
                                    titleGradient: [.blue, .purple],
                                    trips: tripViewModel.activeTrips,
                                    cardGradient: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)],
                                    tripViewModel: tripViewModel,
                                    onTripSelected: { trip in
                                        selectedTrip = trip
                                    }
                                )
                            }
                            if !tripViewModel.upcomingTrips.isEmpty {
                                SectionCard(
                                    icon: "calendar.badge.clock",
                                    iconGradient: [.orange, .yellow],
                                    title: "UPCOMING TRIPS",
                                    titleGradient: [.orange, .yellow],
                                    trips: tripViewModel.upcomingTrips,
                                    cardGradient: [Color.orange.opacity(0.05), Color.yellow.opacity(0.05)],
                                    tripViewModel: tripViewModel,
                                    onTripSelected: { trip in
                                        selectedTrip = trip
                                    }
                                )
                            }
                            if !tripViewModel.pastTrips.isEmpty {
                                SectionCard(
                                    icon: "clock.arrow.circlepath",
                                    iconGradient: [.red, .pink],
                                    title: "PAST TRIPS",
                                    titleGradient: [.red, .pink],
                                    trips: tripViewModel.pastTrips,
                                    cardGradient: [Color.red.opacity(0.05), Color.pink.opacity(0.05)],
                                    tripViewModel: tripViewModel,
                                    onTripSelected: { trip in
                                        selectedTrip = trip
                                    }
                                )
                            }
                            if !tripViewModel.completedTrips.isEmpty {
                                SectionCard(
                                    icon: "checkmark.seal.fill",
                                    iconGradient: [.green, .mint],
                                    title: "COMPLETED TRIPS",
                                    titleGradient: [.green, .mint],
                                    trips: tripViewModel.completedTrips,
                                    cardGradient: [Color.green.opacity(0.05), Color.mint.opacity(0.05)],
                                    tripViewModel: tripViewModel,
                                    onTripSelected: { trip in
                                        selectedTrip = trip
                                    }
                                )
                            }
                            Spacer(minLength: 32)
                        }
                        .padding(.top, 0)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 32) // so it doesn't overlap with the button
                    }
                }
            }
            // --- Floating button ---
            if !tripViewModel.trips.isEmpty {
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
                .padding(.trailing, 24)
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $isAddTripPresented) {
            AddTripView(tripViewModel: tripViewModel)
        }
        .background(
            NavigationLink(
                destination: selectedTrip != nil ? TripDetailView(trip: selectedTrip!, tripViewModel: tripViewModel) : nil,
                isActive: Binding(
                    get: { selectedTrip != nil },
                    set: { if !$0 { selectedTrip = nil } }
                )
            ) {
                EmptyView()
            }
            .opacity(0)
            .allowsHitTesting(false)
        )
        .onAppear {
            tripViewModel.loadTrips()
        }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// --- Enhanced section component ---
struct SectionCard: View {
    let icon: String
    let iconGradient: [Color]
    let title: String
    let titleGradient: [Color]
    let trips: [Trip]
    let cardGradient: [Color]
    let tripViewModel: TripViewModel
    let onTripSelected: (Trip) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header with enhanced design
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: iconGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .shadow(color: iconGradient[0].opacity(0.3), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: titleGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Trip list with enhanced design
            VStack(alignment: .leading, spacing: 12) {
                ForEach(trips) { trip in
                    TripCard(
                        trip: trip, 
                        gradientColors: iconGradient, 
                        tripViewModel: tripViewModel,
                        onTap: {
                            onTripSelected(trip)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: cardGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: titleGradient.map { $0.opacity(0.1) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(
            color: titleGradient[0].opacity(0.08),
            radius: 16,
            x: 0,
            y: 8
        )
        .padding(.horizontal, 8)
        .animation(.easeInOut(duration: 0.3), value: trips.count)
    }
}

// --- New trip card component ---
struct TripCard: View {
    let trip: Trip
    let gradientColors: [Color]
    @State private var isPressed = false
    @ObservedObject var tripViewModel: TripViewModel
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Trip icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: gradientColors.map { $0.opacity(0.1) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: "airplane")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            // Trip information
            VStack(alignment: .leading, spacing: 4) {
                Text(trip.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) - \(trip.endDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status indicator
            Circle()
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 8, height: 8)
                .shadow(color: gradientColors[0].opacity(0.3), radius: 2, x: 0, y: 1)
            
            // Action button
            Menu {
                if !trip.isCompleted {
                    Button(action: {
                        tripViewModel.completeTrip(trip)
                    }) {
                        Label("Mark as Completed", systemImage: "checkmark.circle")
                    }
                } else {
                    Button(action: {
                        tripViewModel.reopenTrip(trip)
                    }) {
                        Label("Reopen Trip", systemImage: "arrow.clockwise.circle")
                    }
                }
                
                Button(role: .destructive, action: {
                    tripViewModel.deleteTrip(trip)
                }) {
                    Label("Delete Trip", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(gradientColors[0].opacity(0.1))
                    )
            }
            .onTapGesture {
                // Предотвращаем срабатывание onTapGesture карточки
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            onTap()
        }

    }
}

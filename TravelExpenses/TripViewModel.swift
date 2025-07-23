//
//  TripViewModel.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import Foundation
import SwiftUI

class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var selectedTrip: Trip?
    
    private let userDefaults = UserDefaults.standard
    private let tripsKey = "SavedTrips"
    
    // Добавляем computed property для совместимости
    var selectedTripId: UUID? {
        get { selectedTrip?.id }
        set { 
            if let id = newValue {
                selectedTrip = trips.first { $0.id == id }
            } else {
                selectedTrip = nil
            }
        }
    }
    
    init() {
        loadTrips()
        // Устанавливаем активную поездку как выбранную по умолчанию
        selectedTrip = trips.first { $0.isActive } ?? trips.first
    }
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
        // Автоматически выбираем новую поездку
        selectedTrip = trip
        saveTrips()
    }
    
    func deleteTrip(at indexSet: IndexSet) {
        trips.remove(atOffsets: indexSet)
        if let selectedTrip = selectedTrip,
           !trips.contains(where: { $0.id == selectedTrip.id }) {
            self.selectedTrip = trips.first
        }
        saveTrips()
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.id == trip.id }
        if let selectedTrip = selectedTrip,
           selectedTrip.id == trip.id {
            self.selectedTrip = trips.first
        }
        saveTrips()
    }
    
    func addExpenseToTrip(_ expense: Expense, tripId: UUID) {
        if let index = trips.firstIndex(where: { $0.id == tripId }) {
            trips[index].expenses.append(expense)
            
            // Обновляем selectedTrip если это та же поездка
            if selectedTrip?.id == tripId {
                selectedTrip = trips[index]
            }
            
            saveTrips()
        }
    }
    
    func deleteExpenseFromTrip(at indexSet: IndexSet, tripId: UUID) {
        if let tripIndex = trips.firstIndex(where: { $0.id == tripId }) {
            trips[tripIndex].expenses.remove(atOffsets: indexSet)
            saveTrips()
        }
    }
    
    func selectTrip(_ trip: Trip) {
        selectedTrip = trip
    }
    
    func completeTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index].isCompleted = true
            
            // Обновляем selectedTrip если это та же поездка
            if selectedTrip?.id == trip.id {
                selectedTrip = trips[index]
            }
            
            saveTrips()
        }
    }
    
    func reopenTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index].isCompleted = false
            
            // Обновляем selectedTrip если это та же поездка
            if selectedTrip?.id == trip.id {
                selectedTrip = trips[index]
            }
            
            saveTrips()
        }
    }
    
    var activeTrips: [Trip] {
        trips.filter { $0.isActive }
    }
    
    var upcomingTrips: [Trip] {
        trips.filter { $0.startDate > Date() && !$0.isCompleted }
    }
    
    var pastTrips: [Trip] {
        trips.filter { $0.endDate < Date() && !$0.isCompleted }
    }
    
    var completedTrips: [Trip] {
        trips.filter { $0.isCompleted }
    }
    
    private func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            userDefaults.set(encoded, forKey: tripsKey)
        }
    }
    
    func loadTrips() {
        if let data = userDefaults.data(forKey: tripsKey),
           let decoded = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = decoded
        } else {
            // Если нет сохраненных данных, используем примеры с уже настроенными расходами
            trips = Trip.sampleData
        }
    }
}

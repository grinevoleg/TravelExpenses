//
//  AddTripView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct AddTripView: View {
    @ObservedObject var tripViewModel: TripViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var tripName = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var budget: Double = 0
    @State private var isCreating = false
    
    var body: some View {
        ZStack {
            // Основной фон
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Красивый градиентный заголовок
                GradientHeaderView(
                    title: "Новая поездка",
                    colors: [.blue, .purple]
                )
                
                // Основной контент
                ScrollView {
                    VStack(spacing: 24) {
                        headerIconSection
                        formSection
                        buttonsSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, -30)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    // MARK: - UI Components
    
    private var headerIconSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                
                Image(systemName: "airplane.departure")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text("Создайте новую поездку")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, -10)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            // Название поездки
            InputField(
                icon: "text.cursor",
                title: "Название поездки",
                placeholder: "Например: Отпуск в Сочи",
                text: $tripName
            )
            
            // Направление
            InputField(
                icon: "paperplane.fill",
                title: "Направление",
                placeholder: "Например: Сочи, Россия",
                text: $destination
            )
            
            // Даты
            datesSection
            
            // Бюджет
            budgetSection
        }
        .padding(20)
        .background(formBackground)
    }
    
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("Даты поездки")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 16) {
                DateField(
                    title: "Начало",
                    date: $startDate,
                    range: nil
                )
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
                
                DateField(
                    title: "Конец",
                    date: $endDate,
                    range: startDate...Date.distantFuture
                )
            }
        }
    }
    
    private var budgetSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "rublesign.circle.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("Бюджет (необязательно)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack {
                TextField("0", value: $budget, format: .number)
                    .textFieldStyle(ModernTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .font(.body)
                
                Text("₽")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
            }
            
            Text("Укажите планируемый бюджет для отслеживания расходов")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private var formBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: [Color.blue.opacity(0.02), Color.purple.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    
    private var buttonsSection: some View {
        VStack(spacing: 12) {
            // Кнопка создания
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCreating = true
                }
                createTrip()
            } label: {
                HStack {
                    if isCreating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    Text(isCreating ? "Создание..." : "Создать поездку")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(createButtonGradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: canCreateTrip ? .blue.opacity(0.4) : .clear, radius: 15, x: 0, y: 8)
                .scaleEffect(isCreating ? 0.98 : 1.0)
            }
            .disabled(!canCreateTrip || isCreating)
            
            // Кнопка отмены
            Button {
                dismiss()
            } label: {
                Text("Отмена")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
            }
            .disabled(isCreating)
        }
        .padding(.horizontal, 20)
    }
    
    private var createButtonGradient: LinearGradient {
        LinearGradient(
            colors: canCreateTrip ? [.blue, .purple] : [.gray.opacity(0.6), .gray.opacity(0.4)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Computed Properties
    
    private var canCreateTrip: Bool {
        !tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        startDate <= endDate
    }
    
    // MARK: - Methods
    
    private func createTrip() {
        let newTrip = Trip(
            name: tripName.trimmingCharacters(in: .whitespacesAndNewlines),
            destination: destination.trimmingCharacters(in: .whitespacesAndNewlines),
            startDate: startDate,
            endDate: endDate,
            budget: budget
        )
        
        tripViewModel.addTrip(newTrip)
        dismiss()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Вспомогательные компоненты

struct InputField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            TextField(placeholder, text: $text)
                .textFieldStyle(ModernTextFieldStyle())
                .font(.body)
        }
    }
}

struct DateField: View {
    let title: String
    @Binding var date: Date
    let range: ClosedRange<Date>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let range = range {
                DatePicker("", selection: $date, in: range, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
            } else {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
            }
        }
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    AddTripView(tripViewModel: TripViewModel())
}

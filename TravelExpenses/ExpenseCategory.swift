//
//  ExpenseCategory.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import Foundation
import SwiftUI

enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case food = "Еда"
    case transport = "Транспорт"
    case accommodation = "Жилье"
    case entertainment = "Развлечения"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .food:
            return "fork.knife"
        case .transport:
            return "car.fill"
        case .accommodation:
            return "house.fill"
        case .entertainment:
            return "gamecontroller.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food:
            return .orange
        case .transport:
            return .blue
        case .accommodation:
            return .green
        case .entertainment:
            return .purple
        }
    }
}

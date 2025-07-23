//
//  ThemeManager.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    static let shared = ThemeManager()
    
    private init() {
        // Initialize with system appearance
        isDarkMode = UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
}

// MARK: - Color Scheme
struct AppColors {
    static let shared = AppColors()
    
    // MARK: - Background Colors
    var background: Color {
        ThemeManager.shared.isDarkMode ? Color.black : Color.white
    }
    
    var secondaryBackground: Color {
        ThemeManager.shared.isDarkMode ? Color(.systemGray6) : Color(.systemGray6)
    }
    
    var cardBackground: Color {
        ThemeManager.shared.isDarkMode ? Color(.systemGray5) : Color.white
    }
    
    // MARK: - Text Colors
    var primaryText: Color {
        ThemeManager.shared.isDarkMode ? Color.white : Color.black
    }
    
    var secondaryText: Color {
        ThemeManager.shared.isDarkMode ? Color(.systemGray2) : Color(.systemGray)
    }
    
    var tertiaryText: Color {
        ThemeManager.shared.isDarkMode ? Color(.systemGray3) : Color(.systemGray2)
    }
    
    // MARK: - Accent Colors
    var primaryAccent: Color {
        ThemeManager.shared.isDarkMode ? Color.blue : Color.blue
    }
    
    var secondaryAccent: Color {
        ThemeManager.shared.isDarkMode ? Color.green : Color.green
    }
    
    var successColor: Color {
        ThemeManager.shared.isDarkMode ? Color.green : Color.green
    }
    
    var warningColor: Color {
        ThemeManager.shared.isDarkMode ? Color.orange : Color.orange
    }
    
    var errorColor: Color {
        ThemeManager.shared.isDarkMode ? Color.red : Color.red
    }
    
    // MARK: - Gradient Colors
    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [
                ThemeManager.shared.isDarkMode ? Color.blue.opacity(0.8) : Color.blue,
                ThemeManager.shared.isDarkMode ? Color.purple.opacity(0.8) : Color.purple
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var secondaryGradient: LinearGradient {
        LinearGradient(
            colors: [
                ThemeManager.shared.isDarkMode ? Color.green.opacity(0.8) : Color.green,
                ThemeManager.shared.isDarkMode ? Color.blue.opacity(0.8) : Color.blue
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var successGradient: LinearGradient {
        LinearGradient(
            colors: [
                ThemeManager.shared.isDarkMode ? Color.green.opacity(0.8) : Color.green,
                ThemeManager.shared.isDarkMode ? Color.mint.opacity(0.8) : Color.mint
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Shadow Colors
    var shadowColor: Color {
        ThemeManager.shared.isDarkMode ? Color.black.opacity(0.3) : Color.black.opacity(0.1)
    }
    
    // MARK: - Border Colors
    var borderColor: Color {
        ThemeManager.shared.isDarkMode ? Color(.systemGray4) : Color(.systemGray4)
    }
    
    var separatorColor: Color {
        ThemeManager.shared.isDarkMode ? Color(.systemGray5) : Color(.systemGray5)
    }
}

// MARK: - Theme Extensions
extension Color {
    static let appBackground = AppColors.shared.background
    static let appSecondaryBackground = AppColors.shared.secondaryBackground
    static let appCardBackground = AppColors.shared.cardBackground
    static let appPrimaryText = AppColors.shared.primaryText
    static let appSecondaryText = AppColors.shared.secondaryText
    static let appTertiaryText = AppColors.shared.tertiaryText
    static let appPrimaryAccent = AppColors.shared.primaryAccent
    static let appSecondaryAccent = AppColors.shared.secondaryAccent
    static let appSuccess = AppColors.shared.successColor
    static let appWarning = AppColors.shared.warningColor
    static let appError = AppColors.shared.errorColor
    static let appShadow = AppColors.shared.shadowColor
    static let appBorder = AppColors.shared.borderColor
    static let appSeparator = AppColors.shared.separatorColor
}

// MARK: - Theme Modifiers
struct ThemeModifier: ViewModifier {
    @ObservedObject var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
            .background(Color.appBackground)
            .foregroundColor(Color.appPrimaryText)
    }
}

extension View {
    func withTheme() -> some View {
        self.modifier(ThemeModifier())
    }
} 
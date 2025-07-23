//
//  ThemeToggleView.swift
//  TravelExpenses
//
//  Created on 11.07.2025.
//

import SwiftUI

struct ThemeToggleView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                themeManager.toggleTheme()
                isAnimating.toggle()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(themeManager.isDarkMode ? .yellow : .orange)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.easeInOut(duration: 0.6), value: isAnimating)
                
                Text(themeManager.isDarkMode ? "Dark" : "Light")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.appPrimaryText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.appCardBackground)
                    .shadow(color: Color.appShadow, radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.appBorder, lineWidth: 0.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ThemeToggleButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                themeManager.toggleTheme()
                isAnimating.toggle()
            }
        }) {
            Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(themeManager.isDarkMode ? .yellow : .orange)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.appCardBackground)
                        .shadow(color: Color.appShadow, radius: 4, x: 0, y: 2)
                )
                .overlay(
                    Circle()
                        .stroke(Color.appBorder, lineWidth: 0.5)
                )
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.easeInOut(duration: 0.6), value: isAnimating)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        ThemeToggleView()
        ThemeToggleButton()
    }
    .padding()
    .background(Color.appBackground)
    .environmentObject(ThemeManager.shared)
} 
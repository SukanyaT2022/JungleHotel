//
//  ContentView.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI

enum AppTab: String, CaseIterable {
    case home = "Home"
    case booking = "Booking"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .booking:
            return "suitcase"
        case .profile:
            return "person"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    MainScreenView()
                case .booking:
                    BookingBottomView()
                case .profile:
                    ProfileView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 88)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
       
}

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(selectedTab == tab ? Colors.primary : Colors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(selectedTab == tab ? Colors.primary.opacity(0.12) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}

#Preview {
    ContentView()
}

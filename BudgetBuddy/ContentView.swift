//
//  ContentView.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 2/24/26.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        TabView {
            Dashboard()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
            SubscriptionsList()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Subscriptions")
                }
        }
    }
}

#Preview {
    ContentView()
}

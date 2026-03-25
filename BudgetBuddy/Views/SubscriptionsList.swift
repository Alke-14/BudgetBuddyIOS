//
//  Saving Goals.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 3/24/26.
//

import SwiftUI

struct Subscriptions: Identifiable, Codable, Equatable {
    var id = UUID();
    let title: String;
    let amount: Double;
}

@Observable
class SubList {
    var goalItems = [Subscriptions]() {
        didSet {
            if let encodedG = try? JSONEncoder().encode(goalItems) {
                UserDefaults.standard.set(encodedG, forKey: "Subscriptions")
            }
        }
    }
    init() {
        if let savedGoals = UserDefaults.standard.data(forKey: "Subscriptions") {
            if let decodedGoals = try? JSONDecoder().decode([Subscriptions].self,from: savedGoals) { goalItems = decodedGoals
                return
            }
        }
        goalItems = []
    }
}

struct SubscriptionsList: View {
    @State private var goals = SubList()
    @State private var showingAddGoal = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                SubscriptionChartView(subs: goals.goalItems)
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(goals.goalItems) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(item.title)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Text(item.amount, format: .currency(code: "USD"))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteItem(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("BudgetBuddy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add Subscriptions", systemImage: "plus") {
                    showingAddGoal = true
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddSub(subs: goals)
            }
        }
    }
    
    func deleteItem(_ item: Subscriptions) {
        if let index = goals.goalItems.firstIndex(where: { $0.id == item.id }) {
            goals.goalItems.remove(at: index)
        }
    }
}


#Preview {
    SubscriptionsList()
}

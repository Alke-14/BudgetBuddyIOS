//
//  Dashboard.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 3/24/26.
//

import SwiftUI
import Foundation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID();
    let name: String;
    let type: String;
    let amount: Double;
    let date: Date;
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self,from: savedItems) { items = decodedItems
                return
            }
        }
        items = []
    }
}



struct Dashboard: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var selectedDate = Date()
    @State private var chartMode: ChartMode = .day // New state for toggle
    
    enum ChartMode {
        case day, week
    }

    // Filtered items for the specific selected day (for the List and Pie Chart)
    var dailyExpenses: [ExpenseItem] {
        expenses.items.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    // Filtered items for the entire week containing the selected date
    var weeklyExpenses: [ExpenseItem] {
        let calendar = Calendar.current
        guard let weekRange = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else { return [] }
        return expenses.items.filter { weekRange.contains($0.date) }
    }

    var body: some View {
        VStack {
            NavigationStack {
                List {
                    Picker("View Mode", selection: $chartMode) {
                        Text("Daily Pie").tag(ChartMode.day)
                        Text("Weekly Bars").tag(ChartMode.week)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if chartMode == .day {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .frame(maxHeight: 350)
                        
                        ExpenseChart(items: dailyExpenses, mode: .pie)
                            .frame(height: 250)
                    } else {
                        // Show the weekly bar chart
                        ExpenseChart(items: weeklyExpenses, mode: .bar)
                            .frame(height: 350)
                            .padding(.top)
                    }
                    // List shows daily items for clarity
                    ForEach(dailyExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name).font(.headline)
                                Text(item.type).font(.subheadline).foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: "USD"))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                .navigationTitle("BudgetBuddy")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddExpense = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    NavigationStack {
                        AddView(expenses: expenses, initialDate: selectedDate)
                    }
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = dailyExpenses[index]
            if let mainIndex = expenses.items.firstIndex(where: { $0.id == itemToDelete.id }) {
                expenses.items.remove(at: mainIndex)
            }
        }
    }
}
#Preview {
    Dashboard()
}

//
//  AddView.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 3/18/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var date = Date()
    
    var expenses: Expenses
    var initialDate: Date?
    let types = ["Transportation", "Housing", "Personal", "Food", "Fun for Aisha", "Miscellaneous", "Medical Expense"]
    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Section("Date") {
                DatePicker("Date of Expense", selection: $date, displayedComponents: .date)
            }
        }
        .navigationTitle("Add Expense")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let initialDate {
                date = initialDate
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
                .foregroundStyle(.red)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount, date: date)
                    expenses.items.append(item)
                    dismiss()
                }
                .disabled(name.isEmpty || amount == 0)
            }
        }
    }
}
#Preview {
    NavigationStack {
        AddView(expenses: Expenses())
    }
}

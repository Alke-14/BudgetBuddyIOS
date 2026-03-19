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
    
    var expenses: Expenses
    
    let types = ["Transportation", "Housing", "Personal", "Other", "Food"]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD")).keyboardType(.decimalPad)
            }
            .navigationTitle(Text("Add Expense"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .foregroundStyle(Color(.red))
                }
                ToolbarItem {
                    Button("Save") {
                        let item = ExpenseItem(name:name, type:type, amount: amount)
                        expenses.items.append(item)
                        dismiss()
                    }
                    .foregroundStyle(Color(.blue))
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}

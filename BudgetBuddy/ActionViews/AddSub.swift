//
//  AddSub.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 3/24/26.
//

import SwiftUI

struct AddSub: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var amount = 0.0
    
    var subs: SubList
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Service", text: $title)
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD")).keyboardType(.decimalPad)
            }
            .navigationTitle(Text("Add Subscription"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .foregroundStyle(Color(.red))
                }
                ToolbarItem {
                    Button("Save") {
                        let item = Subscriptions(title: title, amount: amount)
                        subs.goalItems.append(item)
                        dismiss()
                    }
                    .foregroundStyle(Color(.blue))
                }
            }
        }
    }
}

#Preview {
    AddSub(subs: SubList())
}

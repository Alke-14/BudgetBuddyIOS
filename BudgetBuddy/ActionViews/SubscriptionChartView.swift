//
//  SubscriptionChartView.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 3/24/26.
//


import SwiftUI
import Charts

struct SubscriptionChartView: View {
    var subs: [Subscriptions]
    
    // Calculate total monthly cost
    var totalCost: Double {
        subs.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack {
            Chart(subs) { item in
                SectorMark(
                    angle: .value("Amount", item.amount),
                    innerRadius: .ratio(0.6),
                    angularInset: 2.0
                )
                .foregroundStyle(by: .value("Name", item.title))
                .cornerRadius(5)
            }
            .frame(height: 200)
            .chartBackground { chartProxy in
                VStack {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(totalCost, format: .currency(code: "USD"))
                        .font(.headline)
                        .bold()
                }
            }
            
            Text("Monthly Breakdown")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 5)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

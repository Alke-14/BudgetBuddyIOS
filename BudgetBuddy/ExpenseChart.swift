//
//  ExpenseChart.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 3/18/26.
//

import SwiftUI
import Charts

struct ExpenseChart: View {
    var expenses: Expenses
    
    var groupedExpenses: [(type: String, total: Double)] {
        let grouped = Dictionary(grouping: expenses.items, by: { $0.type})
        return grouped.map { (type,items) in (type: type, total: items.reduce(0) { $0 + $1.amount})
        }
        .sorted { $0.total > $1.total}
    }
    

    var body: some View {
        VStack {
            Chart(groupedExpenses, id: \.type) { item in SectorMark(
                    angle: .value("Amount", item.total),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("Category", item.type))
                .cornerRadius(5)
            }
            .frame(height: 300)
            .chartLegend(position: .bottom, spacing: 20)
            .animation(.bouncy, value: expenses.items)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotAreaFrame]
                    VStack {
                        Text("Total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(groupedExpenses.reduce(0) { $0 + $1.total}, specifier: "%.2f")")
                            .font(.headline.bold())
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
                
            }
            
        }
    }
}

#Preview {
    ExpenseChart(expenses: Expenses())
}

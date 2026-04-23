//
//  ExpenseChart.swift
//  BudgetBuddy
//
//  Created by Kevin Hernandez Garcia on 3/18/26.
//

import SwiftUI
import Charts

struct ExpenseChart: View {
    var items: [ExpenseItem]
    var mode: ChartViewMode

    enum ChartViewMode {
        case pie, bar
    }

    // Data grouped by Category (for Pie)
    var categoryTotals: [(type: String, total: Double)] {
        let grouped = Dictionary(grouping: items, by: { $0.type })
        return grouped.map { (type: $0.key, total: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.total > $1.total }
    }

    // Data grouped by Day (for Bar)
    var dailyTotals: [(date: Date, total: Double)] {
        let grouped = Dictionary(grouping: items) { item in
            Calendar.current.startOfDay(for: item.date)
        }
        return grouped.map { (date: $0.key, total: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        VStack {
            if items.isEmpty {
                ContentUnavailableView("No Data", systemImage: "chart.pie", description: Text("Try selecting a different date."))
            } else {
                Chart {
                    if mode == .pie {
                        ForEach(categoryTotals, id: \.type) { item in
                            SectorMark(
                                angle: .value("Amount", item.total),
                                innerRadius: .ratio(0.6),
                                angularInset: 1.5
                            )
                            .foregroundStyle(by: .value("Category", item.type))
                            .cornerRadius(5)
                        }
                    } else {
                        ForEach(dailyTotals, id: \.date) { item in
                            BarMark(
                                x: .value("Day", item.date, unit: .day),
                                y: .value("Amount", item.total)
                            )
                            .foregroundStyle(.blue.gradient)
                            .cornerRadius(4)
                        }
                    }
                }
                // Customize X-axis for weekly view
                .chartXAxis {
                    if mode == .bar {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        }
                    }
                }
                .chartBackground { chartProxy in
                    if mode == .pie {
                        // Keep existing "Total" overlay for the donut hole
                        GeometryReader { geometry in
                            let frame = geometry[chartProxy.plotAreaFrame]
                            VStack {
                                Text("Total").font(.caption).foregroundColor(.secondary)
                                Text("$\(items.reduce(0){$0 + $1.amount}, specifier: "%.2f")")
                                    .font(.headline.bold())
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    ExpenseChart(items: [], mode: .bar)
}

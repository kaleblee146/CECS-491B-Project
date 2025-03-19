//
//  BarGraph.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//

import SwiftUI
import Charts

struct BarGraphView: View{
    
    let data: [ChartData] = [
        ChartData(day: 1, value: 45),
        ChartData(day: 2, value: 45),
        ChartData(day: 3, value: 55),
        ChartData(day: 4, value: 45),
        ChartData(day: 5, value: 60),
        ChartData(day: 6, value: 45),
        ChartData(day: 7, value: 55)
    ]
    
    var body: some View{
        Chart{
            ForEach(data){ item in
                LineMark(
                    x: .value("Day", item.day),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(Color.magenta)
                
            }
        }
        .frame(height: 200)
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let day: Int
    let value: Double
    
}

struct BarGraphPreview: PreviewProvider{
    static var previews: some View {
        BarGraphView()
    }
}

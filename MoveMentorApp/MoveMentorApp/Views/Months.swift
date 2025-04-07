//
//  Months.swift
//  MoveMentorDraft
//
//  Created by Kaleb Lee on 3/18/25.
//


import SwiftUI

struct MonthView: View {
    
    @State private var selectedMonth: String?
    
    private let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    
    var body: some View{
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(months, id: \.self){ month in
                        Button(action: {
                            selectMonth(month)
                        }){
                            Text(month)
                                .font(Font.custom("Roboto_condensed-black", size: 14))
                                .frame(width: 34, height: 24)
                            
                        }
                        .frame(width: 53, height: 26)
                        .buttonStyle(BorderlessButtonStyle())
                        .background(month == selectedMonth ? Color.magenta : Color.textBoxNavy)
                        .cornerRadius(5)
                        
                        
                    }
                }
                .background(Color.navy)
            }
            .frame(width: 375, height: 40)
            .background(Color.navy)
            
           
            
            /*
             Rectangle()
             .fill(Color.navy)
             .frame(width: 375, height: 213)
             */
            
        }
        .background(Color.navy)
    }
    

    private func selectMonth(_ month: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        if let date = formatter.date(from: month){
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            
            if let newDate = calendar.date(from: DateComponents(year: currentYear, month: calendar.component(.month, from: date))){
                selectedMonth = month
            }
        }
    }
}
    
struct MonthViewPreview : PreviewProvider {
    static var previews: some View {
        MonthView()
    }
}
    



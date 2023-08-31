//
//  DateScroller.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/27/23.
//

import SwiftUI

struct DateScroller: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var date: Date = Date()
    
    
    
    
    
    var body: some View
    {
        HStack
        {
            Spacer()
            DatePicker("Pick a date",selection: $date, displayedComponents: [.date])
                .onChange(of: date, perform: { value in dateHolder.changeDate(selectedDate: date, viewContext) })
            Spacer()
        }
    }
}

struct DateScroller_Previews: PreviewProvider {
    static var previews: some View {
        DateScroller()
    }
}

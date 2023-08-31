//
//  ContentView.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/27/23.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var date: Date = Date()
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()

    @State var selectedTaskFilter = TaskFilter.NonCompleted
    @State var selectedDateFilter = DateFilter.SpecifiedDate
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                Picker("", selection: $selectedDateFilter.animation())
                {
                    ForEach(DateFilter.allFilters, id: \.self)
                    {
                        filter in
                        Text(filter.rawValue)
                    }
                }
                .onChange(of: selectedDateFilter, perform: { value in dateHolder.changeSelection(selection: selectedDateFilter, viewContext) })
                .pickerStyle(.segmented)
                if selectedDateFilter.rawValue == "Date" {
                    HStack
                    {
                        Spacer()
                        DatePicker("Pick a date", selection: $date, displayedComponents: [.date])
                            .onChange(of: date, perform: { value in dateHolder.changeDate(selectedDate: date, viewContext) })
                        Spacer()
                    }
                }
                else if selectedDateFilter.rawValue == "Period of Time"
                {
                    HStack
                    {
                        Spacer()
                        VStack
                        {
                            DatePicker("Start date", selection: $startDate, displayedComponents: [.date])
                                .onChange(of: startDate, perform: { value in dateHolder.changeWeek(selectedStartDate: startDate, selectedEndDate: endDate, viewContext) })
                            DatePicker("End date", selection: $endDate, in: startDate..., displayedComponents: [.date])
                                .onChange(of: endDate, perform: { value in dateHolder.changeWeek(selectedStartDate: startDate, selectedEndDate: endDate, viewContext) })
                        }
                        Spacer()
                    }
                }
                Picker("", selection: $selectedTaskFilter.animation())
                {
                    ForEach(TaskFilter.allFilters, id: \.self)
                    {
                        filter in
                        Text(filter.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                ZStack
                {
                    List
                    {
                        ForEach(filterTaskItems())
                        { taskItem in
                            NavigationLink(destination: TaskEditView(passedTaskItem: taskItem, initialDate: taskItem.dueDate!)
                                .environmentObject(dateHolder))
                            {
                                TaskCell(passedTaskItem: taskItem)
                                    .environmentObject(dateHolder)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .navigationTitle("My To Do List")
                    .navigationBarTitleDisplayMode(.inline)
                    FloatingButton()
                        .environmentObject(dateHolder)
                }
            }
        }
    }
    
    
    private func filterTaskItems() -> [TaskItem]
    {
        if selectedTaskFilter == TaskFilter.Completed
        {
            return dateHolder.taskItems.filter{ $0.isCompleted()}
        }
        
        if selectedTaskFilter == TaskFilter.NonCompleted
        {
            return dateHolder.taskItems.filter{ !$0.isCompleted()}
        }
        
        if selectedTaskFilter == TaskFilter.OverDue
        {
            return dateHolder.taskItems.filter{ $0.isOverdue()}
        }
        return dateHolder.taskItems
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filterTaskItems()[$0] }.forEach(viewContext.delete)

            dateHolder.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

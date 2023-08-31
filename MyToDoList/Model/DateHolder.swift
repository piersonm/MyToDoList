//
//  DateHolder.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/27/23.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject
{
    @Published var date = Date()
    @Published var taskItems: [TaskItem] = []
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var isDaily = true
    
    let calendar: Calendar = Calendar.current
    
    func changeSelection(selection: DateFilter, _ context: NSManagedObjectContext)
    {
        if selection.rawValue == "Date"
        {
            isDaily = true
        }
        else
        {
            isDaily = false
        }
        refreshTaskItems(context)
    }
    func changeDate(selectedDate: Date, _ context: NSManagedObjectContext)
    {
        date = selectedDate
        refreshTaskItems(context)
    }
    
    func changeWeek(selectedStartDate: Date, selectedEndDate: Date, _ context: NSManagedObjectContext)
    {
        startDate = selectedStartDate
        endDate = selectedEndDate
        refreshTaskItems(context)
    }
    
    func refreshTaskItems(_ context: NSManagedObjectContext)
    {
        taskItems = fetchTaskItems(context)
    }
    
    init(_ context: NSManagedObjectContext)
    {
        refreshTaskItems(context)
    }
    
    func fetchTaskItems(_ context: NSManagedObjectContext) -> [TaskItem]
    {
        do
        {
            return try context.fetch(dailyTasksFetch()) as [TaskItem]
        }
        catch let error
        {
            fatalError("Unresovled error \(error)")
        }
    }
    
    func dailyTasksFetch() -> NSFetchRequest<TaskItem>
    {
        let request = TaskItem.fetchRequest()
        
        request.sortDescriptors = sortOrder()
        request.predicate = predicate()
        return request
    }
    
    private func sortOrder() -> [NSSortDescriptor]
    {
        let completedDateSort = NSSortDescriptor(keyPath: \TaskItem.completedDate, ascending: true)
        let timeSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        return [completedDateSort, timeSort, dueDateSort]
    }
    
    private func predicate() -> NSPredicate
    {
        var start = calendar.startOfDay(for: date)
        var end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        
        if isDaily == false
        {
            start = calendar.startOfDay(for: startDate)
            end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)
            return NSPredicate(format: "dueDate >= %@ AND dueDate <= %@", start as NSDate, end! as NSDate)
        }
        else {
            return NSPredicate(format: "dueDate >= %@ AND dueDate < %@", start as NSDate, end! as NSDate)
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshTaskItems(context)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//
//  TaskEditView.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/27/23.
//

import SwiftUI

struct TaskEditView: View
{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var selectedTaskItem: TaskItem?
    @State var name: String
    @State var desc: String
    @State var dueDate: Date
    @State var scheduleTime: Bool
    @State var taskTag: String
    @State var selectedPriority: String
    
    var taskTagArray = [String]()
    
    init(passedTaskItem: TaskItem?, initialDate: Date)
    {
        // If in edit mode
        if let taskItem = passedTaskItem
        {
            _selectedTaskItem = State(initialValue: taskItem)
            // Set name to exisitng name
            _name = State(initialValue: taskItem.name ?? "")
            // Set description to exisiting description
            _desc = State(initialValue: taskItem.desc ?? "")
            _dueDate = State(initialValue: taskItem.dueDate ?? initialDate)
            _scheduleTime = State(initialValue: taskItem.scheduleTime)
            _taskTag = State(initialValue: taskItem.taskTag ?? "")
            _selectedPriority = State(initialValue: taskItem.selectedPriority ?? "")
        }
        // Creating new task
        else
        {
            // Set name to:
            _name = State(initialValue: "")
            // Set description to:
            _desc = State(initialValue: "")
            _dueDate = State(initialValue: initialDate)
            _scheduleTime = State(initialValue: false)
            _taskTag = State(initialValue: "")
            _selectedPriority = State(initialValue: "")
        }
    }
    
    var body: some View
    {
        Form
        {
            Section(header: Text("Task"))
            {
                TextField("Task Name", text: $name)
                TextField("Desc", text: $desc)
            }
            Section(header: Text("Tags"))
            {
                TextField("Tag", text: $taskTag)
                Picker("Priority", selection: $selectedPriority)
                {
                    Text("None").tag(String?.none)
                    ForEach(PriorityFilter.allFilters, id: \.self)
                    {
                        filter in
                        Text(filter.rawValue).tag(filter.rawValue)
                    }
                }
            }
            Section(header: Text("Due Date"))
            {
                Toggle("Schedule Time", isOn: $scheduleTime)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: displayComps())
            }
            
            if selectedTaskItem?.isCompleted() ?? false
            {
                Section(header: Text("Completed"))
                {
                    Text(selectedTaskItem?.completedDate?.formatted(date: .abbreviated, time: .shortened) ?? "")
                        .foregroundColor(.green)
                }
            }
            Section()
            {
                Button("Save", action: saveAction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    func displayComps() -> DatePickerComponents
    {
        return scheduleTime ? [.hourAndMinute, .date] : [.date]
    }
    func saveAction()
    {
        withAnimation
        {
            if selectedTaskItem == nil
            {
                selectedTaskItem = TaskItem(context: viewContext)
            }
            
            selectedTaskItem?.created = Date()
            selectedTaskItem?.name = name
            selectedTaskItem?.dueDate = dueDate
            selectedTaskItem?.scheduleTime = scheduleTime
            selectedTaskItem?.taskTag = taskTag
            selectedTaskItem?.selectedPriority = selectedPriority
            
            
            dateHolder.saveContext(viewContext)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TaskEditView_Previews: PreviewProvider
{
    static var previews: some View {
        TaskEditView(passedTaskItem: TaskItem(), initialDate: Date())
    }
}

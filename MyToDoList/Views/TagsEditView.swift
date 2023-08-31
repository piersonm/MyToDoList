//
//  TagsView.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/30/23.
//

import SwiftUI

struct TagsEditView: View
{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selectedTag: ItemTag?
    @State var name: String
    @State var tagObject: NSObject
    @State var tagObject.color: Color
    
    
    init(passedTaskTag: ItemTag?)
    {
        if let taskTag = passedTaskTag
        {
            _name = State(initialValue: taskTag.name ?? "")
            _tagObject = State(initialValue: taskTag.tagObject!)
            _selectedTag = State(initialValue: taskTag)
            _tagColor = State(initialValue: taskTag.tagColor as Color)
        }
        
        else {
            _name = State(initialValue: "")
        }
    }
    var body: some View
    {
        Form
        {
            Section(header: Text("Tag Details"))
            {
                TextField("Tag Name", text: $name)
                ColorPicker("Set Tag Color", selection: $tagColor , supportsOpacity: false)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Section()
            {
                Button("Save", action: saveAction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    

    
    func saveAction()
    {
        var taskTagProps = TaskTag()
        withAnimation
        {
            if selectedTag == nil
            {
                selectedTag = ItemTag(context: viewContext)
            }
            
            selectedTag?.name = name
            taskTagProps.name = name
            taskTagProps.color = color
            tagObject = taskTagProps
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct TagsEditView_Previews: PreviewProvider {
    static var previews: some View {
        TagsEditView(passedTaskTag: ItemTag())
    }
}

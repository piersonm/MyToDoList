//
//  MyToDoListApp.swift
//  MyToDoList
//
//  Created by Pierson McCall on 8/27/23.
//

import SwiftUI

@main
struct MyToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            let context = persistenceController.container.viewContext
            let dateHolder = DateHolder(context)
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(dateHolder)        }
    }
}

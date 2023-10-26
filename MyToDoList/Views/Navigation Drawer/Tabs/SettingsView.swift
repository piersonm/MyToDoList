//
//  SettingsView.swift
//  MyToDoList
//
//  Created by Pierson McCall on 10/22/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
            
            Spacer()
            Text("Settings View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

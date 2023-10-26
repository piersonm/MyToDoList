//
//  SideMenu.swift
//  MyToDoList
//
//  Created by Pierson McCall on 10/20/23.
//

import Foundation
import SwiftUI

struct SideMenu: View {
    @Binding var sideMenuShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .bottom) 
        {
            if (sideMenuShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        sideMenuShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(
                        Color.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: sideMenuShowing)
    }
}

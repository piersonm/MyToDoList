//
//  NavigationDrawer.swift
//  MyToDoList
//
//  Created by Pierson McCall on 10/22/23.
//

import SwiftUI

struct NavigationDrawer: View {
    @Binding var isOpen: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .bottom)
        {
            if (isOpen) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isOpen.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(Color.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(Animation.easeInOut(duration: 0.2), value: isOpen)
    }
}

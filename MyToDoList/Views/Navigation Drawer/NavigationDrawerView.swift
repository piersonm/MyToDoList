//
//  NavigationBarView.swift
//  MyToDoList
//
//  Created by Pierson McCall on 10/22/23.
//

import SwiftUI


enum NavigationDrawerContent: Int, CaseIterable {
    case home = 0
    case tags
    case settings
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .tags:
            return "Tags"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "home"
        case .tags:
            return "tags"
        case .settings:
            return "settings"
        }
    }
}

struct NavigationDrawerView: View {
    @Binding var selectedTab: Int
    @Binding var presentNavDrawer: Bool
    
    var body: some View {
        
            VStack {
                GeometryReader{ _ in EmptyView() }
                    .background(Color.gray.opacity(0.5))
                    .opacity(self.presentNavDrawer ? 1 : 0)
                    .animation(Animation.easeInOut.delay(0.25), value: presentNavDrawer)
                
                VStack(alignment: .leading, spacing: 0)
                {
                    ForEach(NavigationDrawerContent.allCases, id: \.self) {
                        row in RowView(isSelected: selectedTab == row.rawValue, imageName: row.iconName, title: row.title){
                            selectedTab = row.rawValue
                            presentNavDrawer.toggle()
                        }
                    }
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(Color.white)
            }
            Spacer()
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading)
            {
                HStack(spacing: 20)
                {
                    Rectangle()
                        .fill(isSelected ? .purple : .white)
                        .frame(width: 5)
                    
                    ZStack
                    {
                        Image(imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .black : .gray)
                            .frame(width: 26, height: 26)
                    }
                    .frame(width: 30, height: 30)
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(LinearGradient(colors: [isSelected ? .purple.opacity(0.5) : .white, .white], startPoint: .leading, endPoint: .trailing))
    }
}

//struct NavigationDrawerView_Previews: PreviewProvider {
//    static var previews: some View {
//        @Binding var selectedPreviewTab: Int
//        @Binding var isOpen: Bool = true
//        NavigationDrawerView(selectedTab: $selectedPreviewTab , presentNavDrawer: $isOpen)
//    }
//}

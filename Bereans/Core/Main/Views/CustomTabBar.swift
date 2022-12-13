//
//  CustomTabBar.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/12.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var currentTab: String
    var bottomEdge: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Views.allCases, id: \.self) { view in
                TabButton(view: view, currentTab: $currentTab)
            }
        }
        .padding(.top, 15)
        .padding(.bottom, bottomEdge)
        .background(Color("TabBG"))
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}

struct TabButton: View {
    var view: Views
    @Binding var currentTab: String
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        Button {
            withAnimation {
                currentTab = view.rawValue
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: view.image())
                    .frame(maxWidth: .infinity)
                Text(view.rawValue)
            }
            .foregroundColor(currentTab == view.rawValue ? Color("Pink") : Color.gray.opacity(0.7))
        }
    }
}

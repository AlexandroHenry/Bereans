//
//  MainView.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/08.
//

import SwiftUI

struct MainView: View {
    
    @State var currentTab = "Read"
    
    var bottomEdge: CGFloat
    
    init(bottomEdge: CGFloat) {
        UITabBar.appearance().isHidden = true
        self.bottomEdge = bottomEdge
    }
    
    @State var hideBar = false
    
    var body: some View {
        TabView(selection: $currentTab) {
            Text("Home")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primary.opacity(0.05))
                .tag("Home")
            
            ReadView(hideTab: $hideBar, bottomEdge: bottomEdge)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primary.opacity(0.05))
                .tag("Read")
        }
        .overlay(
            VStack {
                
                CustomTabBar(currentTab: $currentTab, bottomEdge: bottomEdge)
            }
                .offset(y: hideBar ? (15 + 35 + bottomEdge) : 0)
            ,alignment: .bottom
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

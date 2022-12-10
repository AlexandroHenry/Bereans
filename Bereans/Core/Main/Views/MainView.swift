//
//  MainView.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/08.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var mainVM = MainViewModel()
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            
            TabView(selection: $mainVM.selectedTab) {
                Text("\(mainVM.selectedTab) View")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag("Home")
                
                Text("\(mainVM.selectedTab) View")
                    .tabItem {
                        Label("Notification", systemImage: "bell")
                    }
                    .tag("Notification")
                
                ReadView(safeArea: safeArea, size: size)
                    .tabItem {
                        Label("Read", systemImage: "book")
                    }
                    .tag("Read")
                
                Text("\(mainVM.selectedTab) View")
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag("Settings")
            }
            .onAppear() {
                UITabBar.appearance().barTintColor = .black
            }
            .accentColor(.pink)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

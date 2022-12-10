//
//  ContentView.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
            .ignoresSafeArea(.container, edges: .top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

//
//  BereansApp.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/08.
//

import SwiftUI

@main
struct BereansApp: App {
    
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}

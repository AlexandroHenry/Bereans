//
//  FooterButtonView.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/12.
//

import SwiftUI

struct FooterButtonView: View {
    
    @StateObject var readVM = ReadViewModel()
    @Environment(\.colorScheme) var scheme
    @State var imageName: String
    @State var purpose: String
    
    
    var body: some View {
        Button {
            
            switch purpose {
            case "prevChapter":
                if readVM.currentChapter > 1 {
                    readVM.currentChapter -= 1
                }
            case "reduceFontSize":
                if readVM.fontSize > 15 {
                    readVM.fontSize -= 5
                }
                
            default:
                print("default footer button")
            }
           
            
        } label: {
            Image(systemName: imageName)
                .font(.system(size: 20).bold())
                .foregroundColor(.pink)
        }
        .padding()
        .background(Color.primary.opacity(0.8))
        .clipShape(Circle())
        .shadow(radius: 10)
    }
}

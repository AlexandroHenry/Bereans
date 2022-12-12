//
//  SampleView.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/12.
//

import SwiftUI

struct SampleView: View {
    var body: some View {
        VStack {
            ForEach(OldTestament.allCases, id: \.self) { book in
                Text(book.korDescription())
            }
        }
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}

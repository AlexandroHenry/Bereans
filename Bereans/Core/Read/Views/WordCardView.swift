//
//  WordCardView.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/12.
//

import SwiftUI

struct WordCardView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("바울이 더베와 루스드라에도 이르매 거기 디모데라 하는 제자가 있으니 그 어머니는 믿는 유대 여자요 아버지는 헬라인이라")
                    .font(.system(size: 20).bold())
                    .foregroundColor(.primary)
                
                Text("디모데전서 3장 8절")
                    .font(.system(size: 15).bold())
                    .foregroundColor(.orange)
            }
        }
        .padding()
    }
}

struct WordCardView_Previews: PreviewProvider {
    static var previews: some View {
        WordCardView()
    }
}

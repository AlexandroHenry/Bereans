//
//  Views.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/12.
//

import Foundation

enum Views: String, CaseIterable {
    case home = "Home"
    case read = "Read"
    
    func image() -> String {
        switch self {
        case .home:
            return "house.fill"
        case .read:
            return "book.fill"
        }
    }
}


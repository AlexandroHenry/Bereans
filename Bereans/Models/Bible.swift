//
//  Bible.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/09.
//

import Foundation

struct Bible: Codable, Hashable {
    var book: String
    var type: String
    var version: String
    var chapter: Int
    var verse: Int
    var word: String
}

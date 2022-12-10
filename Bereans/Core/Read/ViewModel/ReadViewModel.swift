//
//  ReadViewModel.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/08.
//

import Foundation
import SwiftUI

class ReadViewModel: ObservableObject {
    
    @EnvironmentObject var modelData: ModelData
    
    @Published var showingBookPicker = false

    @Published var currentLanguage: String = "한글"
    @Published var currentBook: String = "Genesis"
    @Published var currentChapter: Int = 1
    @Published var currentVersion: String = "개역한글"
    
    @Published var fontSize: CGFloat = 20
    
    
    // bookPicker
    @Published var showOldList = false
    @Published var showNewList = false
    
    @Published var showSelectedBook = ""
    @Published var showChapterList: Bool = false
    
    // languagePicker
    var languageList = ["한글", "English"]
    var krVersion = ["개역개정", "개역한글", "표준새번역", "현대인의성경"]
    var engVersion = ["New International Version", "King James Version", "New King James Version"]
    
    @Published var showPickLanguage = ""
    @Published var showVersions = false
//    var languageList = ["한글", "English", "français", "español", "日本語", "中文"]
    
    
    
    
    
    
    var old_testament = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiates", "Song of Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    var new_testament = [
        "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"
    ]
    
    func chapterCounter(currentBook: String) -> Int {
        let book = modelData.niv.filter { item in
            item.book == currentBook
        }
        
        var chapterCount = 1
        
        for i in book {
            if i.chapter > chapterCount {
                chapterCount = i.chapter
            }
        }
        
        return chapterCount
    }
    
}

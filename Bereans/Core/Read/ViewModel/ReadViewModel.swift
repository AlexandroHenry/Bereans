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
    
    @Published var currentPart: String = "old"
    
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
    var krVersion = ["개역개정"]
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

enum OldTestament: String, CaseIterable {
    case genesis = "Genesis"
    case exodus = "Exodus"
    case leviticus = "Leviticus"
    case numbers = "Numbers"
    case deuteronomy = "Deuteronomy"
    case joshua = "Joshua"
    case judges = "Judges"
    case ruth = "Ruth"
    case samuel1 = "1 Samuel"
    case samuel2 = "2 Samuel"
    case kings1 = "1 Kings"
    case kings2 = "2 Kings"
    case chronicles1 = "1 Chronicles"
    case chronicles2 = "2 Chronicles"
    case ezra = "Ezra"
    case nehemiah = "Nehemiah"
    case esther = "Esther"
    case job = "Job"
    case psalms = "Psalms"
    case proverbs = "Proverbs"
    case ecclesiates = "Ecclesiates"
    case songOfSongs = "Song of Songs"
    case isaiah = "Isaiah"
    case jeremiah = "Jeremiah"
    case lamentations = "Lamentations"
    case ezekiel = "Ezekiel"
    case daniel = "Daniel"
    case hosea = "Hosea"
    case joel = "Joel"
    case amos = "Amos"
    case obadiah = "Obadiah"
    case jonah = "Jonah"
    case micah = "Micah"
    case nahum = "Nahum"
    case habakkuk = "Habakkuk"
    case zephaniah = "Zephaniah"
    case haggai = "Haggai"
    case zechariah = "Zechariah"
    case malachi = "Malachi"

    func korDescription() -> String {
        switch self {
        case .genesis:
        return "창세기"
        case .exodus:
        return "출애굽기"
        case .leviticus:
        return "레위기"
        case .numbers:
        return "민수기"
        case .deuteronomy:
        return "신명기"
        case .joshua:
        return "여호수아"
        case .judges:
        return "사시기"
        case .ruth:
        return "룻기"
        case .samuel1:
        return "사무엘상"
        case .samuel2:
        return "사무엘하"
        case .kings1:
        return "열왕기상"
        case .kings2:
        return "열왕기하"
        case .chronicles1:
        return "역대상"
        case .chronicles2:
        return "역대하"
        case .ezra:
        return "에스라"
        case .nehemiah:
        return "느헤미야"
        case .esther:
        return "에스더"
        case .job:
        return "욥기"
        case .psalms:
        return "시편"
        case .proverbs:
        return "잠언"
        case .ecclesiates:
        return "전도서"
        case .songOfSongs:
        return "아가"
        case .isaiah:
        return "이사야"
        case .jeremiah:
        return "예레미야"
        case .lamentations:
        return "예레미야애가"
        case .ezekiel:
        return "에스겔"
        case .daniel:
        return "다니엘"
        case .hosea:
        return "호세아"
        case .joel:
        return "요엘"
        case .amos:
        return "아모스"
        case .obadiah:
        return "오바댜"
        case .jonah:
        return "요나"
        case .micah:
        return "미가"
        case .nahum:
        return "나훔"
        case .habakkuk:
        return "하박국"
        case .zephaniah:
        return "스바냐"
        case .haggai:
        return "학개"
        case .zechariah:
        return "스가랴"
        case .malachi:
        return "말라기"
        }
    }
}

enum NewTestament: String, CaseIterable {
    case matthew = "Matthew"
    case mark = "Mark"
    case luke = "Luke"
    case john = "John"
    case acts = "Acts"
    case romans = "Romans"
    case corinthians1 = "1 Corinthians"
    case corinthians2 = "2 Corinthians"
    case galatians = "Galatians"
    case ephesians = "Ephesians"
    case philippians = "Philippians"
    case colossians = "Colossians"
    case thessalonians1 = "1 Thessalonians"
    case thessalonians2 = "2 Thessalonians"
    case timothy1 = "1 Timothy"
    case timothy2 = "2 Timothy"
    case titus = "Titus"
    case philemon = "Philemon"
    case hebrews = "Hebrews"
    case james = "James"
    case peter1 = "1 Peter"
    case peter2 = "2 Peter"
    case john1 = "1 John"
    case john2 = "2 John"
    case john3 = "3 John"
    case jude = "Jude"
    case revelation = "Revelation"
    
    func korDescription() -> String {
        switch self {
        case .matthew:
        return "마태복음"
        case .mark:
        return "마가복음"
        case .luke:
        return "누가복음"
        case .john:
        return "요한복음"
        case .acts:
        return "사도행전"
        case .romans:
        return "로마서"
        case .corinthians1:
        return "고린도전서"
        case .corinthians2:
        return "고린도후서"
        case .galatians:
        return "갈라디아서"
        case .ephesians:
        return "에베소서"
        case .philippians:
        return "빌립보서"
        case .colossians:
        return "골로새서"
        case .thessalonians1:
        return "데살로니가전서"
        case .thessalonians2:
        return "데살로니가후서"
        case .timothy1:
        return "디모데전서"
        case .timothy2:
        return "디모데후서"
        case .titus:
        return "디도서"
        case .philemon:
        return "빌레몬서"
        case .hebrews:
        return "히브리서"
        case .james:
        return "야고보서"
        case .peter1:
        return "베드로전서"
        case .peter2:
        return "베드로후서"
        case .john1:
        return "요한일서"
        case .john2:
        return "요한2서"
        case .john3:
        return "요한3서"
        case .jude:
        return "유다서"
        case .revelation:
        return "요한계시록"
        }
    }
}

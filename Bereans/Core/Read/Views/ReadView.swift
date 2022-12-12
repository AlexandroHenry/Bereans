//
//  ReadView.swift
//  Bereans
//
//  Created by Seungchul Ha on 2022/12/08.
//

import SwiftUI

struct ReadView: View {
    
    @EnvironmentObject var modelData: ModelData
    @StateObject var readVM = ReadViewModel()
    
    var safeArea: EdgeInsets
    var size: CGSize
    
    @State private var showingBookPicker = false
    @State private var showingLanguagePicker = false
    
    @State private var chapNum: Int?
    @State private var selectingBook: String?
    
    var filteredBible: [Bible] {
        switch readVM.currentVersion {
        case "개역한글":
            return modelData.krv.filter { chapter in
                readVM.currentBook == chapter.book && readVM.currentChapter == chapter.chapter
            }
        case "New International Version":
            return modelData.niv.filter { chapter in
                readVM.currentBook == chapter.book && readVM.currentChapter == chapter.chapter
            }
        default:
            return modelData.krv.filter { chapter in
                readVM.currentBook == chapter.book && readVM.currentChapter == chapter.chapter
            }
        }
    }
    
    // MARK: Dragging Variables
    @State private var draggedOffset = CGSize.zero
    
    // MARK: When ChapterNumber Changed, ScrollView Will Be Dragged to Top Of It
    private static let topId = "topIdHere"
    
    var body: some View {
        ZStack {
            
            ScrollViewReader { proxyReader in
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        bibleChapterView()
                            .id(Self.topId)
                            .padding(.top, 80)
                            .padding(.bottom, 100)
                            .padding(.horizontal, 10)
                    }
                    .onChange(of: self.chapNum, perform: { newValue in
                        withAnimation {
                            proxyReader.scrollTo(Self.topId, anchor: .top)
                        }
                    })
                    // MARK: When Drag, move to prev or next chapter : To Do
                    .offset(x: self.draggedOffset.width)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.draggedOffset = value.translation
                            }
                            .onEnded { value in
                            
                                if self.draggedOffset.width >= 1 && readVM.currentChapter > 1 {
                                    proxyReader.scrollTo(Self.topId, anchor: .top)
                                    readVM.currentChapter -= 1
                                    self.draggedOffset = CGSize.zero
                                } else if self.draggedOffset.width <= -1 && readVM.currentChapter < chapterCounter(currentBook: readVM.currentBook) {
                                    proxyReader.scrollTo(Self.topId, anchor: .top)
                                    readVM.currentChapter += 1
                                    self.draggedOffset = CGSize.zero
                                } else {
                                    self.draggedOffset = CGSize.zero
                                }
                                
                            }
                    )
                }
            }
            
            
            VStack {
                headerView()
                Spacer()
                footerView()
                    .padding(.bottom)
            }
            
        }
    }
    
    @ViewBuilder
    func bibleChapterView() -> some View {
        VStack {
            Text("\(currentBook(book: readVM.currentBook)) \(readVM.currentChapter)")
                .font(.system(size: 40))
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                
                ForEach(filteredBible, id: \.self) { chapter in
                    HStack(spacing: 20) {

                        VStack {
                            Text("\(chapter.verse)")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)

                            Spacer()
                        }

                        Text(chapter.word)
                            .font(.system(size: readVM.fontSize))
                            .foregroundColor(.primary)
                            .lineSpacing(20)
                            .fontWeight(.bold)

                        Spacer()
                    }
                    .id(chapter)
                }
            }
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(spacing: 20) {
            Spacer()
            
            Button {
                showingLanguagePicker.toggle()
            } label: {
                Text("\(readVM.currentLanguage)")
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
            }
            .background(.primary)
            .buttonStyle(.bordered)
            .clipShape(Capsule())
            .shadow(radius: 20)
            .sheet(isPresented: $showingLanguagePicker) {
                languagePickView()
            }
            
            Button {
                withAnimation {
                    showingBookPicker.toggle()
                }
            } label: {
                Text("\(currentBook(book: readVM.currentBook)) \(readVM.currentChapter)")
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
            }
            .background(.primary)
            .buttonStyle(.bordered)
            .clipShape(Capsule())
            .shadow(radius: 20)
            .sheet(isPresented: $showingBookPicker) {
                bookPickView()
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func footerView() -> some View {
        HStack(spacing: 20) {
            Spacer()
            footerButton(image: "arrow.left", purpose: "prevChapter")
            footerButton(image: "textformat.size.smaller", purpose: "reduceFontSize")
            footerButton(image: "magnifyingglass", purpose: "search")
            footerButton(image: "textformat.size.larger", purpose: "increaseFontSize")
            footerButton(image: "arrow.right", purpose: "nextChapter")
            Spacer()
        }
    }
    
    @ViewBuilder
    func footerButton(image: String, purpose: String) -> some View {
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
            case "search":
                print("search Button Pressed")
            case "increaseFontSize":
                if readVM.fontSize < 40 {
                    readVM.fontSize += 5
                }
            case "nextChapter":
                if readVM.currentChapter < chapterCounter(currentBook: readVM.currentBook){
                    readVM.currentChapter += 1
                    chapNum = readVM.currentChapter
                }
            default:
                print("default footer button")
            }
           
            
        } label: {
            Image(systemName: image)
                .font(.system(size: 20).bold())
                .foregroundColor(.pink)
                .padding(15)
        }
        .background(Color.primary.opacity(0.8))
        .clipShape(Circle())
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    func bookPickView() -> some View {
        ScrollView(.vertical) {
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text(readVM.currentLanguage == "한글" ? "구약성경" : "Old Testament")
                        .font(.system(size: 25).bold())
                        
                    Spacer()
                    
                    if readVM.showOldList {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.pink)
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                    }
                    
                }
                .onTapGesture {
                    withAnimation {
                        readVM.showOldList.toggle()
                        readVM.showNewList = false
                        if readVM.showOldList {
                            readVM.showSelectedBook = ""
                            readVM.showChapterList = false
                        }
                    }
                }
                
                if readVM.showOldList {
                    ForEach(OldTestament.allCases, id: \.self) { item in
                        Button {
                            if readVM.showSelectedBook == "" {
                                readVM.showSelectedBook = item.rawValue
                                readVM.showChapterList.toggle()
                            } else if readVM.showSelectedBook != item.rawValue && readVM.showSelectedBook != "" {
                                readVM.showSelectedBook = item.rawValue
                                readVM.showChapterList = true
                            } else if readVM.showSelectedBook == item.rawValue {
                                readVM.showSelectedBook = ""
                                readVM.showChapterList = false
                            }
                            
                        } label: {
                            HStack {
                                Text(readVM.currentLanguage == "한글" ? item.korDescription() : item.rawValue)
                                
                                Spacer()
                                
                                Image(systemName: readVM.showSelectedBook == item.rawValue ? "chevron.down" : "chevron.right")
                            }
                            .font(.system(size: 20).bold())
                            .foregroundColor(readVM.showSelectedBook == item.rawValue ? .pink : .primary)
                        }
                        
                        if readVM.showSelectedBook == item.rawValue && readVM.showChapterList {
                            
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
                                ForEach(1...chapterCounter(currentBook: item.rawValue), id: \.self) { chapter in
                                    Button {
                                        
                                        readVM.currentBook = readVM.showSelectedBook
                                        readVM.currentChapter = chapter
                                        
                                        readVM.showSelectedBook = ""
                                        
                                        readVM.showChapterList = false
                                        readVM.showOldList = false
                                        readVM.showNewList = false
                                        showingBookPicker = false
                                        
                                        readVM.currentPart = "old"
                                    } label: {
                                        Text("\(chapter)")
                                            .foregroundColor(.primary)
                                    }
                                    .frame(width: 60, height: 60)
                                    .background(.primary.opacity(0.2))
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Text(readVM.currentLanguage == "한글" ? "신약성경" : "New Testament")
                        .font(.system(size: 25).bold())
                        
                    Spacer()
                    
                    if readVM.showNewList {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.pink)
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                    }
                    
                }
                .onTapGesture {
                    withAnimation {
                        readVM.showNewList.toggle()
                        readVM.showOldList = false
                        if readVM.showNewList {
                            readVM.showSelectedBook = ""
                            readVM.showChapterList = false
                        }
                    }
                }
                
                if readVM.showNewList {
                    ForEach(NewTestament.allCases, id: \.self) { item in
                        Button {
                            if readVM.showSelectedBook == "" {
                                readVM.showSelectedBook = item.rawValue
                                readVM.showChapterList.toggle()
                            } else if readVM.showSelectedBook != item.rawValue && readVM.showSelectedBook != "" {
                                readVM.showSelectedBook = item.rawValue
                                readVM.showChapterList = true
                            } else if readVM.showSelectedBook == item.rawValue {
                                readVM.showSelectedBook = ""
                                readVM.showChapterList = false
                            }
                            
                        } label: {
                            HStack {
                                Text(readVM.currentLanguage == "한글" ? item.korDescription() : item.rawValue)
                                
                                Spacer()
                                
                                Image(systemName: readVM.showSelectedBook == item.rawValue ? "chevron.down" : "chevron.right")
                            }
                            .font(.system(size: 20).bold())
                            .foregroundColor(readVM.showSelectedBook == item.rawValue ? .pink : .primary)
                        }
                        
                        if readVM.showSelectedBook == item.rawValue && readVM.showChapterList {
                            
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
                                ForEach(1...chapterCounter(currentBook: item.rawValue), id: \.self) { chapter in
                                    Button {
                                        
                                        readVM.currentBook = readVM.showSelectedBook
                                        readVM.currentChapter = chapter
                                        
                                        readVM.showSelectedBook = ""
                                        
                                        readVM.showChapterList = false
                                        readVM.showOldList = false
                                        readVM.showNewList = false
                                        showingBookPicker = false
                                        
                                        readVM.currentPart = "new"
                                    } label: {
                                        Text("\(chapter)")
                                            .foregroundColor(.primary)
                                    }
                                    .frame(width: 60, height: 60)
                                    .background(.primary.opacity(0.2))
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func languagePickView() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(readVM.languageList, id: \.self) { language in
                    HStack {
                        Text(language)
                            .font(.system(size: 25).bold())
                            
                        Spacer()
                        
                        Image(systemName: readVM.showPickLanguage == language ? "chevron.down" : "chevron.right")
                        
                    }
                    .foregroundColor(readVM.showPickLanguage == language ? .pink : .primary)
                    .onTapGesture {
                        withAnimation {
                            if readVM.showPickLanguage == "" {
                                readVM.showPickLanguage = language
                            } else if readVM.showPickLanguage != "" && readVM.showPickLanguage != language {
                                readVM.showPickLanguage = language
                            } else if readVM.showPickLanguage == language {
                                readVM.showPickLanguage = ""
                            }
                        }
                    }
                    
                    if readVM.showPickLanguage == language {
                        
                        ForEach(readVM.showPickLanguage == "한글" ? readVM.krVersion : readVM.engVersion, id: \.self) { version in
                            Button {
                                readVM.currentLanguage = readVM.showPickLanguage
                                readVM.currentVersion = version
                                readVM.showPickLanguage = ""
                                showingLanguagePicker = false
                            } label : {
                                HStack {
                                    Text(version)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }
        .padding()
    }
    
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
    
    func currentBook(book: String) -> String {
        
        var bookname: String?
        
        if readVM.currentPart == "old" {
            if readVM.currentLanguage == "한글" {
                bookname = OldTestament(rawValue: readVM.currentBook)?.korDescription()
            } else if readVM.currentLanguage == "English" {
                bookname = OldTestament(rawValue: readVM.currentBook)?.rawValue
            }
        } else {
            if readVM.currentLanguage == "한글" {
                bookname = NewTestament(rawValue: readVM.currentBook)?.korDescription()
            } else if readVM.currentLanguage == "English" {
                bookname = NewTestament(rawValue: readVM.currentBook)?.rawValue
            }
        }
        
        return bookname!
    }
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ModelData())
    }
}


struct ReadBottomButton: View {
    
    @State var image: String
    
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: image)
                .padding(10)
                .font(.system(size: 20).bold())
                .foregroundColor(.pink)
        }
        .background(.primary)
        .buttonStyle(.bordered)
        .clipShape(Circle())
        .shadow(radius: 20)
    }
}

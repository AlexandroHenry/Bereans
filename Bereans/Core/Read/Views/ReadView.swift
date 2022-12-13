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
    
    @Binding var hideTab: Bool
    var bottomEdge: CGFloat
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    
    @State private var draggedOffset = CGSize.zero
    private static let topId = "topIdHere"
    
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

    var body: some View {
        ZStack {
            ScrollViewReader { proxyReader in
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            Spacer()
                            Text("\(currentBook(book: readVM.currentBook)) \(readVM.currentChapter)")
                                .font(.system(size: 40))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 40)
                            Spacer()
                        }
                        .padding(.top, 100)
                        
                        ForEach(filteredBible, id: \.self) { verse in
                            VerseView(bible: verse)
                        }
                    }
                    .id(Self.topId)
                    .onChange(of: self.chapNum, perform: { newValue in
                        withAnimation {
                            proxyReader.scrollTo(Self.topId, anchor: .top)
                        }
                    })
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
                    .overlay(
                    
                        GeometryReader { proxy -> Color in
                            let minY = proxy.frame(in: .named("SCROLL")).minY
                            let durationOffset: CGFloat = 35
                            
                            DispatchQueue.main.async {
                                
                                if offset < 0 && -minY > (lastOffset + durationOffset) {
                                    withAnimation(.easeOut.speed(1.5)) {
                                        hideTab = true
                                    }
                                    lastOffset = -offset
                                }
                                
                                if minY > offset && -minY < (lastOffset - durationOffset) {
                                    
                                    // Showing tab and updating last offset...
                                    withAnimation(.easeOut.speed(1.5)) {
                                        hideTab = false
                                    }
                                    
                                    lastOffset = -offset
                                }
                                
                                self.offset = minY
                            }
                            return Color.clear
                        }
                    )
                    .padding()
                    .padding(.bottom, 15 + bottomEdge + 35)
                }
                .coordinateSpace(name: "SCROLL")
            }
            
            VStack {
                headerView()
                Spacer()
                footerView()
            }
        }
    }
    
    @State private var showingBookPicker = false
    @State private var showingLanguagePicker = false
    @State private var showingSearch = false
    
    @State private var chapNum: Int?
    @State private var selectingBook: String?
    @State private var searchText = ""
    
    @State private var searchTextSubmitted = false
    
    var searchFilteredBible: [Bible] {
        switch readVM.currentVersion {
        case "개역한글":
            return modelData.krv.filter { chapter in
                chapter.word.contains(searchText) && searchTextSubmitted
            }
        case "New International Version":
            return modelData.niv.filter { chapter in
                chapter.word.contains(searchText) && searchTextSubmitted
            }
        default:
            return modelData.krv.filter { chapter in
                chapter.word.contains(searchText) && searchTextSubmitted
            }
        }
    }
    
    @ViewBuilder
    func VerseView(bible: Bible) -> some View {
        HStack(spacing: 15) {
            
            VStack {
                Text(String(bible.verse))
                    .font(.callout.bold())
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
                
                Spacer()
            }
            
            Text(bible.word)
                .font(.system(size: readVM.fontSize))
                .foregroundColor(.primary)
                .lineSpacing(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                .sheet(isPresented: $showingSearch) {
                    searchView()
                }
            
            footerButton(image: "textformat.size.larger", purpose: "increaseFontSize")
            footerButton(image: "arrow.right", purpose: "nextChapter")
            Spacer()
        }
    }
    
    @ViewBuilder
    func searchView() -> some View {
        NavigationView {
            VStack {
                HStack {
                    Text("성경 구절 검색")
                        .font(.largeTitle.bold())
                    Spacer()
                    
                    Button {
                        showingSearch.toggle()
                    } label: {
                        
                        Text("X")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(15)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading, 8)
                    
                }
                .padding(.top, 20)
                
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("원하는 성경 구절을 입력하세요", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            print(searchText)
                            searchTextSubmitted.toggle()
                        }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(Color.primary.opacity(0.15))
                .cornerRadius(10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(searchFilteredBible, id: \.self) { verse in
                        NavigationLink {
                            
                        } label: {
                            HStack {
                                
                                Capsule()
                                    .fill(Color.primary)
                                    .frame(width: 3)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(verse.word)
                                        .font(.system(size: 20).bold())
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("\(verse.book) \(verse.chapter)장 \(verse.verse)절")
                                        .font(.system(size: 15).bold())
                                        .foregroundColor(.orange)
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
                .padding(.vertical, 10)
                
            }
            .padding()
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
                showingSearch.toggle()
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
        VStack {
            HStack {
                Text("언어 및 번역본")
                    .font(.title.bold())
                Spacer()
                
                Button {
                    showingLanguagePicker.toggle()
                } label: {
                    
                    Text("X")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(15)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 8)
                
            }
            .padding(.top, 20)
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(readVM.languageList, id: \.self) { language in
                        HStack {
                            Text(language)
                                .font(.system(size: 20).bold())
                                
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
    
//    func searchWordBook(book: String) -> String{
//
//
//
//
//        return bookname
//    }
    
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
        ContentView()
    }
}

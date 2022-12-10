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
                            .padding()
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
                            
                                if self.draggedOffset.width >= 10 && readVM.currentChapter > 1 {
                                    proxyReader.scrollTo(Self.topId, anchor: .top)
                                    readVM.currentChapter -= 1
                                    self.draggedOffset = CGSize.zero
                                } else if self.draggedOffset.width <= -10 && readVM.currentChapter < chapterCounter(currentBook: readVM.currentBook) {
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
            }
            
        }
        .frame(width: size.width * 0.95)
    }
    
    @ViewBuilder
    func bibleChapterView() -> some View {
        VStack {
            Text("\(readVM.currentBook) \(readVM.currentChapter)")
                .font(.system(size: 40))
                .padding(.top, 50)
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            
            VStack(spacing: 10) {
                
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

                        Spacer()
                    }
                    .id(chapter)
                    .padding(.bottom, 10)
                }
            }
            .padding()
            .padding(.bottom, 100)
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
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
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
                Text("\(readVM.currentBook) \(readVM.currentChapter)")
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
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
            
            Button {
                if readVM.currentChapter > 1{
                    readVM.currentChapter -= 1
                    
                    chapNum = readVM.currentChapter
                }
            } label: {
                Image(systemName: "arrow.left")
                    .padding(10)
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
            }
            .background(.primary.opacity(0.9))
            .buttonStyle(.bordered)
            .clipShape(Circle())
            .shadow(radius: 20)
            
            Button {
                if readVM.fontSize > 15 {
                    readVM.fontSize -= 5
                }
            } label: {
                Image(systemName: "textformat.size.smaller")
                    .padding(10)
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
            }
            .background(.primary)
            .buttonStyle(.bordered)
            .clipShape(Circle())
            .shadow(radius: 20)
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .padding(10)
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
            }
            .background(.primary)
            .buttonStyle(.bordered)
            .clipShape(Circle())
            .shadow(radius: 20)
            
            Button {
                if readVM.fontSize < 40 {
                    readVM.fontSize += 5
                }
            } label: {
                Image(systemName: "textformat.size.larger")
                    .padding(10)
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
            }
            .background(.primary)
            .buttonStyle(.bordered)
            .clipShape(Circle())
            .shadow(radius: 20)
            
            Button {
                if readVM.currentChapter < chapterCounter(currentBook: readVM.currentBook){
                    readVM.currentChapter += 1
                    
                    chapNum = readVM.currentChapter
                }
            } label: {
                Image(systemName: "arrow.right")
                    .padding(10)
                    .font(.system(size: 20).bold())
                    .foregroundColor(.pink)
            }
            .background(.primary)
            .buttonStyle(.bordered)
            .clipShape(Circle())
            .shadow(radius: 20)
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
    
    @ViewBuilder
    func bookPickView() -> some View {
        ScrollView(.vertical) {
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("구약성경")
                        .font(.system(size: 20).bold())
                        
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
                    }
                }
                
                if readVM.showOldList {
                    ForEach(readVM.old_testament, id: \.self) { item in
                        Button {
                            
                            if readVM.showSelectedBook == "" {
                                readVM.showSelectedBook = item
                                readVM.showChapterList.toggle()
                            } else {
                                readVM.showSelectedBook = ""
                                readVM.showChapterList.toggle()
                            }
                            
                        } label: {
                            HStack {
                                Text(item)
                                
                                Spacer()
                                
                                Image(systemName: readVM.showSelectedBook == item ? "chevron.down" : "chevron.right")
                            }
                            .foregroundColor(readVM.showSelectedBook == item ? .pink : .primary)
                        }
                        
                        if readVM.showSelectedBook == item && readVM.showChapterList {
                            
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
                                ForEach(1...chapterCounter(currentBook: item), id: \.self) { chapter in
                                    Button {
                                        readVM.currentBook = readVM.showSelectedBook
                                        readVM.currentChapter = chapter
                                        
                                        readVM.showSelectedBook = ""
                                        
                                        readVM.showChapterList = false
                                        readVM.showOldList = false
                                        readVM.showNewList = false
                                        showingBookPicker = false
                                    } label: {
                                        Text("\(chapter)")
                                            .foregroundColor(.primary)
                                            .padding(15)
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
                    Text("신약성경")
                        .font(.system(size: 20).bold())
                        
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
                        readVM.showNewList.toggle()
                    }
                }
                
                if readVM.showNewList {
                    ForEach(readVM.new_testament, id: \.self) { item in
                        Button {
                            
                            if readVM.showSelectedBook == "" {
                                readVM.showSelectedBook = item
                                readVM.showChapterList.toggle()
                            } else {
                                readVM.showSelectedBook = ""
                                readVM.showChapterList.toggle()
                            }
                            
                        } label: {
                            HStack {
                                Text(item)
                                
                                Spacer()
                                
                                Image(systemName: readVM.showSelectedBook == item ? "chevron.down" : "chevron.right")
                            }
                            .foregroundColor(readVM.showSelectedBook == item ? .pink : .primary)
                        }
                        
                        if readVM.showSelectedBook == item && readVM.showChapterList {
                            
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5)) {
                                ForEach(1...chapterCounter(currentBook: item), id: \.self) { chapter in
                                    Button {
                                        readVM.currentBook = readVM.showSelectedBook
                                        readVM.currentChapter = chapter
                                        
                                        readVM.showSelectedBook = ""
                                        
                                        readVM.showChapterList = false
                                        readVM.showOldList = false
                                        readVM.showNewList = false
                                        showingBookPicker = false
                                        
                                        
                                    } label: {
                                        Text("\(chapter)")
                                            .foregroundColor(.primary)
                                            .padding(15)
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
            .padding()
        }
    }
    
    @ViewBuilder
    func languagePickView() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(readVM.languageList, id: \.self) { language in
                    HStack {
                        Text(language)
                            .font(.system(size: 20).bold())
                            
                        Spacer()
                        
                        Image(systemName: readVM.showPickLanguage == language ? "chevron.down" : "chevron.right")
                            .foregroundColor(.pink)
                        
                    }
                    .onTapGesture {
                        withAnimation {
                            if readVM.showPickLanguage == "" {
                                readVM.showPickLanguage = language
                            } else {
                                readVM.showPickLanguage = ""
                            }
                        }
                    }
                    
                    if readVM.showPickLanguage == language {
                        
                        ForEach(readVM.showPickLanguage == "한글" ? readVM.krVersion : readVM.engVersion, id: \.self) { version in
                            Button {
                                readVM.currentVersion = version
                                showingLanguagePicker = false
                            } label : {
                                HStack {
                                    Text(version)
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                }
            }
            .padding()
        }
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

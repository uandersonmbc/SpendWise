import SwiftUI


enum DisplayMode {
    case list
    case grid
}

struct NoteListView: View {
    @StateObject var note = NoteService.shared
    @State var isOpenCreateList = false
    @State private var displayMode: DisplayMode = .grid
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 2)
    
    @Namespace var animation
    var body: some View {
        VStack {
            if displayMode == .list {
                List{
                    Section(header: HStack {
                        Text("My lists")
                        Spacer()
                        Button {
                            isOpenCreateList.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding(5)
                                .background(.green.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }){
                        ForEach(note.notes) { note in
                            NoteRow(note: note)
                        }
                        .onDelete(perform: deleteNote)
                    }
                }
            } else {
                ScrollView {
                    VStack{
                        HStack{
                            Text("MY LISTS")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                            Spacer()
                            Button {
                                isOpenCreateList.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .padding(5)
                                    .background(.green.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                        .padding(.vertical, -3)
                        .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(note.notes) { note in
                                NoteGrid(note: note)
                                    .contextMenu {
                                        Text("Show List Info")
                                        Text("Delete")
                                    } preview: {
                                        NoteGrid(note: note, preview: true)
                                    }
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .animation(.default, value: displayMode)
        .toolbar {
            ToolbarItemGroup {
                Picker("Display Mode", selection: $displayMode) {
                    Image(systemName: "list.bullet").tag(DisplayMode.list)
                    Image(systemName: "rectangle.grid.2x2").tag(DisplayMode.grid)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }
        }
        .sheet(isPresented: $isOpenCreateList){
            VStack{
                NoteCreateView(isOpenCreateList: $isOpenCreateList)
                    .interactiveDismissDisabled(true)
            }
        }
        .onAppear{
            note.getData()
        }
    }
    
    func deleteNote(at offset: IndexSet) {
        note.removeNote(offset: offset)
    }
}

#Preview {
    NavigationStack{
        NoteListView()
    }
}

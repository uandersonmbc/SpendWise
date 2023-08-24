import SwiftUI

struct NoteListView: View {
    @StateObject var note = NoteService.shared
    
    @State var isOpenCreateList = false
    @State var selectedNode: Note?
    @AppStorage("displayMode") var displayMode: String = "grid"
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 2)
    
    @Namespace var animation
    var body: some View {
        VStack {
            if displayMode == "list" {
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
                                .contextMenu(ContextMenu(menuItems: {
                                    Button{
                                        selectedNode = note
                                        isOpenCreateList.toggle()
                                    } label: {
                                        Label("Edit List", systemImage: "pencil")
                                    }
                                }))
                        }
                        .onDelete(perform: deleteNote)
                    }
                }
                .refreshable {
                    note.getData()
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
                                        Button{
                                            selectedNode = note
                                            isOpenCreateList.toggle()
                                        } label: {
                                            Label("Edit List", systemImage: "pencil")
                                        }
                                        Button{
                                            deleteNote(noteRemove: note)
                                        } label: {
                                            Label("Delte", systemImage: "trash")
                                        }
                                    } preview: {
                                        NoteGrid(note: note, preview: true)
                                    }
                            }
                        }
                    }
                    .padding(20)
                }
                .refreshable {
                    note.getData()
                }
            }
        }
        .animation(.default, value: displayMode)
        .toolbar {
            ToolbarItemGroup {
                Picker("Display Mode", selection: $displayMode) {
                    Image(systemName: "list.bullet").tag("list")
                    Image(systemName: "rectangle.grid.2x2").tag("grid")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
            }
        }
        .sheet(isPresented: $isOpenCreateList){
            VStack{
                NoteCreateView(noteEdit: $selectedNode, isOpenCreateList: $isOpenCreateList)
                    .interactiveDismissDisabled(true)
            }
        }
        .onAppear{
            note.getData()
        }
    }
    
    func deleteNote(noteRemove: Note) {
        if let index = note.notes.firstIndex(where: { $0.id == noteRemove.id }) {
            let path = "/notes/\(noteRemove.id)"
            APIService().get(endpoint: path) { (result: Result<NoteDelete, Error>) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        note.notes.remove(at: index)
                    }
                case .failure(_):
                    note.notes = note.notes
                }
            }
        }
    }
    
    func deleteNote(at offset: IndexSet) {
        let index = offset.first!
        let noteRemove = note.notes[index]
        let path = "/notes/\(noteRemove.id)"
        APIService().get(endpoint: path) { (result: Result<NoteDelete, Error>) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    note.notes.remove(atOffsets: offset)
                }
            case .failure(_):
                note.notes = note.notes
            }
        }
    }
}

#Preview {
    NavigationStack{
        NoteListView()
    }
}

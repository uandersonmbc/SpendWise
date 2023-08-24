import SwiftUI

struct DetailNoteView: View {
    var note: Note
    @Environment(\.colorScheme) var colorScheme
    @State private var openAddItem = false
    @State private var compledtedItems: [String] = []
    
    @StateObject var noteS = NoteService.shared
    
    @State private var isOpenAddItems = false
    
    var totalValue: Double {
        Double(note.items.reduce(0, { x, y in x + ((y.item.commercials.first?.price ?? 0) * y.quantity)}))
    }
    
    @State private var editItem = false
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    HStack {
                        Text("Total")
                        Spacer()
                        Text("R$ \(formatNumberToDecimal(value: totalValue / 100))")
                    }
                    
                    Section {
                        ForEach(note.items.filter { !compledtedItems.contains($0.id) }){ item in
                            DisclosureGroup {
                                VStack{
                                    ForEach(0..<item.item.commercials.count, id: \.self){ index in
                                        HStack{
                                            Text("\(item.item.commercials[index].commercialentity.name)")
                                            Spacer()
                                            Text("R$ \(formatNumberToDecimal(value: Double(item.item.commercials[index].price) / 100))")
                                        }
                                        .foregroundColor((index == 0) ? Color.green : Color.primary )
                                    }
                                }
                            } label: {
                                HStack{
                                    Button {
                                        withAnimation{
                                            compledtedItems.append(item.id)
                                        }
                                    } label: {
                                        Image(systemName: "circle").foregroundColor(Color(hex: "\(note.color)"))
                                    }
                                    .buttonStyle(.borderless)
                                    Text("\(item.quantity) - \(item.item.name)")
                                        .lineLimit(1)
                                    Spacer()
                                    Text("R$ \(formatNumberToDecimal(value: Double(item.item.commercials.first?.price ?? 0) / 100))")
                                }
                            }
                            .padding(.horizontal, -10)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                Button {
                                    deleteItem(id: item.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                Button {
                                    noteS.noteItem = item
                                    editItem.toggle()
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    
                    Section {
                        ForEach(note.items.filter { compledtedItems.contains($0.id) }){ item in
                            DisclosureGroup {
                                VStack{
                                    ForEach(0..<item.item.commercials.count, id: \.self){ index in
                                        HStack{
                                            Text("\(item.item.commercials[index].commercialentity.name)")
                                            
                                            Spacer()
                                            Text("R$ \(formatNumberToDecimal(value: Double(item.item.commercials[index].price) / 100))")
                                        }
                                        .foregroundColor((index == 0) ? Color.green : Color.primary )
                                    }
                                }
                            } label: {
                                HStack{
                                    Button {
                                        withAnimation{
                                            removeCompleted(item.id)
                                        }
                                    } label: {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "\(note.color)"))
                                    }
                                    .buttonStyle(.borderless)
                                    Text("\(item.quantity) - \(item.item.name)").opacity(0.4)
                                        .lineLimit(1)
                                    Spacer()
                                    Text("R$ \(formatNumberToDecimal(value: Double(item.item.commercials.first?.price ?? 0) / 100))")
                                        .opacity(0.4)
                                }
                            }
                            .padding(.horizontal, -10)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(note.title)")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            HStack{
                Spacer()
                Button {
                    isOpenAddItems.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color(hex: note.color))
                        .cornerRadius(50)
                }
                .padding(20)
            }
                .frame(maxWidth: .infinity)
            
            
            
            , alignment: .bottom)
        .sheet(isPresented: $isOpenAddItems, content: {
            SearchItemView(color: note.color, id: note.id, isOpenAddItems: $isOpenAddItems)
                .presentationDetents([.medium, .large])
                .interactiveDismissDisabled(true)
        })
        .sheet(isPresented: $editItem) {
            VStack{
                EditItemQuantity(editItem: $editItem, color: note.color)
            }
            .presentationDetents([.height(100)])
            .interactiveDismissDisabled(true)
        }
    }
    
    func deleteItem(id: String) {
        if let indexNote = noteS.notes.firstIndex(where: {$0.id == note.id}) {
            if let index = note.items.firstIndex(where: { $0.id == id }) {
                let path = "/notesitems/\(id)"
                APIService().get(endpoint: path) { (result: Result<NoteDelete, Error>) in
                    switch result {
                    case .success(_):
                        withAnimation{
                            DispatchQueue.main.async {
                                noteS.notes[indexNote].items.remove(at: index)
                            }
                        }
                    case .failure(_):
                        print("Error")
                    }
                }
            }
        }
    }
    
    func removeCompleted(_ id: String) {
        if let index = compledtedItems.firstIndex(of: id) {
            compledtedItems.remove(at: index)
        }
    }
}

#Preview {
    NavigationStack {
        DetailNoteView(note: .init(id: UUID().uuidString, title: "Jão pede feijao", icon: "sun", color: "#ff9e1c", items: [
            NoteItem(id: UUID().uuidString, quantity: 4, item: Item(id: UUID().uuidString, name: "Leite", code: "00", commercials: [
                CommercialEntityItem(id: UUID().uuidString, price: 423, commercialentity: CommercialEntity(id: UUID().uuidString, name: "Jean"))
            ]))
        ]))
    }
}

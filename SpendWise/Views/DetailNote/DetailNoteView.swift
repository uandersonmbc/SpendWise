import SwiftUI

struct DetailNoteView: View {
    var note: Note
    @Environment(\.colorScheme) var colorScheme
    @State private var openAddItem = false
    @State private var compledtedItems: [String] = []
    
    @State private var isOpenAddItems = false
    
    var totalValue: Double {
        Double(note.items.reduce(0, { x, y in x + (y.item.commercials[0].price * y.quantity)}))
    }
    
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
                            HStack{
                                Button {
                                    withAnimation{
                                        compledtedItems.append(item.id)
                                    }
                                } label: {
                                    Image(systemName: "circle").foregroundColor(Color(hex: "\(note.color)"))
                                }
                                Text("\(item.quantity) - \(item.item.name)")
                                Spacer()
                                Text("R$ \(formatNumberToDecimal(value: Double(item.item.commercials[0].price) / 100))")
                            }
                            .padding(.horizontal, -10)
                        }
                        .onDelete(perform: deleteItem)
                    }
                    
                    Section{
                        ForEach(note.items.filter { compledtedItems.contains($0.id) }){ item in
                            HStack{
                                Button{
                                    withAnimation{
                                        removeCompleted(item.id)
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "\(note.color)"))
                                }
                                Text("\(item.quantity) - \(item.item.name)")
                                    .opacity(0.4)
                                Spacer()
                                Text("R$ \(formatNumberToDecimal(value: Double(item.item.commercials[0].price) / 100))")
                                    .opacity(0.4)
                            }
                            .padding(.horizontal, -10)
                        }
                        .onDelete(perform: deleteItem)
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
            SearchItemView(color: note.color, id: note.id)
                .presentationDetents([.medium, .large])
        })
    }
    
    func deleteItem(at offsets: IndexSet) {
        
    }
    
    func removeCompleted(_ id: String) {
        if let index = compledtedItems.firstIndex(of: id) {
            compledtedItems.remove(at: index)
        }
    }
}

#Preview {
    NavigationStack {
        DetailNoteView(note: .init(id: UUID().uuidString, title: "Jão pede feijao", icon: "sun", color: "#53de42", items: []))
    }
}

import SwiftUI

struct SearchItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var note = NoteService.shared
    var color: String
    var id: String
    @State private var isLoading = false
    @State private var searchText = ""
    @State private var items: [ItemSearch] = []
    @State private var selectedItems: [NoteItemPayload] = []
    @State private var searchTimer: Timer?
    
    @Binding var isOpenAddItems: Bool
    
    
    var body: some View {
        VStack{
            HStack(){
                Button {
                    isOpenAddItems.toggle()
                } label: {
                    Image(systemName: "x.circle")
                        .font(.title2)
                        .foregroundColor(Color(hex: color))
                }
                Spacer()
                Button {
                    withAnimation {
                        addItems()
                        generateHapticFeedback()
                    }
                } label: {
                    Text("Add items")
                        .foregroundColor(selectedItems.count == 0 ? Color.gray : Color(hex: color))
                }
                .disabled(selectedItems.count == 0)
            }
            .padding()
            ScrollView {
                VStack{
                    VStack{
                        ForEach(0..<selectedItems.count, id: \.self) { index in
                            VStack{
                                HStack{
                                    Button{
                                        if selectedItems.count > 0 {
                                            withAnimation{
                                                removeCompleted(id: selectedItems[index].itemId)
                                                generateHapticFeedback()
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "checkmark.square.fill")
                                            .foregroundColor(Color(hex: color))
                                    }
                                    Text("\(selectedItems[index].name ?? "-")")
                                        .lineLimit(1)
                                    Spacer()
                                    Button {
                                        if selectedItems[index].quantity - 1 > 0 {
                                            selectedItems[index].quantity -= 1
                                        }
                                    } label: {
                                        Image(systemName: "minus")
                                    }
                                    Text("\(selectedItems[index].quantity)")
                                    Button {
                                        selectedItems[index].quantity += 1
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.vertical, 30)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .cornerRadius(10)
                .padding(.horizontal)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .padding()
                        if selectedItems.count == 0 {
                            Text("Add items to note").opacity(0.5)
                        }
                    }
                }
                .padding(.bottom)
                
                VStack{
                    TextField("Search by item", text: $searchText)
                        .padding()
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(hex: color))
                        .background(colorScheme == .light ? Color(hex: color)?.opacity(0.2) : Color("bg.grid.sub"))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                ForEach(items.filter { item in !selectedItems.contains { $0.itemId == item.id} }) { item in
                    VStack{
                        HStack{
                            Button{
                                withAnimation {
                                    selectedItems.append(NoteItemPayload(itemId: item.id, noteId: id, quantity: 1, name: item.name))
                                    generateHapticFeedback()
                                }
                            } label: {
                                Image(systemName: "square")
                                    .foregroundColor(Color(hex: color))
                            }
                            Text("\(item.name)")
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding()
                    }
                    .background(Color("bg.grid.sub"))
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .overlay {
                if isLoading {
                    ProgressView()
                } else {
                    Text("")
                }
            }
        }
        .background(Color("bg.gray6"))
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .onTapGesture {
            self.hideKeyboard()
        }
        .onAppear{
            isLoading = true
            APIService().get(endpoint: "/items", parameters: ["name" : searchText, "note_id": id]) { (result: Result<[ItemSearch], Error>) in
                isLoading = false
                
                switch result {
                case .success(let response):
                    items = response
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        .onChange(of: searchText) {  oldState, newState in
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                isLoading = true
                APIService().get(endpoint: "/items", parameters: ["name" : searchText, "note_id": id]) { (result: Result<[ItemSearch], Error>) in
                    isLoading = false
                    
                    switch result {
                    case .success(let response):
                        items = response
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
    
    func addItems() {
        if let jsonData = try? JSONEncoder().encode(selectedItems) {
            APIService().post(endpoint: "/notesitems", body: jsonData) { (result: Result<[NoteItem], Error>) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if let index = note.notes.firstIndex(where: { $0.id == id }) {
                            note.notes[index].items = response
                        }
                        isOpenAddItems.toggle()
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
    
    func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func removeCompleted(id: String) {
        if let index = selectedItems.firstIndex(where: { $0.itemId == id }) {
            selectedItems.remove(at: index)
        }
    }
}

#Preview {
    SearchItemView(color: "#ff9e1c", id: "", isOpenAddItems: .constant(true))
}

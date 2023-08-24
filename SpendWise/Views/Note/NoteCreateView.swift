import SwiftUI
import UIKit

struct NoteCreateView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var note = NoteService.shared
    @Binding var noteEdit: Note?
    @State private var title: String = ""
    @State private var selectedColor: String = colors[0]
    @State private var selectedIcon: String = systemIcons[0]
    @Binding var isOpenCreateList: Bool
    let columns = [GridItem(.adaptive(minimum: 40), spacing: 15)]
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack{
                HStack{
                    Button{
                        isOpenCreateList.toggle()
                        noteEdit = nil
                    } label: {
                        Image(systemName: "x.circle")
                            .font(.title2)
                            .foregroundColor(Color(hex: selectedColor))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: selectedIcon)
                        .foregroundColor(Color(hex: selectedColor))
                        .fontWeight(.bold)
                        .font(.title2)
                        .frame(height: 50)
                    
                    Button{
                        Task {
                            let notePayload = NotePayload(title: title, icon: selectedIcon, color: selectedColor, user_id: user_id)
                            if let jsonData = try? JSONEncoder().encode(notePayload) {
                                if noteEdit == nil {
                                    APIService().post(endpoint: "/notes", body: jsonData) { (result: Result<Note, Error>) in
                                        switch result {
                                        case .success(let response):
                                            DispatchQueue.main.async {
                                                note.notes.append(response)
                                                isOpenCreateList.toggle()
                                            }
                                        case .failure(let error):
                                            print("\(error)")
                                        }
                                    }
                                } else {
                                    let path = "/notes/\(noteEdit?.id ?? "")"
                                    APIService().put(endpoint: path, body: jsonData) { (result: Result<Note, Error>) in
                                        switch result {
                                        case .success(let response):
                                            DispatchQueue.main.async {
                                                if let index = note.notes.firstIndex(where: { $0.id == noteEdit?.id }) {
                                                    note.notes[index] = response
                                                }
                                                isOpenCreateList.toggle()
                                            }
                                        case .failure(let error):
                                            print("\(error)")
                                        }
                                    }
                                }
                            }
                        }
                        
                    } label: {
                        Text("Save")
                            .foregroundColor(title.isEmpty ? Color.gray : Color(hex: selectedColor))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(Color(hex: selectedColor))
                    .disabled(title.isEmpty)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView{
                    VStack (spacing: 40){
                        TextField("Title", text: $title)
                            .padding()
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(hex: selectedColor))
                            .background(Color("bg.grid.sub"))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                        
                        VStack{
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(colors, id: \.self) { color in
                                    Button(action: {
                                        selectedColor = color
                                        self.hideKeyboard()
                                        generateHapticFeedback()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(Color(hex: color))
                                                .frame(width: 50, height: 50)
                                            
                                            if selectedColor == color {
                                                Circle()
                                                    .foregroundColor(Color.white)
                                                    .frame(width: 20, height: 20)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            
                        }
                        .background(Color("bg.grid.sub"))
                        .cornerRadius(10)
                        
                        VStack{
                            ListIcons(selectedIcon: $selectedIcon, selectedColor: Color(hex: selectedColor) ?? .secondary)
                        }
                        .background(Color("bg.grid.sub"))
                        .cornerRadius(10)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
        }
        .background(colorScheme == .light ? Color(hex: selectedColor)?.opacity(0.2) : Color.clear)
        .ignoresSafeArea()
        .onTapGesture {
            self.hideKeyboard()
        }
        .onAppear{
            if noteEdit != nil {
                title = noteEdit?.title ?? ""
                selectedIcon = noteEdit?.icon ?? colors[0]
                selectedColor = noteEdit?.color ?? systemIcons[0]
            }
        }
    }
    
    func generateHapticFeedback() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
}

#Preview {
    NoteCreateView(noteEdit: .constant(nil), isOpenCreateList: .constant(true))
}

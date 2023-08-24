import SwiftUI

struct EditItemQuantity: View {
    @StateObject var note = NoteService.shared
    @Binding var editItem: Bool
    var color: String
    
    var body: some View {
        VStack{
            HStack(){
                Button {
                    editItem.toggle()
                } label: {
                    Image(systemName: "x.circle")
                        .font(.title2)
                        .foregroundColor(Color(hex: color))
                }
                Spacer()
                Button {
                    withAnimation {
                        generateHapticFeedback()
                    }
                } label: {
                    Text("Save")
                        .foregroundColor(Color(hex: color))
                }
            }
            .padding(.top)
            .padding(.bottom, 10)
            .padding(.horizontal)
            
            VStack {
            HStack {
                Text("\(note.noteItem?.item.name ?? "-")")
                    .lineLimit(1)
                Spacer()
                Button {
                    if (note.noteItem?.quantity ?? 1) - 1 > 0 {
                        note.noteItem?.quantity -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                }
                Text("\(note.noteItem?.quantity ?? 0)")
                Button {
                    note.noteItem?.quantity += 1
                } label: {
                    Image(systemName: "plus")
                }
            }
            .padding()
            }
            .background(Color("bg.grid.sub"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            Spacer()
        }
    }
    
    func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview {
    EditItemQuantity(editItem: .constant(true), color: "#ff9e1c")
}

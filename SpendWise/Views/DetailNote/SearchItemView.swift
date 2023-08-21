import SwiftUI

struct SearchItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var note = NoteService.shared
    var color: String
    var id: String
    @State private var itemName = ""
    var body: some View {
        VStack{
            VStack{
                TextField("Title", text: $itemName)
                    .padding()
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(hex: color))
                    .background(Color("bg.grid.sub"))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
            }
            .padding()
            ScrollView {
                ForEach(0..<5) { index in
                    VStack{
                        Text("Item \(index)")
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                Button {
                    Task {
                        note.updateNote(id: id)
                    }
                } label: {
                    Text("add")
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background(colorScheme == .light ? Color(hex: color)?.opacity(0.2) : Color.clear)
        .ignoresSafeArea()
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

#Preview {
    SearchItemView(color: "#3e42ed", id: "")
}

import SwiftUI

struct NoteGrid: View {
    var note: Note
    @Environment(\.colorScheme) var colorScheme
    var preview = false
    
    var body: some View {
        NavigationLink(destination: DetailNoteView()){
            VStack{
                VStack{
                    HStack {
                        Image(systemName: note.icon)
                            .foregroundColor(Color(hex: "\(note.color)"))
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Spacer()
                        if note.notesItems.count > 0 {
                            Text("\(note.notesItems.count)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    HStack {
                        Text(note.name)
                            .foregroundColor(Color(hex: "\(note.color)"))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    
                    if !note.notesItems.isEmpty {
                        VStack {
                            VStack{
                                ForEach(note.notesItems.prefix(preview ? note.notesItems.count : 3)){ noteItem in
                                    HStack {
                                        Circle()
                                            .foregroundColor(Color(hex: "\(note.color)"))
                                            .frame(height: 8)
                                        Text("\(noteItem.item.name)")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                            .padding(-4)
                                    }
                                    .padding(.horizontal, 6)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .background(Color("bg.grid.sub"))
                        .cornerRadius(8.0)
                        .padding(.horizontal, 10)
                        .padding(.top, -10)
                        .padding(.bottom, 10)
                    }
                }
                .background(colorScheme == .dark ? Color("bg.grid") : Color(hex: "\(note.color)")?.opacity(0.3))
                .cornerRadius(10.0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .foregroundColor(.primary)
        .frame(minWidth: (UIScreen.main.bounds.width / 2) - 30)
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            NoteGrid(note: .init(id: UUID().uuidString, name: "Test", icon: "list.bullet", color: "#234ed4", notesItems: []))
        }
    }
}

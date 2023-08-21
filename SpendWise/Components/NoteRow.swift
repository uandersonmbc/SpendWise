import SwiftUI

struct NoteRow: View {
    var note: Note
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: DetailNoteView(note: note)){
            HStack {
                Image(systemName: note.icon)
                    .foregroundColor(Color(hex: "\(note.color)"))
                Text(note.title)
                Spacer()
                if note.items.count > 0 {
                    Text("\(note.items.count)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        List{
            NoteRow(note: .init(id: UUID().uuidString, title: "Test", icon: "list.bullet", color: "#62de13", items: []))
        }
    }
}

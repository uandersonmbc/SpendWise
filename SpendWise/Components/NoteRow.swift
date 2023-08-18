import SwiftUI

struct NoteRow: View {
    var note: Note
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: DetailNoteView()){
            HStack {
                Image(systemName: note.icon)
                Text(note.name)
                Spacer()
                if note.notesItems.count > 0 {
                    Text("\(note.notesItems.count)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        List{
            NoteRow(note: .init(id: UUID().uuidString, name: "Test", icon: "list.bullet", color: "#62de13", notesItems: []))
        }
    }
}

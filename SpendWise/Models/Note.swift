import Foundation

struct Note: Identifiable {
    var id: String
    var name: String
    var icon: String
    var color: String
    
    var notesItems: [NoteItem]
}

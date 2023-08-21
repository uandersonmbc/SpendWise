import Foundation

struct Note: Decodable, Identifiable {
    var id: String
    var name: String?
    var title: String
    var icon: String
    var color: String
    
    var items: [NoteItem]
}

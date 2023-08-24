import Foundation

struct Note: Decodable, Identifiable {
    var id: String
    var title: String
    var icon: String
    var color: String
    
    var items: [NoteItem]
}

struct NotePayload: Codable {
    var title: String
    var icon: String
    var color: String
    var user_id: String
}

struct NoteDelete: Decodable {
    
}

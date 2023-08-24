import Foundation

struct NoteItem: Decodable, Identifiable {
    var id: String
    var quantity: Int
    
    var item: Item
}

struct NoteItemPayload: Codable {
    var itemId: String
    var noteId: String
    var quantity: Int
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case noteId = "note_id"
        case quantity
    }
}

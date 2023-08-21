import Foundation

struct NoteItem: Decodable, Identifiable {
    var id: String
    var quantity: Int
    
    var item: Item
}

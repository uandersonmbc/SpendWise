import Foundation

struct CommercialEntityItem: Decodable, Identifiable {
    var id: String
    var price: Int
    
    var commercialentity: CommercialEntity
}

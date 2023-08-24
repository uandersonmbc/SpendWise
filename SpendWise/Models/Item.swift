import Foundation

struct Item: Decodable, Identifiable {
    var id: String
    var name: String
    var code: String
    
    var commercials: [CommercialEntityItem]
}

struct ItemSearch: Decodable, Identifiable {
    var id: String
    var name: String
    var code: String
}

import Foundation

struct Item: Identifiable {
    var id: String
    var name: String
    var code: String
    
    var commercialEntities: [CommercialEntity]
}

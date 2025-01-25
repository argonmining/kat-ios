import Foundation

struct NFTInfo: Codable {
    let name: String
    let description: String
    var image: String
    let edition: Int
    let attributes: [NFTAttribute]
}

struct NFTAttribute: Codable, Hashable {
    let traitType: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value
    }
}

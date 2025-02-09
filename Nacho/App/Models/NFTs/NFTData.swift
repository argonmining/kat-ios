import Foundation

struct NFTData: Hashable {

    let name: String
    let image: String
    let edition: Int
    let rarity: NFTRarity

    static func == (lhs: NFTData, rhs: NFTData) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.image == rhs.image &&
            lhs.edition == rhs.edition
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(image)
        hasher.combine(edition)
    }
}

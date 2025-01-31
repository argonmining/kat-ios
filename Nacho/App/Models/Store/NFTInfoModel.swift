import Foundation
import SwiftData

@Model
final class NFTInfoModel {

    var name: String
    var image: String
    var edition: Int
    var attributes: [NFTAttribute]
    var visualRarity: Double
    var overallRarity: Double
    var visualRarityPosition: Int
    var overallRarityPosition: Int

    init(
        name: String,
        image: String,
        edition: Int,
        attributes: [NFTAttribute],
        visualRarity: Double,
        overallRarity: Double,
        visualRarityPosition: Int,
        overallRarityPosition: Int
    ) {
        self.name = name
        self.image = image
        self.edition = edition
        self.attributes = attributes
        self.visualRarity = visualRarity
        self.overallRarity = overallRarity
        self.visualRarityPosition = visualRarityPosition
        self.overallRarityPosition = overallRarityPosition
    }
}

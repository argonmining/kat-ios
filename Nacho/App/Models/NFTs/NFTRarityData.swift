import Foundation

struct NFTCollection: Decodable {

    let collectionInfo: CollectionInfo
    let traitRarity: [String: [String: TraitInfo]]
    let nftRarity: [String: NFTRarity]

    enum CodingKeys: String, CodingKey {
        case collectionInfo = "collection_info"
        case traitRarity = "trait_rarity"
        case nftRarity = "nft_rarity"
    }
}

struct CollectionInfo: Decodable {
    let totalSupply: Int
    let traitTypes: [String]
    let rarityDistribution: [String: Int]

    enum CodingKeys: String, CodingKey {
        case totalSupply = "total_supply"
        case traitTypes = "trait_types"
        case rarityDistribution = "rarity_distribution"
    }
}

struct TraitInfo: Decodable {
    let count: Int
    let percentage: Double
    let rarityTier: String

    enum CodingKeys: String, CodingKey {
        case count
        case percentage
        case rarityTier = "rarity_tier"
    }
}

struct NFTRarity: Decodable {
    let rarityScore: Double
    let rarityMetrics: RarityMetrics
    let isSpecial: Bool
    let rarityTier: String
    let rank: Int
    let traitBreakdown: [TraitBreakdown]

    enum CodingKeys: String, CodingKey {
        case rarityScore = "rarity_score"
        case rarityMetrics = "rarity_metrics"
        case isSpecial = "is_special"
        case rarityTier = "rarity_tier"
        case rank
        case traitBreakdown = "trait_breakdown"
    }

    init(
        rarityScore: Double,
        rarityMetrics: RarityMetrics,
        isSpecial: Bool,
        rarityTier: String,
        rank: Int,
        traitBreakdown: [TraitBreakdown]
    ) {
        self.rarityScore = rarityScore
        self.rarityMetrics = rarityMetrics
        self.isSpecial = isSpecial
        self.rarityTier = rarityTier
        self.rank = rank
        self.traitBreakdown = traitBreakdown
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rarityScore = try container.decode(Double.self, forKey: .rarityScore)
        rarityMetrics = try container.decode(RarityMetrics.self, forKey: .rarityMetrics)
        rarityTier = try container.decode(String.self, forKey: .rarityTier)
        rank = try container.decode(Int.self, forKey: .rank)
        traitBreakdown = try container.decode([TraitBreakdown].self, forKey: .traitBreakdown)

        // Handle is_special as String or Bool
        if let boolValue = try? container.decode(Bool.self, forKey: .isSpecial) {
            isSpecial = boolValue
        } else if let stringValue = try? container.decode(String.self, forKey: .isSpecial) {
            isSpecial = stringValue.lowercased() == "true"
        } else {
            isSpecial = false // Default value
        }
    }
}

struct RarityMetrics: Decodable {
    let statisticalRarity: Double
    let traitRarity: Double
    let weightedAverage: Double

    enum CodingKeys: String, CodingKey {
        case statisticalRarity = "statistical_rarity"
        case traitRarity = "trait_rarity"
        case weightedAverage = "weighted_average"
    }

    init(statisticalRarity: Double, traitRarity: Double, weightedAverage: Double) {
        self.statisticalRarity = statisticalRarity
        self.traitRarity = traitRarity
        self.weightedAverage = weightedAverage
    }
}

struct TraitBreakdown: Decodable, Hashable {
    let traitType: String
    let value: String
    let percentage: Double
    let traitScore: Double
    let weight: Double
    let weightedScore: Double
    let rarityTier: String

    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value
        case percentage
        case traitScore = "trait_score"
        case weight
        case weightedScore = "weighted_score"
        case rarityTier = "rarity_tier"
    }
}

import Foundation

struct MintInfo: Decodable, Identifiable {
    let id: UUID = UUID()
    let tick: String
    let mintTotal: Double
}

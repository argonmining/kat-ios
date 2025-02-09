import Foundation

struct AddressNFTInfoDTO: Decodable, Hashable {

    let tick: String
    let buri: String
    let tokenId: String
    let opScoreMod: String

    init(
        tick: String,
        buri: String,
        tokenId: String,
        opScoreMod: String
    ) {
        self.tick = tick
        self.buri = buri
        self.tokenId = tokenId
        self.opScoreMod = opScoreMod
    }
}

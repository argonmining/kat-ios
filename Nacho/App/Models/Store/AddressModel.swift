import Foundation
import SwiftData

@Model
final class AddressModel {

    var address: String
    var contentTypes: [AddressModel.ContentType]

    init(address: String, contentTypes: [AddressModel.ContentType]) {
        self.address = address
        self.contentTypes = contentTypes
    }
}

extension AddressModel {

    enum ContentType: String, Codable {
        case none
        case tokens
        case nfts
        case miners
    }
}

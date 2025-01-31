import SwiftData

protocol DataProvidable: AnyObject {
    func getNFTs() throws -> [NFTInfoModel]
    func set(nftInfo: NFTInfoModel) throws
    func set(nftInfos: [NFTInfoModel]) throws
}

class DataProvider: DataProvidable {

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getNFTs() throws -> [NFTInfoModel] {
        return try context.fetch(FetchDescriptor<NFTInfoModel>())
    }

    func set(nftInfo: NFTInfoModel) throws {
        context.insert(nftInfo)
        try context.save()
    }

    func set(nftInfos: [NFTInfoModel]) throws {
        for item in nftInfos {
            try set(nftInfo: item)
        }
    }
}

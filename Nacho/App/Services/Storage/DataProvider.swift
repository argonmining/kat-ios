import SwiftData

protocol DataProvidable: AnyObject {
    func getNFTs() async throws -> [NFTInfoModel]
    func set(nftInfo: NFTInfoModel) async throws
    func set(nftInfos: [NFTInfoModel]) async throws
}

@ModelActor
final actor DataProvider: DataProvidable, Sendable {

    private var context: ModelContext { modelExecutor.modelContext }
    
    func getNFTs() throws -> [NFTInfoModel] {
        return try context.fetch(FetchDescriptor<NFTInfoModel>())
    }

    func set(nftInfo: NFTInfoModel) throws {
        context.insert(nftInfo)
        try context.save()
    }

    func set(nftInfos: [NFTInfoModel]) throws {
        for item in nftInfos {
            context.insert(item)
        }
        try context.save()
    }
}

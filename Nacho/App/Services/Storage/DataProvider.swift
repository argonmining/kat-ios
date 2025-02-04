import SwiftData

protocol DataProvidable: AnyObject {
    // Addresses
    func getAddresses() async throws -> [AddressModel]
    func set(address: AddressModel) async throws
    func delete(address: AddressModel) async throws

    // NFTs
    func getNFTs() async throws -> [NFTInfoModel]
    func set(nftInfo: NFTInfoModel) async throws
    func set(nftInfos: [NFTInfoModel]) async throws
}

@ModelActor
final actor DataProvider: DataProvidable, Sendable {

    private var context: ModelContext { modelExecutor.modelContext }

    // MARK: Addresses
    func getAddresses() async throws -> [AddressModel] {
        return try context.fetch(FetchDescriptor<AddressModel>())
    }

    func set(address: AddressModel) async throws {
        context.insert(address)
        try context.save()
    }

    func delete(address: AddressModel) async throws {
        context.delete(address)
        try context.save()
    }

    // MARK: NFTs

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

class MockDataProvider: DataProvidable {

    private var addresses: [AddressModel] = []

    func getAddresses() async throws -> [AddressModel] {
        return addresses
    }

    func set(address: AddressModel) async throws {
        addresses.append(address)
    }

    func delete(address: AddressModel) async throws {
        addresses.removeAll { $0.address == address.address }
    }

    func getNFTs() throws -> [NFTInfoModel] {
        return []
    }

    func set(nftInfo: NFTInfoModel) throws { }

    func set(nftInfos: [NFTInfoModel]) throws { }
}

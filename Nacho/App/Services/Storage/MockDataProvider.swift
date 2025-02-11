class MockDataProvider: DataProvidable {

    private var addresses: [AddressModel] = [
        .init(address: "kaspa:qpq6lt496v9lvcmc744hfe5m6cl5e33qfuasmjq205gsf50xjm2nwy9er5h56", contentTypes: [.tokens, .nfts, .miners]),
        .init(address: "kaspa:qpz2vgvlxhmyhmt22h538pjzmvvd52nuut80y5zulgpvyerlskvvwm7n4uk5a", contentTypes: [.tokens, .nfts, .miners])
    ]

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

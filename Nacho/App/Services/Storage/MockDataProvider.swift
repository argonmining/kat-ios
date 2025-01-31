class MockDataProvider: DataProvidable {

    func getNFTs() throws -> [NFTInfoModel] {
        return []
    }

    func set(nftInfo: NFTInfoModel) throws { }

    func set(nftInfos: [NFTInfoModel]) throws { }
}

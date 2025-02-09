import SwiftUI
import Observation

@Observable
final class NFTsViewModel {

    var isCollectionLoading: Bool = false
    var isNFTsLoading: Bool = false
    var isSortingSelected = true
    var collectionInfo: NFTCollectionInfo?
    var nftCollection: NFTCollection?
    var nfts: [NFTData] = []
    var filteredNfts: [NFTData] = []
    var showGame: Bool = false
    var searchText: String = ""
    var memoryGameViewModel: MemoryGameViewModel?

    var addressModels: [AddressModel] = []
    var addressNFTs: [String: [AddressNFTInfoDTO]] = [:]
    var addressesLoading: Bool = false
    var showAddresses: Bool = false
    var addressNFTsViewPresented: Bool = false
    var selectedAddress: String? = nil

    private let networkService: NetworkServiceProvidable
    private let dataProvider: DataProvidable

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        self.networkService = networkService
        self.dataProvider = dataProvider
        memoryGameViewModel = MemoryGameViewModel(images: ["nft1", "nft2", "nft3", "nft4", "nft5", "nft6"])
        isNFTsLoading = true
        checkAddresses()
        Task {
            do {
                let nftCollection = try await loadNFTCollectionData(from: "nft_rarity_data")
                nfts = nftCollection.nftRarity.compactMap { key, value in
                    guard let edition = Int(key) else { return nil }
                    return NFTData(
                        name: "Nacho Kats #\(key)",
                        image: "/NACHO/\(key)",
                        edition: edition,
                        rarity: value
                    )
                }
                nfts.sort { $0.rarity.rank < $1.rarity.rank }
                await MainActor.run {
                    filteredNfts = nfts
                    isNFTsLoading = false
                }
            } catch {
                print("Error loading NFT collection: \(error)")
                await MainActor.run {
                    isNFTsLoading = false
                }
            }
        }
    }

    func filteredNFTsForAddress(_ address: String) -> [NFTData] {
        guard let _addressNFTs = addressNFTs[address] else { return [] }
        var result: [NFTData] = []
        for nft in _addressNFTs {
            let _nfts = nfts.filter({ String($0.edition) == nft.tokenId })
            guard let _nft = _nfts.first else { continue }
            result.append(_nft)
        }
        return result
    }

    func sortNFTs() {
        if isSortingSelected {
            isSortingSelected = false
            nfts.sort { $0.edition < $1.edition }
        } else {
            isSortingSelected = true
            nfts.sort { $0.rarity.rank < $1.rarity.rank }
        }
        filteredNfts = nfts
    }

    func filterNFTs() {
        guard !searchText.isEmpty else {
            filteredNfts = nfts
            return
        }
        filteredNfts = nfts.filter {
            String($0.edition) == searchText.lowercased()
        }
    }

    func fetchNachoCollection() async {
        isCollectionLoading = true
        do {
            let collectionInfo = try await networkService.fetchNFTCollectionInfo(ticker: "NACHO")
            await MainActor.run {
                isCollectionLoading = false
                self.collectionInfo = collectionInfo
            }
        } catch {
            isCollectionLoading = false
            // TODO: Add error handling
            print(error)
        }
    }

    func fetchAddressNFTs(_ addresses: [String]) async {
        await withTaskGroup(of: (String, [AddressNFTInfoDTO]?).self) { group in
            for address in addresses {
                group.addTask { [weak self] in
                    do {
                        let nfts = try await self?.networkService.fetchAddressNFTs(address: address)
                        return (address, nfts?.filter({ $0.tick == "NACHO" }) ?? [])
                    } catch {
                        print("Failed to fetch NFTs for address \(address): \(error)")
                        return (address, nil)
                    }
                }
            }
            var results: [String: [AddressNFTInfoDTO]] = [:]
            for await (address, nfts) in group {
                if let nfts = nfts {
                    results[address] = nfts
                }
            }
            self.addressNFTs = results
        }
    }

    func checkAddresses() {
        addressesLoading = true
        Task {
            do {
                let addressModels = try await self.dataProvider.getAddresses().filter { $0.contentTypes.contains(.nfts) }
                if !addressModels.isEmpty {
                    await MainActor.run {
                        showAddresses = true
                    }
                } else {
                    await MainActor.run {
                        showAddresses = false
                    }
                }
                await self.fetchAddressNFTs(addressModels.compactMap(\.address))
                await MainActor.run {
                    self.addressModels = addressModels
                    addressesLoading = false
                }
            } catch {
                // TODO: Add error handling
                print("Error: \(error)")
                await MainActor.run {
                    showAddresses = false
                    addressesLoading = false
                }
            }
        }
    }

    private func loadNFTCollectionData(from fileName: String) async throws -> NFTCollection {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                    continuation.resume(throwing: NSError(domain: "FileNotFound", code: 404, userInfo: nil))
                    return
                }
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let nftCollection = try decoder.decode(NFTCollection.self, from: data)
                    continuation.resume(returning: nftCollection)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

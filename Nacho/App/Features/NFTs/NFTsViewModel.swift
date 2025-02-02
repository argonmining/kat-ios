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
    private let networkService: NetworkServiceProvidable
    private let dataProvider: DataProvidable

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        self.networkService = networkService
        self.dataProvider = dataProvider
        memoryGameViewModel = MemoryGameViewModel(images: ["nft1", "nft2", "nft3", "nft4", "nft5", "nft6"])
        isNFTsLoading = true
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

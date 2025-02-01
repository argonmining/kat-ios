import SwiftUI
import Observation

@Observable
final class NFTsViewModel {

    var isCollectionLoading: Bool = false
    var isNFTsLoading: Bool = false
    var isSortingSelected = true
    var collectionInfo: NFTCollectionInfo?
    var nfts: [NFTInfo] = []
    var nftInfoModels: [NFTInfoModel] = []
    var filteredNFTs: [NFTInfoModel] = []
    var showGame: Bool = false
    var searchText: String = ""
    var memoryGameViewModel: MemoryGameViewModel?
    private var loadedNFTsSet: Set<Int> = []
    private var currentIndex = 0
    private let networkService: NetworkServiceProvidable
    private let dataProvider: DataProvidable

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        print("INIT NFT MODEL")
        self.networkService = networkService
        self.dataProvider = dataProvider
        memoryGameViewModel = MemoryGameViewModel(images: ["nft1", "nft2", "nft3", "nft4", "nft5", "nft6"])
    }

    func sortNFTs() {
        if isSortingSelected {
            isSortingSelected = false
            nftInfoModels.sort { $0.edition < $1.edition }
        } else {
            isSortingSelected = true
            nftInfoModels.sort { $0.overallRarityPosition < $1.overallRarityPosition }
        }
        filteredNFTs = nftInfoModels
    }

    func filterNFTs() {
        guard !searchText.isEmpty else {
            filteredNFTs = nftInfoModels
            return
        }
        filteredNFTs = nftInfoModels.filter {
            String($0.edition) == searchText.lowercased()
        }
    }

    func fetchNachoCollection() async {
        guard filteredNFTs.isEmpty else { return }
        isCollectionLoading = true
        do {
            let collectionInfo = try await networkService.fetchNFTCollectionInfo(ticker: "NACHO")
            await loadNFTsFromStorage()
            if nftInfoModels.count < collectionInfo.max {
                Notifications.presentTopMessage("⌛ We are fetching more Nacho NFTs, it might take a while, please stay on the current Tab and don't close the app", duration: 7)
                await batchFetchNFTs(collectionInfo: collectionInfo)
            } else {
                filteredNFTs = nftInfoModels
            }
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

    private func batchFetchNFTs(collectionInfo: NFTCollectionInfo) async {
        let limit = collectionInfo.max
        guard
            limit > 0,
            let hash = collectionInfo.buri.components(separatedBy: "://").last,
            !hash.isEmpty
        else { return }

        isNFTsLoading = true
        let batchSize = 1000
        let minCountForDelay = batchSize / 2

        while currentIndex < limit {
            var requestsCount = 0
            await withTaskGroup(of: NFTInfo?.self) { taskGroup in
                let endIndex = min(currentIndex + batchSize, limit)

                for i in currentIndex+1...endIndex {
                    guard !loadedNFTsSet.contains(i) else {
                        self.currentIndex += 1
                        continue
                    }
                    taskGroup.addTask {
                        do {
                            return try await self.networkService.fetchNFTInfo(hash: "NACHO", index: i)
                        } catch {
                            print("Failed to fetch NFT for index \(i): \(error)")
                            return nil
                        }
                    }
                }

                
                for await result in taskGroup {
                    if var nft = result {
                        nft.image = "/NACHO/" + String(nft.edition)
                        self.nfts.append(nft)
                    }
                    self.currentIndex += 1
                    requestsCount += 1
                }
            }

            if currentIndex < limit && requestsCount >= minCountForDelay {
                print("Batch completed, waiting 1 second before next batch...")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }

        Task {
            await self.groupNFTs()
        }
    }

    private func loadNFTsFromStorage() async {
        do {
            nftInfoModels = try await dataProvider.getNFTs()
            for item in nftInfoModels {
                loadedNFTsSet.insert(item.edition)
                nfts.append(
                    .init(
                        name: item.name,
                        description: "",
                        image: item.image,
                        edition: item.edition,
                        attributes: item.attributes
                    )
                )
            }
            print("--- 1 ---")
            print(nftInfoModels.count)
        } catch {
            print(error)
        }
    }

    

    private func fetchNFTInfo(hash: String, index: Int) async {
        guard index > currentIndex else { return }
        do {
            let nftInfo = try await networkService.fetchNFTInfo(hash: hash, index: index)
            await MainActor.run {
                self.nfts.append(nftInfo)
                self.currentIndex += 1
            }
        } catch {
            // TODO: Add error handling
            print(error)
        }
    }

    private func groupNFTs() async {
        defer {
            isNFTsLoading = false
        }
        guard !nfts.isEmpty else { return }

        var traitCounts: [String: Int] = [:]
        var visualTraitCounts: [String: Int] = [:]
        let totalNFTs = Double(nfts.count)

        let excludedVisualTraits: Set<String> = ["Realm", "Type", "Role"]

        // Count occurrences of each trait
        for nft in nfts {
            for attr in nft.attributes {
                let key = "\(attr.traitType)-\(attr.value)"
                traitCounts[key, default: 0] += 1
                
                if !excludedVisualTraits.contains(attr.traitType) {
                    visualTraitCounts[key, default: 0] += 1
                }
            }
        }

        for nft in nfts {
            guard !loadedNFTsSet.contains(nft.edition) else { continue }

            var overallRarity: Double = 0
            var visualRarity: Double = 0

            for attr in nft.attributes {
                let key = "\(attr.traitType)-\(attr.value)"

                // Rarity calculation: Frequency-based (lower frequency = rarer)
                if let count = traitCounts[key] {
                    let rarityScore = 1.0 / (Double(count) / totalNFTs)
                    overallRarity += rarityScore
                }

                if !excludedVisualTraits.contains(attr.traitType),
                   let count = visualTraitCounts[key] {
                    let rarityScore = 1.0 / (Double(count) / totalNFTs)
                    visualRarity += rarityScore
                }
            }

            let model = NFTInfoModel(
                name: nft.name,
                image: nft.image,
                edition: nft.edition,
                attributes: nft.attributes,
                visualRarity: visualRarity,
                overallRarity: overallRarity,
                visualRarityPosition: 0,
                overallRarityPosition: 0
            )
            nftInfoModels.append(model)
        }

        await sortByRarity()
    }

    private func sortByRarity() async {
        nftInfoModels.sort { $0.visualRarity > $1.visualRarity }
        for i in 0..<nftInfoModels.count {
            nftInfoModels[i].visualRarityPosition = i + 1
        }

        nftInfoModels.sort { $0.overallRarity > $1.overallRarity }
        for i in 0..<nftInfoModels.count {
            nftInfoModels[i].overallRarityPosition = i + 1
        }

        for model in nftInfoModels {
            do {
                try await self.dataProvider.set(nftInfo: model)
            } catch {
                print(" --- ERROR ---")
                print(error.localizedDescription)
            }
        }

        filteredNFTs = nftInfoModels
    }
}

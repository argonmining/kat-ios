import SwiftUI
import Observation

@Observable
final class NFTsViewModel {

    var isCollectionLoading: Bool = false
    var isNFTsLoading: Bool = false
    var collectionInfo: NFTCollectionInfo?
    var nfts: [NFTInfo] = []
    var showGame: Bool = false
    var memoryGameViewModel: MemoryGameViewModel?
    private var currentIndex = 0
    private let networkService: NetworkServiceProvidable

    init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
        memoryGameViewModel = MemoryGameViewModel(images: ["nft1", "nft2", "nft3", "nft4", "nft5", "nft6"])
    }

    func fetchNachoCollection() async {
        isCollectionLoading = true
        do {
            let collectionInfo = try await networkService.fetchNFTCollectionInfo(ticker: "NKTTWO")
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

    func batchFetchNFTs() async {
        guard
            let limit = collectionInfo?.max,
            limit > 0,
            currentIndex == 0,
            let hash = collectionInfo?.buri.components(separatedBy: "://").last,
            !hash.isEmpty
        else { return }

        isNFTsLoading = true
        await withTaskGroup(of: NFTInfo?.self) { taskGroup in
            for i in 1...limit {
                taskGroup.addTask {
                    do {
                        return try await self.networkService.fetchNFTInfo(hash: hash, index: i)
                    } catch {
                        print("Failed to fetch NFT for index \(i): \(error)")
                        return nil
                    }
                }
            }

            for await result in taskGroup {
                if var nft = result {
                    self.currentIndex += 1
                    nft.image = String(nft.edition)
                    self.nfts.append(nft)
                }
            }

            self.nfts.sort { $0.edition < $1.edition }
            self.isNFTsLoading = false
            self.groupNFTs()
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

    private func groupNFTs() {
        var heads: Set<String> = []
        var faces: Set<String> = []
        var moods: Set<String> = []
        var collars: Set<String> = []
        var outfits: Set<String> = []
        var roles: Set<String> = []
        var tails: Set<String> = []
        var backgrounds: Set<String> = []
        var groupedNFTs: [String: [NFTInfo]] = [:]

        for nft in nfts {
            if let head = NFTStyleItem.head.style(from: nft.attributes) {
                heads.insert(head)
            }
            if let face = NFTStyleItem.face.style(from: nft.attributes) {
                faces.insert(face)
            }
            if let mood = NFTStyleItem.mood.style(from: nft.attributes) {
                moods.insert(mood)
            }
            if let collar = NFTStyleItem.collar.style(from: nft.attributes) {
                collars.insert(collar)
            }
            if let outfit = NFTStyleItem.outfit.style(from: nft.attributes) {
                outfits.insert(outfit)
            }
            if let role = NFTStyleItem.role.style(from: nft.attributes) {
                roles.insert(role)
            }
            if let tail = NFTStyleItem.tail.style(from: nft.attributes) {
                tails.insert(tail)
            }
            if let background = NFTStyleItem.background.style(from: nft.attributes) {
                backgrounds.insert(background)
            }
            let id = NFTStyleItem.imageUniqueId(from: nft.attributes)
            if groupedNFTs[id] == nil {
                groupedNFTs[id] = [nft]
            } else {
                groupedNFTs[id]?.append(nft)
            }
        }
    }
}

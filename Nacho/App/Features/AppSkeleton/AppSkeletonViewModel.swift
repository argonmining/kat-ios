import SwiftUI
import Observation

@Observable
final class AppSkeletonViewModel {

    let homeViewModel: HomeViewModel
    let katScanViewModel: KatScanViewModel
    let katPoolViewModel: KatPoolViewModel
    let nftsViewModel: NFTsViewModel

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        print("APP SKELETON INIT")
        homeViewModel = HomeViewModel(networkService: networkService)
        katScanViewModel = KatScanViewModel(networkService: networkService)
        katPoolViewModel = KatPoolViewModel(networkService: networkService)
        nftsViewModel = NFTsViewModel(
            networkService: networkService,
            dataProvider: dataProvider
        )
    }
}

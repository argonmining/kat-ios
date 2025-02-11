import SwiftUI
import Observation

@Observable
final class AppSkeletonViewModel {

    let homeViewModel: HomeViewModel
    let katScanViewModel: KatScanViewModel
    let katPoolViewModel: KatPoolViewModel
    let nftsViewModel: NFTsViewModel

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        homeViewModel = HomeViewModel(
            networkService: networkService,
            dataProvider: dataProvider
        )
        katScanViewModel = KatScanViewModel(networkService: networkService)
        katPoolViewModel = KatPoolViewModel(
            networkService: networkService,
            dataProvider: dataProvider
        )
        nftsViewModel = NFTsViewModel(
            networkService: networkService,
            dataProvider: dataProvider
        )
    }
}

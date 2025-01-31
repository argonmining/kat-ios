import SwiftUI
import Observation

@Observable
final class AppSkeletonViewModel {

    weak var networkService: NetworkServiceProvidable!
    let dataProvider: DataProvidable

    init(networkService: NetworkServiceProvidable, dataProvider: DataProvidable) {
        self.networkService = networkService
        self.dataProvider = dataProvider
    }
}

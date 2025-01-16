import SwiftUI
import Observation

@Observable
final class AppSkeletonViewModel {

    weak var networkService: NetworkServiceProvidable!

    init(networkService: NetworkServiceProvidable) {
        self.networkService = networkService
    }
}

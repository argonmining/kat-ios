import SwiftUI
import Observation

@Observable
final class AppCoordinator {

    let networkService: NetworkServiceProvidable = NetworkService()
}

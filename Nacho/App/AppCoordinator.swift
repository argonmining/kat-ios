import SwiftUI
import SwiftData
import Observation

@Observable
final class AppCoordinator {

    let networkService: NetworkServiceProvidable = NetworkService()
    var rootView: AnyView = AnyView(EmptyView())

    private var modelContainer: ModelContainer?

    init() {
        Task { @MainActor in
            setUpView()
        }
    }

    @MainActor
    private func setUpView() {
        print("SET UP CORE DATA")
        guard let modelContainer = try? ModelContainer(for: NFTInfoModel.self) else {
            print("Error: Failed to initialize CoreData")
            return
        }
        self.modelContainer = modelContainer
        rootView = AnyView(
            AppSkeletonView(
                viewModel: AppSkeletonViewModel(
                    networkService: networkService,
                    dataProvider: DataProvider(modelContainer: modelContainer)
                )
            )
        )
    }
}

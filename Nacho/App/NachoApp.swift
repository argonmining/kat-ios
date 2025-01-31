import SwiftUI
import SwiftData

@main
struct NachoApp: App {
    @State var coordinator = AppCoordinator()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AddressModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppSkeletonView(viewModel: AppSkeletonViewModel(networkService: coordinator.networkService))
        }
        .modelContainer(sharedModelContainer)
    }
}

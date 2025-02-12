import SwiftUI

struct AppSkeletonView: View {

    let viewModel: AppSkeletonViewModel
    @Namespace private var animationNamespace
    @State private var slideOutStep = 0
    @State private var selectedTab: TabType = .home

    var body: some View {
        ZStack {
            if viewModel.showTabs {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        HomeView(
                            viewModel: viewModel.homeViewModel,
                            namespace: animationNamespace
                        )
                    }
                    .tabItem {
                        Label(
                            Localization.tabHome,
                            systemImage: "house.fill"
                        )
                    }
                    .tag(TabType.home)
                    .transition(.opacity)

                    NavigationStack {
                        KatScanView(viewModel: viewModel.katScanViewModel)
                    }
                    .tabItem {
                        Label(
                            Localization.tabScan,
                            systemImage: "magnifyingglass"
                        )
                    }
                    .tag(TabType.katScan)

                    NavigationStack {
                        KatPoolView(viewModel: viewModel.katPoolViewModel)
                    }
                    .tabItem {
                        Label(
                            Localization.tabPool,
                            systemImage: "cube.fill"
                        )
                    }
                    .tag(TabType.katPool)

                    NavigationStack {
                        NFTsView(viewModel: viewModel.nftsViewModel)
                    }
                    .tabItem {
                        Label(
                            Localization.tabNFTs,
                            systemImage: "photo.stack.fill"
                        )
                    }
                    .tag(TabType.katBot)
                }
                .transition(.opacity)
            } else {
                WelcomeView(
                    namespace: animationNamespace,
                    slideOutStep: $slideOutStep
                ) {
                    slideOutSequentially()
                }
                .transition(.opacity)
            }
        }
    }

    func slideOutSequentially() {
        let animationDuration = 0.25
        let delayBetweenAnimations = -0.1

        for step in 1...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(step - 1) * (animationDuration + delayBetweenAnimations))) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    slideOutStep = step
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (3 * (animationDuration + delayBetweenAnimations))) {
            withAnimation(.easeInOut) {
                viewModel.showTabs = true
            }
        }
    }
}

private extension AppSkeletonView {

    enum TabType {
        case home
        case katScan
        case katPool
        case katBot
    }
}

#Preview {
    AppSkeletonView(viewModel: AppSkeletonViewModel(
        networkService: MockNetworkService(),
        dataProvider: MockDataProvider())
    )
}

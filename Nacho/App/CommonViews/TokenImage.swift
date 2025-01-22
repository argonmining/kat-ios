import CachedAsyncImage
import SwiftUI

struct TokenImage: View {

    private let ticker: String
    private let isCache: Bool
    private let urlPrefix: String

    init(_ ticker: String, isCache: Bool = true, urlPrefix: String = Constants.logoUrl) {
        self.ticker = ticker
        self.isCache = isCache
        self.urlPrefix = urlPrefix
    }

    var body: some View {
        asyncImage(ticker + ".jpg")
    }

    @ViewBuilder
    private func asyncImage(_ token: String) -> some View {
        if isCache {
            CachedAsyncImage(
                url: URL(string: urlPrefix + token),
                urlCache: .imageCache
            ) { phase in
                switch phase {
                case .empty:
                    imagePlaceholder
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: Size.iconMedium, height: Size.iconMedium)
                        .clipShape(Circle())
                case .failure:
                    imagePlaceholder
                @unknown default:
                    imagePlaceholder
                }
            }
        } else {
            AsyncImage(url: URL(string: urlPrefix + token)) { image in
                image
                    .resizable()
                    .frame(width: Size.iconMedium, height: Size.iconMedium)
                    .clipShape(Circle())
            } placeholder: {
                imagePlaceholder
            }
        }
    }

    private var imagePlaceholder: some View {
        ZStack {
            Color.surfaceBackground
            Image(systemName: "photo")
                .foregroundStyle(Color.textSecondary)
        }
        .frame(width: Size.iconMedium, height: Size.iconMedium)
        .clipShape(Circle())
    }
}

#Preview {
    VStack {
        TokenImage("NACHO", isCache: true)
            .padding()
        TokenImage("NACHO", isCache: false)
            .padding()
    }
    .background(Color.surfaceBackground.ignoresSafeArea())
}

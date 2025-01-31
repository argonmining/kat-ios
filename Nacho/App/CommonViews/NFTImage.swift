import CachedAsyncImage
import SwiftUI

struct NFTImage: View {

    private let index: String
    private let isCache: Bool
    private let urlPrefix: String

    init(index: String, isCache: Bool = true, urlPrefix: String = Constants.nftKatscanImageUrl) {
        self.index = index
        self.isCache = isCache
        self.urlPrefix = urlPrefix
    }

    var body: some View {
        asyncImage(index)
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
                        .scaledToFit()
                        .aspectRatio(5 / 6, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.radius_2))
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
                    .scaledToFit()
                    .aspectRatio(5 / 6, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.radius_2))
            } placeholder: {
                imagePlaceholder
            }
        }
    }

    private var imagePlaceholder: some View {
        ZStack {
            Color.surfaceForeground
            Image(systemName: "photo")
                .foregroundStyle(Color.textSecondary)
        }
        .aspectRatio(5 / 6, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: Radius.radius_2))
    }
}

#Preview {
    VStack {
        NFTImage(index: "1", isCache: true)
            .padding()
        NFTImage(index: "1", isCache: false)
            .padding()
    }
    .background(Color.surfaceBackground.ignoresSafeArea())
}


import SwiftUI
import Vortex

struct NFTDetailView: View {

    let nft: NFTInfoModel
    @Binding var isVisible: Bool
    let namespace: Namespace.ID
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            if let style = NFTStyleItem.base.style(from: nft.attributes), style == "Rainstorm" {
                VortexView(.rain) {
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
                VortexView(.splash) {
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
            } else if let style = NFTStyleItem.base.style(from: nft.attributes), style == "Volcano" {
                VortexView(.smoke) {
                    Circle()
                        .fill(.white)
                        .frame(width: 64)
                        .tag("circle")
                }
                .offset(y: -200)
            } else if let style = NFTStyleItem.base.style(from: nft.attributes), style == "Snowy Tundra" {
                VortexView(.snow) {
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
            }
            Color.surfaceBackground.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isVisible = false
                        onDismiss()
                    }
                }
            VStack(spacing: Spacing.padding_1) {
                Spacer()
                NFTImage(index: nft.image)
                    .matchedGeometryEffect(id: nft.image, in: namespace)
                    .frame(width: 280)
                Text(nft.name)
                    .typography(.headline3)
                VStack(alignment: .leading) {
                    let columns = Array(
                        repeating: GridItem(
                            .flexible(),
                            spacing: Spacing.padding_1
                        ),
                        count: 2
                    )
                    LazyVGrid(columns: columns, spacing: Spacing.padding_1) {
                        ForEach(nft.attributes, id: \.self) { attribute in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(attribute.traitType)
                                        .typography(.subtitle, color: .textSecondary)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                HStack {
                                    Text(attribute.value)
                                        .typography(.body2)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Overall Rarity")
                                    .typography(.subtitle, color: .textSecondary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            HStack {
                                Text("\(nft.overallRarityPosition)")
                                    .typography(.subtitle)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Visual Rarity")
                                    .typography(.subtitle, color: .textSecondary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            HStack {
                                Text("\(nft.visualRarityPosition)")
                                    .typography(.subtitle)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(Spacing.padding_2)
                .background(
                    RoundedRectangle(cornerRadius: Radius.radius_3)
                        .fill(Material.regular.opacity(0.9))
                )
                .padding(.horizontal, Spacing.padding_6)
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    NFTDetailView(
        nft: .init(
            name: "Test NFT #1",
            image: "/NACHO/1",
            edition: 1,
            attributes: [],
            visualRarity: 1000,
            overallRarity: 11000,
            visualRarityPosition: 3,
            overallRarityPosition: 5
        ),
        isVisible: .constant(true),
        namespace: namespace,
        onDismiss: {}
    )
}

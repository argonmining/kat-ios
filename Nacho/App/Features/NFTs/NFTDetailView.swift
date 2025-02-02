import SwiftUI
import Vortex

struct NFTDetailView: View {

    let nft: NFTData
    @Binding var isVisible: Bool
    let namespace: Namespace.ID
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            if let style = NFTStyleItem.base.style(from: nft.rarity.traitBreakdown), style == "Rainstorm" {
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
            } else if let style = NFTStyleItem.base.style(from: nft.rarity.traitBreakdown), style == "Volcano" {
                VortexView(.smoke) {
                    Circle()
                        .fill(.white)
                        .frame(width: 64)
                        .tag("circle")
                }
                .offset(y: -200)
            } else if let style = NFTStyleItem.base.style(from: nft.rarity.traitBreakdown), style == "Snowy Tundra" {
                VortexView(.snow) {
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
            } else if let style = NFTStyleItem.base.style(from: nft.rarity.traitBreakdown), style == "Fireworks" {
                VortexView(.fireworks) {
                    Circle()
                        .fill(.accent)
                        .blendMode(.plusLighter)
                        .frame(width: 24)
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
                        ForEach(nft.rarity.traitBreakdown, id: \.self) { attribute in
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
                                    Text(Formatter.formatPercentage(attribute.percentage))
                                        .typography(.body2, color: .textSecondary)
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
                                Text("Rarity Rank")
                                    .typography(.subtitle, color: .textSecondary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            HStack {
                                Text("\(nft.rarity.rank)")
                                    .typography(.subtitle)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Rarity Tier")
                                    .typography(.subtitle, color: .textSecondary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            HStack {
                                Text(nft.rarity.rarityTier)
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
            name: "NACHO #1",
            image: "/NACHO/1",
            edition: 1,
            rarity: .init(
                rarityScore: 99,
                rarityMetrics: .init(statisticalRarity: 1, traitRarity: 1, weightedAverage: 1),
                isSpecial: false,
                rarityTier: "Something",
                rank: 1,
                traitBreakdown: []
            )
        ),
        isVisible: .constant(true),
        namespace: namespace,
        onDismiss: {}
    )
}

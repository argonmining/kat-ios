import SwiftUI

struct TokenListItemView: View {

    let tokenInfo: TokenDeployInfo

    var body: some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_1_5) {
                HStack(spacing: Spacing.padding_1) {
                    TokenImage(tokenInfo.tick)
                    VStack(alignment: .leading, spacing: Spacing.padding_0_2_5) {
                        Text(tokenInfo.tick).typography(.body1)
                        Text(Formatter.formatDate(value: tokenInfo.releaseTimeInterval)).typography(.caption2)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: Spacing.padding_0_5) {
                        launchPill
                        HStack(spacing: Spacing.padding_0_5) {
                            Spacer()
                            Text(Localization.premintedText + ":").typography(.caption2)
                            Text(premintedString).typography(.caption2)
                        }
                    }
                }
                if showSegmentedBar {
                    segmentedBar
                }
                HStack(alignment: .bottom) {
                    Text(Localization.mintedText + ":").typography(.body2, color: .textSecondary)
                    Spacer()
                    Text(mintedString + " / " + supplyString).typography(.body2).lineLimit(1)
                }
                HStack {
                    Text(Localization.holdersText + ":").typography(.body2, color: .textSecondary)
                    Spacer()
                    Text(holdersString).typography(.body2).lineLimit(1)
                }
//                HStack {
//                    Text(Localization.tradeText + ":").typography(.body2, color: .textSecondary)
//                    Spacer()
//                    tradeButton
//                }
            }
        }
    }

    private var tradeButton: some View {
        Button {
            // TODO: Implement redirect to KSPR Bot
        } label: {
            Image(systemName: "arrow.left.arrow.right.circle")
                .resizable()
                .foregroundColor(.textAccent)
                .frame(width: Size.iconSmall, height: Size.iconSmall)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    private var launchPill: some View {
        if tokenInfo.preMinted > 0 {
            PillDS(text: Localization.preMint, color: .solidWarning)
        } else {
            PillDS(text: Localization.fairMint)
        }
    }

    private var segmentedBar: some View {
        SegmentedBarDS(segments: [
            .init(value: tokenInfo.preMinted, color: .solidWarning),
            .init(value: tokenInfo.minted, color: .solidSuccess),
            .init(value: tokenInfo.maxSupply - (tokenInfo.minted + tokenInfo.preMinted), color: .textSecondary)
        ])
        .frame(height: 8)
    }

    private var premintedString: String {
        Formatter.formatToNumber(value: tokenInfo.preMinted)
    }

    private var mintedString: String {
        Formatter.formatToNumber(value: tokenInfo.minted + tokenInfo.preMinted)
    }

    private var supplyString: String {
        Formatter.formatToNumber(value: tokenInfo.maxSupply)
    }

    private var holdersString: String {
        Formatter.formatToNumber(value: tokenInfo.holdersTotal)
    }

    private var showSegmentedBar: Bool {
        return tokenInfo.minted != tokenInfo.preMinted + tokenInfo.maxSupply || tokenInfo.preMinted > 0
    }
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer()
            TokenListItemView(
                tokenInfo:
                    TokenDeployInfo(
                        tick: "NACHO",
                        maxSupply: 287000000000,
                        limit: 28700,
                        preMinted: 200000000000,
                        minted: 87000000000,
                        holdersTotal: 17759,
                        mintTotal: 9998095,
                        logoPath: "https://katapi.nachowyborski.xyz/api/logos/NACHO",
                        releaseTimeInterval: 1719757838.224
                    )
            )
            Spacer()
        }
        Spacer()
    }
    .background(Color.surfaceBackground.ignoresSafeArea())
}

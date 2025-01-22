import SwiftUI

struct TokenListItemPlaceholderView: View {

    var body: some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_1_5) {
                HStack(spacing: Spacing.padding_1) {
                    imagePlaceholder
                        .shimmer(isActive: true)
                    VStack(alignment: .leading, spacing: Spacing.padding_0_2_5) {
                        Text("NACHO").typography(.body1)
                            .shimmer(isActive: true)
                        Text("30.10.24").typography(.caption2)
                            .shimmer(isActive: true)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: Spacing.padding_0_5) {
                        PillDS(text: Localization.fairMint)
                            .shimmer(isActive: true)
                        HStack(spacing: Spacing.padding_0_5) {
                            Spacer()
                            Text(Localization.premintedText + ":")
                                .typography(.caption2)
                                .shimmer(isActive: true)
                            Text("999999999")
                                .typography(.caption2)
                                .shimmer(isActive: true)
                        }
                    }
                }
                HStack(alignment: .bottom) {
                    Text(Localization.mintedText + ":")
                        .typography(.body2, color: .textSecondary)
                        .shimmer(isActive: true)
                    Spacer()
                    Text("999999999/99999999")
                        .typography(.body2).lineLimit(1)
                        .shimmer(isActive: true)
                }
                HStack {
                    Text(Localization.holdersText + ":")
                        .typography(.body2, color: .textSecondary)
                        .shimmer(isActive: true)
                    Spacer()
                    Text("99999")
                        .typography(.body2).lineLimit(1)
                        .shimmer(isActive: true)
                }
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
        Spacer()
        HStack {
            Spacer()
            TokenListItemPlaceholderView()
            Spacer()
        }
        Spacer()
    }
    .background(Color.surfaceBackground.ignoresSafeArea())
}

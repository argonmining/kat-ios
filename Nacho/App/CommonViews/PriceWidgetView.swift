import SwiftUI

struct PriceWidgetView: View {

    @Binding var viewData: TokenPriceData?

    var body: some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_1) {
                HStack(spacing: .zero) {
                    Text(Localization.widgetPriceTitle)
                        .typography(.headline3, color: .textSecondary)
                    Spacer()
                }
                HStack(spacing: Spacing.padding_1) {
                    Text("$\(stringPrice)").typography(.body1)
                        .lineLimit(1)
                        .shimmer(isActive: viewData == nil)
                    PillDS(text: stringChange, color: changeColor)
                        .shimmer(isActive: viewData == nil)
                }
                .padding(.bottom, Spacing.padding_1)
                Text(Localization.widgetMCTitle)
                    .typography(.headline3, color: .textSecondary)
                Text(stringMarketCap)
                    .typography(.body1)
                    .shimmer(isActive: viewData == nil)
                    .padding(.bottom, Spacing.padding_1)
                Text(Localization.widgetVolumeTitle)
                    .typography(.headline3, color: .textSecondary)
                Text(stringVolume)
                    .typography(.body1)
                    .shimmer(isActive: viewData == nil)
                    .padding(.bottom, Spacing.padding_1)
            }
        }
    }

    private var stringPrice: String {
        String(format: "%.8f", viewData?.price ?? 0)
    }

    private var stringMarketCap: String {
        return Formatter.formatToUSD(value: viewData?.marketCap ?? 0)
    }

    private var stringChange: String {
        String(format: "%.0f%%", viewData?.change ?? 0)
    }

    private var stringVolume: String {
        return Formatter.formatToUSD(value: viewData?.volume ?? 0)
    }

    private var changeColor: Color {
        return viewData?.change ?? 0 >= 0 ? .solidSuccess : .solidDanger
    }
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer()
            PriceWidgetView(
                viewData: .constant(nil)
            )
            Spacer()
        }
        Spacer()
    }
    .background(Color.surfaceBackground.ignoresSafeArea())
}

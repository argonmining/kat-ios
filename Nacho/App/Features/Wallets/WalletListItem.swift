import SwiftUI

struct WalletListItem: View {

    let addressModel: AddressModel
    
    var body: some View {
        VStack(spacing: Spacing.padding_1) {
            HStack(alignment: .center, spacing: Spacing.padding_1) {
                Image("kaspaLogo")
                    .resizable()
                    .frame(width: Size.iconSmall, height: Size.iconSmall)
                Text(addressModel.address.trimmedInMiddle(toLength: 30))
                    .typography(.body1)
                Spacer()
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    UIPasteboard.general.string = addressModel.address
                    Notifications.presentTopMessage(Localization.addressCopyMessage)
                }) {
                    Image(systemName: "document.on.document")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, Spacing.padding_2)
            HStack(spacing: Spacing.padding_1) {
                if addressModel.contentTypes.contains(.tokens) {
                    PillDS(
                        text: Localization.walletsTagsTokens,
                        style: .medium
                    )
                }
                if addressModel.contentTypes.contains(.nfts) {
                    PillDS(
                        text: Localization.walletsTagsNfts,
                        style: .medium,
                        color: .solidWarning
                    )
                }
                if addressModel.contentTypes.contains(.miners) {
                    PillDS(
                        text: Localization.walletsTagsMiners,
                        style: .medium,
                        color: .solidInfo
                    )
                }
                if addressModel.contentTypes.contains(.none) || addressModel.contentTypes.isEmpty {
                    PillDS(
                        text: Localization.walletsTagsNone,
                        style: .medium,
                        color: .solidDanger
                    )
                }
                Spacer()
            }
            .padding(.leading, Spacing.padding_2 + Size.iconSmall + Spacing.padding_1)
        }
        .padding(.top, Spacing.padding_1_5)
    }
}

#Preview {
    VStack(spacing: .zero) {
        Spacer()
        WalletListItem(addressModel: .init(
            address: "kaspa:qpz2vgvlxhmyhmt22h538pjzmvvd52nuut80y5zulgpvyerlskvvwm7n4uk5a",
            contentTypes: [.tokens, .nfts, .miners])
        )
        WalletListItem(addressModel: .init(
            address: "kaspa:qpz2vgvlxhmyhmt22h538pjzmvvd52nuut80y5zulgpvyerlskvvwm7n4uk5a",
            contentTypes: [.miners])
        )
        WalletListItem(addressModel: .init(
            address: "kaspa:qpz2vgvlxhmyhmt22h538pjzmvvd52nuut80y5zulgpvyerlskvvwm7n4uk5a",
            contentTypes: [.none])
        )
        WalletListItem(addressModel: .init(
            address: "kaspa:qpz2vgvlxhmyhmt22h538pjzmvvd52nuut80y5zulgpvyerlskvvwm7n4uk5a",
            contentTypes: [.tokens, .miners])
        )
        Spacer()
    }
    .background(Color.surfaceBackground)
}

import CachedAsyncImage
import SwiftUI

struct AddressInfoView: View {

    @State var viewModel: AddressInfoViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ScrollView {
            VStack {
                TextInputDS(
                    placeholder: Localization.addressInfoTextInputPlaceholder,
                    text: $viewModel.address,
                    isButtonShowing: viewModel.isPasteAvailable || !viewModel.address.isEmpty,
                    actionIcon: viewModel.address.isEmpty ? "document.on.document" : "xmark.circle.fill"
                ) {
                    if viewModel.address.isEmpty {
                        viewModel.pasteFromClipboard()
                    } else {
                        viewModel.address = ""
                    }
                }
                .textInputAutocapitalization(.never)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .padding(.bottom, Spacing.padding_2)

                balanceContent
                    .padding(.bottom, Spacing.padding_2)
                tokensWidget
            }
            .padding(Spacing.padding_2)
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    viewModel.checkClipbaord()
                }
            }
            .onChange(of: viewModel.address) { _, newValue in
                Task {
                    await viewModel.fetchAddressBalance()
                    await viewModel.fetchAddressTokens()
                }
            }
            .onChange(of: viewModel.isBalanceLoading) { _, newValue in
                if newValue { hideKeyboard() }
            }
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(Localization.addressInfoTitle)
    }

    @ViewBuilder
    private var balanceContent: some View {
        if let addressBalance = viewModel.addressBalance, !viewModel.isBalanceLoading {
            HStack(alignment: .lastTextBaseline) {
                Spacer()
                Text(Formatter.formatToNumber(addressBalance.balance, decimal: 3))
                    .typography(.numeric2)
                    .lineLimit(1)
                Text("KAS")
                    .typography(.body1, color: .textSecondary)
            }
        } else if viewModel.isBalanceLoading {
            HStack(alignment: .lastTextBaseline) {
                Spacer()
                Text("99999999")
                    .typography(.numeric)
                    .shimmer(isActive: true)
                Text("KAS")
                    .typography(.body1, color: .textSecondary)
                    .shimmer(isActive: true)
            }
        }
    }

    @ViewBuilder
    private var tokensWidget: some View {
        if let tokens = viewModel.tokens, !viewModel.isTokensLoading {
            WidgetDS {
                VStack(alignment: .leading, spacing: Spacing.padding_2) {
                    Text(Localization.addressInfoTokensTitle)
                        .typography(.headline3, color: .textSecondary)
                    ForEach(tokens, id: \.self) { token in
                        HStack {
                            TokenImage(token.ticker)
                            Text(token.ticker).typography(.body1)
                            Spacer()
                            if token.locked > 0 {
                                PillDS(
                                    text: Formatter.formatToNumber(token.locked),
                                    color: .solidWarning,
                                    iconName: "lock.fill"
                                )
                            }
                            Text(Formatter.formatToNumber(token.balance))
                                .typography(.body1)
                                .lineLimit(1)
                        }
                        .onTapGesture {
                            viewModel.onTickerSelected(tick: token.ticker)
                        }
                    }
                }
            }
        } else if viewModel.isTokensLoading {
            WidgetDS {
                VStack(alignment: .leading, spacing: Spacing.padding_2) {
                    Text(Localization.addressInfoTokensTitle)
                        .typography(.headline3, color: .textSecondary)
                    ForEach(0...4, id: \.self) { _ in
                        HStack {
                            TokenImage("")
                                .shimmer(isActive: true)
                            Text("NACHO")
                                .typography(.body1)
                                .shimmer(isActive: true)
                            Spacer()
                            Text("9999999999")
                                .typography(.body1)
                                .shimmer(isActive: true)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        AddressInfoView(viewModel: .init(
            networkService: MockNetworkService(),
            onTickerSelected: {_ in }
        ))
    }
}

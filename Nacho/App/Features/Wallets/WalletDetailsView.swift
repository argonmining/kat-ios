import SwiftUI

struct WalletDetailsView: View {

    let address: AddressModel?
    var callback: (AddressModel) -> Void
    @State private var name: String
    @State private var contentTypes: [AddressModel.ContentType]
    @State private var isPasteAvailable: Bool = false
    @State private var isValidAddress: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    
    init(
        address: AddressModel? = nil,
        callback: @escaping (AddressModel) -> Void
    ) {
        self.address = address
        self.callback = callback
        self.name = address?.address ?? ""
        self.contentTypes = address?.contentTypes ?? []
        isValidAddress = isValidKaspaAddress(self.name)
    }

    var body: some View {
        VStack(spacing: Spacing.padding_2) {
            TextInputDS(
                placeholder: Localization.addressInfoTextInputPlaceholder,
                text: $name,
                isButtonShowing: isPasteAvailable || !name.isEmpty,
                actionIcon: name.isEmpty ? "doc.on.doc" : "xmark.circle.fill"
            ) {
                if name.isEmpty {
                    pasteFromClipboard()
                } else {
                    name = ""
                }
            }
            .textInputAutocapitalization(.never)
            .keyboardType(.alphabet)
            .disableAutocorrection(true)
            .padding(.bottom, Spacing.padding_2)

            HStack(spacing: Spacing.padding_2) {
                PillDS(
                    text: Localization.walletsTagsTokens,
                    style: .large,
                    color: contentTypes.contains(.tokens) ? .solidSuccess : .textSecondary
                )
                .onTapGesture {
                    if contentTypes.contains(.tokens) {
                        contentTypes.removeAll { $0 == .tokens }
                    } else {
                        contentTypes.append(.tokens)
                    }
                }
                PillDS(
                    text: Localization.walletsTagsNfts,
                    style: .large,
                    color: contentTypes.contains(.nfts) ? .solidWarning : .textSecondary
                )
                .onTapGesture {
                    if contentTypes.contains(.nfts) {
                        contentTypes.removeAll { $0 == .nfts }
                    } else {
                        contentTypes.append(.nfts)
                    }
                }
                PillDS(
                    text: Localization.walletsTagsMiners,
                    style: .large,
                    color: contentTypes.contains(.miners) ? .solidInfo : .textSecondary
                )
                .onTapGesture {
                    if contentTypes.contains(.miners) {
                        contentTypes.removeAll { $0 == .miners }
                    } else {
                        contentTypes.append(.miners)
                    }
                }
            }
            Text(Localization.walletTagsCaption)
                .typography(.caption)
                .multilineTextAlignment(.center)

            Spacer()

            ButtonDS(Localization.buttonConfirm) {
                if address != nil {
                    address!.address = name
                    address!.contentTypes = contentTypes
                    callback(address!)
                } else {
                    callback(.init(address: name, contentTypes: contentTypes))
                }
            }
            .disabled(!isValidAddress || contentTypes.isEmpty)
            .padding(.vertical, Spacing.padding_2)
        }
        .padding(Spacing.padding_2)
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                checkClipbaord()
            }
        }
        .onChange(of: name) { _, newValue in
            isValidAddress = isValidKaspaAddress(newValue)
        }
        .onAppear {
            checkClipbaord()
            isValidAddress = isValidKaspaAddress(name)
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(Localization.addressInfoTitle)
    }

    private func checkClipbaord() {
        guard UIPasteboard.general.hasStrings else { return }
        isPasteAvailable = true
    }

    private func pasteFromClipboard() {
        guard let text = UIPasteboard.general.string else {
            return
        }
        name = text
        isPasteAvailable = false
    }

    private func isValidKaspaAddress(_ address: String) -> Bool {
        guard address.hasPrefix("kaspa:") else { return false }
        let addressBody = address.dropFirst(6)
        guard !addressBody.isEmpty else { return false }
        let base32Charset = Set("abcdefghijklmnopqrstuvwxyz0123456789")
        for char in addressBody.lowercased() {
            if !base32Charset.contains(char) {
                return false
            }
        }
        let lengthIsValid = (address.count >= 59 && address.count <= 79)
        return lengthIsValid
    }
}

#Preview {
    NavigationView {
        WalletDetailsView(address: nil) { address in
            print(address)
        }
    }
}

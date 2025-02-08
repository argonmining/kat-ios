import SwiftUI

struct AddressTokensView: View {
    
    let address: String
    let tokens: [AddressTokenInfoKasFyiDTO]
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.padding_2_5) {
                WidgetDS {
                    VStack(alignment: .leading, spacing: Spacing.padding_2) {
                        PillDS(
                            text: address.trimmedInMiddle(toLength: 22, shiftStartBy: 6),
                            style: .large,
                            color: .accentColor.opacity(0.7)
                        )
                        HStack {
                            Text("\(tokens.count) tokens")
                                .typography(.body1)
                            Spacer()
                            Text(Formatter.formatToUSD(tokens.reduce(0.0) { total, token in
                                total + (token.price?.priceInUsd ?? 0.0) * token.calculatedBalance
                            }))
                            .typography(.numeric4)
                        }
                    }
                }
                ForEach(tokens, id: \.self) { token in
                    tokenItem(token: token)
                }
            }
            .padding(Spacing.padding_2)
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(Localization.addressInfoTitle)
    }

    private func tokenItem(token: AddressTokenInfoKasFyiDTO) -> some View {
        VStack {
            HStack {
                TokenImage(token.ticker)
                VStack(alignment: .leading, spacing: Spacing.padding_0_2_5) {
                    Text(token.ticker)
                        .typography(.body1)
                    Text(Formatter.formatToNumber(token.calculatedBalance))
                        .typography(.caption)
                    
                }
                Spacer()
                Text(Formatter.formatToUSD(token.calculatedBalance * (token.price?.priceInUsd ?? 0.0)))
                    .typography(.numeric4)
            }
        }
    }
}

#Preview {
    NavigationView {
        AddressTokensView(
            address: "kaspa:qyptk9cfan6nfg60nhdrtwe4n09j09lzxkjxkql7p5ueyr9l7spt4rgmwg34m5a",
            tokens: [
                AddressTokenInfoKasFyiDTO(
                    balance: "9372704713966445",
                    ticker: "GHOAD",
                    decimal: "8",
                    locked: "0",
                    opScoreMod: "1027115990000",
                    price: .init(
                        floorPrice: 0.005903077422961695,
                        priceInUsd: 0.0005086584733943417,
                        marketCapInUsd: 2034633.3847697156,
                        change24h: 3.9924914428355924,
                        change24hInKas: 10.839678375030424
                    ),
                    iconUrl: URL(string: "https://krc20-assets.kas.fyi/icons/GHOAD.jpg")!
                ),
                AddressTokenInfoKasFyiDTO(
                    balance: "64709650775759093",
                    ticker: "NACHO",
                    decimal: "8",
                    locked: "0",
                    opScoreMod: "1026817450001",
                    price: .init(
                        floorPrice: 0.00045633630777855574,
                        priceInUsd: 0.00003932174915513671,
                        marketCapInUsd: 11285341.521405213,
                        change24h: -15.907294364549385,
                        change24hInKas: -10.372914115966662
                    ),
                    iconUrl: URL(string: "https://krc20-assets.kas.fyi/icons/NACHO.jpg")!
                ),
                AddressTokenInfoKasFyiDTO(
                    balance: "135050002871078355",
                    ticker: "KASPY",
                    decimal: "8",
                    locked: "0",
                    opScoreMod: "1025218250000",
                    price: .init(
                        floorPrice: 0.00016555817575224883,
                        priceInUsd: 0.000014265875729246294,
                        marketCapInUsd: 4721138.034599611,
                        change24h: -5.210128044875123,
                        change24hInKas: 1.0055370338898397
                    ),
                    iconUrl: URL(string: "https://krc20-assets.kas.fyi/icons/KASPY.jpg")!
                )
            ]
        )
    }
}

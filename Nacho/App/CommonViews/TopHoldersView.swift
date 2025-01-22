import SwiftUI

struct TopHoldersView: View {

    @Binding var holders: [HolderInfo]?
    let supply: Double

    var body: some View {
        if holders == nil {
            topHoldersPlaceholder
        } else {
            topHolders
        }
    }

    private var topHolders: some View {
        VStack(alignment: .leading) {
            Text(Localization.topHoldersText)
                .typography(.headline3, color: .textSecondary)
            VStack(spacing: Spacing.padding_2) {
                ForEach(holders!, id: \.self) { holder in
                    HStack(spacing: Spacing.padding_1) {
                        PillDS(
                            text: holder.address.trimmedInMiddle(toLength: 11, shiftStartBy: 6),
                            style: .medium,
                            color: .accentColor.opacity(0.7)
                        )
                        Spacer()
                        Text(Formatter.formatToNumber(value: holder.amount))
                            .typography(.body1)
                            .lineLimit(1)
                        Text(holderPercentage(amount: holder.amount))
                            .typography(.body1, color: .textSecondary)
                    }
                }
            }
        }
    }

    private var topHoldersPlaceholder: some View {
        VStack(alignment: .leading) {
            Text(Localization.topHoldersText)
                .typography(.headline3, color: .textSecondary)
            VStack(spacing: Spacing.padding_2) {
                placeholderItem
                    .shimmer(isActive: true)
                placeholderItem
                    .shimmer(isActive: true)
                placeholderItem
                    .shimmer(isActive: true)
            }
        }
    }

    private var placeholderItem: some View {
        HStack(spacing: Spacing.padding_1) {
            PillDS(
                text: "kaspa:werw...sdfs",
                style: .medium,
                color: .accentColor.opacity(0.7)
            )
            Spacer()
            Text("999999999")
                .typography(.body1)
                .lineLimit(1)
            Text("10%")
                .typography(.body1, color: .textSecondary)
        }
    }

    private func holderPercentage(amount: Double) -> String {
        let value = amount / supply * 100
        return Formatter.formatToNumber(value: value, decimal: 1) + "%"
    }
}

#Preview {
    TopHoldersView(holders: .constant([
        .init(
            address: "kaspa:qrn9k3sz4fkzmaf7608yntvx8pav6a75g240pj40sqp27zcztnr3jmfx85yye",
            amount: 17500
        ),
        .init(
            address: "kaspa:qz46qj2e5xe0chxfarxfkppjvzg6thn3xsjpnfum4tgu0ew2ckajyc7x05se3",
            amount: 25801300
        ),
        .init(
            address: "kaspa:qpyzs5yqaystvrr6nf5p6cswj3zgjrxfghv58m2qc5ufh8324ve370a2k5340",
            amount: 828900
        )
    ]), supply: 1000000)
}

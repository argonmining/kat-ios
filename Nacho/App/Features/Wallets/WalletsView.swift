import SwiftUI
import SwiftData

struct WalletsView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var addresses: [AddressModel]

    var body: some View {
        VStack {
            if addresses.isEmpty {
                placeholderView
            } else {
                List {
                    ForEach(addresses, id: \.self) { address in
                        WalletListItem(addressModel: address)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteAddress(address)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(Color.solidDanger)
                                
                                Button {
                                    editAddress(address)
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(Color.solidInfo)
                            }
                    }
                    .listRowInsets(EdgeInsets.init(top: 0, leading: 0, bottom: Spacing.padding_1, trailing: 0))
                    .listRowBackground(Color.surfaceBackground)
                }
                .listSectionSeparator(.hidden, edges: [.top, .bottom])
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
        .navigationTitle(Localization.walletsTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addNewAddress) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private var placeholderView: some View {
        VStack {
            Spacer()
            VStack(spacing: Spacing.padding_2) {
                Image(systemName: "wallet.bifold")
                    .typography(.numeric2, color: .textSecondary)
                    .padding(.top, Spacing.padding_1)
                Text("No addresses")
                    .typography(.headline3, color: .textSecondary)
                Text("Add your first address to start tracking your Tokens at Kat Scan, Miners and Payouts at Kat Pool or NFTs you own.")
                    .typography(.body1, color: .textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(Spacing.padding_0_5)
                ButtonDS("Add Address", style: .outlined, isSmall: true) {
                    addNewAddress()
                }
                .padding(.vertical, Spacing.padding_1)
            }
            .padding(Spacing.padding_2)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.radius_3)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                    .foregroundColor(Color.borderRegularPrimary)
            )
            .padding(Spacing.padding_4)
            Spacer()
        }
    }

    private func deleteAddress(_ address: AddressModel) {
        withAnimation { modelContext.delete(address) }
    }

    private func editAddress(_ address: AddressModel) {
        // Handle address editing (e.g., show a sheet or navigate to edit screen)
    }

    private func addNewAddress() {
        let newAddress = AddressModel(address: "New Wallet", contentTypes: [])
        modelContext.insert(newAddress)
    }
}

#Preview {
    NavigationView {
        WalletsView()
            .modelContainer(for: AddressModel.self, inMemory: true)
    }
}

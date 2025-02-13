import SwiftUI
import SwiftData

struct WalletsView: View {

    @Environment(\.dismiss) private var dismiss
    @State var viewModel: WalletsViewModel

    var body: some View {
        VStack {
            if viewModel.addresses.isEmpty {
                placeholderView
            } else {
                List {
                    ForEach(viewModel.addresses, id: \.self) { address in
                        WalletListItem(addressModel: address)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteAddress(address)
                                } label: {
                                    Label(
                                        Localization.buttonDelete,
                                        systemImage: "trash"
                                    )
                                }
                                .tint(Color.solidDanger)
                                
                                Button {
                                    editAddress(address)
                                } label: {
                                    Label(
                                        Localization.buttonEdit,
                                        systemImage: "pencil"
                                    )
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addNewAddress) {
                    Image(systemName: "plus.circle")
                }
                .sheet(isPresented: $viewModel.addressDetailsPresented) {
                    NavigationView {
                        WalletDetailsView(address: viewModel.selectedAddress) { address in
                            viewModel.addressDetailsPresented = false
                            viewModel.add(address: address)
                        }
                    }
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }

    private var placeholderView: some View {
        VStack {
            Spacer()
            VStack(spacing: Spacing.padding_2) {
                Image("wallet")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42)
                    .typography(.numeric2, color: .textSecondary)
                    .padding(.top, Spacing.padding_1)
                Text(Localization.walletsEmptyTitle)
                    .typography(.headline3, color: .textSecondary)
                Text(Localization.walletsEmptyDescription)
                    .typography(.body1, color: .textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(Spacing.padding_0_5)
                ButtonDS(
                    Localization.buttonAddAddress,
                    style: .outlined,
                    isSmall: true,
                    action: addNewAddress
                )
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
        withAnimation { viewModel.delete(address: address) }
    }

    private func editAddress(_ address: AddressModel) {
        viewModel.selectedAddress = address
        viewModel.addressDetailsPresented = true
    }

    private func addNewAddress() {
        viewModel.addressDetailsPresented = true
    }
}

#Preview {
    NavigationView {
        WalletsView(viewModel: .init(dataProvider: MockDataProvider()))
    }
}

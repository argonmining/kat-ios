import SwiftUI
import Observation

@Observable
final class WalletsViewModel {

    var addresses: [AddressModel] = []
    var addressDetailsPresented = false
    var selectedAddress: AddressModel? = nil

    private let dataProvider: DataProvidable

    init(dataProvider: DataProvidable) {
        self.dataProvider = dataProvider
        Task {
            await fetchAddresses()
        }
    }

    func add(address: AddressModel) {
        Task {
            do {
                try await dataProvider.set(address: address)
                guard !addresses.contains(where: { $0.id == address.id }) else {
                    return
                }
                addresses.append(address)
            } catch {
                print("Error adding address: \(error)")
            }
        }
    }

    func delete(address: AddressModel) {
        Task {
            do {
                try await dataProvider.delete(address: address)
                addresses.removeAll { $0.id == address.id }
            } catch {
                print("Error deleting address: \(error)")
            }
        }
    }

    private func fetchAddresses() async {
        do {
            addresses = try await dataProvider.getAddresses()
        } catch {
            print("Error fetching addresses: \(error)")
        }
    }
}

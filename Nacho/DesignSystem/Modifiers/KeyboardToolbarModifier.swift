import SwiftUI
import Combine

@Observable
final class KeyboardToolbarViewModel {

    var isKeyboardVisible = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                withAnimation(.easeIn.delay(0.15)) {
                    self?.isKeyboardVisible = true
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = false
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

struct KeyboardToolbar<V: View>: ViewModifier {

    @State private var viewModel: KeyboardToolbarViewModel = .init()
    private let toolbar: V

    init(@ViewBuilder toolbar: () -> V) {
        self.toolbar = toolbar()
    }

    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                if viewModel.isKeyboardVisible {
                    toolbar
                }
            }
    }
}

extension View {
    func keyboardToolbar<V: View>(view: @escaping () -> V) -> some View {
        modifier(KeyboardToolbar(toolbar: view))
    }
}

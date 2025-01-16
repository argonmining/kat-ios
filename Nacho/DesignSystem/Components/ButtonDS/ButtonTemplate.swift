import SwiftUI

struct ButtonTemplate: View {

    private let text: String
    private var action: () -> Void
    private let style: ButtonDS.Style
    private let icon: ButtonDS.Icon
    private let autosize: Bool
    @Binding private var loading: Bool
    @State private var isPressed: Bool = false

    init(
        _ text: String,
        action: @escaping () -> Void,
        style: ButtonDS.Style = .contained,
        icon: ButtonDS.Icon = .none,
        autosize: Bool = false,
        loading: Binding<Bool> = .constant(false)
    ) {
        self.text = text
        self.action = action
        self.style = style
        self.icon = icon
        self.autosize = autosize
        self._loading = loading
    }

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }) {
            ZStack {
                if loading {
                    ProgressView()
                } else {
                    HStack(alignment: .center, spacing: Spacing.padding_1) {
                        switch icon {
                        case .none:
                            titleText
                        case .leading(let image):
                            iconImage(image)
                            titleText
                        case .trailing(let image):
                            titleText
                            iconImage(image)
                        }
                    }
                }
            }
            .frame(maxWidth: autosize ? .none : .infinity)
            .opacity(isPressed ? 0.5 : 1)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        isPressed = false
                    }
                }
        )
    }

    private var titleText: some View {
        Text(text)
            .opacity(loading ? 0 : 1)
            .scaleEffect(x: loading ? 0 : 1, y: 1)
    }

    private func iconImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(height: 18)
    }
}

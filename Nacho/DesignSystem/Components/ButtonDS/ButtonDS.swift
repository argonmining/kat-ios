import SwiftUI

struct ButtonDS: View {

    private let text: String
    private let style: Style
    private let isSmall: Bool
    private let icon: Icon
    private let autosize: Bool
    @Binding private var loading: Bool
    private var action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    init(
        _ text: String,
        style: Style = .contained,
        isSmall: Bool = false,
        icon: Icon = .none,
        autosize: Bool = false,
        loading: Binding<Bool> = .constant(false),
        action: @escaping () -> Void
    ) {
        self.text = text
        self.style = style
        self.isSmall = isSmall
        self.icon = icon
        self.autosize = autosize
        self._loading = loading
        self.action = action
    }

    var body: some View {
        switch style {
        case .contained:
            ButtonTemplate(
                text,
                action: action,
                style: style,
                icon: icon,
                autosize: autosize,
                loading: $loading
            )
            .buttonStyle(
                ContainedButtonStyle(
                    .constant(
                        loading ? .loading : isEnabled ? .idle : .disabled
                    ),
                    height: isSmall ? Constants.buttonSmallHeight : Constants.buttonHeight
                )
            )
            
        case .outlined:
            ButtonTemplate(
                text,
                action: action,
                style: style,
                icon: icon,
                autosize: autosize,
                loading: $loading
            )
            .buttonStyle(
                OutlinedButtonStyle(
                    .constant(
                        loading ? .loading : isEnabled ? .idle : .disabled
                    ),
                    height: isSmall ? Constants.buttonSmallHeight : Constants.buttonHeight
                )
            )
            
        case .text:
            ButtonTemplate(
                text,
                action: action,
                style: style,
                icon: icon,
                autosize: autosize,
                loading: $loading
            )
            .buttonStyle(
                TextButtonStyle(
                    .constant(
                        loading ? .loading : isEnabled ? .idle : .disabled
                    ),
                    height: isSmall ? Constants.buttonSmallHeight : Constants.buttonHeight
                )
            )
            
        case .danger:
            ButtonTemplate(
                text,
                action: action,
                style: style,
                icon: icon,
                autosize: autosize,
                loading: $loading
            )
            .buttonStyle(
                DangerButtonStyle(
                    .constant(
                        loading ? .loading : isEnabled ? .idle : .disabled
                    ),
                    height: isSmall ? Constants.buttonSmallHeight : Constants.buttonHeight
                )
            )
        case .inverted:
            ButtonTemplate(
                text,
                action: action,
                style: style,
                icon: icon,
                autosize: autosize,
                loading: $loading
            )
            .buttonStyle(
                InvertedButtonStyle(
                    .constant(
                        loading ? .loading : isEnabled ? .idle : .disabled
                    ),
                    height: isSmall ? Constants.buttonSmallHeight : Constants.buttonHeight
                )
            )
        }
    }
}

extension ButtonDS {

    enum Style {
        case contained
        case outlined
        case text
        case danger
        case inverted
    }

    enum Icon {
        case none
        case leading(Image)
        case trailing(Image)
    }

    enum State {
        case idle
        case pressed
        case disabled
        case loading
    }

}

extension ButtonDS {

    enum Constants {
        static let buttonHeight: CGFloat = 48
        static let buttonSmallHeight: CGFloat = 40
    }
}

#Preview {
    VStack {
        VStack {
            ButtonDS("Inverted", style: .inverted) {}
                .padding(Spacing.padding_2)
        }
        .background(Color.surfaceAccent)
        Spacer()
        VStack(spacing: Spacing.padding_2) {
            ButtonDS("Contained", isSmall: true) {}
            ButtonDS("Outlined", style: .outlined, isSmall: true) {}
            ButtonDS("Contained") {}
            ButtonDS("Outlined", style: .outlined) {}
            ButtonDS("Danger", style: .danger) {}
            ButtonDS("Text", style: .text) {}
        }
        .padding(.horizontal, Spacing.padding_2)
    }
    .background(Color.surfaceBackground)
}

import SwiftUI

struct TextInputDS: View {

    private let placeholder: String
    private let prefix: String?
    private let actionIcon: String?
    private let action: (() -> Void)?
    private var isButtonShowing: Bool
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    init(
        placeholder: String,
        text: Binding<String>,
        isButtonShowing: Bool,
        prefix: String? = nil,
        actionIcon: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isButtonShowing = isButtonShowing
        self.prefix = prefix
        self.actionIcon = actionIcon
        self.action = action
    }

    var body: some View {
        HStack {
            if let prefix = self.prefix {
                Text(prefix)
                    .typography(.caption)
            }
            TextField(placeholder, text: $text)
                .typography(.body2)
                .focused($isFocused)
            if isButtonShowing && actionIcon != nil {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    action?()
                }) {
                    Image(systemName: actionIcon!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .foregroundColor(Color.accentColor)
                }
                
            }
        }
        .padding(Spacing.padding_1_5)
        .background(
            RoundedRectangle(cornerRadius: Radius.radius_2)
                .stroke(
                    isFocused ? Color.borderRegularAccent : Color.borderRegularPrimary,
                    lineWidth: isFocused ? 2 : 1
                )
                .background(
                    RoundedRectangle(cornerRadius: Radius.radius_2)
                        .fill(Color.surfaceForeground)
                )
        )
    }
}

#Preview {
    VStack {
        TextInputDS(
            placeholder: "Word",
            text: .constant(""),
            isButtonShowing: true,
            actionIcon: "doc.on.doc"
        )
        .padding()
        TextInputDS(
            placeholder: "Word",
            text: .constant(""),
            isButtonShowing: false,
            prefix: "12."
        )
        .padding()
    }
    .background(Color.surfaceBackground)
}

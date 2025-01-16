import SwiftUI

struct TextInputDS: View {

    private let placeholder: String
    private let prefix: String?
    @Binding private var text: String
    @FocusState private var isFocused: Bool

    init(
        placeholder: String,
        text: Binding<String>,
        prefix: String? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.prefix = prefix
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
        }
        .padding(Spacing.padding_1_5)
        .background(
            RoundedRectangle(cornerRadius: Radius.radius_2)
                .stroke(
                    isFocused ? Color.borderRegularAccent : Color.borderRegularPrimary,
                    lineWidth: isFocused ? 3 : 1
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
        TextInputDS(placeholder: "Word", text: .constant(""))
            .padding()
        TextInputDS(placeholder: "Word", text: .constant(""), prefix: "12.")
            .padding()
    }
    .background(Color.surfaceBackground)
}

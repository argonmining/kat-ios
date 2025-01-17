import SwiftUI

struct Tone: ViewModifier {

    enum Style {
        case idle
        case disabled
    }

    let style: Style

    init(style: Style) {
        self.style = style
    }

    func body(content: Content) -> some View {
        switch style {
        case .idle:
            return content
                .opacity(1)
        case .disabled:
            return content
                .opacity(0.5)
        }
    }
}

extension View {

    func toneStyle(_ style: Tone.Style) -> some View {
        return self.modifier(Tone(style: style))
    }
}

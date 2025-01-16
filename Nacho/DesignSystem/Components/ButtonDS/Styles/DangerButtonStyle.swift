import SwiftUI

struct DangerButtonStyle: ButtonStyle {

    @Binding private var state: ButtonDS.State
    private let height: CGFloat

    init(_ state: Binding<ButtonDS.State> = .constant(.idle), height: CGFloat) {
        self._state = state
        self.height = height
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(.button, color: textColor)
            .toneStyle(toneStyle(configuration))
            .padding(.vertical, Spacing.padding_2)
            .padding(.horizontal, Spacing.padding_3)
            .frame(height: height)
            .background(backColor)
            .cornerRadius(Radius.radius_max)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.radius_max)
                    .stroke(
                        borderColor,
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
    }

    private var backColor: Color {
        switch state {
            case .idle, .pressed: return .clear
            case .disabled, .loading: return .stateDisabled
        }
    }

    private var borderColor: Color {
        switch state {
            case .idle, .pressed: return .solidDanger
            case .disabled, .loading: return .clear
        }
    }

    private var textColor: Color {
        switch state {
            case .idle, .pressed: return .solidDanger
            default: return .textPrimary
        }
    }

    private func toneStyle(_ configuration: Configuration) -> ToneStyle.Style {
        switch state {
            case .idle: return configuration.isPressed ? .disabled : .idle
            case .disabled: return .disabled
            case .pressed, .loading: return .idle
        }
    }
}

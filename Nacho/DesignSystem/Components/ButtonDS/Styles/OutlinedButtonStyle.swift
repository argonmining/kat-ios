import SwiftUI

struct OutlinedButtonStyle: ButtonStyle {

    @Binding private var state: ButtonDS.State
    private let height: CGFloat

    init(
        _ state: Binding<ButtonDS.State> = .constant(.idle),
        height: CGFloat
    ) {
        self._state = state
        self.height = height
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(.button, color: .textPrimary)
            .toneStyle(toneStyle(state: state, isPressed: configuration.isPressed))
            .padding(.vertical, Spacing.padding_2)
            .padding(.horizontal, Spacing.padding_3)
            .frame(height: height)
            .background(backColor(state: state, isPressed: configuration.isPressed))
            .cornerRadius(Radius.radius_max)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.radius_max)
                    .stroke(
                        borderColor(
                            state: state,
                            isPressed: configuration.isPressed
                        ),
                        lineWidth: 1
                    )
            )
            .contentShape(Rectangle())
    }

    private func borderColor(state: ButtonDS.State, isPressed: Bool) -> Color {
        switch state {
            case .idle, .pressed: return .borderRegularPrimary
            case .disabled, .loading: return .clear
        }
    }

    private func textColor(state: ButtonDS.State) -> Color {
        switch state {
            case .disabled: return .textPrimary
            default: return .textOnAccent
        }
    }

    private func toneStyle(state: ButtonDS.State, isPressed: Bool) -> ToneStyle.Style {
        switch state {
            case .idle: return isPressed ? .disabled : .idle
            case .disabled: return .disabled
            case .pressed, .loading: return .idle
        }
    }

    private func backColor(state: ButtonDS.State, isPressed: Bool) -> Color {
        switch state {
        case .idle, .pressed: return .clear
        case .disabled, .loading: return .stateDisabled
        }
    }
}

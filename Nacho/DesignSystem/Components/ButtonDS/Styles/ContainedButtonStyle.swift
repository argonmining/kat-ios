import SwiftUI

struct ContainedButtonStyle: ButtonStyle {

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
            .typography(.button, color: textColor(state: state))
            .toneStyle(toneStyle(state: state))
            .padding(.vertical, Spacing.padding_2)
            .padding(.horizontal, Spacing.padding_3)
            .frame(height: height)
            .background(backColor(state: state, isPressed: configuration.isPressed))
            .cornerRadius(Radius.radius_max)
            .contentShape(Rectangle())
    }

    func borderColor(state: ButtonDS.State, isPressed: Bool) -> Color {
        switch state {
            case .idle: return isPressed ? .statePressedAccent : .surfaceAccent
            case .pressed: return .statePressedAccent
            case .disabled, .loading: return .stateDisabled
        }
    }

    private func textColor(state: ButtonDS.State) -> Color {
        switch state {
            case .disabled: return .textPrimary
            default: return .textOnAccent
        }
    }

    private func toneStyle(state: ButtonDS.State) -> Tone.Style {
        switch state {
            case .disabled: return .disabled
            default: return .idle
        }
    }

    private func backColor(state: ButtonDS.State, isPressed: Bool) -> Color {
        switch state {
            case .idle: return isPressed ? .statePressedAccent : .surfaceAccent
            case .pressed: return .statePressedAccent
            case .disabled, .loading: return .stateDisabled
        }
    }
}

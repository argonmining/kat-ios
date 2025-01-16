import SwiftUI

struct TypographyStyle: ViewModifier {

    enum Style {
        case headline1
        case headline2
        case headline3
        case subtitle
        case numeric
        case button
        case body1
        case body2
        case caption
        case caption2
    }

    let style: Style
    let color: Color?

    init(style: Style, color: Color?) {
        self.style = style
        self.color = color
    }

    private var font: Font {
        switch style {
        case .headline1:
            return .system(size: 48, weight: .heavy, design: .default)
        case .headline2:
            return .system(size: 32, weight: .heavy, design: .default)
        case .headline3:
            return .system(size: 24, weight: .heavy, design: .default)
        case .subtitle:
            return .system(size: 16, weight: .bold, design: .default)
        case .numeric:
            return .system(size: 32, weight: .regular, design: .monospaced)
        case .button:
            return .system(size: 16, weight: .bold, design: .default)
        case .body1:
            return .system(size: 16, weight: .regular, design: .default)
        case .body2:
            return .system(size: 15, weight: .regular, design: .default)
        case .caption:
            return .system(size: 14, weight: .regular, design: .default)
        case .caption2:
            return .system(size: 12, weight: .regular, design: .default)
        }
    }

    private var textColor: Color {
        if let color = color {
            return color
        } else {
            switch style {
            case .caption, .caption2:
                return .secondary
            default:
                return .primary
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(textColor)
    }
}

extension View {
    func typography(_ style: TypographyStyle.Style, color: Color? = nil) -> some View {
        self.modifier(TypographyStyle(style: style, color: color))
    }
}

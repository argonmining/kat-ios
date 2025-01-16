import SwiftUI

struct WidgetDS<Content: View>: View {

    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.padding_2)
            .background(
                RoundedRectangle(cornerRadius: Radius.radius_3)
                    .foregroundColor(.surfaceForeground)
            )
    }
}

#Preview {
    Group {
        WidgetDS {
            VStack(alignment: .leading) {
                Text("Hello world")
                    .typography(.subtitle)
                Text("Some text here and there with the multiline content")
                    .typography(.body2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
    }
    .background(Color.surfaceBackground)
}

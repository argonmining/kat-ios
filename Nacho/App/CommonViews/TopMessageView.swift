import SwiftUI

struct TopMessageView: View {
    
    let message: String
    let color: Color = .solidInfo
    
    var body: some View {
        Text(message)
            .typography(.body1, color: .textOnSolid)
            .multilineTextAlignment(.center)
            .padding(.vertical, Spacing.padding_2)
            .padding(.horizontal, Spacing.padding_3)
            .background(color)
            .cornerRadius(Radius.radius_3)
    }
}

#Preview {
    TopMessageView(message: "Hello World!")
}

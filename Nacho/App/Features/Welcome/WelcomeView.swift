import SwiftUI

struct WelcomeView: View {

    let namespace: Namespace.ID
    @Binding var slideOutStep: Int
    var onButtonStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.padding_2) {
            Image("logo")
                .resizable()
                .frame(width: Size.iconLarge, height: Size.iconLarge)
                .offset(y: slideOutStep >= 3 ? 70 : 0)
            Spacer()
            HStack {
                Text(Localization.welcomeTitle)
                    .typography(.headline1, color: .textOnAccent)
                    .multilineTextAlignment(.leading)
                    .offset(x: slideOutStep >= 1 ? -UIScreen.main.bounds.width : 0)
                Spacer()
            }
            Text(Localization.welcomeSubtitle)
                .typography(.subtitle, color: .textOnAccent)
                .offset(x: slideOutStep >= 2 ? -UIScreen.main.bounds.width : 0)
            Text(Localization.welcomeDescription)
                .typography(.body1, color: .textOnAccent)
                .lineSpacing(Spacing.padding_0_5)
                .padding(.bottom, Spacing.padding_1)
                .offset(x: slideOutStep >= 3 ? -UIScreen.main.bounds.width : 0)
            ButtonDS(Localization.buttonStart, style: .inverted) {
                onButtonStart()
            }
        }
        .padding(Spacing.padding_2)
        .background(
            Color.surfaceAccent
                .ignoresSafeArea()
        )
        .animation(.easeInOut, value: slideOutStep)
    }
}


#Preview {
    @Previewable @Namespace var namespace
    WelcomeView(namespace: namespace, slideOutStep: .constant(0)) {}
}

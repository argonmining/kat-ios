import SwiftUI

struct ToastMessageViewModifier: ViewModifier {

    let message: String
    @Binding var isPresented: Bool
    let color: Color
    let duration: Double

    @State private var toastOffset: CGFloat = UIScreen.main.bounds.height

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                GeometryReader { geometry in
                    Text(message)
                        .typography(.body1, color: .textOnSolid)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, Spacing.padding_1)
                        .padding(.horizontal, Spacing.padding_4)
                        .background(color)
                        .cornerRadius(Radius.radius_4)
                        .frame(maxWidth: .infinity)
                        .offset(y: toastOffset)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.2), value: toastOffset)
                        .onAppear {
                            toastOffset = geometry.size.height - geometry.safeAreaInsets.bottom - 80
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    toastOffset = geometry.size.height
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isPresented = false
                                }
                            }
                        }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

extension View {

    func toastMessageDS(
        message: String,
        isPresented: Binding<Bool>,
        color: Color = Color.solidInfo,
        duration: Double = 3.0
    ) -> some View {
        self.modifier(
            ToastMessageViewModifier(
                message: message,
                isPresented: isPresented,
                color: color,
                duration: duration
            )
        )
    }
}

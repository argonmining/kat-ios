import SwiftUI

struct ShimmerModifier: ViewModifier {

    @State private var phase: CGFloat = -1
    let animation: Animation

    init(animation: Animation) {
        self.animation = animation
    }

    func body(content: Content) -> some View {
        content
            .modifier(AnimatedMask(phase: phase))
            .onAppear {
                withAnimation(animation) {
                    phase = 1.5
                }
            }
    }

    struct AnimatedMask: AnimatableModifier {
        var phase: CGFloat
        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }

        func body(content: Content) -> some View {
            content
                .mask(GradientMask(phase: phase).scaleEffect(3))
        }
    }

    struct GradientMask: View {
        let phase: CGFloat
        let centerColor = Color.black
        let edgeColor = Color.black.opacity(0.5)

        var body: some View {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: edgeColor, location: phase),
                    .init(color: centerColor, location: phase + 0.1),
                    .init(color: edgeColor, location: phase + 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

public extension View {

    @ViewBuilder func shimmer(
        isActive: Bool = true,
        animation: Animation = .linear(duration: 1).repeatForever(autoreverses: false)
    ) -> some View {
        if isActive {
            redacted(reason: .placeholder)
                .modifier(ShimmerModifier(animation: animation))
        } else {
            self
        }
    }
}

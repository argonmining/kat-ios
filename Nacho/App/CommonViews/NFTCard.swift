import SwiftUI

struct NFTCard: View {

    let frontImageName: String
    let backImageName: String
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            if isFlipped {
                backSide
            } else {
                frontSide
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.3), value: isFlipped)
    }

    private var frontSide: some View {
        Image(frontImageName)
            .resizable()
            .scaledToFit()
            .aspectRatio(5 / 6, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: Radius.radius_2))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.radius_2)
                    .stroke(.surfaceForeground, lineWidth: 4)
            )
            .shadow(radius: 4)
    }

    private var backSide: some View {
        Image("cardBack")
            .resizable()
            .scaledToFit()
            .aspectRatio(5 / 6, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: Radius.radius_2))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.radius_2)
                    .stroke(.surfaceForeground, lineWidth: 4)
            )
            .rotation3DEffect(
                .degrees(180),
                axis: (x: 0, y: 1, z: 0)
            )
            .shadow(radius: 4)
        }
}

#Preview {
    VStack {
        NFTCard(
            frontImageName: "nft1",
            backImageName: "nft2",
            isFlipped: .constant(false)
        )
        .padding(Spacing.padding_6)
    }
    .background(Color.surfaceBackground)
}

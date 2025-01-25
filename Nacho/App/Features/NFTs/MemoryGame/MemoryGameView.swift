import SwiftUI
import Vortex

struct MemoryGameView: View {

    @State var viewModel: MemoryGameViewModel

    @State private var cards: [Card] = []
    @State private var flippedCards: [Card] = [] // Cards currently flipped
    @State private var matchedCards: Set<String> = [] // Cards that are already matched
    @State private var isGameFinished = false
    @State private var isFlippedArray: [Bool] = [] // Track flip status for each card
    @State private var cardScales: [CGFloat] = []
    @State private var interactionEnabled: Bool = true

    @State private var startTime: Date? // Track the start time
    @State private var elapsedTime: TimeInterval = 0 // Time taken to finish the game
    @State private var currentElapsedTime: TimeInterval = 0
    @State private var isFirstTap = true

    @State private var isFannedOut = false

    var body: some View {
        ZStack {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: calculateGridColumns())) {
                    ForEach(cards.indices, id: \.self) { index in
                        NFTCard(
                            frontImageName: cards[index].imageName,
                            backImageName: "back_image",
                            isFlipped: $isFlippedArray[index]
                        )
                        .scaleEffect(cardScales[index])
                        .onTapGesture {
                            Task {
                                await handleCardTap(cards[index], at: index)
                            }
                        }
                        .opacity(matchedCards.contains(cards[index].imageName) ? 0.5 : 1)
                        .padding(Spacing.padding_0_2_5)
                    }
                }
                .padding()
                Spacer()
            }
            .blur(radius: isGameFinished ? 3 : 0)
            .background(Color.surfaceBackground.ignoresSafeArea())
            .onAppear {
                setupGame()
            }

            if isGameFinished {
                VortexView(.fireworks) {
                    Circle()
                        .fill(.accent)
                        .blendMode(.plusLighter)
                        .frame(width: 24)
                        .tag("circle")
                }
                popupDialog
            }
        }
        .navigationTitle(
            startTime == nil || isGameFinished
            ? Localization.nftsGameTitle
            : formatTime(currentElapsedTime)
        )
    }

    private var popupDialog: some View {
        VStack(spacing: Spacing.padding_2) {
            Text(formatTime(elapsedTime))
                .typography(.numeric2)
                

            ZStack {
                ForEach(viewModel.images.indices, id: \.self) { index in
                    Image(viewModel.images[index])
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(5 / 6, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.radius_2))
                        .frame(height: 110)
                        .shadow(radius: 2)
                        .rotationEffect(Angle(degrees: isFannedOut ? Double(index) * 10 - Double(viewModel.images.count - 1) * 5 : 0))
                        .offset(x: isFannedOut ? CGFloat(index - viewModel.images.count / 2) * 10 : 0, y: 0)
                        .zIndex(Double(index))
                }
            }
            .padding()
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 1)) {
                    isFannedOut = true
                }
            }
            ButtonDS(Localization.nftsButtonPlayAgain, isSmall: true) {
                resetGame()
            }
        }
        .padding(Spacing.padding_2)
        .background(
            RoundedRectangle(cornerRadius: Radius.radius_3)
                .fill(Material.regular.opacity(0.9))
        )
        .padding(Spacing.padding_10)
        .padding(.bottom, Spacing.padding_10)
    }

    private func calculateGridColumns() -> Int {
        let itemCount = cards.count
        if itemCount <= 4 { return 2 }
        if itemCount <= 12 { return 3 }
        return 4
    }

    private func setupGame() {
        let pairedImages = viewModel.images.flatMap { [Card(imageName: $0), Card(imageName: $0)] }
        cards = pairedImages.shuffled()

        isFlippedArray = Array(repeating: true, count: cards.count)
        cardScales = Array(repeating: 1.0, count: cards.count)

        // Reset state
        startTime = nil
        elapsedTime = 0
        currentElapsedTime = 0
        matchedCards.removeAll()
        flippedCards.removeAll()
        isGameFinished = false
        elapsedTime = 0
        isFirstTap = true
    }

    private func resetGame() {
        setupGame() // Restart the game
    }

    private func handleCardTap(_ tappedCard: Card, at index: Int) async {
        if isFirstTap {
            startTime = Date()
            isFirstTap = false
            Task {
                await startTimer()
            }
        }
        guard !matchedCards.contains(tappedCard.imageName) else { return }
        guard interactionEnabled else { return }
        guard !flippedCards.contains(tappedCard) else { return }
        isFlippedArray[index].toggle()

        if flippedCards.count == 0 {
            flippedCards.append(tappedCard)
            return
        } else if flippedCards.count == 1 {
            interactionEnabled = false
            flippedCards.append(tappedCard)
            if await checkForMatch() {
                if await checkGameCompletion() {
                    elapsedTime = Date().timeIntervalSince(startTime ?? Date())
                    isFirstTap = true
                    withAnimation { isGameFinished = true }
                }
            }
        }
    }

    private func checkForMatch() async -> Bool {
        guard flippedCards.count == 2 else { return false }
        if flippedCards[0].imageName == flippedCards[1].imageName {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5)) {
                if let firstIndex = cards.firstIndex(of: flippedCards[0]),
                   let secondIndex = cards.firstIndex(of: flippedCards[1]) {
                    cardScales[firstIndex] = 1.2
                    cardScales[secondIndex] = 1.2
                }
            }
            try? await Task.sleep(nanoseconds: 500_000_000) // Wait 0.5 seconds

            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5)) {
                if let firstIndex = cards.firstIndex(of: flippedCards[0]),
                   let secondIndex = cards.firstIndex(of: flippedCards[1]) {
                    cardScales[firstIndex] = 1.0 // Reset scale
                    cardScales[secondIndex] = 1.0
                    matchedCards.insert(flippedCards[0].imageName)
                    matchedCards.insert(flippedCards[1].imageName)
                }
                flippedCards.removeAll()
                interactionEnabled = true
            }
            return true
        }

        try? await Task.sleep(nanoseconds: 1_000_000_000) // Wait 1 second

        // Flip the cards back if not matched
        if flippedCards.count == 2 {
            let firstIndex = cards.firstIndex(of: flippedCards[0])!
            let secondIndex = cards.firstIndex(of: flippedCards[1])!
            if flippedCards[0].imageName != flippedCards[1].imageName {
                isFlippedArray[firstIndex].toggle()
                isFlippedArray[secondIndex].toggle()
            }
        }
        flippedCards.removeAll()
        interactionEnabled = true
        return false
    }

    private func checkGameCompletion() async -> Bool {
        return matchedCards.count == cards.count / 2
    }

    private func startTimer() async {
        while !isGameFinished {
            currentElapsedTime = Date().timeIntervalSince(startTime ?? Date())
            try? await Task.sleep(nanoseconds: 10_000_000) // 0.1 seconds
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time * 100).truncatingRemainder(dividingBy: 100))
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
}

#Preview {
    NavigationView {
        MemoryGameView(viewModel: .init(images: ["nft1", "nft2", "nft3", "nft4", "nft5", "nft6"]))
    }
}

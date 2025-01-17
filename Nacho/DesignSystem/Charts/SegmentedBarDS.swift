import SwiftUI

struct SegmentedBarDS: View {

    private let segments: [Segment]
    private let spacing: CGFloat
    private let outerCornerRadius: CGFloat
    private let innerCornerRadius: CGFloat

    init(
        segments: [Segment],
        spacing: CGFloat = Spacing.padding_0_5,
        outerCornerRadius: CGFloat = Radius.radius_max,
        innerCornerRadius: CGFloat = .zero
    ) {
        self.segments = segments.filter { $0.value > 0 }
        self.spacing = spacing
        self.outerCornerRadius = outerCornerRadius
        self.innerCornerRadius = innerCornerRadius
    }

    private var totalValue: Double {
        segments.reduce(0) { $0 + $1.value }
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: spacing) {
                ForEach(segments.indices, id: \.self) { index in
                    let segment = segments[index]
                    let widthRatio = segment.value / totalValue
                    let isFirst = index == 0
                    let isLast = index == segments.count - 1

                    Rectangle()
                        .fill(segment.color)
                        .frame(width: minWidth(geometry.size.width * widthRatio - (!isLast ? spacing : 0)))
                        .clipShape(
                            .rect(
                                topLeadingRadius: isFirst ? outerCornerRadius : innerCornerRadius,
                                bottomLeadingRadius: isFirst ? outerCornerRadius : innerCornerRadius,
                                bottomTrailingRadius: isLast ? outerCornerRadius : innerCornerRadius,
                                topTrailingRadius: isLast ? outerCornerRadius : innerCornerRadius
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func minWidth(_ value: CGFloat) -> CGFloat {
        return value < 5 ? 5 : value
    }
}

extension SegmentedBarDS {

    struct Segment {
        let value: Double
        let color: Color
    }
}

#Preview {
    VStack {
        SegmentedBarDS(
            segments: [
                SegmentedBarDS.Segment(value: 30, color: .solidInfo),
                SegmentedBarDS.Segment(value: 20, color: .solidDanger),
                SegmentedBarDS.Segment(value: 20, color: .solidWarning)
            ]
        )
        .frame(width: .infinity, height: 12)
        .padding()
    }
    .background(Color.surfaceBackground)
}

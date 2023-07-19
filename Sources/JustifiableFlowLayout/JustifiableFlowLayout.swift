import SwiftUI

/// A Layout that lays out its subviews left to right and top to bottom, in sequential order.  It can use exact spacing, or justify by the width of the widest subview.
///
/// By default it is a standard flow layout, where an exact spacing is applied between items.
///
/// It can also be used as a 'justified' flow layout, where the widest item determines the spacing and alignment, creating an even appearance of neat columns.
public struct JustifiableFlowLayout: Layout {
    
    private let minSpacing: CGFloat
    
    private let shouldJustify: Bool
    
    /// Creates a JustifiableFlowLayout.
    ///
    /// - Parameters:
    ///   - minSpacing: The minimum spacing between subviews. Defaults to 4.0.
    ///   - shouldJustify: If true, the width of the widest subview is used to align the subviews into columns. If false, the `minSpacing` is applied precisely between items. Defaults to false.
    public init(minSpacing: CGFloat = 4, shouldJustify: Bool = false) {
        self.minSpacing = minSpacing
        self.shouldJustify = shouldJustify
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        // The widest child will be used to determine placement
        let justifiedWidth = shouldJustify ? maxWidth(sizes: sizes) : 0
        
        // The total width offered to the grid
        // If the proposed width is unspecified, let the system replace it with an appropriate guess
        let maxLineWidth = proposal.replacingUnspecifiedDimensions().width
        
        // The total height needed by the grid, to be calculated
        var totalHeight: CGFloat = 0
        
        // The total width needed by the grid, to be calculated
        var totalWidth: CGFloat = 0
        
        // Dimensions of the current line
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for size in sizes {
            let itemWidth = shouldJustify ? justifiedWidth : size.width
            
            // if the item is too wide to fit on the current line...
            if lineWidth + itemWidth > maxLineWidth {
                // ... move to a new line
                
                totalHeight += lineHeight + minSpacing
                lineWidth = itemWidth + minSpacing
                lineHeight = size.height
            } else {
                // else update the width and height of the current line
                lineWidth += itemWidth + minSpacing
                lineHeight = max(lineHeight, size.height)
            }
            
            // The final spacing can be removed if this is the end of the line
            totalWidth = max(totalWidth, lineWidth - minSpacing)
        }
        
        totalHeight += lineHeight
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        // The widest child will be used to determine placement
        let justifiedWidth = shouldJustify ? maxWidth(sizes: sizes) : 0
        
        // The total width offered to the grid
        // If the proposed width is unspecified, let the system replace it with an appropriate guess
        let maxLineWidth = proposal.replacingUnspecifiedDimensions().width
        let maxX = min(bounds.minX + maxLineWidth, bounds.maxX)
        
        // x and y positions to place the next item
        // start laying out from the rectangle's top left corner
        var lineX = bounds.minX
        var lineY = bounds.minY
        
        // Height of the current line
        var lineHeight: CGFloat = 0
        
        for index in subviews.indices {
            let itemWidth = shouldJustify ? justifiedWidth : sizes[index].width
            
            // if the item is too wide to fit on the current line...
            if lineX + itemWidth > maxX {
                // ... move to a new line
                lineY += lineHeight + minSpacing
                lineHeight = 0
                lineX = bounds.minX
            }
            
            // place the item, anchored at its centre
            subviews[index].place(
                at: .init(
                    x: lineX + itemWidth / 2,        // centreX
                    y: lineY + sizes[index].height / 2    // centreY
                ),
                anchor: .center,
                proposal: ProposedViewSize(sizes[index])
            )
            
            // make sure the line height is big enough to fit the latest item
            lineHeight = max(lineHeight, sizes[index].height)
            
            // update the width of the line
            lineX += itemWidth + minSpacing
        }
    }
    
    // MARK: Private helpers
    
    private func maxWidth(sizes: [CGSize]) -> CGFloat {
        sizes
            .map { size in size.width }
            .max() ?? 0
    }
}

// MARK: - Previews

struct JustifiableFlowLayout_Previews: PreviewProvider {
    
    static let uniqueLetters = ["r", "s", "t", "u", "v", "w", "x", "y", "z", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    static let uniqueWords = ["cloud", "hill", "thunder", "if", "run", "fright", "just", "twenty", "agent", "theatre", "ink", "so", "rig", "week", "range", "today"]
    
    static var previews: some View {
        
        JustifiableFlowLayout(minSpacing: 10, shouldJustify: false) {
            ForEach(uniqueLetters, id: \.self) { letter in
                Text(letter)
                    .font(.largeTitle)
                    .padding(20)
                    .background(Color.yellow.opacity(0.3))
            }
        }
        .padding()
        .previewDisplayName("Default, similar widths")
        
        JustifiableFlowLayout(minSpacing: 10, shouldJustify: true) {
            ForEach(uniqueLetters, id: \.self) { letter in
                Text(letter)
                    .font(.largeTitle)
                    .padding(20)
                    .background(Color.yellow.opacity(0.3))
            }
        }
        .padding()
        .previewDisplayName("Justified, similar widths")
        
        JustifiableFlowLayout(minSpacing: 10, shouldJustify: false) {
            ForEach(uniqueWords, id: \.self) { word in
                Text(word)
                    .font(.title2)
                    .padding(20)
                    .border(Color.mint, width: 2.5)
            }
        }
        .padding()
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDisplayName("Default, varied widths")
        
        JustifiableFlowLayout(minSpacing: 10, shouldJustify: true) {
            ForEach(uniqueWords, id: \.self) { word in
                Text(word)
                    .font(.title2)
                    .padding(20)
                    .border(Color.mint, width: 2.5)
            }
        }
        .padding()
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDisplayName("Justified, varied widths")
    }
}

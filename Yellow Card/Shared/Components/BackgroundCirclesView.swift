import SwiftUI

/// A view that creates a blurred gradient background effect using overlapping circles
struct BackgroundCirclesView: View {
    var body: some View {
        GeometryReader { geometry in
            // Stack circles on top of each other
            ZStack {
                // Create 3 circles with different sizes and offsets
                ForEach(0..<3) { index in
                    backgroundCircle(for: index, geometry: geometry)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    /// Creates a single background circle with gradient fill, offset, and blur
    /// - Parameters:
    ///   - index: The index of the circle (0-2) which determines its size and position
    ///   - geometry: The GeometryProxy to get screen size
    /// - Returns: A styled circle view
    private func backgroundCircle(for index: Int, geometry: GeometryProxy) -> some View {
        // Calculate base size for scaling
        let baseSize = max(geometry.size.width, geometry.size.height)
        
        // Size increases with index
        let circleSize = baseSize * (0.4 + CGFloat(index) * 0.2)
        
        // Offset diagonally based on index
        let offsetX = geometry.size.width * (CGFloat(index) * 0.1 - 0.2)
        let offsetY = geometry.size.height * (CGFloat(index) * 0.1 - 0.2)
        
        // Apply increasing blur effect for depth
        let blurRadius = baseSize * 0.02 * CGFloat(index + 1)
        
        return Circle()
            // Apply gradient fill from blue to purple with transparency
            .fill(
                LinearGradient(
                    colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            // Adjust size
            .frame(width: circleSize, height: circleSize)
            // Apply offset
            .offset(x: offsetX, y: offsetY)
            // Apply blur
            .blur(radius: blurRadius)
    }
}

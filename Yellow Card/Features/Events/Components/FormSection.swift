
import SwiftUI

/// A custom form section view that displays a header and content
struct FormSection<Content: View>: View {
    /// The header text to display above the content
    let header: String
    /// The content view to display below the header
    let content: Content

    /// Creates a new form section with the given header and content
    /// - Parameters:
    ///   - header: The text to display as the section header
    ///   - content: A closure that returns the content view
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }

    var body: some View {
        // Stack the header and content vertically with left alignment
        VStack(alignment: .leading, spacing: 10) {
            // Display the header text
            Text(header)
                .font(.headline)
                .foregroundColor(.white)
            // Display the content view
            content
        }
    }
}

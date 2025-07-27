//
//  HomeView.swift
//  TrackWeight
//

import SwiftUI

struct HomeView: View {
    // State variables for the "Begin" button animations
    @State private var isHovering: Bool = false
    @State private var isPressing: Bool = false

    // Action closure for the "Begin" button
    let onBegin: () -> Void

    var body: some View {
        VStack(spacing: 40) { // Overall spacing between major sections
            Spacer() // Pushes content towards the center/top if there's space

            // Title section
            VStack(spacing: 15) {
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundStyle(Color.blue) // Keep the original blue for the icon

                Text("TrackWeight")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .teal, .cyan], // Original gradient for the title
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }

            // Description and Limitations section (now more responsive and aesthetic)
            VStack(spacing: 30) { // Spacing between description and limitations box
                Text("Transform your MacBook trackpad into a precision scale using Apple's private MultitouchSupport framework to read pressure values with gram-level accuracy.")
                    .font(.system(size: 19, weight: .medium)) // Slightly larger font for main description
                    .foregroundStyle(Color.primary) // Adapts to light/dark mode
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 600) // Increased max width for better readability on larger screens
                    .padding(.horizontal, 20) // Horizontal padding to prevent text from touching edges

                // Limitations section container (with glassmorphism effect)
                VStack(spacing: 15) { // Spacing within the limitations box
                    Text("Important Limitations")
                        .font(.system(size: 17, weight: .semibold)) // Slightly larger, bolder font for title
                        .foregroundStyle(Color.orange) // Keep the orange accent for the title

                    VStack(alignment: .leading, spacing: 10) { // Align limitation rows to the leading edge
                        LimitationRow(
                            icon: "hand.point.up.left",
                            text: "Requires finger contact for capacitive detection. Objects must be non-conductive and have sufficient surface area."
                        )
                        LimitationRow(
                            icon: "chart.line.downtrend.xyaxis",
                            text: "May experience slight pressure drift when placing objects due to temperature or contact changes. Calibration is recommended."
                        )
                        LimitationRow(
                            icon: "cube.box.fill",
                            text: "Metal or magnetic objects may interfere with the trackpad's sensors and may not register accurately or at all."
                        )
                    }
                    .padding(.top, 5) // Small space between "Important Limitations" title and the first row
                }
                .padding(.horizontal, 30) // Horizontal padding for content *inside* the limitations box
                .padding(.vertical, 25) // Vertical padding for content *inside* the limitations box
                .background(
                    RoundedRectangle(cornerRadius: 20) // More rounded corners for the box
                        .fill(.ultraThinMaterial) // Frosted glass effect!
                )
                .overlay( // Subtle white stroke for definition
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5) // Softer, more diffuse shadow
                .frame(maxWidth: 550) // Max width for the entire limitations box
                .padding(.horizontal, 20) // Ensure the entire box has horizontal padding from screen edges
            }

            // Begin button (with glassmorphism effect and animations)
                       // Begin button
            Button(action: {
                           self.isPressing = true
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                               self.isPressing = false
                               onBegin()
                           }
                       }) {
                           HStack(spacing: 10) {
                               Text("Begin")
                                   .font(.system(size: 18, weight: .semibold))
                               Image(systemName: "scalemass.fill") // SF Symbol for the arrow
                                   .font(.system(size: 16, weight: .semibold))
                                   // Icon movement on hover
                                   .offset(x: isHovering ? 3 : 0) // Move icon right on hover
                           }
                           .foregroundStyle(.white) // Text and icon color
                           .frame(width: 140, height: 50) // Fixed size for consistency
                           .background(
                               RoundedRectangle(cornerRadius: 20)
                                   .fill(
                                       LinearGradient(
                                           // Adjust colors based on hover/press state for dynamic gradient
                                           colors: isPressing ? [.init(red: 0.35, green: 0.13, blue: 0.71), .init(red: 0.49, green: 0.23, blue: 0.98)] : // Darker on press
                                                   (isHovering ? [.init(red: 0.49, green: 0.23, blue: 0.98), .init(red: 0.65, green: 0.54, blue: 0.98)] : // Brighter on hover
                                                    [.blue, .teal]), // Original gradient
                                           startPoint: .leading,
                                           endPoint: .trailing
                                       )
                                   )
                           )
                           // Shadow effect based on hover/press
                           .shadow(color: Color.black.opacity(isPressing ? 0.15 : (isHovering ? 0.35 : 0.2)),
                                   radius: isPressing ? 8 : (isHovering ? 25 : 15),
                                   x: 0,
                                   y: isPressing ? 2 : (isHovering ? 8 : 4))
                       }
                       .buttonStyle(.plain)
                       .padding(.vertical, 10)
                       // Scale and lift effect based on hover/press
                       .scaleEffect(isPressing ? 0.98 : (isHovering ? 1.02 : 1.0))
                       .offset(y: isHovering ? -3 : 0) // Lift button on hover
                       // Apply animations for smooth transitions
                       .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovering) // Smooth hover animation
                       .animation(.easeOut(duration: 0.1), value: isPressing) // Quicker press animation
                       .onHover { hover in // For macOS hover detection
                           self.isHovering = hover
                       }
            Spacer() // Pushes content towards the center/bottom if there's space
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the VStack fill the available screen
        .padding(.horizontal, 40) // Overall horizontal padding for the entire HomeView content
    }
}

/// A reusable SwiftUI view for displaying a single limitation row with an icon and text.
/// Includes a subtle hover effect for macOS.
struct LimitationRow: View {
    let icon: String // SF Symbol name (e.g., "hand.point.up.left")
    let text: String // The description text for the limitation

    // State to track if the mouse is hovering over this specific row (macOS only)
    @State private var isRowHovering: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Icon for the limitation
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium)) // Consistent icon size
                .foregroundStyle(Color.orange) // Keep the orange accent for the icon
                .frame(width: 25) // Give the icon a fixed width to align text nicely

            // Text description for the limitation
            Text(text)
                .font(.system(size: 15, weight: .regular)) // Slightly smaller, regular weight
                .foregroundStyle(Color.secondary) // Use secondary color for softer text
                .lineLimit(nil) // Allow text to wrap to multiple lines
                .fixedSize(horizontal: false, vertical: true) // Allow text to take up vertical space as needed
        }
        .padding(.vertical, 5) // Small vertical padding inside the row
        .padding(.horizontal, 10) // Small horizontal padding inside the row
        .background(
            RoundedRectangle(cornerRadius: 10) // Background for the row itself
                // Apply a very subtle white background on hover
                .fill(isRowHovering ? Color.white.opacity(0.08) : Color.clear)
        )
        .cornerRadius(10) // Clip content to rounded corners
        // Subtle scale effect on hover
        .scaleEffect(isRowHovering ? 1.01 : 1.0)
        // Subtle shadow effect on hover
        .shadow(color: Color.black.opacity(isRowHovering ? 0.1 : 0),
                radius: isRowHovering ? 5 : 0,
                x: 0,
                y: isRowHovering ? 2 : 0)
        // Smooth animation for hover effects
        .animation(.easeOut(duration: 0.2), value: isRowHovering)
        .onHover { hover in // macOS specific modifier to detect hover
            isRowHovering = hover
        }
    }
}

// Preview Provider for Xcode Canvas
#Preview {
    // To properly see the glassmorphism effect, provide a background in the preview
    ZStack {
        LinearGradient(gradient: Gradient(colors: [.purple, .blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all) // Make the gradient fill the entire preview area

        HomeView(onBegin: {
            print("Begin button tapped from preview!")
        })
    }
}

//
//  ScaleView.swift
//  TrackWeight
//

import SwiftUI
import AppKit


struct ScaleView: View {
    @StateObject private var viewModel = ScaleViewModel()
    @State private var scaleCompression: CGFloat = 0 // Controls vertical compression of the scale
    @State private var displayShake = false // For subtle display shake animation (not used in this version but kept)
    @State private var particleOffset: CGFloat = 0 // For particle effect (not used in this version but kept)
    @State private var keyMonitor: Any?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated gradient background (uncommented and slightly adjusted colors)
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.15), // Darker start
                        Color(red: 0.05, green: 0.05, blue: 0.1)  // Darker end
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: geometry.size.height * 0.06) { // Overall vertical spacing
                    // Title with subtitle directly underneath
                    VStack(spacing: 8) {
                        Text("Track Weight")
                            .font(.system(size: min(max(geometry.size.width * 0.05, 24), 42), weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .teal, .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)

                        Text("Place your finger on the trackpad to begin")
                            .font(.system(size: min(max(geometry.size.width * 0.022, 14), 18), weight: .medium))
                            .foregroundStyle(.gray.opacity(0.7)) // Slightly more visible gray
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: geometry.size.width * 0.8)
                            .opacity(viewModel.hasTouch ? 0 : 1) // Fades out when touch is detected
                            .animation(.easeInOut(duration: 0.5), value: viewModel.hasTouch)
                    }
                    .frame(height: max(geometry.size.height * 0.15, 80)) // Fixed height for title + subtitle
                    .frame(maxWidth: .infinity) // Ensure full width for centering

                    Spacer() // Pushes the scale towards the center

                    // Modern Digital Scale View - responsive size
                    HStack {
                        Spacer()
                        ModernScaleView( // Changed from CartoonScaleView
                            weight: viewModel.currentWeight,
                            hasTouch: viewModel.hasTouch,
                            compression: $scaleCompression,
                            displayShake: $displayShake,
                            scaleFactor: min(geometry.size.width / 700, geometry.size.height / 500)
                        )
                        Spacer()
                    }

                    Spacer() // Pushes button towards the bottom

                    // Fixed container for button to prevent jumping
                    VStack(spacing: 10) {
                        if viewModel.hasTouch {
                            Text("Press spacebar or click to zero")
                                .font(.system(size: min(max(geometry.size.width * 0.018, 12), 16), weight: .medium))
                                .foregroundStyle(.gray.opacity(0.7)) // More visible gray
                        }

                        Button(action: {
                            viewModel.zeroScale()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: min(max(geometry.size.width * 0.02, 14), 18), weight: .semibold))
                                Text("Zero Scale")
                                    .font(.system(size: min(max(geometry.size.width * 0.02, 14), 18), weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(width: min(max(geometry.size.width * 0.2, 140), 180),
                                   height: min(max(geometry.size.height * 0.08, 40), 55))
                            .background(
                                RoundedRectangle(cornerRadius: 25) // Use the same corner radius as the HomeView button
                                    .fill(.ultraThinMaterial) // Glassmorphism for the button
                            )
                            .overlay( // Subtle border for definition
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4) // Softer shadow
                        }
                        .buttonStyle(.plain)
                        .opacity(viewModel.hasTouch ? 1 : 0) // Fades in when touch is detected
                        .scaleEffect(viewModel.hasTouch ? 1 : 0.8) // Scales in when touch is detected
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.hasTouch)
                    }
                    .frame(height: min(max(geometry.size.height * 0.15, 80), 100)) // Fixed space for button + instruction
                    .frame(maxWidth: .infinity) // Ensure full width for centering
                }
                .padding(.horizontal, max(geometry.size.width * 0.05, 20)) // Overall horizontal padding
                .padding(.vertical, max(geometry.size.height * 0.03, 20)) // Overall vertical padding
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the VStack takes full available space
            }
        }
        .focusable()
        .modifier(FocusEffectModifier())
        .onChange(of: viewModel.currentWeight) { newWeight in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {

                scaleCompression = CGFloat(min(newWeight / 100.0, 0.3)) //sensitivity
            }
        }
        .onAppear {
            viewModel.startListening()
            setupKeyMonitoring()
        }
        .onDisappear {
            viewModel.stopListening()
            removeKeyMonitoring()
        }
    }

    private func setupKeyMonitoring() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // Space key code is 49
            if event.keyCode == 49 && viewModel.hasTouch {
                viewModel.zeroScale()
            }
            return event
        }
    }

    private func removeKeyMonitoring() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
    }
}

// MARK: - ModernScaleView (Replaces CartoonScaleView)
struct ModernScaleView: View {
    let weight: Float
    let hasTouch: Bool
    @Binding var compression: CGFloat
    @Binding var displayShake: Bool // Kept for potential future use
    let scaleFactor: CGFloat

    // Max weight for needle rotation (e.g., 200 grams for full sweep)
    private let maxNeedleWeight: Float = 200.0
    // Angle range for the needle (e.g., from -60 degrees to +60 degrees)
    private let needleAngleRange: CGFloat = 120.0

    var body: some View {
        VStack(spacing: 0) {
            // Scale Platform (top part where object is placed)
            RoundedRectangle(cornerRadius: 12 * scaleFactor) // Slightly rounded corners
                .fill(
                    LinearGradient( // Subtle metallic gradient
                        colors: [
                            Color(red: 0.8, green: 0.8, blue: 0.85),
                            Color(red: 0.95, green: 0.95, blue: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 250 * scaleFactor, height: 25 * scaleFactor) // Thicker platform
                .offset(y: compression * 15) // Moves down on compression
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3) // Soft shadow

            // Scale Body (main part)
            ZStack {
                RoundedRectangle(cornerRadius: 20 * scaleFactor) // Rounded, modern shape
                    .fill(.ultraThinMaterial) // Frosted glass body
                    .frame(width: 280 * scaleFactor, height: 180 * scaleFactor) // Wider, more substantial body
                    .scaleEffect(y: 1 - compression * 1.2) // Squeeze effect: Increased multiplier for more squeeze
                    .offset(y: compression * 15) // Adjust vertical position during compression
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10) // Enhanced shadow for depth
                    .overlay( // Subtle outer border
                        RoundedRectangle(cornerRadius: 25 * scaleFactor)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1 * scaleFactor)
                    )

                // Digital Display Screen
                RoundedRectangle(cornerRadius: 15 * scaleFactor)
                    .fill(Color.black.opacity(0.6)) // Dark, slightly transparent background for the screen
                    .frame(width: 200 * scaleFactor, height: 80 * scaleFactor)
                    .overlay( // Inner glow effect for the screen
                        RoundedRectangle(cornerRadius: 15 * scaleFactor)
                            .stroke(Color.white.opacity(hasTouch ? 0.3 : 0.1), lineWidth: hasTouch ? 1.5 * scaleFactor : 1 * scaleFactor)
                            .blur(radius: hasTouch ? 2 * scaleFactor : 0)
                    )
                    .offset(y: -25 * scaleFactor + compression * 15) // Adjust position with compression

                // Weight display (numbers)
                VStack(spacing: 4 * scaleFactor) {
                    Text(String(format: "%.1f", weight))
                        .font(.system(size: 48 * scaleFactor, weight: .bold, design: .monospaced)) // Larger, bolder font
                        .foregroundStyle(.white) // White numbers
                        .shadow(color: .white.opacity(hasTouch ? 0.6 : 0), radius: hasTouch ? 4 : 0) // Glow effect on numbers when touched
                        .animation(.easeInOut(duration: 0.2), value: weight)

                    Text("grams")
                        .font(.system(size: 10 * scaleFactor, weight: .medium)) // Larger unit text
                        .foregroundStyle(.white.opacity(0.6)) // Softer white for units
                }
                .offset(y: 50 * scaleFactor + compression * 15) // Match display screen position

                // Status Indicator (simple dot) - now inside the scale body
                if hasTouch {
                    Circle()
                        .fill(.teal) // Bright teal for active state
                        .frame(width: 20 * scaleFactor, height: 10 * scaleFactor)
                        .offset(x: 120 * scaleFactor, y: -70 * scaleFactor + compression * 15) // Positioned at top-right of screen
                        .animation(.easeInOut(duration: 0.3), value: hasTouch)
                }

                // NEW: Odometer-like Needle Animation
                // Visible only when touch is detected and weight is above a threshold
                if hasTouch && weight > 0.5 { // Show needle only when weighing something
                    // Needle shape
                    Rectangle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 3 * scaleFactor, height: 40 * scaleFactor) // Needle dimensions
                        .cornerRadius(2 * scaleFactor)
                        .offset(y: -25 * scaleFactor + compression * 15) // Position at display center, adjusted for compression
                        .rotationEffect(
                            // Calculate rotation based on weight, clamped to range
                            Angle(degrees: Double(min(weight, maxNeedleWeight) / maxNeedleWeight) * needleAngleRange - (needleAngleRange / 2))
                        )
                        .shadow(color: .white.opacity(0.3), radius: 2 * scaleFactor) // Subtle glow
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: weight) // Smooth animation

                    // Small pivot circle at the base of the needle
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 10 * scaleFactor, height: 10 * scaleFactor)
                        .offset(y: -2 * scaleFactor + compression * 15) // Position at display center, adjusted for compression
                        .shadow(color: .black.opacity(0.2), radius: 2 * scaleFactor)
                }
            }

            // Scale Legs
            HStack(spacing: 160 * scaleFactor) { // Increased spacing between legs
                ForEach(0..<2, id: \.self) { _ in
                    Capsule() // More modern capsule shape for legs
                        .fill(.gray.opacity(0.6))
                        .frame(width: 15 * scaleFactor, height: 40 * scaleFactor) // Thicker, taller legs
                        .offset(y: compression * 3)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2) // Subtle shadow
                }
            }
            .offset(y: -15 * scaleFactor) // Adjust vertical position relative to scale body
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: compression) // Smooth compression animation
    }
}


// MARK: - FocusEffectModifier
struct FocusEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 14.0, *) {
            content.focusEffectDisabled()
        } else {
            content
        }
    }
}

// MARK: - Preview
#Preview {
    // A dark gradient background to highlight the sleek, modern scale design
    LinearGradient(gradient: Gradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.0, blue: 0.05)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
        .overlay(
            ScaleView()
        )
}

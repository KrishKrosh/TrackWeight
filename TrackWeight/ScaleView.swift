//
//  ScaleView.swift
//  TrackWeight
//

import SwiftUI
import AppKit


struct ScaleView: View {
    @StateObject private var viewModel = ScaleViewModel()
    @State private var scaleCompression: CGFloat = 0
    @State private var displayShake = false
    @State private var particleOffset: CGFloat = 0
    @State private var keyMonitor: Any?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.15), // Darker start
                        Color(red: 0.05, green: 0.05, blue: 0.1)  // Darker end
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: geometry.size.height * 0.06) {
                    
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
                            .foregroundStyle(.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: geometry.size.width * 0.8)
                            .opacity(viewModel.hasTouch ? 0 : 1)
                            .animation(.easeInOut(duration: 0.5), value: viewModel.hasTouch)
                    }
                    .frame(height: max(geometry.size.height * 0.15, 80))
                    .frame(maxWidth: .infinity)

                    Spacer()

                    //Scale View - responsive size
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

                    Spacer()

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
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        .opacity(viewModel.hasTouch ? 1 : 0)
                        .scaleEffect(viewModel.hasTouch ? 1 : 0.8)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.hasTouch)
                    }
                    .frame(height: min(max(geometry.size.height * 0.15, 80), 100))
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, max(geometry.size.width * 0.05, 20))
                .padding(.vertical, max(geometry.size.height * 0.03, 20))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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


struct ModernScaleView: View {
    let weight: Float
    let hasTouch: Bool
    @Binding var compression: CGFloat
    @Binding var displayShake: Bool // can be used in future
    let scaleFactor: CGFloat


    private let maxNeedleWeight: Float = 200.0
    private let needleAngleRange: CGFloat = 120.0

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 12 * scaleFactor)
                .fill(
                    LinearGradient( 
                        colors: [
                            Color(red: 0.8, green: 0.8, blue: 0.85),
                            Color(red: 0.95, green: 0.95, blue: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 280 * scaleFactor, height: 20 * scaleFactor)
                .offset(y: compression * 15)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

            // Scale Body (main part)
            ZStack {
                RoundedRectangle(cornerRadius: 20 * scaleFactor)
                    .fill(.ultraThinMaterial)
                    .frame(width: 280 * scaleFactor, height: 180 * scaleFactor)
                    .scaleEffect(y: 1 - compression * 1.2)
                    .offset(y: compression * 15)
                    .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                    .overlay( // Subtle outer border
                        RoundedRectangle(cornerRadius: 20 * scaleFactor)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1 * scaleFactor)
                    )

                // Digital Display Screen
                RoundedRectangle(cornerRadius: 20 * scaleFactor)
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 200 * scaleFactor, height: 80 * scaleFactor)
                    .overlay( // Inner glow effect for the screen
                        RoundedRectangle(cornerRadius: 15 * scaleFactor)
                            .stroke(Color.white.opacity(hasTouch ? 0.3 : 0.1), lineWidth: hasTouch ? 1.5 * scaleFactor : 1 * scaleFactor)
                            .blur(radius: hasTouch ? 2 * scaleFactor : 0)
                    )
                    .offset(y: -25 * scaleFactor + compression * 15)

                // Weight display
                VStack(spacing: 4 * scaleFactor) {
                    Text(String(format: "%.1f", weight))
                        .font(.system(size: 42 * scaleFactor, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white) // White numbers
                        .shadow(color: .white.opacity(hasTouch ? 0.6 : 0), radius: hasTouch ? 4 : 0) // Glow effect when touch
                        .animation(.easeInOut(duration: 0.2), value: weight)

                    Text("grams")
                        .font(.system(size: 10 * scaleFactor, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .offset(y: 50 * scaleFactor + compression * 15)

                // Status Indicator
                if hasTouch {
                    Circle()
                        .fill(.teal)
                        .frame(width: 20 * scaleFactor, height: 10 * scaleFactor)
                        .offset(x: 120 * scaleFactor, y: -70 * scaleFactor + compression * 15)
                        .animation(.easeInOut(duration: 0.3), value: hasTouch)
                }

// Needle Animation
                if weight > 0.5 {
                    Rectangle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 3 * scaleFactor, height: 40 * scaleFactor)
                        .cornerRadius(2 * scaleFactor)
                        .offset(y: -25 * scaleFactor + compression * 15)
                        .rotationEffect(
                            Angle(degrees: Double(min(weight, maxNeedleWeight) / maxNeedleWeight) * needleAngleRange - (needleAngleRange / 2))
                        )
                        .shadow(color: .white.opacity(0.3), radius: 2 * scaleFactor)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: weight)

                    // Pivot circle
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 10 * scaleFactor, height: 10 * scaleFactor)
                        .offset(y: -2 * scaleFactor + compression * 15)
                        .shadow(color: .black.opacity(0.2), radius: 2 * scaleFactor)


                }
            }

            // Scale Legs
            HStack(spacing: 160 * scaleFactor) {
                ForEach(0..<2, id: \.self) { _ in
                    Capsule()
                        .fill(.gray.opacity(0.5))
                        .frame(width: 20 * scaleFactor, height: 40 * scaleFactor)
                        .offset(y: -2 * compression * 3)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2) // Subtle shadow
                }
            }
            .offset(y: -15 * scaleFactor)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: compression)
    }
}


struct FocusEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 14.0, *) {
            content.focusEffectDisabled()
        } else {
            content
        }
    }
}


#Preview {
    //dark gradient background
    LinearGradient(gradient: Gradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.1), Color(red: 0.0, green: 0.0, blue: 0.05)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
        .overlay(
            ScaleView()
        )
}

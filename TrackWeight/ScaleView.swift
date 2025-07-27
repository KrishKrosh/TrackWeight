//
//  ScaleView.swift
//  TrackWeight
//

import SwiftUI
import AppKit

// MARK: - ViewModel (Required for the view to work)
// ⚠️ If you have this class defined elsewhere, DELETE this placeholder to avoid errors.



// MARK: - Main View
struct ScaleView: View {
    @StateObject private var viewModel = ScaleViewModel()
    @State private var scaleCompression: CGFloat = 0
    @State private var keyMonitor: Any?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: geometry.size.height * 0.06) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Track Weight")
                            .font(.system(size: min(max(geometry.size.width * 0.05, 24), 42), weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.blue, .teal, .cyan], startPoint: .leading, endPoint: .trailing)
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

                    FitnessScaleView(
                        weight: viewModel.currentWeight,
                        hasTouch: viewModel.hasTouch,
                        compression: $scaleCompression,
                        scaleFactor: min(geometry.size.width / 700, geometry.size.height / 550) // Adjusted scale
                    )

                    Spacer()

                    // Controls
                    VStack(spacing: 10) {
                        if viewModel.hasTouch {
                            Text("Press spacebar or click to zero")
                                .font(.system(size: min(max(geometry.size.width * 0.018, 12), 16), weight: .medium))
                                .foregroundStyle(.gray.opacity(0.7))
                        }

                        Button(action: viewModel.zeroScale) {
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
                                    .fill(LinearGradient(colors: [.blue, .teal], startPoint: .leading, endPoint: .trailing))
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
            // The `compression` value drives all the animations.
            // It's a value from 0.0 (no weight) to 0.2 (max weight).
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                scaleCompression = CGFloat(min(Float(newWeight) / 200.0, 0.2))
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

// MARK: - Fitness Character View (with Tray)
struct FitnessScaleView: View {
    let weight: Float
    let hasTouch: Bool
    @Binding var compression: CGFloat // Value from 0.0 to 0.2
    let scaleFactor: CGFloat

    var body: some View {
        // This offset will move the arms and tray down as weight increases
        let trayOffset = compression * 200 * scaleFactor
        
        ZStack {
            // MARK: - Body, Face, and Legs
            VStack(spacing: 0) {
                // Main Body
                ZStack {
                    RoundedRectangle(cornerRadius: 20 * scaleFactor)
                        .fill(LinearGradient(colors: [Color(red: 0.98, green: 0.98, blue: 1.0), Color(red: 0.88, green: 0.88, blue: 0.92)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 180 * scaleFactor, height: 160 * scaleFactor)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                    // Face
                    VStack(spacing: 10 * scaleFactor) {
                        HStack(spacing: 30 * scaleFactor) {
                            EyeView(size: 20 * scaleFactor, isHappy: weight > 5)
                            EyeView(size: 20 * scaleFactor, isHappy: weight > 5)
                        }
                        
                        Group {
                            if weight > 5 {
                                let smileWidth = 35 * scaleFactor + CGFloat(min(weight, 100) / 5) * scaleFactor
                                Path { path in
                                    path.move(to: .zero)
                                    path.addQuadCurve(to: CGPoint(x: smileWidth, y: 0), control: CGPoint(x: smileWidth / 2, y: 15 * scaleFactor))
                                }
                                .stroke(.black, style: StrokeStyle(lineWidth: 4 * scaleFactor, lineCap: .round))
                                .frame(width: smileWidth)
                            } else {
                                Rectangle().fill(.black).frame(width: 20 * scaleFactor, height: 3 * scaleFactor)
                            }
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: weight)
                        .frame(height: 20 * scaleFactor)
                    }
                }
                .offset(y: 50 * scaleFactor) // Move body down to make room for tray

                // Legs
                HStack(spacing: 100 * scaleFactor) {
                     RoundedRectangle(cornerRadius: 4, style: .continuous).fill(.gray.opacity(0.7)).frame(width: 35 * scaleFactor, height: 20 * scaleFactor)
                     RoundedRectangle(cornerRadius: 4, style: .continuous).fill(.gray.opacity(0.7)).frame(width: 35 * scaleFactor, height: 20 * scaleFactor)
                }
                .offset(y: 45 * scaleFactor)
            }
            
            // MARK: - Arms
            ZStack {
                // Left Arm
                ArmView(scaleFactor: scaleFactor)
                    .rotationEffect(.degrees(180)) // Flip it
                    .offset(x: -80 * scaleFactor, y: 30 * scaleFactor + trayOffset)
                
                // Right Arm
                ArmView(scaleFactor: scaleFactor)
                    .rotationEffect(.degrees(180)) 
                    .offset(x: 80 * scaleFactor, y: 30 * scaleFactor + trayOffset)
            }

            // MARK: - Tray and Display
            ZStack {
                // Tray
                RoundedRectangle(cornerRadius: 15 * scaleFactor)
                    .fill(Color(red: 0.85, green: 0.85, blue: 0.90))
                    .frame(width: 220 * scaleFactor, height: 80 * scaleFactor)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -3)
                
                // Digital Display on the tray
                RoundedRectangle(cornerRadius: 8 * scaleFactor)
                    .fill(.black)
                    .frame(width: 110 * scaleFactor, height: 40 * scaleFactor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8 * scaleFactor)
                           .fill(LinearGradient(colors: [.teal.opacity(0.8), .blue.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                           .padding(2 * scaleFactor)
                    )
                
                Text(String(format: "%.1f", weight))
                    .font(.system(size: 22 * scaleFactor, weight: .heavy, design: .monospaced))
                    .foregroundColor(.white)
                    .shadow(color: .teal, radius: hasTouch ? 4 : 0)
            }
            .offset(y: -40 * scaleFactor + trayOffset) // Move tray up and animate with offset
        }
    }
}


// MARK: - Helper Views
struct ArmView: View {
    let scaleFactor: CGFloat
    
    var body: some View {
        ZStack {
            // Main arm part
            RoundedRectangle(cornerRadius: 10 * scaleFactor)
                .fill(Color(red: 0.9, green: 0.9, blue: 0.92))
                .frame(width: 30 * scaleFactor, height: 80 * scaleFactor)
            
            // Hand/Holder part
            RoundedRectangle(cornerRadius: 8 * scaleFactor)
                .fill(Color(red: 0.85, green: 0.85, blue: 0.90))
                .frame(width: 40 * scaleFactor, height: 20 * scaleFactor)
                .offset(y: -40 * scaleFactor)
        }
    }
}

struct EyeView: View {
    let size: CGFloat
    var isHappy: Bool = false

    var body: some View {
        ZStack {
            Circle().fill(.black).frame(width: size, height: size)
            if isHappy {
                Circle().fill(.white).frame(width: size * 0.4, height: size * 0.4).offset(x: -size * 0.15, y: -size * 0.15)
            } else {
                Circle().fill(.white).frame(width: size * 0.2, height: size * 0.2).offset(x: size * 0.2, y: -size * 0.2)
            }
        }
    }
}

// MARK: - Modifiers
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
    ScaleView()
}

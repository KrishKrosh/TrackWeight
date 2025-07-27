//
//  HomeView.swift
//  TrackWeight
//

import SwiftUI

struct HomeView: View {
    
    @State private var isHovering: Bool = false
    @State private var isPressing: Bool = false

    let onBegin: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Title section
            VStack(spacing: 15) {
                Image(systemName: "scalemass.fill")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundStyle(Color.blue)

                Text("TrackWeight")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .teal, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }

            // Description and Limitations section
            VStack(spacing: 30) {
                Text("Transform your MacBook trackpad into a precision scale using Apple's private MultitouchSupport framework to read pressure values with gram-level accuracy.")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 600)
                    .padding(.horizontal, 20)

                // Limitations section container but with glassmorphism effect this do not work as i thought
                VStack(spacing: 15) {
                    Text("Important Limitations")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.orange)

                    VStack(alignment: .leading, spacing: 10) {
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
                    .padding(.top, 5)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .frame(maxWidth: 550)
                .padding(.horizontal, 20)
            }

            
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
                               Image(systemName: "scalemass.fill")
                                   .font(.system(size: 16, weight: .semibold))
                                   // Icon movement on hover
                                   .offset(x: isHovering ? 3 : 0)
                           }
                           .foregroundStyle(.white)
                           .frame(width: 140, height: 50)
                           .background(
                               RoundedRectangle(cornerRadius: 20)
                                   .fill(
                                       LinearGradient(
                                           
                                           colors: isPressing ? [.init(red: 0.35, green: 0.13, blue: 0.71), .init(red: 0.49, green: 0.23, blue: 0.98)] : // Darker on press
                                                   (isHovering ? [.init(red: 0.49, green: 0.23, blue: 0.98), .init(red: 0.65, green: 0.54, blue: 0.98)] : // Brighter on hover
                                                    [.blue, .teal]),
                                           startPoint: .leading,
                                           endPoint: .trailing
                                       )
                                   )
                           )
                           
                           .shadow(color: Color.black.opacity(isPressing ? 0.15 : (isHovering ? 0.35 : 0.2)),
                                   radius: isPressing ? 8 : (isHovering ? 25 : 15),
                                   x: 0,
                                   y: isPressing ? 2 : (isHovering ? 8 : 4))
                       }
                       .buttonStyle(.plain)
                       .padding(.vertical, 10)
                       .scaleEffect(isPressing ? 0.98 : (isHovering ? 1.02 : 1.0))
                       .offset(y: isHovering ? -3 : 0)
                       .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isHovering)
                       .animation(.easeOut(duration: 0.1), value: isPressing)
                       .onHover { hover in
                           self.isHovering = hover
                       }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

struct LimitationRow: View {
    let icon: String
    let text: String

    
    @State private var isRowHovering: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
           
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.orange)
                .frame(width: 25)

            
            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.secondary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isRowHovering ? Color.white.opacity(0.08) : Color.clear)
        )
        .cornerRadius(10)
        .scaleEffect(isRowHovering ? 1.01 : 1.0)
        .shadow(color: Color.black.opacity(isRowHovering ? 0.1 : 0),
                radius: isRowHovering ? 5 : 0,
                x: 0,
                y: isRowHovering ? 2 : 0)

        .animation(.easeOut(duration: 0.2), value: isRowHovering)
        .onHover { hover in
            isRowHovering = hover
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(gradient: Gradient(colors: [.purple, .blue, .green]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)

        HomeView(onBegin: {
            print("Begin button tapped from preview!")
        })
    }
}

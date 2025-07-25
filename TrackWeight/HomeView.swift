//
//  HomeView.swift
//  TrackWeight
//

import SwiftUI

struct HomeView: View {
    let onBegin: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Title section
            VStack(spacing: 15) {
                Image(systemName: "scalemass")
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
            
            // Description section
            VStack(spacing: 20) {
                Text("Transform your MacBook trackpad into a precision scale using Apple's private MultitouchSupport framework to read pressure values with gram-level accuracy.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 550)
                
                // Limitations section
                VStack(spacing: 12) {
                    Text("Important Limitations")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.orange)
                    
                    VStack(spacing: 8) {
                        LimitationRow(
                            icon: "hand.point.up.left",
                            text: "Requires finger contact for capacitive detection"
                        )
                        LimitationRow(
                            icon: "chart.line.downtrend.xyaxis",
                            text: "May experience pressure drift when placing objects"
                        )
                        LimitationRow(
                            icon: "cube.fill",
                            text: "Metal/magnetic objects may not work"
                        )
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.orange.opacity(0.05))
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )
                .frame(maxWidth: 500)
            }
            
            Spacer()
            
            // Begin button
            Button(action: onBegin) {
                HStack(spacing: 10) {
                    Text("Begin")
                        .font(.system(size: 18, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(Color.white)
                .frame(width: 140, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .teal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                )
            }
            .buttonStyle(.plain)
            .scaleEffect(1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: true)
            .padding(.vertical, 10)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

struct LimitationRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.orange)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

#Preview {
    HomeView(onBegin: {})
}

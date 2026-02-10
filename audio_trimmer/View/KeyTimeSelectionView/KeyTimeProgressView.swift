//
//  KeyTimeProgressView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/27.
//

import SwiftUI

struct KeyTimeProgressView: View {
    let state: KeyTimeProgressState
    let height: CGFloat = 24
    let onTapKeyTimeProgress: (Double) -> Void
    
    @State var indicatorStartRatio: Double = 0
    @State var isDragging = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: height)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !isDragging {
                                isDragging = true
                            }
                            let progress = min(max(value.location.x / geo.size.width, 0), 1)
                            indicatorStartRatio = getClampedIndicatorStartRatio(with: progress)
                            onTapKeyTimeProgress(progress)
                        }.onEnded({ _ in
                            isDragging = false
                        }))
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(.orange)
                            .frame(width: geo.size.width * state.trimmedRatio, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: height/2))
                            .allowsHitTesting(false)
                            .offset(x: indicatorStartRatio * geo.size.width)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: height/2))
                    .overlay {
                        GeometryReader { overlayGeo in
                            ForEach(Array(state.keyTimes.enumerated()), id: \.offset) { index, keyTime in
                                KeyTimeDot()
                                    .position(x: keyTime * overlayGeo.size.width, y: overlayGeo.size.height / 2)
                                    .onTapGesture {
                                        indicatorStartRatio = keyTime
                                        onTapKeyTimeProgress(keyTime)
                                    }
                            }
                        }
                    }
                Spacer()
            }
        }.onChange(of: state.playbackProgressRatio) { _, newValue in
            if isDragging { return }
            indicatorStartRatio = getClampedIndicatorStartRatio(with: newValue)
        }
    }
    
    private func getClampedIndicatorStartRatio(with newRatio: Double) -> Double {
        return min(max(newRatio, 0), 1-state.trimmedRatio)
    }
}

struct KeyTimeDot: View {
    var body: some View {
        Circle()
            .fill(.gray)
            .frame(width: 20, height: 20)
    }
}

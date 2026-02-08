//
//  HorizontalScrollView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/26.
//

import SwiftUI

struct TimelineView: View {
    @Binding var state: TimelineProgressState
    
    var onUserSeekToProgress: onUserSeekToProgressCallback
    
    @State private var scrollPosition: ScrollPosition = .init(x: 0)
    
    @State private var isProgrammaticScrolling: Bool = false
    @State private var stopTask: Task<Void, Never>?
    
    let trimmedAreaWidthRatio = 0.3
    
    var body: some View {
        GeometryReader { geo in
            let windowWidth = geo.size.width
            let timelineViewWidth = (windowWidth * trimmedAreaWidthRatio)/state.trimmedDurationRatio
            let trimmedAreaWidth = windowWidth * trimmedAreaWidthRatio
            let trimmedAreaInset = windowWidth/2 - trimmedAreaWidth/2
                                    
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        Color.clear.frame(width: trimmedAreaInset)
                        Rectangle()
                            .fill(.green)
                            .frame(width: timelineViewWidth, height: 30)
                            .overlay {
                                WaveformView(waveform: WaveSamples)
                            }
                            .clipped()
                        Color.clear.frame(width: trimmedAreaInset)
                    }
                }
                .scrollPosition($scrollPosition)
                .onScrollGeometryChange(for: CGFloat.self) { scrollViewGeo in
                    scrollViewGeo.contentOffset.x
                } action: {_, scrollOffset in
                    onScrollOffsetChange(scrollOffset, total: timelineViewWidth)
                }
                .onAppear {
                    print("[TimelineView] windowWidth: \(windowWidth), timelineViewWidth: \(timelineViewWidth), trimmedAreaWidth: \(trimmedAreaWidth), trimmedAreaInset: \(trimmedAreaInset)")
                }
                Rectangle()
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: trimmedAreaWidth, height: 50, alignment: .center)
                    .allowsHitTesting(false)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(.orange.opacity(0.5))
                            .frame(width: trimmedAreaWidth * state.playbackProgressInRange, height: 50)
                            .animation(.linear(duration: 1.0/30.0), value: state.playbackProgressInRange)
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onChange(of: state.programmaticScrollProgress) { _, newValue in
                isProgrammaticScrolling = true
                stopTask?.cancel()
                
                guard let programmaticScrollProgressValue = state.programmaticScrollProgress.value else { return }
                
                var newPosition = programmaticScrollProgressValue * timelineViewWidth;
                newPosition = min(newPosition, timelineViewWidth - trimmedAreaWidth)
                scrollPosition.scrollTo(x: newPosition)
                
                stopTask = Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 200_000_000)
                    isProgrammaticScrolling = false
                }
            }
        }
        .background(.black)
    }
    
    private func onScrollOffsetChange(_ offset: CGFloat, total: CGFloat) {
        guard !isProgrammaticScrolling else { return }
        let progress = offset / total
        onUserSeekToProgress(progress)
    }
}

struct WaveformView: View {
    var waveform: [Double] = []
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 2) {
                ForEach(waveform.enumerated(), id: \.offset) { _, value in
                    let waveHeight = value * geo.size.height
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(.white)
                        .frame(width: 5, height: waveHeight)
                        .foregroundStyle(Color.white)
                }
            }
        }
    }
}

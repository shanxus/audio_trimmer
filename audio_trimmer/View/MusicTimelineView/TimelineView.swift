//
//  HorizontalScrollView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/26.
//

import SwiftUI

struct TimelineView: View {
    @Binding var state: TimelineViewState
    
    var onUserSeekToProgress: onUserSeekToProgressCallback
    
    @State private var scrollPosition: ScrollPosition = .init(x: 0)
    
    @State private var isUserScrolling: Bool = false
    @State private var isProgrammaticScrolling: Bool = false
    @State private var stopTask: Task<Void, Never>?
    
    let trimmedAreaWidthRatio = 0.3
    
    var body: some View {
        GeometryReader { geo in
            let windowWidth = geo.size.width
            let timelineViewWidth = (windowWidth * trimmedAreaWidthRatio)/state.timelineConfig.trimmedDurationRatio
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
                                WaveformView(waveform: state.waveSamples)
                            }
                            .clipped()
                        Color.clear.frame(width: trimmedAreaInset)
                    }
                }
                .scrollPosition($scrollPosition)
                .animation(.default, value: scrollPosition.x)
                .simultaneousGesture(userDragGesture)
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onChange(of: state.programmaticScrollProgress) { _, newValue in
                
                guard state.programmaticScrollProgress.isValid else { return }
                                
                guard !isUserScrolling else { return }
                
                print("onChange of programmaticScrollProgress")
                
                isProgrammaticScrolling = true
                isUserScrolling = false
                
                var newPosition = state.programmaticScrollProgress.value * timelineViewWidth;
                newPosition = min(newPosition, timelineViewWidth - trimmedAreaWidth)
                scrollPosition.scrollTo(x: newPosition)
                
                state.programmaticScrollProgress.value = -1
            }
        }
        .background(.black)
    }
    
    private var userDragGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged { value in
                if !isProgrammaticScrolling {
                    isUserScrolling = true
                }
            }
    }
    
    private func onScrollOffsetChange(_ offset: CGFloat, total: CGFloat) {        
        if isUserScrolling {
            let progress = offset / total
            print("will onUserSeekToProgress: \(progress)")
            onUserSeekToProgress(progress)
        }
        
        triggerStopDebounce()
    }
    
    private func triggerStopDebounce() {
        stopTask?.cancel()
        stopTask = Task { @MainActor in
            // 180 ms
            try? await Task.sleep(nanoseconds: 180_000_000)
            if Task.isCancelled { return }
            onScrollStopped()
        }
    }
    
    private func onScrollStopped() {
        if isProgrammaticScrolling {
            isProgrammaticScrolling = false
            return
        }
        
        if isUserScrolling {
            isUserScrolling = false
        }
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

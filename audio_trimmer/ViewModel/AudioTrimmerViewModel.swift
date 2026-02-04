//
//  AudioTrimmerViewModel.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/28.
//

import Combine

enum SeekActionSource {
    case KeyTimeSelection
    case Timeline
}

class AudioTrimmerViewModel: ObservableObject {
    func play() {}
    func pause() {}
    func seek(toProgressRatio ratio: Double) {}
    
    func onTimelineScroll(toRatio ratio: Double) {}
    
    @Published var keyTimeSelectionState: KeyTimeSelectionState = .default
    @Published var timelineViewState: TimelineViewState = .default
}

final class AudioTrimmerViewModelImpl: AudioTrimmerViewModel {
    private let audioService: AudioService
    private(set) var appConfig: AppConfig
    private var cancellables: Set<AnyCancellable> = []
    
    init(audioService: AudioService, appConfig: AppConfig) {
        self.audioService = audioService
        audioService.setupConfig(AudioConfig(totalTrackLength: appConfig.trackLenght))
        self.appConfig = appConfig
        super.init()
        
        let timelineConfig = TimelineConfig(trimmedDurationRatio: appConfig.trimmedRangeRatio, trackDuration: appConfig.trackLenght)
        timelineViewState = TimelineViewState(timelineConfig: timelineConfig, programmaticScrollProgress: ProgrammaticScrollProgress(value: 0), trimmedDuration: appConfig.trimmedDuration)
        
        keyTimeSelectionState = KeyTimeSelectionState(keyTimes: appConfig.keyTimes, trimmedRatio: appConfig.trimmedRangeRatio, playbackProgressRatio: 0)
        
        audioService.statePublisher.sink { [weak self] state in
            print("[AudioTrimmerViewModelImpl] Received new state, isPlaying: \(state.isPlaying), currentPlaybackTime: \(state.currentPlaybackTime)")
        
            guard let weakSelf = self else { return }
            let progress = state.currentPlaybackTime / Double(appConfig.trackLenght)
            
            if state.playbackTimeUpdateAction == .seek {
                if state.seekActionSource == .KeyTimeSelection {
                    weakSelf.timelineViewState = weakSelf.timelineViewState.copyWith(
                        programmaticScrollProgress: ProgrammaticScrollProgress(value: progress),
                        playbackTime: state.currentPlaybackTime
                    )
                } else if state.seekActionSource == .Timeline {
                    weakSelf.keyTimeSelectionState = weakSelf.keyTimeSelectionState.copyWith(
                        playbackProgressRatio: progress
                    )
                }
            }
            
        }.store(in: &cancellables)
    }
    
    override
    func play() {
        audioService.play()
    }
    
    override
    func pause() {
        audioService.pause()
    }
    
    override
    func seek(toProgressRatio ratio: Double) {
        let maxSeekProgress = 1 - appConfig.trimmedRangeRatio
        let clampedRatio = min(maxSeekProgress, max(0, ratio))
        audioService.seek(withRatio: clampedRatio, source: .KeyTimeSelection)
    }
    
    override
    func onTimelineScroll(toRatio ratio: Double) {        
        audioService.seek(withRatio: ratio, source: .Timeline)
    }
}

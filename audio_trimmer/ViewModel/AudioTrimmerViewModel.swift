//
//  AudioTrimmerViewModel.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/28.
//

import Combine

class AudioTrimmerViewModel: ObservableObject {
    func play() {}
    func pause() {}
    func seek(toProgressRatio ratio: Double) {}
    
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
        
        let timelineConfig = TimelineConfig(trimmedDurationRatio: appConfig.trimmedRangeRatio)
        timelineViewState = TimelineViewState(timelineConfig: timelineConfig, programmaticScrollProgress: ProgrammaticScrollProgress.default, trimmedDuration: appConfig.trimmedDuration)
        
        keyTimeSelectionState = KeyTimeSelectionState(keyTimes: appConfig.keyTimes, trimmedRatio: appConfig.trimmedRangeRatio, playbackProgress: 0)
        
        audioService.statePublisher.sink { [weak self] state in
            print("[AudioTrimmerViewModelImpl] Received new state, isPlaying: \(state.isPlaying), currentPlaybackTime: \(state.currentPlaybackTime)")
        
            let progress = state.currentPlaybackTime / Double(appConfig.trackLenght)
            self?.timelineViewState.programmaticScrollProgress.value = progress
            self?.timelineViewState.playbackTime = state.currentPlaybackTime
            
            self?.keyTimeSelectionState.playbackProgress = progress
            
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
        audioService.seek(withRatio: ratio)
    }
}

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
    
    @Published var keytimeInfoState: KeyTimeInfoState = .default
    @Published var keytimeProgressState: KeyTimeProgressState = .default
    
    @Published var timelineInfoState: TimelineInfoState = .default
    @Published var timelineProgressState: TimelineProgressState = .default
}

final class AudioTrimmerViewModelImpl: AudioTrimmerViewModel {
    private let audioService: AudioService
    private(set) var appConfig: AppConfig
    private var cancellables: Set<AnyCancellable> = []
    
    init(audioService: AudioService, appConfig: AppConfig) {
        self.audioService = audioService
        let audioConfig = AudioConfig(totalTrackLength: appConfig.trackLenght, playRangeDurationRatio: appConfig.trimmedRangeRatio)
        audioService.setupConfig(audioConfig)
        self.appConfig = appConfig
        super.init()
        
        initState()
        
        audioService.statePublisher.sink { [weak self] state in
//            print("[AudioTrimmerViewModelImpl] Received new state, isPlaying: \(state.isPlaying), currentPlaybackTime: \(state.currentPlaybackTime)")
        
            guard let weakSelf = self else { return }
            let progress = state.currentPlaybackTime / Double(appConfig.trackLenght)
            
            switch state.playbackTimeUpdateAction {
            case .seek:
                weakSelf.onAudioStateUpdateWithSeek(audioState: state)
            case .playback:
                weakSelf.onAudioStateUpdateWithPlayback(audioState: state)
            case .none:
                break
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
    
    private func initState() {
        keytimeInfoState = KeyTimeInfoState(trimmedRatio: appConfig.trimmedRangeRatio, playbackProgressRatio: 0)
        keytimeProgressState = KeyTimeProgressState(keyTimes: appConfig.keyTimes, trimmedRatio: appConfig.trimmedRangeRatio, playbackProgressRatio: 0)
        
        timelineInfoState = TimelineInfoState(trackDuration: appConfig.trackLenght, playbackTime: 0, trimmedDuration: appConfig.trimmedDuration)
        timelineProgressState = TimelineProgressState(trimmedDuration: appConfig.trimmedDuration, trimmedDurationRatio: appConfig.trimmedRangeRatio, programmaticScrollProgress: ProgrammaticScrollProgress(value: 0), playbackProgressInRange: 0)
    }
    
    private func onAudioStateUpdateWithSeek(audioState: AudioServiceState) {
        let progress = audioState.currentPlaybackTime / Double(appConfig.trackLenght)
        
        if audioState.seekActionSource == .KeyTimeSelection {
            timelineProgressState = timelineProgressState.copyWith(programmaticScrollProgress: ProgrammaticScrollProgress(value: progress), playbackProgressInRange: 0)
        } else if audioState.seekActionSource == .Timeline {
            keytimeProgressState = keytimeProgressState.copyWith(playbackProgressRatio: progress)
            timelineProgressState = timelineProgressState.copyWith(playbackProgressInRange: 0)
        }
        
        keytimeInfoState = keytimeInfoState.copyWith(playbackProgressRatio: progress)
        timelineInfoState = timelineInfoState.copyWith(playbackTime: audioState.currentPlaybackTime)
    }
    
    private func onAudioStateUpdateWithPlayback(audioState: AudioServiceState) {
        let progress = audioState.currentPlaybackTime / Double(appConfig.trackLenght)
        
        keytimeInfoState = keytimeInfoState.copyWith(playbackProgressRatio: progress)
        timelineInfoState = timelineInfoState.copyWith(playbackTime: audioState.currentPlaybackTime)
        
        timelineProgressState = timelineProgressState.copyWith(playbackProgressInRange: audioState.playbackProgressInRange)
    }
}

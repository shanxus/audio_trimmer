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
    func reset() {}
    func seek(toProgressRatio ratio: Double) {}
    
    func onTimelineScroll(toRatio ratio: Double) {}
    
    @Published var keyTimeInfoState: KeyTimeInfoState = .default
    @Published var keyTimeProgressState: KeyTimeProgressState = .default
    
    @Published var timelineInfoState: TimelineInfoState = .default
    @Published var timelineProgressState: TimelineProgressState = .default
    
    @Published var timelinePlayPauseState: TimelinePlayPauseState = .default
}

final class AudioTrimmerViewModelImpl: AudioTrimmerViewModel {
    private let audioService: AudioService
    private(set) var appConfig: AppConfig
    private var cancellables: Set<AnyCancellable> = []
    
    init(audioService: AudioService, appConfig: AppConfig) {
        self.audioService = audioService
        self.appConfig = appConfig
        super.init()
        
        audioService.statePublisher.sink { [weak self] state in
            guard let weakSelf = self else { return }
            switch state.updateAction {
            case .setup:
                weakSelf.onAudioStateUpdateWithSetup(audioState: state)
            case .seek:
                weakSelf.onAudioStateUpdateWithSeek(audioState: state)
            case .playback:
                weakSelf.onAudioStateUpdateWithPlayback(audioState: state)
            case .reset:
                weakSelf.onAudioStateUpdateWithReset(audioState: state)
            case .playPause:
                weakSelf.onAudioStateUpdateWithPlayPause(audioState: state)
            case .none:
                break
            }
        }.store(in: &cancellables)
        
        let audioConfig = AudioConfig(totalTrackLength: appConfig.trackLenght, playRangeDurationRatio: appConfig.trimmedRangeRatio)
        audioService.setupConfig(audioConfig)
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
    func reset() {
        audioService.reset()
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
    
    private func onAudioStateUpdateWithSeek(audioState: AudioServiceState) {
        let progress = audioState.currentPlaybackTime / Double(appConfig.trackLenght)
        
        if audioState.seekActionSource == .KeyTimeSelection {
            timelineProgressState = timelineProgressState.copyWith(programmaticScrollProgress: ProgrammaticScrollProgress(value: progress), playbackProgressInRange: 0)
        } else if audioState.seekActionSource == .Timeline {
            keyTimeProgressState = keyTimeProgressState.copyWith(playbackProgressRatio: progress)
            timelineProgressState = timelineProgressState.copyWith(playbackProgressInRange: 0)
        }
        
        keyTimeInfoState = keyTimeInfoState.copyWith(playbackProgressRatio: progress, rangeStartRatio: audioState.rangeStartRatio, rangeEndRatio: audioState.rangeEndRatio)
        timelineInfoState = timelineInfoState.copyWith(playbackTime: audioState.currentPlaybackTime, rangeStartTime: audioState.playbackRange.startTime, rangeEndTime: audioState.playbackRange.endTime)
    }
    
    private func onAudioStateUpdateWithPlayback(audioState: AudioServiceState) {
        let progress = audioState.currentPlaybackTime / Double(appConfig.trackLenght)
        
        keyTimeInfoState = keyTimeInfoState.copyWith(playbackProgressRatio: progress)
        timelineInfoState = timelineInfoState.copyWith(playbackTime: audioState.currentPlaybackTime)
        
        timelineProgressState = timelineProgressState.copyWith(playbackProgressInRange: audioState.playbackProgressInRange)
    }
    
    private func onAudioStateUpdateWithSetup(audioState: AudioServiceState) {
        keyTimeInfoState = KeyTimeInfoState(
            playbackProgressRatio: audioState.currentPlaybackProgress,
            rangeStartRatio: audioState.rangeStartRatio,
            rangeEndRatio: audioState.rangeEndRatio
        )
        
        keyTimeProgressState = KeyTimeProgressState(keyTimes: appConfig.keyTimes, trimmedRatio: appConfig.trimmedRangeRatio, playbackProgressRatio: audioState.currentPlaybackProgress)
        
        timelineInfoState = TimelineInfoState(playbackTime: audioState.currentPlaybackTime, rangeStartTime: audioState.playbackRange.startTime, rangeEndTime: audioState.playbackRange.endTime)
        
        timelineProgressState = TimelineProgressState(trimmedDuration: appConfig.trimmedDuration, trimmedDurationRatio: appConfig.trimmedRangeRatio, programmaticScrollProgress: ProgrammaticScrollProgress(value: audioState.currentPlaybackProgress), playbackProgressInRange: audioState.playbackProgressInRange)
    }
    
    private func onAudioStateUpdateWithReset(audioState: AudioServiceState) {
        timelineProgressState = timelineProgressState.copyWith(playbackProgressInRange: 0)
        
        let progress = audioState.currentPlaybackTime / Double(appConfig.trackLenght)
        keyTimeInfoState = keyTimeInfoState.copyWith(playbackProgressRatio: progress)
        timelineInfoState = timelineInfoState.copyWith(playbackTime: audioState.currentPlaybackTime)
    }
    
    private func onAudioStateUpdateWithPlayPause(audioState: AudioServiceState) {
        timelinePlayPauseState = timelinePlayPauseState.copyWith(isPlaying: audioState.isPlaying)
    }
}

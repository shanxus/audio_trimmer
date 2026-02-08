//
//  AudioServiceTests.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/8.
//

import XCTest
import Combine
@testable import audio_trimmer

final class AudioServiceImplTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - setupConfig

    func test_setupConfig_setsTrackDurationAndInitialRange() {
        let sut = AudioServiceImpl()
        let config = AudioConfig(totalTrackLength: 30, playRangeDurationRatio: 0.3)  // playRangeDuration = 9

        sut.setupConfig(config)

        XCTAssertEqual(sut.state.trackDuration, 30, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackRange.startTime, 0, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackRange.endTime, 9, accuracy: 1e-9)
        XCTAssertEqual(sut.state.updateAction, .setup)
    }

    func test_statePublisher_emitsSetupState() {
        let sut = AudioServiceImpl()
        let config = AudioConfig(totalTrackLength: 10, playRangeDurationRatio: 0.5)

        let exp = expectation(description: "should emit setup state")

        // Drop initial state
        sut.statePublisher
            .dropFirst()
            .sink { state in
                switch state.updateAction {
                case .setup:
                    exp.fulfill()
                default:
                    break
                }
            }
            .store(in: &cancellables)

        sut.setupConfig(config)

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - seek

    func test_seek_updatesPlaybackTimeRangeAndProgress() {
        let sut = AudioServiceImpl()
        sut.setupConfig(AudioConfig(totalTrackLength: 100, playRangeDurationRatio: 0.2)) // range duration = 20

        sut.seek(withRatio: 0.5, source: .Timeline)

        XCTAssertEqual(sut.state.currentPlaybackTime, 50, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackProgressInRange, 0, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackRange.startTime, 50, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackRange.endTime, 70, accuracy: 1e-9)
        XCTAssertEqual(sut.state.seekActionSource, .Timeline)
        XCTAssertEqual(sut.state.updateAction, .seek)
    }

    // MARK: - reset

    func test_reset_movesPlaybackTimeToRangeStart_andResetsProgress() {
        let sut = AudioServiceImpl()
        sut.setupConfig(AudioConfig(totalTrackLength: 100, playRangeDurationRatio: 0.2))
        sut.seek(withRatio: 0.5, source: .Timeline)
        sut.tick(delta: 5)

        sut.reset()

        XCTAssertEqual(sut.state.currentPlaybackTime, 50, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackProgressInRange, 0, accuracy: 1e-9)
        XCTAssertEqual(sut.state.updateAction, .reset)
    }

    // MARK: - tick

    func test_tick_advancesPlaybackTime_andUpdatesProgressInRange() {
        let sut = AudioServiceImpl()
        sut.setupConfig(AudioConfig(totalTrackLength: 10, playRangeDurationRatio: 0.5)) // range: 0~5

        sut.tick(delta: 1.0)

        XCTAssertEqual(sut.state.currentPlaybackTime, 1.0, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackProgressInRange, 0.2, accuracy: 1e-9) // 1/5
        XCTAssertEqual(sut.state.updateAction, .playback)
    }

    func test_tick_clampsPlaybackTime_toRangeEnd() {
        let sut = AudioServiceImpl()
        sut.setupConfig(AudioConfig(totalTrackLength: 10, playRangeDurationRatio: 0.5)) // end=5

        sut.tick(delta: 100)

        XCTAssertEqual(sut.state.currentPlaybackTime, 5.0, accuracy: 1e-9)
        XCTAssertEqual(sut.state.playbackProgressInRange, 1.0, accuracy: 1e-9)
        XCTAssertEqual(sut.state.updateAction, .playback)
    }
}

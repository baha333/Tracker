
import XCTest
import SnapshotTesting
@testable import Tracker


final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = TrackersViewController()
        let vm = TrackersViewModel()
        vm.updateStore(with: Date().dateWithoutTime(), text: "", completedFilter: nil)
        vc.trackersCollectionView.reloadData()
        assertSnapshot(matching: vc, as: .image)
    }

}

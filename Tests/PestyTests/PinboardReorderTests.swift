import XCTest
@testable import Pesty

final class PinboardReorderTests: XCTestCase {
    private let items = (0..<4).map { ClipItem(type: .text, text: "clip \($0)") }

    private func texts(_ items: [ClipItem]?) -> [String]? {
        items?.map { $0.text ?? "" }
    }

    func testMovingRightLandsAfterTarget() {
        let moved = ClipboardStore.reordered(items, moving: items[0].id, to: items[2].id)
        XCTAssertEqual(texts(moved), ["clip 1", "clip 2", "clip 0", "clip 3"])
    }

    func testMovingLeftLandsBeforeTarget() {
        let moved = ClipboardStore.reordered(items, moving: items[3].id, to: items[1].id)
        XCTAssertEqual(texts(moved), ["clip 0", "clip 3", "clip 1", "clip 2"])
    }

    func testNoChangeReturnsNil() {
        XCTAssertNil(ClipboardStore.reordered(items, moving: items[1].id, to: items[1].id))
        XCTAssertNil(ClipboardStore.reordered(items, moving: UUID(), to: items[1].id))
        XCTAssertNil(ClipboardStore.reordered(items, moving: items[1].id, to: UUID()))
    }
}

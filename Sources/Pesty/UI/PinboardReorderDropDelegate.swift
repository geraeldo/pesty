import SwiftUI

/// Rearranges a Pinboard by dragging one of its cards over another. The card
/// slides into place as soon as the drag enters a neighbour, Finder-style, so
/// the drop itself only has to end the session. Drags that did not start on a
/// card in this Pinboard - files from Finder, clips dragged in from History,
/// a filtered strip - are refused and fall through untouched.
struct PinboardReorderDropDelegate: DropDelegate {
    let targetID: UUID
    let store: ClipboardStore

    private var boardID: UUID? {
        guard store.reorderingItemID != nil,
              store.searchText.isEmpty,
              case .pinboard(let id) = store.source else { return nil }
        return id
    }

    func validateDrop(info: DropInfo) -> Bool {
        boardID != nil
    }

    func dropEntered(info: DropInfo) {
        guard let boardID, let dragged = store.reorderingItemID, dragged != targetID else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            store.movePinboardItem(dragged, to: targetID, in: boardID)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        boardID == nil ? nil : DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        let handled = boardID != nil
        store.reorderingItemID = nil
        return handled
    }
}

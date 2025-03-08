//
//
//  Created by Hiep Nguyen on 7/3/25.
//

import Foundation
import SwiftUI
import Combine

enum HeaderState {
    case expanded
    case collapsed
}

struct CollapsableHeader<HeaderView: View, ScrollView: View>: View {
    let expandedHeaderHeight: CGFloat
    let collapsedHeaderHeight: CGFloat
    let headerView: (() -> HeaderView)
    let scrollView: (() -> ScrollView)
    @Binding var offset: CGFloat
    @Binding var headerState: HeaderState
    
    init(expandedHeaderHeight: CGFloat,
         collapsedHeaderHeight: CGFloat,
         offset: Binding<CGFloat>,
         headerState: Binding<HeaderState>,
         headerView: @escaping () -> HeaderView,
         scrollView: @escaping () -> ScrollView) {
        self.expandedHeaderHeight = expandedHeaderHeight
        self.collapsedHeaderHeight = collapsedHeaderHeight
        self._offset = offset
        self._headerState = headerState
        self.headerView = headerView
        self.scrollView = scrollView
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            scrollView() // Scrollable content
            
            headerView() // Collapsible header
                .frame(height: expandedHeaderHeight)
                .offset(y: getOffset(offset: offset))
                .zIndex(1) // Ensure the header stays on top
        }
    }
    
    private func getOffset(offset: CGFloat) -> CGFloat {
        guard offset < .zero else { return .zero }
        if offset > -(expandedHeaderHeight - collapsedHeaderHeight) {
            updateHeaderState(currentState: headerState, futureState: .expanded)
            return offset
        } else {
            updateHeaderState(currentState: headerState, futureState: .collapsed)
            return -(expandedHeaderHeight - collapsedHeaderHeight)
        }
    }
    
    private func updateHeaderState(currentState: HeaderState,
                                   futureState: HeaderState) {
        if currentState != futureState {
            DispatchQueue.main.async {
                self.headerState = futureState
            }
        }
    }
}

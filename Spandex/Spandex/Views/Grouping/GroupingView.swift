//
//  GroupingView.swift
//  Spandex
//
//  Created by Tristan Warner-Smith on 05/04/2021.
//

import SwiftUI

struct GroupingListView: View {

    @EnvironmentObject var search: SearchViewModel

    @Namespace var selectionNamespace
    var groups: [CharacterGrouping] = CharacterGrouping.allCases

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(groups, id: \.self) { grouping in
                    GroupingView(
                        animationNamespace: selectionNamespace,
                        grouping: grouping,
                        selection: search.grouping
                    )
                    .matchedGeometryEffect(
                        id: grouping,
                        in: selectionNamespace,
                        anchor: .center
                    )
                    .onTapGesture {
                        withAnimation {
                            search.group(by: grouping)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct GroupingListView_Previews: PreviewProvider {

    static var previews: some View {
        let groups = CharacterGrouping.allCases
        let search = SearchViewModel(characters: PreviewCharacterStateProvider().provide())

        return Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                GroupingListView(
                    groups: groups
                )
                .padding()
                .background(Color(.systemBackground))
                .colorScheme(colorScheme)
                .previewDisplayName("\(colorScheme)")
            }
        }
        .environmentObject(search)

        .previewLayout(.sizeThatFits)
    }
}

struct GroupingView: View {

    var animationNamespace: Namespace.ID
    let grouping: CharacterGrouping
    let selection: CharacterGrouping
    var selected: Bool { grouping == selection }

    var body: some View {
        VStack {
            ZStack {
                Text(String(describing: grouping))
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(selected ? .clear : .primary)

                Text(String(describing: grouping))
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(selected ? .primary : .clear)
            }
            .overlay(
                Capsule()
                    .fill(selected ? Color.accentColor : Color.clear)
                    .frame(height: 4)
                    .padding(.horizontal)
                    .matchedGeometryEffect(
                        id: selection,
                        in: animationNamespace,
                        anchor: .center,
                        isSource: false)
                ,
                alignment: .bottom
            )
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
    }
}

struct GroupingView_Previews: PreviewProvider {
    @Namespace static var animationNamespace

    static var previews: some View {

        let groupings = CharacterGrouping.allCases
        let notSelected = groupings[0]
        let selected = groupings[1]

        return Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in

                GroupingView(
                    animationNamespace: animationNamespace,
                    grouping: selected,
                    selection: selected
                )
                .background(Color(.systemBackground))
                .colorScheme(colorScheme)
                .previewDisplayName("Selected \(colorScheme)")

                GroupingView(
                    animationNamespace: animationNamespace,
                    grouping: selected,
                    selection: notSelected
                )
                .background(Color(.systemBackground))
                .colorScheme(colorScheme)
                .previewDisplayName("Not selected \(colorScheme)")
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

//
//  GroupedSection.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 8/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import Foundation

struct GroupedSection<SectionItem: Hashable, RowItem> {
    var sectionItem: SectionItem
    var rows: [RowItem]

    static func group(rows: [RowItem], by criteria: (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: rows, by: criteria)
        return groups.map(GroupedSection.init(sectionItem:rows:))
    }
}

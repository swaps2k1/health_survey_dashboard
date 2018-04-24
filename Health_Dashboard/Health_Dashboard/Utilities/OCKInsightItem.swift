//
//  OCKInsightItem.swift
//  Health_Dashboard
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/24/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import CareKit

extension OCKInsightItem {
    static func emptyInsightsMessage() -> OCKInsightItem {
        let text = "You haven't entered any data, or reports are in process."
        return OCKMessageItem(title: "No Insights", text: text,
                              tintColor: UIColor.orange, messageType: .tip)
    }
}

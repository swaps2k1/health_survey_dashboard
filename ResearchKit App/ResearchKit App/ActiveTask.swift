//
//  ActiveTask.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/20/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit

public var ActiveTask: ORKOrderedTask {
    return ORKOrderedTask.twoFingerTappingIntervalTask(withIdentifier: "TapTask", intendedUseDescription: "Check tapping speed", duration: 6, handOptions: .both, options: ORKPredefinedTaskOption())
}

//
//  ActiveTaskType2.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/23/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit

public var ActiveTaskType2: ORKOrderedTask {
    
    return ORKOrderedTask.fitnessCheck(withIdentifier: "fitness", intendedUseDescription: "To check the fitness", walkDuration: 8, restDuration: 6, options: ORKPredefinedTaskOption())
}

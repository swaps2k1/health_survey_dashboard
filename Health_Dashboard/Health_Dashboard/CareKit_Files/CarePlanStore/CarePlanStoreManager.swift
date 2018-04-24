//
//  CarePlanStoreManager.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/23/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit
import CareKit

class CarePlanStoreManager: NSObject {
    
    static let sharedCarePlanStoreManager = CarePlanStoreManager()
    var store: OCKCarePlanStore
    
    override init() {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Failed to obtain Documents directory!")
        }
        
        let storeURL = documentDirectory.appendingPathComponent("CarePlanStore")
        
        if !fileManager.fileExists(atPath: storeURL.path) {
            try! fileManager.createDirectory(at: storeURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        store = OCKCarePlanStore(persistenceDirectoryURL: storeURL)

        super.init()
    }
    
    //converting the ResearchKit task result into CareKit
    func buildCarePlanResultFrom(taskResult: ORKTaskResult) -> OCKCarePlanEventResult {
        // 1
        guard let firstResult = taskResult.firstResult as? ORKStepResult,
            let stepResult = firstResult.results?.first else {
                fatalError("Unexepected task results")
        }
        
        // 2
        if let numericResult = stepResult as? ORKNumericQuestionResult,
            let answer = numericResult.numericAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: numericResult.unit, userInfo: nil)
        }
        
        // 3
        fatalError("Unexpected task result type")
    }
}

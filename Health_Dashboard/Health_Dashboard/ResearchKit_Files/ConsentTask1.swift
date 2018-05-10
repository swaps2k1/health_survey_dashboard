//
//  ConsentTask1.swift
//  Health_Dashboard
//
//  Created by Bansal, Anshul (US - Mumbai) on 09/05/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit


var ConsentTask1: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]
    
    if let signature = consentDocument.signatures?.first {
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        
        reviewConsentStep.text = "Review Consent!"
        reviewConsentStep.reasonForConsent = "Consent to join study"
        
        steps += [reviewConsentStep]
    }
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}

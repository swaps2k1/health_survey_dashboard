//
//  ConsentTask.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/19/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit

public var ConsentTask: ORKOrderedTask {
    
    let document = ORKConsentDocument()
    document.title = "Test Document"
    
    let sectionTypes : [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .timeCommitment,
        .studySurvey,
        .studyTasks,
        .withdrawing
    ]
    
    let consentSections: [ORKConsentSection] = sectionTypes.map( { consentSectionType in
        let consentSection = ORKConsentSection(type: consentSectionType)
        consentSection.summary = "Complete the study"
        consentSection.content = "This survey will ask you three questions and you will also measure your tapping speed by performing a small activity."
        return consentSection
    })
    
    document.sections = consentSections
    document.addSignature(ORKConsentSignature(forPersonWithTitle: "Tejas", dateFormatString: "19-Apr-2018", identifier: "signature", givenName: "given name", familyName: "family name", signatureImage: nil, dateString: "date string"))
    
    var steps = [ORKStep]()
    
    //Visual Consent
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsent", document: document)
    steps += [visualConsentStep]
    
    //Signature
    let signature = document.signatures!.first! as ORKConsentSignature
    let reviewConsentStep = ORKConsentReviewStep(identifier: "Review", signature: signature, in: document)
    reviewConsentStep.text = "Review the consent"
    reviewConsentStep.reasonForConsent = "Consent to join the Research Study."
    
    steps += [reviewConsentStep]
    
    //Completion
    let completionStep = ORKCompletionStep(identifier: "CompletionStep")
    completionStep.title = "Welcome..!! You have successfully signed the consent document"
    completionStep.text = "Thank you for joining this study."
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}

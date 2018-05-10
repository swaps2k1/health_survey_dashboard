//
//  ConsentDocument.swift
//  Health_Dashboard
//
//  Created by Bansal, Anshul (US - Mumbai) on 09/05/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit


public var ConsentDocument: ORKConsentDocument {
    
    let consentDoc = ORKConsentDocument()
    consentDoc.title = "Sample Doc"
    
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
    
    let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        consentSection.summary = "If you wish to complete this study..."
        consentSection.content = "In this study you will be asked five (wait, no, three!) questions. You will also have your voice recorded for ten seconds."
        return consentSection
    }
    
    consentDoc.sections = consentSections
    
    consentDoc.addSignature(ORKConsentSignature(forPersonWithTitle: "Consent Signatory", dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
    
    return consentDoc
}

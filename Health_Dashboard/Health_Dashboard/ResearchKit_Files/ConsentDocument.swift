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
        .withdrawing,
        .onlyInDocument
    ]
    
    let consentSections: [ORKConsentSection] = sectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        if contentSectionType == .onlyInDocument {
            if let fileURL = Bundle.main.url(forResource: "Data Privacy", withExtension: "html") {
                consentSection.summary = "Detail Document"
                do {
                    let contentString = try String.init(contentsOf: fileURL)
                    consentSection.htmlContent = contentString
                } catch let error {
                    print(error)
                    consentSection.htmlContent = "Haila!! Read nahi hua"
                }
            }
        } else {
            consentSection.summary = "If you wish to complete this study..."
            consentSection.content = "In this study you will be asked five (wait, no, three!) questions. You will also have your voice recorded for ten seconds."
        }
        return consentSection
    }
    
    consentDoc.sections = consentSections
    
    consentDoc.addSignature(ORKConsentSignature(forPersonWithTitle: "Consent Signatory", dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
    
    return consentDoc
}

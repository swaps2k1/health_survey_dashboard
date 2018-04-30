//
//  CarePlanData.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/23/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import CareKit

enum ActivityIdentifier: String {
    case cardio
    case limberUp = "Limber Up"
    case targetPractice = "Target Practice"
    case pulse
    case temperature
    case bloodPressure = "Blood Pressure"
}

class CarePlanData: NSObject {
    let carePlanStore: OCKCarePlanStore
    let contacts =
        [OCKContact(contactType: .personal, name: "John Lee", relation: "Friend", contactInfoItems: [.email("johnlee@xyz.com"), .phone("888-555-2351"), .sms("888-555-2351")], tintColor: nil, monogram: "JL", image: nil),
         OCKContact(contactType: .careTeam, name: "Carl Harper", relation: "Therapist", contactInfoItems:[.email("carlharper@xyz.com"), .phone("888-555-2351"), .sms("888-555-2351")], tintColor: nil, monogram: "CH", image: nil),
         OCKContact(contactType: .careTeam, name: "Dr. Michell Hall", relation: "Veterinarian", contactInfoItems: [.email("michellhall@xyz.com"), .phone("888-555-2351"), .sms("888-555-2351")], tintColor: nil, monogram: "MH", image: nil)]
    
    class func dailyScheduleRepeating(occurencesPerDay: UInt) -> OCKCareSchedule {
        return OCKCareSchedule.dailySchedule(withStartDate: DateComponents.firstDateOfCurrentWeek,
                                             occurrencesPerDay: occurencesPerDay)
    }
    
    init(carePlanStore: OCKCarePlanStore) {
        self.carePlanStore = carePlanStore
        super.init()
        //---------------------------------------------
        //Intervention activities
        //---------------------------------------------
        let cardioActivity = OCKCarePlanActivity(
            identifier: ActivityIdentifier.cardio.rawValue,
            groupIdentifier: nil,
            type: .intervention,
            title: "Cardio",
            text: "60 Minutes",
            tintColor: UIColor.orange,
            instructions: "Jog at a moderate pace for an hour. If there isn't an actual one, imagine a horde of zombies behind you.",
            imageURL: nil,
            schedule:CarePlanData.dailyScheduleRepeating(occurencesPerDay: 2),
            resultResettable: true,
            userInfo: nil)
        
        let limberUpActivity = OCKCarePlanActivity(
            identifier: ActivityIdentifier.limberUp.rawValue,
            groupIdentifier: nil,
            type: .intervention,
            title: "Limber Up",
            text: "Stretch Regularly",
            tintColor: UIColor.orange,
            instructions: "Stretch and warm up muscles in your arms, legs and back before any expected burst of activity. This is especially important if, for example, you're heading down a hill to inspect a Hostess truck.",
            imageURL: nil,
            schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 6),
            resultResettable: true,
            userInfo: nil)
        
        let targetPracticeActivity = OCKCarePlanActivity(
            identifier: ActivityIdentifier.targetPractice.rawValue,
            groupIdentifier: nil,
            type: .intervention,
            title: "Target Practice",
            text: nil,
            tintColor: UIColor.orange,
            instructions: "Gather some objects that frustrated you before the apocalypse, like printers and construction barriers. Keep your eyes sharp and your arm steady, and blow as many holes as you can in them for at least five minutes.",
            imageURL: nil,
            schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 2),
            resultResettable: true,
            userInfo: nil)
        
        //---------------------------------------------
        //Assessment activities
        //---------------------------------------------
        let pulseActivity = OCKCarePlanActivity.assessment(withIdentifier: ActivityIdentifier.pulse.rawValue, groupIdentifier: nil, title: "Pulse", text: "Do you have one?", tintColor: UIColor.brown, resultResettable: true, schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), userInfo: ["ORKTask" : AssessmentTaskFactory.makePulseAssessmentTask()], optional: false)
        
        let temperatureActivity = OCKCarePlanActivity.assessment(withIdentifier: ActivityIdentifier.temperature.rawValue, groupIdentifier: nil, title: "Temperature", text: "Oral", tintColor: .gray, resultResettable: true, schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), userInfo: ["ORKTask" : AssessmentTaskFactory.makeTemperatureAssessmentTask()], optional: false)
        
        let bloodPressureActivity = OCKCarePlanActivity.assessment(withIdentifier: ActivityIdentifier.bloodPressure.rawValue, groupIdentifier: nil, title: "Blood Pressure", text: "What is your current blood pressure?", tintColor: UIColor.purple, resultResettable: true, schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), userInfo: ["ORKTask" : AssessmentTaskFactory.makeBloodPresureAssessmentTask()], optional: false)
        
        
        //---------------------------------------------
        //Finally, adding all the activities
        //---------------------------------------------
        for activity in [cardioActivity, limberUpActivity, targetPracticeActivity, pulseActivity, temperatureActivity, bloodPressureActivity] {
            add(activity: activity)
        }
    }
    
    func add(activity: OCKCarePlanActivity) {
        // 1
        carePlanStore.activity(forIdentifier: activity.identifier) {
            [weak self] (success, fetchedActivity, error) in
            guard success else { return }
            guard let strongSelf = self else { return }
            // 2
            if let _ = fetchedActivity { return }
            
            // 3
            strongSelf.carePlanStore.add(activity, completion: { _,_  in })
        }
    }
}

extension CarePlanData {
    func generateDocumentWith(chart: OCKChart?) -> OCKDocument {
        let intro = OCKDocumentElementParagraph(content: "I've been tracking my efforts to stay healthy. Please check the attached report to see if my health is good.")
        
        var documentElements: [OCKDocumentElement] = [intro]
        if let chart = chart {
            documentElements.append(OCKDocumentElementChart(chart: chart))
        }
        
        let document = OCKDocument(title: "Re: Your Brains", elements: documentElements)
        document.pageHeader = "Weekly Report"
        
        return document
    }
}

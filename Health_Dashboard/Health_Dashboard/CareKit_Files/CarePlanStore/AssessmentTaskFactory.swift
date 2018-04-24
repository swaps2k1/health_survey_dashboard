//
//  AssessmentTaskFactory.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/24/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit

struct AssessmentTaskFactory {
    static func makePulseAssessmentTask() -> ORKTask {
        let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let unit = HKUnit(from: "count/min")
        let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .integer)
        
        // Create a question.
        let title = "Measure the number of beats per minute."
        let text = "Place two fingers on your wrist and count how many beats you feel in 15 seconds.  Multiply this number by 4."
        let questionStep = ORKQuestionStep(identifier: "PulseStep", title: title, text: text, answer: answerFormat)
        questionStep.isOptional = false
        
        // Create an ordered task with a single question
        return ORKOrderedTask(identifier: "PulseTask", steps: [questionStep])
    }
    
    static func makeTemperatureAssessmentTask() -> ORKTask {
        let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!
        let unit = HKUnit(from: "degF")
        let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .decimal)
        
        // Create a question.
        let title = "Take temperature orally."
        let text = "Temperatures in the range of 99-103°F are an early sign of possible infection. Temperatures over 103°F generally indicate early stages of transformation."
        let questionStep = ORKQuestionStep(identifier: "TemperatureStep", title: title, text: text, answer: answerFormat)
        questionStep.isOptional = false
        
        // Create an ordered task with a single question
        return ORKOrderedTask(identifier: "TemperatureTask", steps: [questionStep])
    }
    
    static func makeBloodPresureAssessmentTask() -> ORKTask {
        let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!
        let unit = HKUnit(from: "mmHg")
        let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .decimal)
        
        // Create a question.
        let title = "Measure Blood Pressure"
        let text = "Blood Pressure in the range of 120-190 mmHg are an early sign of possible infection. Blood Pressure over 180 mmHg generally indicate early stages of High Blood Pressure."
        let questionStep = ORKQuestionStep(identifier: "BloodPressureStep", title: title, text: text, answer: answerFormat)
        questionStep.isOptional = false
        
        // Create an ordered task with a single question
        return ORKOrderedTask(identifier: "BloodPressureTask", steps: [questionStep])
    }
}

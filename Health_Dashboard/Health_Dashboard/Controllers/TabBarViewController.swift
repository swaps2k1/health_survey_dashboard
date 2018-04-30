//
//  TabBarViewController.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/23/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit
import CareKit

class TabBarViewController: UITabBarController {

    fileprivate let carePlanStoreManager = CarePlanStoreManager.sharedCarePlanStoreManager
    fileprivate let carePlanData: CarePlanData
    fileprivate var symptomTrackerViewController: OCKSymptomTrackerViewController? = nil
    fileprivate var insightsViewController: OCKInsightsViewController? = nil
    fileprivate var insightChart: OCKBarChart? = nil

    required init?(coder aDecoder: NSCoder) {
        carePlanData = CarePlanData(carePlanStore: carePlanStoreManager.store)

        super.init(coder: aDecoder)
        carePlanStoreManager.delegate = self
        carePlanStoreManager.updateInsights()
        self.tabBar.tintColor = .purple
        
        let careCardStack = createCareCardStack()
        let symptomTrackerStack = createSymptomTrackerStack()
        let insightsStack = createInsightsStack()
        let connectStack = createConnectStack()
        
        self.viewControllers = [careCardStack,
                                symptomTrackerStack,
                                insightsStack,
                                connectStack]
    }

    fileprivate func createCareCardStack() -> UINavigationController {
        let viewController = OCKCareCardViewController(carePlanStore: carePlanStoreManager.store)
        viewController.tabBarItem = UITabBarItem(title: "Care Card", image: UIImage(named: "care_card"), selectedImage: UIImage(named: "care_card"))
        viewController.title = "Care Card"
        viewController.headerTitle = "Care Card"
        return UINavigationController(rootViewController: viewController)
    }
    
    fileprivate func createSymptomTrackerStack() -> UINavigationController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: carePlanStoreManager.store)
        viewController.delegate = self
        viewController.glyphTintColor = .purple
        symptomTrackerViewController = viewController
        
        viewController.tabBarItem = UITabBarItem(title: "Symptom Tracker", image: UIImage(named: "symptomTracking"), selectedImage: UIImage.init(named: "symptomTracking"))
        viewController.title = "Symptom Tracker"
        viewController.headerTitle = "Symptom Tracker"
        return UINavigationController(rootViewController: viewController)
    }
    
    fileprivate func createInsightsStack() -> UINavigationController {
        let viewController = OCKInsightsViewController(insightItems: [OCKInsightItem.emptyInsightsMessage()], patientWidgets: nil, thresholds: nil, store: carePlanStoreManager.store)
        insightsViewController = viewController

        viewController.tabBarItem = UITabBarItem(title: "Insights", image: UIImage(named: "insights"), selectedImage: UIImage.init(named: "insights"))
        viewController.title = "Insights"
        return UINavigationController(rootViewController: viewController)
    }
    
    fileprivate func createConnectStack() -> UINavigationController {
        let viewController = OCKConnectViewController(contacts: carePlanData.contacts)
        viewController.delegate = self
        viewController.tabBarItem = UITabBarItem(title: "Connect", image: UIImage(named: "connect"), selectedImage: UIImage.init(named: "connect"))
        viewController.title = "Connect"
        return UINavigationController(rootViewController: viewController)
    }
}

// MARK: - OCKSymptomTrackerViewControllerDelegate
extension TabBarViewController: OCKSymptomTrackerViewControllerDelegate {
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController,
                                      didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        guard let userInfo = assessmentEvent.activity.userInfo,
            let task: ORKTask = userInfo["ORKTask"] as? ORKTask else { return }
        
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
    }
}

// MARK: - ORKTaskViewControllerDelegate
extension TabBarViewController: ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith
        reason: ORKTaskViewControllerFinishReason, error: Error?) {
        // 1
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        // 2
        guard reason == .completed else { return }
        guard let symptomTrackerViewController = symptomTrackerViewController,
            let event = symptomTrackerViewController.lastSelectedAssessmentEvent else { return }
        let carePlanResult = carePlanStoreManager.buildCarePlanResultFrom(taskResult: taskViewController.result)
        carePlanStoreManager.store.update(event, with: carePlanResult, state: .completed) {
            success, _, error in
            if !success {
                print(error?.localizedDescription)
            }
        }
    }
}

// MARK: - CarePlanStoreManagerDelegate
extension TabBarViewController: CarePlanStoreManagerDelegate {
    func carePlanStore(_ store: OCKCarePlanStore, didUpdateInsights insights: [OCKInsightItem]) {
        if let trainingPlan = (insights.filter { $0.title == "Training Plan" }.first) {
            insightChart = trainingPlan as? OCKBarChart
        }
        insightsViewController?.items = insights
    }
}

// MARK: - OCKConnectViewControllerDelegate
extension TabBarViewController: OCKConnectViewControllerDelegate {
    
    func connectViewController(_ connectViewController: OCKConnectViewController,
                               didSelectShareButtonFor contact: OCKContact,
                               presentationSourceView sourceView: UIView?) {
        let document = carePlanData.generateDocumentWith(chart: insightChart)
        let activityViewController = UIActivityViewController(activityItems: [document.htmlContent],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}

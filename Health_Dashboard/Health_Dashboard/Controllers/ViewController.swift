//
//  ViewController.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/19/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit

class ViewController: UIViewController {
    
    var consentDocument: ORKConsentDocument = ConsentDocument
    
    @IBAction func consentButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ConsentTask1, taskRun: nil)
        taskViewController.delegate = self
        self.present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func surveyButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func actionTaskButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ActiveTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func actionTaskType2ButtonTapped(_ sender: UIButton) {
        let taskVC = ORKTaskViewController(task: ActiveTaskType2, taskRun: nil)
        taskVC.delegate = self
        present(taskVC, animated: true, completion: nil)
    }
    
    @IBAction func careKitDashboardButtonTapped(_ sender: UIButton) {
        let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
        navigationController?.pushViewController(tabBarViewController, animated: true)
    }
}

extension ViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        print(reason.rawValue)
        print(taskViewController.result)
        
        if let consentSignatureResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.firstResult as? ORKConsentSignatureResult {
            consentSignatureResult.apply(to: consentDocument)
            
            consentDocument.makePDF(completionHandler: {(data, error) in
                if let pdfData = data, let docDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                    let filePath = "\(docDirPath)/ConsentDocument.pdf"
                    let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
                    print(fileURL)
                    try! pdfData.write(to: fileURL)
                }
            })
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    
}

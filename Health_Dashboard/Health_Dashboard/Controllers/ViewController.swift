//
//  ViewController.swift
//  ResearchKit App
//
//  Created by Kokate, Tejas (US - Mumbai) on 4/19/18.
//  Copyright © 2018 Deloitte. All rights reserved.
//

import ResearchKit

class ViewController: UIViewController {
    
    @IBAction func consentButtonTapped(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
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
        taskViewController.dismiss(animated: true, completion: nil)
    }
}

//
//  LoginViewController.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 14/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var isValidEmail = false
    var isValidPassword = false
    let disposeBag = DisposeBag()
    
    /// Description:- view controller Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSubmitStatus()
        setupRxObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateSubmitStatus() {
        if isValidEmail, isValidPassword {
            submitButton.isEnabled = true
            submitButton.backgroundColor = UIColor.systemRed
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.lightGray
        }
    }
    
    func setupRxObservers() {
        emailTextField
            .rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: {
                self.isValidEmail = false
            } ).disposed(by: disposeBag)
        
        emailTextField
            .rx.controlEvent([.editingDidEnd,.editingDidEndOnExit])
            .asObservable()
            .subscribe(onNext: {
                if self.emailTextField.text?.isValidEmail ?? false {
                    self.isValidEmail = true
                    self.passwordTextField.becomeFirstResponder()
                } else {
                    self.isValidEmail = false
                    self.emailTextField.becomeFirstResponder()
                }
                self.dismissKeyboard()
                self.updateSubmitStatus()
            } ).disposed(by: disposeBag)
        passwordTextField
            .rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: {
                self.isValidPassword = false
            } ).disposed(by: disposeBag)
        
        passwordTextField
            .rx.controlEvent([.editingDidEnd,.editingDidEndOnExit])
            .asObservable()
            .subscribe(onNext: {
                if self.passwordTextField.text?.isValidPassword ?? false {
                    self.isValidPassword = true
                    self.submitButton.becomeFirstResponder()
                } else {
                    self.isValidPassword = false
                    self.passwordTextField.becomeFirstResponder()
                }
                self.dismissKeyboard()
                self.updateSubmitStatus()
            } ).disposed(by: disposeBag)
        
        submitButton.rx.tap
            .asDriver()
            .debounce(DispatchTimeInterval.microseconds(500000))
            .drive(onNext:{ (_) in
                self.addMenu()
            }).disposed(by: disposeBag)
    }
    
    @objc func dismissKeyboard() {
      view.endEditing(true)
    }
}

//
//  Sprint2SignUpViewController.swift
//  Sprint2Tests
//
//  Created by Capgemini-DA230 on 9/27/22.
//

import XCTest
@testable import Sprint2

class Sprint2SignUpViewController: XCTestCase {

    var model: SignUpViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        model = SignUpViewController.getVc()
        model!.loadViewIfNeeded()
    }
    func test_NameValidate() {
        XCTAssertTrue(model.userNameValidation("Yash"), "Name should have atleast 4 characters")
    }
    
    func test_MobileValidate() {
        XCTAssertTrue(model.mobileValidation("9899252611"), "Mobile Number should contain 10 digits.")
    }
    
    func test_EmailValidate() {
        XCTAssertTrue(model.emailValidation("yash@gmail.com"), "The Email Address must be alphanumeric and should contain atleast 2 charcters.")
        
    }

    func test_PasswordValidate() {
        XCTAssertTrue(model.pwdValidation("salnjan12"), "Password should contain minimum 6 characters and should be alphanumeric")
    }
    
    func test_ConfirmPasValidate() {
        XCTAssertTrue(model.confirmPwdValidation("salnjan12", "salnjan12"), "Confirm Password doesn't match Password.")
    }
    
    func test_Check_outlets() throws {
        XCTAssertNotNil(model.nameTextField, "Name nil")
        XCTAssertNotNil(model.emailTextField, "Email nil")
        XCTAssertNotNil(model.mobileTextField, "Mobile nil")
        XCTAssertNotNil(model.passwordTextField, "Password Nil")
        XCTAssertNotNil(model.confirmPasswordTextField, "CPassword Nil")
        XCTAssertNotNil(model.signUpImgView, "SignUPImgView Nil")
        
        
    }
    
   
    
    func test_buttonAction() throws {
        let emailAction = try XCTUnwrap(model.emailTextField, "not there outlet for emai button")
        //let sign = try XCTUnwrap(signUpButton.actions(forTarget: <#T##Any?#>, forControlEvent: <#T##UIControl.Event#>))
        let emailUpActionButton = try XCTUnwrap(emailAction.actions(forTarget: model, forControlEvent: .editingDidEnd), "no action for email button" )
        
        XCTAssertEqual(emailUpActionButton.count, 1)
        XCTAssertEqual(emailUpActionButton.first, "emailTextFieldAction:", "There is no action to a emailTextField ")
        
        let passwordAction = try XCTUnwrap(model.passwordTextField, "Not there outlet for password")
        let passwordActionButton = try XCTUnwrap(passwordAction.actions(forTarget: model, forControlEvent: .editingDidEnd),"No action for password")
        
        XCTAssertEqual(passwordActionButton.count, 1)
        XCTAssertEqual(passwordActionButton.first, "passwordTextFieldAction:", "There is no action to passwordTextField.")
        
        let mobileAction = try XCTUnwrap(model.mobileTextField, "Not there outlet for mobile button")
        
        let mobileActionButton = try XCTUnwrap(mobileAction.actions(forTarget: model, forControlEvent: .editingDidEnd), "No action for mobile button")
        
        XCTAssertEqual(mobileActionButton.count, 1)
        XCTAssertEqual(mobileActionButton.first, "mobileTextFieldAction:", "There is no action to a mobile TextField.")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

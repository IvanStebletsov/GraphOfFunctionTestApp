//
//  GraphVCExtension.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 30/05/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

extension GraphVC {
    
    // MARK: - UI Configuration
    func makeChart() {
        lineChart = LineChart()
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.backgroundColor = .clear
        
        lineChart.stepX = 5
        lineChart.stepY = 20
        lineChart.drawGrid = true
        view.addSubview(lineChart)
        
        let safeArea = view.safeAreaLayoutGuide
        
        lineChartTopAnchor = lineChart.topAnchor.constraint(equalTo: inputTFBackView.bottomAnchor, constant: 10)
        lineChartTopAnchor.isActive = true
        
        let lineChartConstraints = [
            lineChart.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            lineChart.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            lineChart.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)]
        NSLayoutConstraint.activate(lineChartConstraints)
    }
    
    func makeInputTextField() {
        inputTFBackView = UIView()
        inputTFBackView.translatesAutoresizingMaskIntoConstraints = false
        
        inputTFBackView.backgroundColor = .init(white: 1, alpha: 0.8)
        inputTFBackView.layer.cornerRadius = 30
        inputTFBackView.layer.shouldRasterize = true
        inputTFBackView.layer.rasterizationScale = UIScreen.main.nativeScale
        
        view.addSubview(inputTFBackView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let inputTFBackViewConstraints = [
            inputTFBackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            inputTFBackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            inputTFBackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            inputTFBackView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(inputTFBackViewConstraints)
        
        inputTextField = UITextField()
        inputTextField.addTarget(self, action: #selector(validateExpression), for: UIControl.Event.editingChanged)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inputTextField.delegate = self
        inputTextField.textColor = #colorLiteral(red: 0.1937165895, green: 0.2214707394, blue: 0.2453658953, alpha: 1)
        inputTextField.font = .boldSystemFont(ofSize: 20)
        inputTextField.placeholder = "(3 * (2 + x))"
        
        inputTFBackView.addSubview(inputTextField)
        
        let inputTextFieldConstraints = [
            inputTextField.topAnchor.constraint(equalTo: inputTFBackView.topAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: inputTFBackView.leadingAnchor, constant: 20),
            inputTextField.trailingAnchor.constraint(equalTo: inputTFBackView.trailingAnchor, constant: -20),
            inputTextField.bottomAnchor.constraint(equalTo: inputTFBackView.bottomAnchor)]
        NSLayoutConstraint.activate(inputTextFieldConstraints)
    }
    
    func makeDrawGraphButton() {
        drawGraphButton = UIButton()
        drawGraphButton.translatesAutoresizingMaskIntoConstraints = false
        
        drawGraphButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        drawGraphButton.layer.cornerRadius = 20
        drawGraphButton.addTarget(self, action: #selector(showInputTextField), for: UIControl.Event.touchUpInside)
        
        inputTFBackView.addSubview(drawGraphButton)
        
        let drawGraphButtonConstraints = [
            drawGraphButton.topAnchor.constraint(equalTo: inputTFBackView.topAnchor, constant: 10),
            drawGraphButton.bottomAnchor.constraint(equalTo: inputTFBackView.bottomAnchor, constant: -10),
            drawGraphButton.trailingAnchor.constraint(equalTo: inputTFBackView.trailingAnchor, constant: -10),
            drawGraphButton.widthAnchor.constraint(equalTo: drawGraphButton.heightAnchor)]
        NSLayoutConstraint.activate(drawGraphButtonConstraints)
    }
    
    func makeEnteredExpressionLabel() {
        enteredExpressionLabel = UILabel()
        enteredExpressionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        enteredExpressionLabel.font = .boldSystemFont(ofSize: 16)
        enteredExpressionLabel.textColor = .white
        view.addSubview(enteredExpressionLabel)
        
        let enteredExpressionLabelConstraints = [
            enteredExpressionLabel.trailingAnchor.constraint(equalTo: lineChart.trailingAnchor, constant: -20),
            enteredExpressionLabel.bottomAnchor.constraint(equalTo: lineChart.bottomAnchor, constant: -30)]
        NSLayoutConstraint.activate(enteredExpressionLabelConstraints)
    }
    
    func hideKeyboardByTapAnywhere() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func showInputTextField() {
        print(#function)
        print(inputTextField.text!)
        
        
        //        let points = compute { (x) -> Int in
        //            (x - 10) * (x - 10)
        //        }
        
        
        //        lineChart.plotGraph(points)
    }
    
    @objc func validateExpression(sende: UITextField) {
        print(sende.text)
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789()+-*Xx").inverted
        
        if ((sende.text?.rangeOfCharacter(from: allowedCharacters) != nil)) {
            sende.text? = (sende.text?.trimmingCharacters(in: allowedCharacters))!
        }
    }
    
}

extension GraphVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function, "- \(textField.text ?? "nil")")
        
        if textField.text!.count == 0 || (!textField.text!.contains("x")) || (textField.text?.contains("()"))! {
            print("Траблы")
        } else {
            //переводим в регулярное выражение и строим график
            enteredExpressionLabel.text = "y = \(textField.text!.lowercased())"
        }
        
        inputTextField.resignFirstResponder()
        return true
    }
}


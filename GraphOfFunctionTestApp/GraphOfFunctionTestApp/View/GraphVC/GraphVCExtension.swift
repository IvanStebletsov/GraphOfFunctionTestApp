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
        inputTextField.addTarget(self, action: #selector(correctExpression(from:)), for: UIControl.Event.editingChanged)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inputTextField.delegate = self
        inputTextField.textColor = #colorLiteral(red: 0.1937165895, green: 0.2214707394, blue: 0.2453658953, alpha: 1)
        inputTextField.font = .boldSystemFont(ofSize: 20)
        inputTextField.placeholder = "Введите функцию"
        
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
        
        drawGraphButton.backgroundColor = #colorLiteral(red: 0.1260859668, green: 0.582623601, blue: 0.9936849475, alpha: 1)
        drawGraphButton.layer.cornerRadius = 20
        drawGraphButton.addTarget(self, action: #selector(plotGraph), for: UIControl.Event.touchUpInside)
        
        let image = UIImage(named: "draw")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        
        drawGraphButton.setImage(tintedImage, for: .normal)
        drawGraphButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        drawGraphButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
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
    
    // MARK: - Gesture recognizer
    func addGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        slideDown.direction = .down
        view.addGestureRecognizer(slideDown)
    }
    
    // MARK: - Draw chart
    @objc func plotGraph() {
        guard let expression = correctExpression(from: inputTextField) else { return }
        let validationResult = inputValidator.isValid(this: expression)
        guard validationResult.1 == nil else { presentAlertController(with: validationResult.1!); return }
        
        let pointsForGraph = viewModel.computePoints(for: expression)
        lineChart.plotGraph(pointsForGraph)
        
        let mathOperatorsCharacterSet = CharacterSet(charactersIn: "+-*")
        if expression.rangeOfCharacter(from: mathOperatorsCharacterSet) != nil {
            enteredExpressionLabel.text = "y = \(expression.separateWithSpaces())"
            inputTextField.placeholder = expression.separateWithSpaces()
        } else {
            enteredExpressionLabel.text = "y = \(expression)"
            inputTextField.placeholder = expression
        }
        
        inputTextField.resignFirstResponder()
        inputTextField.text = ""
    }
    
    // MARK: - Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Input validation
    @objc func correctExpression(from sender: UITextField) -> String? {
        sender.text = sender.text?.correctInput()
        guard let expression = sender.text?.correctInput(), !expression.isEmpty, expression != " " else { return nil }
        return expression
    }
    
    // MARK: - Alert
    func presentAlertController(with error: InputError) {
        let alertController = UIAlertController(title: "Ошибка ввода функции",
                                                message: error.reason,
                                                preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAlertAction)
        
        self.present(alertController, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate methods
extension GraphVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        plotGraph()
        textField.resignFirstResponder()
        return true
    }
    
}


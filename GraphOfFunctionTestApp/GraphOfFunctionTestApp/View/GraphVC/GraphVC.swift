//
//  GraphViewController.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 30/05/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

class GraphVC: UIViewController {
    
    // MARK: - Properties
    var viewModel: GraphVCVMProtocol!
    var lineChartTopAnchor: NSLayoutConstraint!
    
    // MARK: - UI elements
    var inputTFBackView: UIView!
    var inputTextField: UITextField!
    var drawGraphButton: UIButton!
    var lineChart: LineChart!
    var enteredExpressionLabel: UILabel!
    
    // MARK: - Initialization
    init(viewModel: GraphVCVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cicle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1260859668, green: 0.582623601, blue: 0.9936849475, alpha: 1)
        
        makeInputTextField()
        makeDrawGraphButton()
        addGestureRecognizer()
        makeChart()
        makeEnteredExpressionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let points = viewModel.computePoints(for: "x * x")
        enteredExpressionLabel.text = "y = x * x"
        inputTextField.placeholder = "x * x"
        lineChart.plotGraph(points)
    }
    
    // MARK: - UI Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            inputTFBackView.isHidden = false
            lineChartTopAnchor.isActive = false
            lineChartTopAnchor = lineChart.topAnchor.constraint(equalTo: inputTFBackView.bottomAnchor, constant: 10)
            lineChartTopAnchor.isActive = true
        } else {
            inputTFBackView.isHidden = true
            lineChartTopAnchor.isActive = false
            lineChartTopAnchor = lineChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
            lineChartTopAnchor.isActive = true
        }
    }
    
    // MARK: - UI Adjustment
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}




//
//  RequestViewController.swift
//  WeatherApp
//
//  Created by Julia Martsenko on 17.02.2022.
//

import UIKit

class RequestViewController: UIViewController {
    
    var parceTextToLocationService: RecastAIServiceProtocol?
    var weatherForcastService: DarkSkyService?
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.cornerRadius = 8.0
        button.setTitle("Request", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.isHidden = false
        button.addTarget(self, action: #selector(makeRequest(_:)), for: .touchUpInside)
        return button
    }()
    
    let responseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Response will be here"
        label.backgroundColor = .white
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let questionField: UITextField = {
        let view  = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.cornerRadius = 8.0
        view.backgroundColor = .white
        view.textColor = .black
        view.placeholder = "Ask me a question: "
        return view
    }()
    
    @objc func makeRequest(_ sender: UIButton) {
        guard let text = questionField.text,
              !text.isEmpty else {
                  responseLabel.text = WeatherAppErrors.emptyRequest.localizedDescription
                  return
              }
        parceTextToLocationService?.parceText(text: text) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let location):
                self.weatherForcastService?.getWeather(in: location) { result in
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.responseLabel.text = forecast.daily?.summary
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.responseLabel.text = error.localizedDescription
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.responseLabel.text = error.localizedDescription
                }
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.frame = UIScreen.main.bounds
        view.addSubview(responseLabel)
        view.addSubview(questionField)
        view.addSubview(requestButton)
    }
    
    override func viewDidLayoutSubviews() {
        responseLabel.frame = CGRect(x: view.bounds.minX + 20,
                                     y: view.bounds.maxY / 2 - view.bounds.maxY / 4,
                                     width: view.bounds.width - 40,
                                     height: CGFloat(80))
        questionField.frame = CGRect(x: view.bounds.minX + 20,
                                     y: responseLabel.frame.maxY + 16,
                                     width: view.bounds.width - 40,
                                     height: 300)
        requestButton.frame = CGRect(x: view.bounds.minX + (view.bounds.maxX - 150) / 2,
                                     y: questionField.frame.maxY + 16,
                                     width: 150,
                                     height: 50)
        view.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        parceTextToLocationService = RecastAIService()
        weatherForcastService = DarkSkyService()
        setupView()
    }
    
}

extension RequestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        questionField.endEditing(true)
        questionField.resignFirstResponder()
        return true
    }
    
}

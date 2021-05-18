//
//  ViewController.swift
//  VPNTest
//
//  Created by 111 on 18.05.2021.
//

import UIKit

class ViewController: UIViewController, DataDelegateProtocol {
    
    let connectButton = PulseButton()
    let statusLabel = UILabel()
    let countryImageView = UIImageView()
    var secCount = 0
    var active = false
    
    enum Status {
        case disConnected
        case connected
    }
    
    var status: Status = .disConnected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectButton.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
    }
    
    override func loadView() {
        self.view = UIView()
        view.backgroundColor = .white
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        countryImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countryImageView)
        view.addSubview(connectButton)
        view.addSubview(statusLabel)
        connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        connectButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        statusLabel.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 40).isActive = true
        countryImageView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20).isActive = true
        countryImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statusLabel.text = "Tap on circle to connect"
        statusLabel.textColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openCountryList))

    }
    
    @objc func openCountryList() {
        if !active {
            let newViewController = SecondViewController()
            newViewController.delegate = self
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func buttonClicked() {
        switch status {
        case .connected:
            active = true
            connectButton.isEnabled = false
            connectButton.pulsator.start()
            statusLabel.text = "Disconnecting"
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.secCount += 1
                if self.secCount == 4 {
                    timer.invalidate()
                    self.connectButton.pulsator.stop()
                    self.statusLabel.text = "Tap to connect"
                    self.connectButton.isEnabled = true
                    self.status = .disConnected
                    self.secCount = 0
                    self.active = false
                }
            }
        case .disConnected:
            active = true
            connectButton.isEnabled = false
            connectButton.pulsator.start()
            statusLabel.text = "Connecting"
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.secCount += 1
                if self.secCount == 4 {
                    timer.invalidate()
                    self.connectButton.pulsator.stop()
                    self.status = .connected
                    self.statusLabel.text = "Tap to disconnect"
                    self.connectButton.isEnabled = true
                    self.secCount = 0
                    self.active = false
                }
            }
        }
    }
    
    func setCountryImage(image: UIImage) {
        navigationController?.popViewController(animated: true)
        countryImageView.image = image
        status = .disConnected
        buttonClicked()
    }

}

protocol DataDelegateProtocol {
    func setCountryImage(image: UIImage)
}



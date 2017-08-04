import UIKit

class HelloViewController: UIViewController {

    var infomationLabel: UILabel!
    var logoutButton: UIButton!

    let service = AuthSampleService()

    override func loadView() {
        super.loadView()

        infomationLabel = UILabel(frame: CGRect.zero)
        infomationLabel.textAlignment = .center

        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.isEnabled = false

        infomationLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(infomationLabel)
        self.view.addSubview(logoutButton)

        let labelConstraints = [
            infomationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infomationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        let buttonConstraints = [
            logoutButton.centerXAnchor.constraint(equalTo: infomationLabel.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: infomationLabel.bottomAnchor, constant: 100.0),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 35)
        ]

        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // request user info.
        service.getMyInfomation { [unowned self] infomation in
            self.infomationLabel.text = infomation
            self.logoutButton.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        logoutButton.removeTarget(self, action: #selector(logout), for: .touchUpInside)
    }

    func logout() {
        let defauls = UserDefaults.standard
        defauls.removeObject(forKey: "token")

        dismiss(animated: true, completion: nil)
    }
}

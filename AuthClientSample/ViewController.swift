import UIKit

class ViewController: UIViewController {

    let service = AuthSampleService()

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func login(_ sender: UIButton) {

        let email = emailField.text!
        let password = passwordField.text!

        // perform login.
        service.login(email: email, password: password) {

            // if you have token, go next scene. if not, show alert dialog.
            if self.getToken() != nil {
                self.goToNextViewController()
            } else {
                let alertController = UIAlertController(
                    title: "login fail",
                    message: "enter correct email and password.",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)

                self.present(alertController, animated: true) {
                    self.passwordField.text = ""

                }
            }
        }
    }

    @IBAction func cancel(_ sender: UIButton) {
        emailField.text = ""
        passwordField.text = ""

        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // if you have token, don't show this schene and go next scene.
        if getToken() != nil {
            goToNextViewController()
        }

        emailField.text = "yamada@jiro.jp"
        passwordField.text = "abcde"
    }

    private func getToken() -> String? {

        // FIXME: I shouldn't use UserDefaults for storing token.
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "token")
    }

    private func goToNextViewController() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "myInfo")
        nextVC?.modalTransitionStyle = .coverVertical

        present(nextVC!, animated: true, completion: nil)
    }
}

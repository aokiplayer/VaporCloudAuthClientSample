import Foundation

class AuthSampleService: NSObject {

    private let urlString = "https://auth20170803-develop.vapor.cloud/"

    let session = URLSession(configuration: .default)

    /// perform login.
    ///
    /// - Parameters:
    ///   - email: email address
    ///   - password: password
    ///   - handler: perform when request has completed, even if it failed.
    func login(email: String, password: String, completionHandler handler: (() -> Void)?) {

        let authData = "\(email):\(password)".data(using: .utf8)!
        let encodedAuthString = authData.base64EncodedString()

        var urlComponents = URLComponents(string: urlString)!
        urlComponents.path += "login"
        let url = urlComponents.url!

        // MARK: - for debug.
        print(url.absoluteString)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // add "Authorization" header to request. base 64 encoded email:password.
        request.addValue("Basic \(encodedAuthString)", forHTTPHeaderField: "Authorization")

        // MARK: - for debug.
        print(request.allHTTPHeaderFields!)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                // save token.
                self.saveToken(from: data)
            }

            // perform handler, even if it failed.
            DispatchQueue.main.async {
                handler?()
            }
        }

        task.resume()
    }

    deinit {
        session.finishTasksAndInvalidate()
    }

    /// request logined user info.
    ///
    /// - Parameter handler: perform when request has completed, even if it failed.
    func getMyInfomation(completionHandler handler: ((String) -> Void)?) {

        guard let token = UserDefaults.standard.string(forKey: "token") else { print("login first."); return }

        var urlComponents = URLComponents(string: urlString)!
        urlComponents.path += "me"
        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { (data, response, error) in

            let result: String

            if let data = data {
                result = String(data: data, encoding: .utf8)!
            } else {
                result = "something error."
            }

            DispatchQueue.main.async {
                handler?(result)
            }
        }

        task.resume()
    }

    /// persist token.
    ///
    /// - Parameter data: Data object includes token.
    private func saveToken(from data: Data) {

        guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: String]
            else { print("json error."); return }
        guard let token = json["token"] else { print("token error."); return }

        // FIXME: I shouldn't use UserDefaults for storing token.
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
        defaults.synchronize()
    }
}

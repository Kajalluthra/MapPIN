//
//  NetworkService.swift
//  Demo
//
//  Created by Kajal Luthra on 16/3/21.
//

import UIKit

final class HomeNetworkService {
    func fetchTrafficListing(completed:@escaping (_ success: Bool, _ response: [Item]?) -> Void)  {

        let urlString = "https://api.data.gov.sg/v1/transport/traffic-images"

        let url: URL = URL(string: urlString)!
        URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> () in
            guard let data = data else { return }

            do {
                let data = try JSONDecoder().decode(Welcome.self, from: data)
                completed(true, data.items)
            } catch _ {
                completed(false, nil)
            }

        }).resume()

    }

    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: UIImage?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: urlString)

        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                completionHandler(nil)
            } else {
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    completionHandler(UIImage(data: data))
                }
            }
        }
        dataTask.resume()
    }
}

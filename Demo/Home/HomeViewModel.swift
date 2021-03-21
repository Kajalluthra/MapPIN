//
//  HomeViewModel.swift
//  Demo
//
//  Created by Kajal Luthra on 16/3/21.
//

import UIKit

final class HomeViewModel {
    private let service: HomeNetworkService
    private(set) var cameras = [Camera]()

    init(service: HomeNetworkService) {
        self.service = service
    }

    func fetchData(completed: @escaping (_ success: Bool) -> Void) {
        service.fetchTrafficListing { [weak self] (success, response) in
            guard success, let data = response?.first?.cameras else {
                completed(false)
                return
            }
            self?.cameras.append(contentsOf: data)
            completed(true)
        }
    }

    func fetchImage(_ imageStr: String, completionBlock: @escaping (_ image: UIImage?) -> ()) {
        service.fetchImage(from: imageStr) { (resultImage) in
            completionBlock(resultImage)
        }
    }
}

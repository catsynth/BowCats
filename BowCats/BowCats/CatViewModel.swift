//
//  CatViewModel.swift
//  BowCats
//
//  Created by Amanda Chaudhary on 11/15/20.
//

import Foundation
import RxAlamofire
import Alamofire
import BowRx
import Bow
import RxSwift
import UIKit
import BowOptics
import Combine


class CatViewModel : ObservableObject {
    var objectWillChange = ObservableObjectPublisher()

    private let disposeBag = DisposeBag()
     
    var state = CatState() {
        willSet {
            objectWillChange.send()
        }
    }
    
    
    func nextCatImage () {
        let headers = HTTPHeaders (["x-api-key" : "d10c4b51-d658-416f-9d6f-4735f439318d"])
        RxAlamofire.json(.get, "https://api.thecatapi.com/v1/images/search",
                        parameters: ["limit":1],
                        encoding: URLEncoding.default,
                        headers: headers,
                        interceptor: nil)
            .map { (input : Any) -> Option<CatResult> in
                guard let array = input as? [[AnyHashable:Any]] else { return Option.none() }
                let result = array.k()
                    .firstOrNone()
                    .flatMap { (json) -> Option<CatResult> in
                        guard let id = json["id"] as? String else  { return Option.none() }
                        guard let url = json["url"] as? String else  { return Option.none() }
                        let result = CatResult(id: id, url: url)
                        return Option.some(result)
                    }
                return Option.fix(result)
            }
            .subscribe(onNext: { (input : Option<CatResult>) in
                input.fold({}, { [weak self] in
                    guard let url = URL(string: $0.url) else { return }
                    guard let data = try? Data(contentsOf: url) else { return }
                    guard let image = UIImage(data: data) else { return }
                    let imageLens = CatState.lens(for: \.image)
                    self?.state = imageLens.set(self?.state ?? CatState(),image)
                })
            }).disposed(by: disposeBag)
    }
    
}

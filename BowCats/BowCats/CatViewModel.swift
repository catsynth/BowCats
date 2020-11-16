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
import BowEffects
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
        
        let either = Either<Error,Option<CatResult>>.fix(
            callCatAPI()
                .unsafeRunSyncEither()
                .map { (input : Any) -> Option<CatResult> in
                print("")
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
        )

        if either.isRight {
            let input = either.rightValue
            input.fold({}, { [weak self] in
                guard let url = URL(string: $0.url) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                let imageLens = CatState.lens(for: \.image)
                self?.state = imageLens.set(self?.state ?? CatState(),image)
            })
        }
    }
    
    func callCatAPI() -> IO<Error, Any> {
        print ("Meow")
        return IO.async { callback in
            print ("Meow2")
            if let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=1") {
                var request = URLRequest(url: url)
                request.setValue("d10c4b51-d658-416f-9d6f-4735f439318d", forHTTPHeaderField: "x-api-key")
                URLSession.shared.dataTask(with: request) { data, _, error in
                        if let data = data {
                            callback(.right(data))
                        } else if let error = error {
                            callback(.left(error))
                        }
                }.resume()
            }
        }^
    }
}

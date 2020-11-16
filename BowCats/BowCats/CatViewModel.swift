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
                .map { try! JSONDecoder().decode([CatResult].self, from: $0) }
                .map { $0.firstOrNone }
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
    
    func callCatAPI() -> IO<Error, Data> {
        guard  let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=1") else {
            return IO<Error, Data>()
        }
        var request = URLRequest(url: url)
        request.setValue("d10c4b51-d658-416f-9d6f-4735f439318d", forHTTPHeaderField: "x-api-key")
        let result = URLSession.shared.dataTaskIO(with: request)
            .map { $0.data }
        return IO<Error,Data>.fix(result)
    }
}

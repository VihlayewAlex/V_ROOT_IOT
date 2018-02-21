//
//  Alomafire.swift
//  V_ROOT_IOT
//
//  Created by Andrew on 2/17/18.
//  Copyright © 2018 Alex Vihlayew. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class APIService {
    
    enum APIServiceError: Error {
        case invalidData
    }
    
    static let shared = APIService()
    private init() { }
    
    func getVisits() -> Promise<[Visit]> {
        return Promise(resolvers: { (fulfill, reject) in
            Alamofire.request(Config.baseApiUrl + "/visits", method: .get)
                .responseData()
                .then(execute: { (jsonData) -> Void in
                    var visitResponse: VisitsResponseApiStruct?
                    do {
                        visitResponse = try JSONDecoder().decode(VisitsResponseApiStruct.self, from: jsonData)
                    } catch {
                        reject(error)
                    }
                    var allVisitsLoadingPromises = [Promise<Visit>]()
                    visitResponse?.visits.forEach({ (visitApiStruct) in
                        allVisitsLoadingPromises.append(self.getVisit(with: visitApiStruct.uid))
                    })
                    when(resolved: allVisitsLoadingPromises)
                        .then(execute: { (results) -> Void in
                            var visits = [Visit]()
                            results.forEach({ (result) in
                                switch result {
                                case .fulfilled(let visit):
                                visits.append(visit)
                                case .rejected(let error):
                                reject(error)
                                }
                            })
                            fulfill(visits)
                        })
                }).catch(execute: { (error) in
                    reject(error)
                })
        })
    }
    
    func getVisit(with uid: String) -> Promise<Visit> {
        return Promise(resolvers: { (fulfill, reject) in
            Alamofire.request(URL(string: Config.baseApiUrl + "/visit?uid=" + uid)!)
                .responseData().then(execute: { (data) -> Void in
                    do {
                        let visitJson = try JSONDecoder().decode(VisitApiStruct.self, from: data)
                        self.loadImagesFrom(urls: visitJson.photoUIDs.map({ (str) in
                            return URL(string: Config.baseApiUrl + "/downloadPhoto?uid=" + str)!
                        })).then(execute: { (images) -> Void in
                            let visit = Visit(uid: visitJson.uid, number: visitJson.number, date: Date(timeIntervalSince1970: TimeInterval(visitJson.timestamp)), photos: images)
                            fulfill(visit)
                        }).catch(execute: { (error) in
                            reject(error)
                        })
                    } catch {
                        reject(error)
                    }
                })
        })
    }
    
    func loadImagesFrom(urls: [URL]) -> Promise<[UIImage]> {
        return Promise(resolvers: { (fulfill, reject) in
            var imageLoadingPromises = [Promise<UIImage>]()
            urls.forEach({ (url) in
                imageLoadingPromises.append(loadImageWith(url: url))
            })
            when(resolved: imageLoadingPromises).then(execute: { (results) -> Void in
                var images = [UIImage]()
                results.forEach({ (result) in
                    switch result {
                    case .fulfilled(let image):
                        images.append(image)
                    case .rejected(let error):
                        reject(error)
                    }
                })
                fulfill(images)
            }).catch(execute: { (error) in
                reject(error)
            })
        })
    }
    
    func loadImageWith(url: URL) -> Promise<UIImage> {
        return Promise(resolvers: { (fulfill, reject) in
            Alamofire.request(url)
                .responseData()
                .then(execute: { (imageData) -> Void in
                    guard let image = UIImage(data: imageData) else {
                        reject(APIServiceError.invalidData)
                        return
                    }
                    fulfill(image)
                }).catch(execute: { (error) in
                    reject(error)
                })
        })
    }
    
}

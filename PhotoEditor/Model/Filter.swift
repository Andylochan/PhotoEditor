//
//  Filter.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/3/21.
//

struct Filter {
    enum FilterType: CaseIterable {
        case Chrome
        case Fade
        case Instant
        case Mono
        case Noir
        case Process
        case Tonal
        case Transfer
        
        var key: String {
            switch self {
            case .Chrome:
                return "CIPhotoEffectChrome"
            case .Fade:
                return "CIPhotoEffectFade"
            case .Instant:
                return "CIPhotoEffectInstant"
            case .Mono:
                return "CIPhotoEffectMono"
            case .Noir:
                return "CIPhotoEffectNoir"
            case .Process:
                return "CIPhotoEffectProcess"
            case .Tonal:
                return "CIPhotoEffectTonal"
            case .Transfer:
                return "CIPhotoEffectTransfer"
            }
        }
    }
}

let filterNames = ["Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Transfer"]
let filterTypes: [Filter.FilterType] = [.Chrome, .Fade, .Instant, .Mono, .Noir, .Process, .Tonal, .Transfer]

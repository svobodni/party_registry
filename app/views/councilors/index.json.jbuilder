json.regional(@regional_councilors) { |region_councilors|
    json.name region_councilors[0]
    json.people(region_councilors[1]) { |councilor|
        json.partial! 'councilor', councilor: councilor
    }
}
json.municipal(@municipal_councilors) { |municipality_councilors|
    json.name municipality_councilors[0][0]
    json.party municipality_councilors[0][1]
    json.people(municipality_councilors[1]) { |councilor|
        json.partial! 'councilor', councilor: councilor
    }
}

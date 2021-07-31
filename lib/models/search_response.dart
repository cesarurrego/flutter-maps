// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
    SearchResponse({
        this.type,
        this.query,
        this.features,
        this.attribution,
    });

    String type;
    List<String> query;
    List<Feature> features;
    String attribution;

    factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        type: json["type"],
        query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
    };
}

class Feature {
    Feature({
        this.id,
        this.type,
        this.placeType,
        this.relevance,
        this.properties,
        this.text,
        this.placeName,
        this.center,
        this.geometry,
        this.context,
    });

    String id;
    String type;
    List<String> placeType;
    double relevance;
    Properties properties;
    String text;
    String placeName;
    List<double> center;
    Geometry geometry;
    List<Context> context;

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"].toDouble(),
        properties: Properties.fromJson(json["properties"]),
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context: List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
    };
}

class Context {
    Context({
        this.id,
        this.wikidata,
        this.shortCode,
        this.text,
    });

    String id;
    String wikidata;
    String shortCode;
    String text;

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "wikidata": wikidata == null ? null : wikidata,
        "short_code": shortCode == null ? null : shortCode,
        "text": text,
    };
}

class Geometry {
    Geometry({
        this.coordinates,
        this.type,
    });

    List<double> coordinates;
    String type;

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
    };
}

class Properties {
    Properties({
        this.foursquare,
        this.landmark,
        this.address,
        this.category,
        this.maki,
    });

    String foursquare;
    bool landmark;
    String address;
    String category;
    String maki;

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        foursquare: json["foursquare"],
        landmark: json["landmark"],
        address: json["address"] == null ? null : json["address"],
        category: json["category"],
        maki: json["maki"] == null ? null : json["maki"],
    );

    Map<String, dynamic> toJson() => {
        "foursquare": foursquare,
        "landmark": landmark,
        "address": address == null ? null : address,
        "category": category,
        "maki": maki == null ? null : maki,
    };
}

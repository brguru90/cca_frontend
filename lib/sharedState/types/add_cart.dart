class PlaylistCartStruct {
  final String id;
  final String name;
  final double price;

  PlaylistCartStruct(
      {required this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
    };
  }

  static PlaylistCartStruct mapToClass(Map mapObj) {
    return PlaylistCartStruct(
        id: mapObj["id"], name: mapObj["name"], price: mapObj["price"]);
  }
}

class SubscriptionPackageCartStruct {
  final String id;
  final String name;
  final double price;

  SubscriptionPackageCartStruct(
      {required this.id, required this.name, required this.price});

  static SubscriptionPackageCartStruct mapToClass(Map mapObj) {
    return SubscriptionPackageCartStruct(
        id: mapObj["id"], name: mapObj["name"], price: mapObj["price"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
    };
  }
}

class CartData {
  final List<PlaylistCartStruct> playlists;
  final List<SubscriptionPackageCartStruct> playlistSubscriptionPackages;

  CartData({
    playlistsParam,
    // required  this.playlistSubscriptionPackages,
    playlistSubscriptionPackagesParam,
  })  : playlists = playlistsParam ?? [],
        playlistSubscriptionPackages = playlistSubscriptionPackagesParam ?? [];

  static CartData mapToClass(Map mapObj) {
    print(mapObj);
    return CartData(
        playlistsParam: (mapObj["playlists"] as List<Map>)
            .map((e) => PlaylistCartStruct.mapToClass(e))
            .toList(),
        playlistSubscriptionPackagesParam:
            (mapObj["playlistSubscriptionPackages"] as List<Map>)
                .map((e) => PlaylistCartStruct.mapToClass(e))
                .toList());
  }

  Map<String, dynamic> toMap() {
    return {
      "playlists": playlists.map((e) => e.toMap()).toList(),
      "playlistSubscriptionPackages":
          playlistSubscriptionPackages.map((e) => e.toMap()).toList(),
    };
  }
}

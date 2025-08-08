class UserModel {
  final String uid;
  final String name;
  final String username;
  final String bio;
  final String email;
  final String imgUrl;
  final List<String> followers;
  final List<String> following;
  final List<String> posts;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.bio,
    required this.email,
    required this.imgUrl,
    required this.followers,
    required this.following,
    required this.posts,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map["name"] ?? "fun",
      bio: map["bio"] ?? "",
      username: map["username"] ?? "",
      email: map["email"] ?? "",
      imgUrl: map["imgUrl"] ?? "https://firebasestorage.googleapis.com/v0/b/imagigoai-5652c.firebasestorage.app/o/logo.png?alt=media&token=024118af-9231-4b6a-8e8e-4652e51b4924",
      followers: List<String>.from(map["followers"] ?? []),
      following: List<String>.from(map["following"] ?? []),
      posts: List<String>.from(map["posts"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "username": username,
      "bio": bio,
      "email": email,
      "imgUrl": imgUrl,
      "followers": followers,
      "following": following,
      "posts":posts
    };
  }

  UserModel copyWith({
    String? name,
    String? username,
    String? bio,
    String? email,
    String? imgUrl,
    List<String>? followers,
    List<String>? following,
    List<String>? posts,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      imgUrl: imgUrl ?? this.imgUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
    );
  }
}

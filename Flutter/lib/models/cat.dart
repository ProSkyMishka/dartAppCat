class Cat {
  final String imageUrl;
  final String breedName;
  final String breedDescription;

  Cat({
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    var breeds = json['breeds'];
    return Cat(
      imageUrl: json['url'] ?? '',
      breedName:
          (breeds != null && breeds.isNotEmpty)
              ? breeds[0]['name']
              : 'Неизвестная порода',
      breedDescription:
          (breeds != null && breeds.isNotEmpty)
              ? breeds[0]['description']
              : 'Описание отсутствует',
    );
  }
}

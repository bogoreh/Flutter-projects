class UserData {
  double height;
  double weight;
  int age;
  Gender gender;

  UserData({
    this.height = 170,
    this.weight = 70,
    this.age = 25,
    this.gender = Gender.male,
  });

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender.toString(),
    };
  }
}

enum Gender {
  male,
  female,
}
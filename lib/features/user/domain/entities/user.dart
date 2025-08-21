class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final DateTime birthdate;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.birthdate,
    this.avatarUrl,
  });


  int get age {
    final now = DateTime.now();
    int years = now.year - birthdate.year;
    final birthdayThisYear = DateTime(now.year, birthdate.month, birthdate.day);
    if (now.isBefore(birthdayThisYear)) {
      years--;
    }
    return years;
  }

  bool get isProfileComplete {
    return firstname.isNotEmpty &&
        lastname.isNotEmpty &&
        email.isNotEmpty ;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $firstname $lastname, age: $age)';
  }
}

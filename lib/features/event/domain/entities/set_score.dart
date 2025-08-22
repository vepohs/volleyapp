class SetScore {
  final int number ;
  final int homePoints;
  final int awayPoints;

  const SetScore({required this.homePoints, required this.awayPoints,required this.number});

  bool get homeWon => homePoints > awayPoints;
  bool get awayWon => awayPoints > homePoints;

}
class LaunchModel {
  final String mission;
  final String date;

  LaunchModel({required this.mission, required this.date});

  Map<String, dynamic> toJson() => {
        'mission': mission,
        'date': date,
      };
}

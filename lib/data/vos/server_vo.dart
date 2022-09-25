class ServerVO {
  int? id;
  String? countryName;
  String? flag;
  String? userName;
  String? password;
  String? config;
  bool? isSelected;

  ServerVO({
    required this.id,
    required this.countryName,
    required this.flag,
    required this.userName,
    required this.password,
    required this.config,
    required this.isSelected,
  });
}

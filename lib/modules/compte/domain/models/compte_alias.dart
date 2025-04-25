class CompteAlias {
  CompteAlias({
    required this.cle,
    required this.type,
    this.shid,
  });
  late String cle;
  late String type;
  String? shid;

  CompteAlias.fromJson(Map<dynamic, dynamic> json) {
    cle = json['cle'];
    type = json['type'];
    shid = json.containsKey('shid') ? json['shid'] : null;
  }

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['cle'] = cle;
    data['type'] = type;
    if (shid != null) data['shid'] = shid;
    return data;
  }
}

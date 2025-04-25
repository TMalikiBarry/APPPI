class QrcodeData {
  ///
  QrcodeData(this.alias, this.txId, this.montant, this.channel);

  final String alias;

  final String? txId;

  final double? montant;

  final String channel;

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'txId': txId,
      'montant': montant != null ? montant!.toDouble() : null,
      'channel': channel,
    };
  }
}

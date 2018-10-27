class WebblenReward {

  String rewardKey;
  String rewardProviderName;
  String rewardDescription;
  String rewardImagePath;
  double rewardLat;
  double rewardLon;
  double rewardCost;
  int amountAvailable;
  String expirationDate;
  String rewardUrl;
  String rewardCategory;

  WebblenReward({
    this.rewardKey,
    this.rewardProviderName,
    this.rewardDescription,
    this.rewardImagePath,
    this.rewardLat,
    this.rewardLon,
    this.rewardCost,
    this.amountAvailable,
    this.expirationDate,
    this.rewardUrl,
    this.rewardCategory
  });

  WebblenReward.fromMap(Map<String, dynamic> data)
      : this(rewardKey: data['rewardKey'],
      rewardProviderName: data['rewardProviderName'],
      rewardDescription: data['rewardDescription'],
      rewardImagePath: data['rewardImagePath'],
      rewardLat: data['rewardLat'],
      rewardLon: data['rewardLon'],
      rewardCost: data['rewardCost'],
      amountAvailable: data['amountAvailable'],
      expirationDate: data['expirationDate'],
      rewardUrl: data['rewardUrl'],
      rewardCategory: data['rewardCategory']
  );

  Map<String, dynamic> toMap() => {
    'rewardKey': this.rewardKey,
    'rewardProviderName': this.rewardProviderName,
    'rewardDescription': this.rewardDescription,
    'rewardImagePath': this.rewardImagePath,
    'rewardLat': this.rewardLat,
    'rewardLon': this.rewardLon,
    'rewardCost': this.rewardCost,
    'amountAvailable': this.amountAvailable,
    'expirationDate': this.expirationDate,
    'rewardUrl': this.rewardUrl,
    'rewardCategory': this.rewardCategory
  };
}
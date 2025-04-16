const databaseName = "bookmgr_database.db";

enum BookGenre {
  economy("経済"),
  religion("宗教"),
  it("IT"),
  social("社会"),
  politics("政治"),
  other("その他"),
  all("全て");

  const BookGenre(this.name);
  final String name;
}

enum Publisher {
  chikuma("ちくま新書"),
  chikumap("ちくまプリマー新書"),
  chikumag("ちくま学芸文庫"),
  hayakawab("早川文庫"),
  php("PHP新書"),
  asahi("朝日新著"),
  chuukou("中公新書"),
  koudangakubunn("講談社学術文庫"),
  koudangshinsho("講談社現代新書"),
  koudanshaplus("講談社+α新書"),
  bluebacks("ブルーバックス"),
  koubun("光文社新書"),
  shincho("新潮新書"),
  kawada("河出書房新社"),
  shuueisha("集英社新書"),
  iwanamigbunko("岩波現代文庫"),
  iwanamibunko("岩波文庫"),
  iwanamishinsho("岩波新書"),
  iwanamij("岩波ジュニア新書"),
  waseda("早稲田新書"),
  fusou("扶桑社新書"),
  gentousha("幻冬舎新書"),
  shodensha("祥伝社新書");

  const Publisher(this.name);
  final String name;
}

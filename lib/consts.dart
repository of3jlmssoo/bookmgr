import 'dart:collection';

import 'package:flutter/material.dart';

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

typedef PublisherEntry = DropdownMenuEntry<Publisher>;

enum Publisher {
  chikuma("ちくま新書", Icons.favorite),
  chikumap("ちくまプリマー新書", Icons.book),
  chikumag("ちくま学芸文庫", Icons.book),
  hayakawab("早川文庫", Icons.book),
  php("PHP新書", Icons.book),
  asahi("朝日新著", Icons.book),
  chuukou("中公新書", Icons.book),
  koudangakubunn("講談社学術文庫", Icons.book),
  koudangshinsho("講談社現代新書", Icons.book),
  koudanshaplus("講談社+α新書", Icons.book),
  bluebacks("ブルーバックス", Icons.book),
  koubun("光文社新書", Icons.book),
  shincho("新潮新書", Icons.book),
  kawada("河出書房新社", Icons.book),
  shuueisha("集英社新書", Icons.book),
  iwanamigbunko("岩波現代文庫", Icons.book),
  iwanamibunko("岩波文庫", Icons.book),
  iwanamishinsho("岩波新書", Icons.book),
  iwanamij("岩波ジュニア新書", Icons.book),
  waseda("早稲田新書", Icons.book),
  fusou("扶桑社新書", Icons.book),
  gentousha("幻冬舎新書", Icons.book),
  shodensha("祥伝社新書", Icons.book),
  other("その他", Icons.book),
  all("全て", Icons.book);

  const Publisher(this.name, this.icon);
  final String name;
  final IconData icon;
  static final List<PublisherEntry> entries = UnmodifiableListView<PublisherEntry>(
    values.map<PublisherEntry>((Publisher publisher) => PublisherEntry(value: publisher, label: publisher.name)),
  );
}

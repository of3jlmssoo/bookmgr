import 'dart:collection';

import 'package:flutter/material.dart';

const databaseName = "bookmgr_database.db";

typedef BookGenreEntry = DropdownMenuEntry<BookGenre>;

enum BookGenre {
  economy("経済", Icons.description),
  religion("宗教", Icons.description),
  it("IT", Icons.description),
  social("社会", Icons.description),
  philosophy("哲学思想", Icons.description),
  politics("政治", Icons.description),
  literature("文学", Icons.description),
  biz("ビジネス", Icons.description),
  language("言語", Icons.description),
  art("アート", Icons.description),
  hobby("趣味", Icons.description),
  science("科学", Icons.description),
  other("その他", Icons.description),
  all("全て", Icons.description);

  const BookGenre(this.name, this.icon);
  final String name;
  final IconData icon;
  static final List<BookGenreEntry> entries = UnmodifiableListView<BookGenreEntry>(
    values.map<BookGenreEntry>((BookGenre bookgenre) => BookGenreEntry(value: bookgenre, label: bookgenre.name)),
  );
}

typedef PublisherEntry = DropdownMenuEntry<Publisher>;

enum Publisher {
  chikuma("ちくま新書", Icons.favorite),
  chikumap("ちくまプリマー新書", Icons.book),
  chikumag("ちくま学芸文庫", Icons.book),
  hayakawab("早川文庫", Icons.book),
  php("PHP新書", Icons.book),
  asahi("朝日新書", Icons.book),
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

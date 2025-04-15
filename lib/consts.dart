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

import random
import re

genre = [
    'economy("経済", Icons.description)',
    'religion("宗教", Icons.description)',
    'it("IT", Icons.description)',
    'social("社会", Icons.description)',
    'politics("政治", Icons.description)',
    'other("その他", Icons.description)',
    'all("全て", Icons.description)',
]

publishers = [
    'chikuma("ちくま新書", Icons.favorite)',
    'chikumap("ちくまプリマー新書", Icons.book)',
    'chikumag("ちくま学芸文庫", Icons.book)',
    'hayakawab("早川文庫", Icons.book)',
    'php("PHP新書", Icons.book)',
    'asahi("朝日新著", Icons.book)',
    'chuukou("中公新書", Icons.book)',
    'koudangakubunn("講談社学術文庫", Icons.book)',
    'koudangshinsho("講談社現代新書", Icons.book)',
    'koudanshaplus("講談社+α新書", Icons.book)',
    'bluebacks("ブルーバックス", Icons.book)',
    'koubun("光文社新書", Icons.book)',
    'shincho("新潮新書", Icons.book)',
    'kawada("河出書房新社", Icons.book)',
    'shuueisha("集英社新書", Icons.book)',
    'iwanamigbunko("岩波現代文庫", Icons.book)',
    'iwanamibunko("岩波文庫", Icons.book)',
    'iwanamishinsho("岩波新書", Icons.book)',
    'iwanamij("岩波ジュニア新書", Icons.book)',
    'waseda("早稲田新書", Icons.book)',
    'fusou("扶桑社新書", Icons.book)',
    'gentousha("幻冬舎新書", Icons.book)',
    'shodensha("祥伝社新書", Icons.book)',
    'other("その他", Icons.book)',
    'all("全て", Icons.book)',
]

plist = []
for p in publishers:
    pOnly = re.findall(r"\".+\"", p)[0].replace('"', "'")
    # print(f"{pOnly}")
    plist.append(pOnly)


# print(plist)
i = 0
l = 0
for g in genre:
    # print(f"{plist[random.randint(0, len(plist) - 1)]}")

    gOnly = re.findall(r"\".+\"", g)[0].replace('"', "'")
    print(
        f"await txn.insert('bookmgr_tbl',{{'purchased': 0, 'date': '2025-04-14', 'title': 'タイトル{i}', 'author': '著者{i}', 'publisher': {plist[random.randint(0, len(plist) - 2)]}, 'genre':  {gOnly}, 'memo': 'コメント{i}', }});"
    )
    i = i + 1
    l = i
# await txn.insert('bookmgr_tbl', { 'purchased': 0, 'date': '2025-04-14', 'title': 'タイトル1', 'author': '著者1', 'publisher': '中公新書', 'genre': '経済', 'memo': 'コメント1', });

print("")

glist = []
for g in genre:
    gOnly = re.findall(r"\".+\"", g)[0].replace('"', "'")
    # print(f"{pOnly}")
    glist.append(gOnly)


# print(f"{glist}")
# print("---")

for p in plist:
    print(
        f"await txn.insert('bookmgr_tbl',{{'purchased': 0, 'date': '2025-04-14', 'title': 'タイトル{i}', 'author': '著者{i}', 'publisher': {p}, 'genre':  {glist[random.randint(0, len(glist) - 2)]}, 'memo': 'コメント{i}', }});"
    )
    i = i + 1
    if i == 27:
        i = 0

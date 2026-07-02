import '../models/spice_route.dart';

/// Heritage copy for cuisines added after the original React port.
Map<String, String> _l(String en, String zh, String ja, String ko, String vi) =>
    {'en': en, 'zh': zh, 'ja': ja, 'ko': ko, 'vi': vi};

Map<Cuisine, Map<Course, Map<String, String>>> crossCulturalStoriesExpansion = {
  // ─────────────────────────────────────────────────────────────────────
  // Cambodian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.cambodian: {
    Course.breakfast: _l(
      'Mornings start with borbor rice porridge topped with ginger, preserved radish, and pork, or nom banh chok with coconut fish curry.',
      '柬式清晨常是一碗撒着姜丝、萝卜干与猪肉的米粥，或椰香鱼咖喱拌米粉。',
      '朝は生姜と大根漬け、豚肉のトッピング粥ボルボル、またはココナッツ魚カレーのヌオムバンチョク。',
      '아침은 생강, 무장아찌, 돼지고기를 올린 죽이나 코코넛 생선 카레 쌀국수로 시작합니다.',
      'Buổi sáng thường là cháo borbor với gừng, củ cải muối và thịt heo, hoặc bún nước lèo cà ri cá dừa.',
    ),
    Course.lunch: _l(
      'Lunch centers on amok trei fish steamed in banana leaf, lok lak pepper beef over rice, and broken-rice plates with grilled pork.',
      '午餐离不开香蕉叶蒸鱼阿莫、胡椒牛肉饭，以及配烤猪肉的碎米饭。',
      '昼はバナナの葉のアモック、ロクロック牛肉、豚の炭火焼きコンブレック定食。',
      '점심은 바나나 잎 찜 생선 아목, 후추 소고기 록락, 구운 돼지 고슬밥이 중심입니다.',
      'Bữa trưa quanh cá hấp lá chuối amok, bò lok lak và cơm tấm sườn nướng.',
    ),
    Course.appetizer: _l(
      'Starters include fresh spring rolls with herbs, fried spring rolls, and green mango salad tossed with peanuts and dried shrimp.',
      '前菜有香草春卷、炸春卷，以及花生虾米拌青芒果沙拉。',
      '前菜は生春巻き、揚げ春巻き、青マンゴーのピーナッツエビ和え。',
      '전채는 허브 생춘권, 튀긴 춘권, 땅콩과 건새우 망고 샐러드입니다.',
      'Khai vị gồm gỏi cuốn, chả giò và gỏi xoài xanh đậu phộng tôm khô.',
    ),
    Course.sideDish: _l(
      'Sides feature trey chha kroeung stir-fries, pickled vegetables, and samlor machu sour soups to balance rich mains.',
      '配菜有香料炒鱼、泡菜与酸汤，用来平衡主菜的浓郁。',
      '副菜はクルン炒め、漬物、酸っぱいサムロー汁で主菜を整えます。',
      '반찬은 크루엉 볶음, 장아찌, 새콤한 삼로 수프로 짠 메인을 받칩니다.',
      'Món phụ gồm cá xào kroeung, dưa chua và canh chua cân bằng món chính.',
    ),
    Course.dessert: _l(
      'Sweets lean on num ansom chek sticky rice cakes with banana, pumpkin custard, and palm-sugar coconut puddings.',
      '甜点常见香蕉糯米糕、南瓜布丁与棕榈糖椰奶布丁。',
      '甘味はバナナのもち米、カボチャプリン、ヤシ糖ココナッツプリン。',
      '디저트는 바나나 찹쌀떡, 호박 푸딩, 야자당 코코넛 푸딩이 대표적입니다.',
      'Tráng miệng có bánh chưng chuối, bánh flan bí và pudding dừa đường thốt nốt.',
    ),
    Course.snack: _l(
      'Street snacks mean grilled skewered meats, fried taro rolls, and iced coffee with sweet condensed milk.',
      '街头小吃有烤肉串、炸芋头卷，以及加炼乳的冰咖啡。',
      '屋台は串焼き、タロイモ揚げ、練乳入りアイスコーヒー。',
      '길거리 간식은 꼬치 구이, 튀긴 토란 롤, 연유 아이스 커피입니다.',
      'Ăn vặt đường phố gồm thịt xiên nướng, cuốn khoai môn chiên và cà phê đá sữa đặc.',
    ),
    Course.drinks: _l(
      'Drinks span jasmine tea, sugar-cane juice, fresh coconut water, and tuk-a-loc shakes with durian or avocado.',
      '饮品从茉莉花茶、甘蔗汁、鲜椰青，到榴莲或牛油果冰沙。',
      '飲み物はジャスミン茶、サトウキビジュース、若いココナッツ、ドリアンやアボカドシェイク。',
      '음료는 자스민 차, 사탕수수 주스, 어린 코코넛, 두리안·아보카도 쉐이크입니다.',
      'Đồ uống gồm trà nhài, nước mía, nước dừa tươi và sinh tố sầu riêng hoặc bơ.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Filipino
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.filipino: {
    Course.breakfast: _l(
      'Filipino breakfasts pair garlic fried rice (sinangag) with tocino, longganisa, or sunny eggs and vinegar-dipped tomatoes.',
      '菲式早餐常是蒜香炒饭配甜腌肉、香肠或煎蛋与醋渍番茄。',
      '朝はシナガガーリックライスにトシーノ、ロンガニサ、目玉焼きと酢トマト。',
      '아침은 마늘 볶음밥에 토시노, 롱가니사, 계란 프라이와 식초 토마토를 곁들입니다.',
      'Sáng có cơm chiên tỏi với tocino, longganisa, trứng và cà chua chấm giấm.',
    ),
    Course.lunch: _l(
      'Lunch might be adobo chicken braised in soy-vinegar, sinigang sour tamarind soup, or a loaded silog plate with beef tapa.',
      '午餐可能是酱油醋炖鸡阿多波、罗望子酸汤，或配牛肉塔帕的西式饭盘。',
      '昼はアドボ、タマリンドのシニガン、ビーフタパのシログプレート。',
      '점심은 아도보, 타마린드 신니강, 비프 타파 실로그 플레이트가 흔합니다.',
      'Trưa có adobo gà, canh chua me sinigang hoặc silog thịt bò tapa.',
    ),
    Course.appetizer: _l(
      'Starters include lumpia fresh or fried, tokwa\'t baboy tofu-pork bites, and kinilaw raw fish cured in calamansi.',
      '前菜有生鲜或炸春卷、豆腐猪肉小菜，以及青柠腌渍生鱼。',
      '前菜はルンピア、トクワットバボイ、カラマンシーのキニラウ。',
      '전채는 룸피아, 두부 돼지고기, 칼라만시 키닐라우 생선입니다.',
      'Khai vị gồm lumpia, tokwa\'t baboy và cá sống ngâm calamansi.',
    ),
    Course.sideDish: _l(
      'Sides bring atchara pickled papaya, ginisang monggo mung-bean stew, and blanched kangkong with bagoong shrimp paste.',
      '配菜有腌木瓜、绿豆羹，以及虾酱烫空心菜。',
      '副菜はアチャラ、モングビーン煮、バゴーンのカンコン。',
      '반찬은 파파야 장아찌, 녹두찌개, 바군 캉콩 나물입니다.',
      'Món phụ gồm atchara đu đủ, cháo đậu xanh và rau muống luộc mắm bagoong.',
    ),
    Course.dessert: _l(
      'Sweets celebrate leche flan, bibingka rice cakes, halo-halo shaved ice, and ube halaya purple-yam jam.',
      '甜点有焦糖布丁、米糕、哈罗哈罗刨冰与紫薯酱。',
      '甘味はレチェフラン、ビビンカ、ハロハロ、ウベハラヤ。',
      '디저트는 레체 플랑, 비빙카, 할로할로, 우베 할라야입니다.',
      'Tráng miệng gồm leche flan, bibingka, halo-halo và khoai môn tím ube.',
    ),
    Course.snack: _l(
      'Merienda time means fish balls on sticks, banana cue caramelized plantains, and hot pandesal rolls with cheese.',
      '下午茶点有鱼丸串、焦糖香蕉与热奶酪面包。',
      'おやつは魚団子串、バナナキュー、温かいパンデサル。',
      '간식은 어묵 꼬치, 바나나 큐, 따뜻한 판데살 치즈빵입니다.',
      'Merienda có xiên cá viên, chuối sáp caramel và bánh pandesal phô mai.',
    ),
    Course.drinks: _l(
      'Drinks range from salabat ginger tea and calamansi juice to strong barako coffee and sweet sago gulaman coolers.',
      '饮品从姜茶、青柠汁到浓烈巴拉科咖啡与仙草西米冷饮。',
      '飲み物はショウガ茶、カラマンシー、バラココーヒー、サゴグラマン。',
      '음료는 생강 차, 칼라만시, 바라코 커피, 사고 굴라만 음료입니다.',
      'Đồ uống gồm trà gừng salabat, nước calamansi, cà phê barako và sương sáo sago.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Indonesian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.indonesian: {
    Course.breakfast: _l(
      'Breakfast often means nasi uduk coconut rice with fried shallots, tempeh, and sambal, or bubur ayam chicken congee.',
      '早餐常见椰浆饭配炸葱、天贝与叁巴，或鸡肉粥。',
      '朝はココナッツライスのナシウドゥック、テンペ、サンバル、または鶏粥。',
      '아침은 코코넛 나시 우둑, 템페, 삼발, 또는 닭 죽이 흔합니다.',
      'Sáng thường là nasi uduk dừa với tempeh sambal hoặc cháo gà bubur ayam.',
    ),
    Course.lunch: _l(
      'Lunch is built around nasi campur mixed rice, beef rendang simmered in coconut, or gado-gado salad with peanut sauce.',
      '午餐以什锦饭、椰浆炖牛肉仁当或花生酱沙拉为核心。',
      '昼はナシチャンプル、レンダン、ガドガドのピーナッツソース。',
      '점심은 나시 참푸르, 렌당, 땅콩 소스 가도가도가 중심입니다.',
      'Trưa quanh nasi campur, rendang bò và gado-gado sốt đậu phộng.',
    ),
    Course.appetizer: _l(
      'Starters include satay skewers with peanut sauce, perkedel potato fritters, and crispy tempeh mendoan fritters.',
      '前菜有花生酱沙爹、土豆饼与脆炸天贝。',
      '前菜はサテ、ペルケデル、メンドアンテンペ。',
      '전채는 땅콩 사테, 페르케델, 튀긴 템페 멘도안입니다.',
      'Khai vị gồm satay sốt lạc, perkedel khoai và tempeh mendoan chiên.',
    ),
    Course.sideDish: _l(
      'Sides showcase urap blanched vegetables with coconut, acar pickles, and sambal matah raw chili relish.',
      '配菜有椰丝拌烫菜、腌菜与生辣椒叁巴。',
      '副菜はウラップ、ピクルス、アチャル、サンバルマタ。',
      '반찬은 코코넛 나물 우랍, 아차르, 생고추 삼발 마타입니다.',
      'Món phụ gồm urap dừa, acar chua và sambal matah tươi.',
    ),
    Course.dessert: _l(
      'Sweets span klepon palm-sugar rice balls, es cendol iced coconut with green jelly, and layered lapis legit spice cake.',
      '甜点有棕榈糖糯米球、椰奶绿豆凉粉与千层香料蛋糕。',
      '甘味はクレポン、エスチェンドル、ラピスレギット。',
      '디저트는 클레폰, 에스 첸돌, 라피스 레깃 케이크입니다.',
      'Tráng miệng gồm klepon, es cendol và bánh lapis legit.',
    ),
    Course.snack: _l(
      'Street snacks mean martabak stuffed pancakes, pisang goreng fried bananas, and bakso meatball soup cups.',
      '街头小吃有马丁巴克煎饼、炸香蕉与肉丸汤。',
      '屋台はマルタバク、ピサンゴレン、バクソ。',
      '길거리 간식은 마르타박, 튀긴 바나나, 바크소 국물입니다.',
      'Ăn vặt gồm martabak, chuối chiên pisang goreng và bakso.',
    ),
    Course.drinks: _l(
      'Drinks feature jamu herbal tonics, es teh manis sweet iced tea, and young-coconut es kelapa muda.',
      '饮品有草药汁、甜冰茶与嫩椰冰饮。',
      '飲み物はジャム、マニスアイスティー、若いココナッツ。',
      '음료는 자무 한방 음료, 달콤한 아이스 티, 어린 코코넛 음료입니다.',
      'Đồ uống gồm jamu thảo mộc, trà đá ngọt và nước dừa non es kelapa.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Malaysian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.malaysian: {
    Course.breakfast: _l(
      'Mornings favor nasi lemak coconut rice with sambal, anchovies, peanuts, and boiled egg, or roti canai with dal.',
      '清晨偏爱椰浆饭配叁巴、小鱼干、花生与水煮蛋，或印度煎饼配豆糊。',
      '朝はナシレマック、イカンビリス、ピーナッツ、卵、またはロティチャナイとダール。',
      '아침은 나시 레막, 멸치, 땅콩, 삶은 달걀, 또는 로티 차나이와 달입니다.',
      'Sáng ưa nasi lemak với sambal, cá cơm, đậu phộng, trứng và roti canai kèm dal.',
    ),
    Course.lunch: _l(
      'Lunch might be char kway teow wok noodles, laksa curry noodles, or a banana-leaf rice spread with curries and pickles.',
      '午餐可能是炒粿条、叻沙咖喱面，或芭蕉叶上的咖喱饭。',
      '昼はチャークイティアウ、ラクサ、バナナの葉のカレーライス。',
      '점심은 차 콰이티아우, 락사, 바나나 잎 카레 밥이 대표적입니다.',
      'Trưa có char kway teow, laksa hoặc cơm lá chuối với cà ri.',
    ),
    Course.appetizer: _l(
      'Starters include satay with peanut sauce, popiah fresh spring rolls, and acar awak pickled vegetables.',
      '前菜有沙爹、润饼与生腌蔬菜。',
      '前菜はサテ、ポピア、アチャール。',
      '전채는 사테, 포피아 생춘권, 아차르 절임 채소입니다.',
      'Khai vị gồm satay, popiah cuốn tươi và acar awak.',
    ),
    Course.sideDish: _l(
      'Sides bring kangkung belacan stir-fried water spinach, sambal eggplant, and cooling cucumber kerabu salads.',
      '配菜有虾酱空心菜、叁巴茄子与青瓜沙拉。',
      '副菜はカンクンベラカン、サンバルナス、キュウリケラブ。',
      '반찬은 벨라칸 캉콩 볶음, 가지 삼발, 오이 케라부 샐러드입니다.',
      'Món phụ gồm rau muống belacan, cà tím sambal và kerabu dưa leo.',
    ),
    Course.dessert: _l(
      'Sweets include onde-onde palm-sugar balls, cendol iced coconut dessert, and kuih lapis rainbow layer cakes.',
      '甜点有棕榈糖球、煎蕊冰与彩虹千层糕。',
      '甘味はオンデオンデ、チェンドル、クイラピス。',
      '디저트는 온데온데, 첸돌, 쿠이 라피스 케이크입니다.',
      'Tráng miệng gồm onde-onde, cendol và bánh kuih lapis.',
    ),
    Course.snack: _l(
      'Night markets serve satay, apam balik peanut pancakes, and curry puffs filled with spiced potatoes.',
      '夜市有沙爹、花生煎饼与咖喱土豆角。',
      '夜市はサテ、アパムバリック、カレーパフ。',
      '야시장은 사테, 아팜 발릭, 카레 퍼프가 인기입니다.',
      'Chợ đêm có satay, apam balik và bánh gói cà ri khoai.',
    ),
    Course.drinks: _l(
      'Drinks span teh tarik pulled milk tea, bandung rose syrup milk, and fresh sugar-cane or coconut juice.',
      '饮品有拉茶、玫瑰糖浆奶与甘蔗或椰汁。',
      '飲み物はテータリック、バンドン、サトウキビやココナッツジュース。',
      '음료는 뜯은 밀크티 테 타릭, 반둥, 사탕수수·코코넛 주스입니다.',
      'Đồ uống gồm teh tarik, bandung sữa hoa hồng và nước mía hoặc dừa.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Pakistani
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.pakistani: {
    Course.breakfast: _l(
      'Breakfasts feature halwa puri with chickpea curry, anda paratha egg-stuffed flatbread, or nihari slow-cooked beef stew.',
      '早餐有甜糕配油炸饼与鹰嘴豆咖喱、鸡蛋夹心烤饼，或慢炖牛肉尼哈里。',
      '朝はハルワプリ、チャナ、エッグパラタ、ニハリの牛肉シチュー。',
      '아침은 할와 푸리, 차나, 달걀 파라타, 니하리 소고기 스튜가 흔합니다.',
      'Sáng có halwa puri, chana, paratha trứng và nihari bò hầm.',
    ),
    Course.lunch: _l(
      'Lunch stars biryani layered rice, karahi wok-cooked meats, and dal chawal lentils over basmati rice.',
      '午餐主打层叠香料饭、铁锅肉菜与扁豆饭。',
      '昼はビリヤニ、カラヒ、ダールチャウル。',
      '점심은 비리야니, 카라히 볶음, 달 차왈이 중심입니다.',
      'Trưa nổi bật biryani, karahi và dal chawal.',
    ),
    Course.appetizer: _l(
      'Starters include samosas, pakoras vegetable fritters, and dahi baray lentil dumplings in yogurt.',
      '前菜有萨摩萨、蔬菜炸饼与酸奶扁豆球。',
      '前菜はサモosa、パコラ、ダヒバラ。',
      '전채는 사모사, 파코라, 다히 바라이입니다.',
      'Khai vị gồm samosa, pakora và dahi baray.',
    ),
    Course.sideDish: _l(
      'Sides bring raita cooling yogurt, saag spinach, and fresh naan or roti to scoop curries.',
      '配菜有酸奶酱、菠菜泥与现烤馕饼。',
      '副菜はライタ、サーグ、ナンやロティ。',
      '반찬은 라이타, 사그 시금치, 난·로티입니다.',
      'Món phụ gồm raita, saag và naan/roti.',
    ),
    Course.dessert: _l(
      'Sweets celebrate gulab jamun milk dumplings, kheer rice pudding, and falooda rose-milk vermicelli drinks.',
      '甜点有奶球、米布丁与玫瑰奶露粉条饮。',
      '甘味はグラブジャムン、キール、ファルーダ。',
      '디저트는 굴랍 자문, 키르, 팔루다입니다.',
      'Tráng miệng gồm gulab jamun, kheer và falooda.',
    ),
    Course.snack: _l(
      'Street snacks mean chaat tangy plates, bun kebab sliders, and grilled seekh kebab rolls.',
      '街头小吃有酸辣小吃盘、烤肉汉堡与烤羊肉串卷。',
      '屋台はチャート、ブンケバブ、シークカバブ。',
      '길거리 간식은 차트, 분 케밥, 씨크 카밥 롤입니다.',
      'Ăn vặt gồm chaat, bun kebab và seekh kebab.',
    ),
    Course.drinks: _l(
      'Drinks include doodh patti milky tea, lassi yogurt shakes, and refreshing nimbu pani limeade.',
      '饮品有奶茶、酸奶昔与青柠汽水。',
      '飲み物はドゥードパティ、ラッシー、ニンブパニ。',
      '음료는 두드 파티 차, 라시, 님부 파니 라임에이드입니다.',
      'Đồ uống gồm trà sữa doodh patti, lassi và nimbu pani.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Sri Lankan
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.sriLankan: {
    Course.breakfast: _l(
      'Mornings mean string hoppers with coconut sambol, pol roti flatbread, or kiribath milk rice with lunu miris chili paste.',
      '清晨常吃米粉饼配椰丝酱、椰子烤饼或奶米饭配辣椒酱。',
      '朝はストリングホッパー、ポルロティ、キリバスとルヌミリス。',
      '아침은 스트링 호퍼, 폴 로티, 키리바트 밀크 라이스와 칠리 페이스트입니다.',
      'Sáng có string hoppers, pol roti hoặc kiribath với lunu miris.',
    ),
    Course.lunch: _l(
      'Lunch is rice and curry spreads: fish ambul thiyal sour black-pepper stew, dhal, and mallung shredded greens.',
      '午餐是米饭咖喱宴：酸胡椒炖鱼、扁豆与切碎青菜。',
      '昼はライスカレー、アンブルティヤル、ダール、マルン。',
      '점심은 밥과 암불 티얄 생선, 달, 말룽 채소입니다.',
      'Trưa là cơm cà ri: ambul thiyal, dhal và mallung.',
    ),
    Course.appetizer: _l(
      'Starters include fish cutlets, wade crispy lentil fritters, and tempered chickpeas with mustard seeds.',
      '前菜有鱼饼、扁豆脆饼与香料鹰嘴豆。',
      '前菜はフィッシュカトレット、ワデ、テンパードチャナ。',
      '전채는 생선 커틀릿, 와데, 병아리콘 템퍼링입니다.',
      'Khai vị gồm cutlet cá, wade và đậu garbanzo temper.',
    ),
    Course.sideDish: _l(
      'Sides showcase gotu kola sambol, caramelized onion seeni sambol, and brinjal moju sweet-sour eggplant.',
      '配菜有积雪草沙拉、焦糖洋葱酱与酸甜茄子。',
      '副菜はゴトゥコラ、シーニサンボル、モジュナス。',
      '반찬은 고투 콜라, 시니 삼볼, 가지 모주입니다.',
      'Món phụ gồm gotu kola sambol, seeni sambol và moju cà tím.',
    ),
    Course.dessert: _l(
      'Sweets favor wattalapam spiced coconut custard, kavum oil cakes, and jaggery-sweetened buffalo curd with treacle.',
      '甜点有香料椰奶布丁、油炸糕与棕榈糖酸奶。',
      '甘味はワッタラパム、カヴム、キトゥルパニ。',
      '디저트는 와탈라팜, 카붐, 야자당 요구르트입니다.',
      'Tráng miệng gồm wattalapam, kavum và sữa chua kitul.',
    ),
    Course.snack: _l(
      'Tea-time snacks include fish buns, roti wraps with curry, and spicy short eats from bakery cases.',
      '下午茶点有鱼包、咖喱烤饼卷与香辣小点。',
      'おやつはフィッシュバン、カレーロティ、スナック。',
      '차 시간 간식은 생선 번, 카레 로티, 매운 베이커리 스낵입니다.',
      'Merienda có bánh cá, roti cuốn cà ri và bánh snack cay.',
    ),
    Course.drinks: _l(
      'Drinks revolve around Ceylon black tea with milk, king coconut water, and faluda rose-milk coolers.',
      '饮品以锡兰奶茶、王椰青与玫瑰奶饮为主。',
      '飲み物はセイロンティー、キングココナッツ、ファルーダ。',
      '음료는 실론 밀크티, 킹 코코넛, 팔루다입니다.',
      'Đồ uống gồm trà Ceylon sữa, nước dừa king và faluda.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // British
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.british: {
    Course.breakfast: _l(
      'The full English stacks eggs, bacon, sausages, grilled tomatoes, mushrooms, and buttered toast with tea.',
      '全英式早餐叠煎蛋、培根、香肠、烤番茄、蘑菇与黄油吐司配茶。',
      'フルイングリッシュは卵、ベーコン、ソーセージ、トマト、マッシュルーム、トーストと紅茶。',
      '풀 잉글리시 브렉퍼스트는 계란, 베이컨, 소시지, 토마토, 버섯, 토스트와 차입니다.',
      'Full English gồm trứng, thịt xông khói, xúc xích, cà chua nướng, nấm và bánh mì bơ.',
    ),
    Course.lunch: _l(
      'Lunch might be fish and chips by the sea, a ploughman\'s cheese-and-pickle plate, or a hearty cottage pie.',
      '午餐可能是海边炸鱼薯条、奶酪腌菜拼盘或牧羊人派。',
      '昼はフィッシュアンドチップス、プラウマンズランチ、コテージパイ。',
      '점심은 피시 앤 칩스, 플라우맨스 플래터, 코티지 파이가 흔합니다.',
      'Trưa có fish and chips, ploughman\'s hoặc cottage pie.',
    ),
    Course.appetizer: _l(
      'Starters include prawn cocktail, Scotch eggs, and smoked salmon with brown bread and lemon.',
      '前菜有虾仁鸡尾酒、苏格兰蛋与烟熏三文鱼。',
      '前菜はプリーンカクテル、スコッチエッグ、スモークサーモン。',
      '전채는 새우 칵테일, 스코치 에그, 훈제 연어입니다.',
      'Khai vị gồm cocktail tôm, trứng Scotch và cá hồi hun khói.',
    ),
    Course.sideDish: _l(
      'Sides mean mushy peas, roast potatoes, minted peas, and Yorkshire puddings to catch gravy.',
      '配菜有豌豆泥、烤土豆、薄荷豌豆与约克郡布丁。',
      '副菜はマッシュピー、ローストポテト、ヨークシャープディング。',
      '반찬은 머시 피, 로스트 포테이토, 요크셔 푸딩입니다.',
      'Món phụ gồm đậu nghiền, khoai nướng và Yorkshire pudding.',
    ),
    Course.dessert: _l(
      'Puddings span sticky toffee, spotted dick, Eton mess berries with cream, and warm apple crumble.',
      '甜点有太妃糖布丁、葡萄干布丁、伊顿麦斯与苹果酥。',
      '甘味はスティッキートフィー、スポッテッドディック、イートンメス、アップルクランブル。',
      '디저트는 스티키 토피, 스포티드 딕, 이튼 메스, 애플 크럼블입니다.',
      'Tráng miệng gồm sticky toffee, spotted dick, Eton mess và crumble táo.',
    ),
    Course.snack: _l(
      'Afternoon tea brings scones with clotted cream and jam, sausage rolls, and finger sandwiches.',
      '下午茶有司康配凝脂奶油、香肠卷与手指三明治。',
      'アフタヌーンティーはスコーン、クロテッドクリーム、ソーセージロール。',
      '애프터눈 티는 스콘, 클로티드 크림, 소시지 롤, 핑거 샌드위치입니다.',
      'Trà chiều có scone kem clotted, sausage roll và sandwich nhỏ.',
    ),
    Course.drinks: _l(
      'Drinks mean builder\'s tea, pint bitters at the pub, Pimm\'s cups in summer, and hot toddies in winter.',
      '饮品有浓茶、酒吧苦啤、夏日皮姆士与冬日热托迪。',
      '飲み物は紅茶、ビター、ピムス、ホットトディ。',
      '음료는 건설工 차, 펍 비터, 핌스, 핫 토디입니다.',
      'Đồ uống gồm trà đặc, bitter, Pimm\'s và hot toddy.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // German
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.german: {
    Course.breakfast: _l(
      'German breakfasts layer dark bread, cold cuts, cheeses, soft-boiled eggs, and mustard with strong coffee.',
      '德式早餐叠黑面包、冷切肉、奶酪、溏心蛋与芥末配浓咖啡。',
      '朝は黒パン、ハム、チーズ、半熟卵、マスタードとコーヒー。',
      '아침은 흑빵, 콜드컷, 치즈, 반숙 달걀, 겨자와 진한 커피입니다.',
      'Sáng có bánh mì đen, giăm bông, phô mai, trứng lòng đào và cà phê đậm.',
    ),
    Course.lunch: _l(
      'Lunch stars schnitzel with potato salad, bratwurst with sauerkraut, or käsespätzle cheese noodles.',
      '午餐主打炸肉排配土豆沙拉、酸菜香肠或奶酪面。',
      '昼はシュニッツル、ブラートヴルストとザワークラウト、ケーゼシュペッツレ。',
      '점심은 슈니첼, 브라트부르스트와 자우어크라우트, 치즈 슈페츨레입니다.',
      'Trưa có schnitzel, bratwurst kraut hoặc käsespätzle.',
    ),
    Course.appetizer: _l(
      'Starters include obatzda cheese spread, pretzel bites with obatzda, and liverwurst on rye.',
      '前菜有奶酪酱、椒盐脆饼配酱与黑麦肝肠。',
      '前菜はオバツダ、プレッツェル、レバーウルスト。',
      '전채는 오바츠다 치즈, 프레첼, 호밀빵 리버부르스트입니다.',
      'Khai vị gồm obatzda, pretzel và liverwurst trên lúa mạch đen.',
    ),
    Course.sideDish: _l(
      'Sides mean braised red cabbage, buttered spätzle, and tangy sauerkraut simmered with caraway.',
      '配菜有炖红卷心菜、黄油面疙瘩与茴香籽酸菜。',
      '副菜はロトコール、シュペッツレ、キャラウェイのザワークラウト。',
      '반찬은 적양배추 조림, 버터 슈페츨레, 커민 자우어크라우트입니다.',
      'Món phụ gồm bắp cải đỏ hầm, spätzle bơ và kraut caraway.',
    ),
    Course.dessert: _l(
      'Sweets celebrate Black Forest cake, apple strudel, and warm dampfnudel yeast dumplings with vanilla sauce.',
      '甜点有黑森林蛋糕、苹果卷与香草酱酵母球。',
      '甘味はシュワルツヴァルダー、リンゼンシュトルーデル、ダンプフヌーデル。',
      '디저트는 블랙 포레스트, 사과 슈트루델, 담프누델입니다.',
      'Tráng miệng gồm bánh Black Forest, strudel táo và dampfnudel.',
    ),
    Course.snack: _l(
      'Biergarten snacks include giant pretzels, currywurst with fries, and flammkuchen flatbread.',
      '啤酒花园小吃有巨型椒盐脆饼、咖喱香肠薯条与火焰薄饼。',
      'ビアガーデンはプレッツェル、カリーヴルスト、フラムクーヘン。',
      '비어가르텐 간식은 대형 프레첼, 커리부르스트, 플람쿠헨입니다.',
      'Ăn vặt biergarten gồm pretzel khổng lồ, currywurst và flammkuchen.',
    ),
    Course.drinks: _l(
      'Drinks feature helles and weissbier lagers, Apfelwein cider, and coffee with kirsch schnapps on cold days.',
      '饮品有拉格与小麦啤酒、苹果酒，以及冬日咖啡配樱桃酒。',
      '飲み物はヘレス、ヴァイツビア、アプフェルヴァイン、キルシュ。',
      '음료는 헬레스·바이스비어, 사과 와인, 키르슈 슈냅스 커피입니다.',
      'Đồ uống gồm helles, weissbier, Apfelwein và cà phê kirsch.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Greek
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.greek: {
    Course.breakfast: _l(
      'Greek mornings favor thick yogurt with thyme honey and walnuts, tiropita cheese pie, or koulouri sesame bread rings.',
      '希式清晨偏爱浓稠酸奶配蜂蜜核桃、奶酪派或芝麻面包圈。',
      '朝はギリシャヨーグルトと蜂蜜、ティロピタ、クルリ。',
      '아침은 그릭 요거트·꿀·호두, 티로피타, 참깨 쿨루리 빵입니다.',
      'Sáng có sữa chua Hy Lạp mật ong, tiropita và koulouri vừng.',
    ),
    Course.lunch: _l(
      'Lunch might be moussaka layered bake, souvlaki wraps, or horiatiki village salad with feta and olives.',
      '午餐可能是千层慕萨卡、烤肉卷或乡村沙拉配羊奶酪。',
      '昼はムサカ、スブラキ、ホリアティキサラダ。',
      '점심은 무사카, 수블라키, 페타 올리브 호리아티키 샐러드입니다.',
      'Trưa có moussaka, souvlaki hoặc salad horiatiki feta.',
    ),
    Course.appetizer: _l(
      'Meze spreads include tzatziki, taramasalata, dolmades grape leaves, and grilled octopus with lemon.',
      '前菜拼盘有酸奶黄瓜酱、鱼子酱、葡萄叶卷与烤章鱼。',
      'メゼはツァジキ、タラマサラタ、ドルマデス、焼きタコ。',
      '메제는 차지키, 타라마살라타, 돌마데스, 레몬 문어 구이입니다.',
      'Meze gồm tzatziki, taramasalata, dolmades và bạch tuộc nướng.',
    ),
    Course.sideDish: _l(
      'Sides bring lemon potatoes, gigantes giant beans in tomato, and horta greens dressed with olive oil.',
      '配菜有柠檬土豆、番茄焗豆与橄榄油拌野菜。',
      '副菜はレモンポテト、ギガンテス、オリーブオイルのホルタ。',
      '반찬은 레몬 감자, 토마토 콩, 올리브오일 허브 채소입니다.',
      'Món phụ gồm khoai sốt chanh, gigantes và horta dầu ô liu.',
    ),
    Course.dessert: _l(
      'Sweets include baklava honey pastry, galaktoboureko custard pie, and loukoumades honey doughnuts.',
      '甜点有蜜糖酥皮、奶黄派与蜂蜜甜甜圈。',
      '甘味はバクラヴァ、ガラクトボウレコ、ルクマデス。',
      '디저트는 바클라바, 갈락토보레코, 루쿠마데스입니다.',
      'Tráng miệng gồm baklava, galaktoboureko và loukoumades.',
    ),
    Course.snack: _l(
      'Street snacks mean spanakopita spinach pie, tyropita cheese triangles, and grilled corn with sea salt.',
      '街头小吃有菠菜派、奶酪三角与海盐烤玉米。',
      '屋台はスパナコピタ、ティロピタ、塩コショウの焼きトウモロコシ。',
      '길거리 간식은 스파나코피타, 티로피타, 소금 옥수수 구이입니다.',
      'Ăn vặt gồm spanakopita, tyropita và ngô nướng muối biển.',
    ),
    Course.drinks: _l(
      'Drinks span frappé iced coffee, retsina wine, ouzo with meze, and mountain herbal teas.',
      '饮品有冰咖啡、树脂酒、茴香酒配小食与山野草本茶。',
      '飲み物はフラッペ、レツィナ、ウーゾ、ハーブティー。',
      '음료는 프라페, 레치나, 우조, 산허브 차입니다.',
      'Đồ uống gồm frappé, retsina, ouzo và trà thảo mộc.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Portuguese
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.portuguese: {
    Course.breakfast: _l(
      'Breakfast is espresso with pastel de nata custard tart, broa cornbread, and fresh cheese with quince jam.',
      '早餐是浓缩咖啡配蛋挞、玉米面包与新鲜奶酪榅桲酱。',
      '朝はエスプレッソ、パステルデナタ、ブロア、チーズとマルメロ。',
      '아침은 에스프레소, 나타 타르트, 브로아, 치즈와 모과 잼입니다.',
      'Sáng có espresso, pastel de nata, broa và phô mai mứt mơ.',
    ),
    Course.lunch: _l(
      'Lunch stars caldo verde kale soup with chouriço, bacalhau salt-cod dishes, or grilled sardines on bread.',
      '午餐主打甘蓝汤配香肠、鳕鱼料理或烤沙丁鱼面包。',
      '昼はカルドヴェルデ、バカルハウ、焼きイワシ。',
      '점심은 칼두 베르데, 바칼라우, 구운 정어리입니다.',
      'Trưa có caldo verde, bacalhau hoặc sardine nướng.',
    ),
    Course.appetizer: _l(
      'Starters include peixinhos da horta fried green beans, bolinhos de bacalhau fritters, and presunto ham.',
      '前菜有炸豆角、鳕鱼饼与伊比利亚火腿。',
      '前菜はペイシーニョス、ボリーニョス、プリシュート。',
      '전채는 튀긴 완두콩, 바칼라우 볼, 프레슈토 햄입니다.',
      'Khai vị gồm đậu chiên, bolinho bacalhau và presunto.',
    ),
    Course.sideDish: _l(
      'Sides bring migas bread crumbs with greens, roasted potatoes, and tomato rice studded with herbs.',
      '配菜有面包屑炒青菜、烤土豆与香草番茄饭。',
      '副菜はミガス、ローストポテト、トマトリョ。',
      '반찬은 미가스, 로스트 포테이토, 허브 토마토 라이스입니다.',
      'Món phụ gồm migas, khoai nướng và cơm cà chua thảo mộc.',
    ),
    Course.dessert: _l(
      'Sweets include arroz doce cinnamon rice pudding, queijadas cheese tarts, and bolo de bolacha biscuit cake.',
      '甜点有肉桂米布丁、奶酪塔与饼干蛋糕。',
      '甘味はアローズドース、ケイジャーダ、ボロデボラッサ。',
      '디저트는 아로즈 도스, 케이자다, 비스킷 케이크입니다.',
      'Tráng miệng gồm arroz doce, queijadas và bolo de bolacha.',
    ),
    Course.snack: _l(
      'Tasca snacks mean bifana pork sandwiches, pregos steak rolls, and francesinha loaded hot sandwiches.',
      '小酒馆小吃有猪肉三明治、牛排包与丰盛热三明治。',
      'タスカはビファナ、プレゴ、フランセジーニャ。',
      '타스카 간식은 비파나, 프레고, 프란세지냐 샌드위치입니다.',
      'Ăn vặt tasca gồm bifana, prego và francesinha.',
    ),
    Course.drinks: _l(
      'Drinks feature vinho verde young wine, ginjinha cherry liqueur, and galão milky coffee.',
      '饮品有绿酒、樱桃利口酒与牛奶咖啡。',
      '飲み物はヴィーニョヴェルデ、ジンジーニャ、ガラオ。',
      '음료는 비뉴 베르데, 진지냐, 갈라우 커피입니다.',
      'Đồ uống gồm vinho verde, ginjinha và galão.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Spanish
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.spanish: {
    Course.breakfast: _l(
      'Spanish mornings mean pan con tomate rubbed bread, café con leche, and sometimes churros dipped in chocolate.',
      '西式清晨是番茄面包、牛奶咖啡，有时配巧克力蘸油条。',
      '朝はパンコントマテ、カフェコンレチェ、チュロス。',
      '아침은 토마토 빵, 카페 콘 레체, 초코 츄러ros입니다.',
      'Sáng có pan con tomate, café con leche và churros sô-cô-la.',
    ),
    Course.lunch: _l(
      'Lunch is the big meal: paella with saffron rice, cocido stew, or a table of tapas shared family-style.',
      '午餐是一日正餐：藏红花饭、炖菜或全家分享的 tapas。',
      '昼はパエリア、コシード、タパスのシェア。',
      '점심은 파에야, 코시도, 가족식 타파스가 중심입니다.',
      'Trưa là bữa chính: paella, cocido hoặc tapas chia sẻ.',
    ),
    Course.appetizer: _l(
      'Tapas include patatas bravas, gambas al ajillo garlic shrimp, and jamón ibérico with manchego cheese.',
      'Tapas 有辣味土豆、蒜香虾与伊比利亚火腿配曼彻戈奶酪。',
      'タパスはブラバス、ガンバス、アルハモンイベリコ。',
      '타파스는 브라바스 감자, 감바스 알 아히요, 이베리코 햄입니다.',
      'Tapas gồm patatas bravas, gambas al ajillo và jamón ibérico.',
    ),
    Course.sideDish: _l(
      'Sides bring pan con tomate, roasted piquillo peppers, and garlicky sautéed mushrooms.',
      '配菜有番茄面包、烤红椒与蒜香蘑菇。',
      '副菜はパンコントマテ、ピキージョ、キノコのアヒージョ。',
      '반찬은 토마토 빵, 피키요 피망, 마늘 버섯입니다.',
      'Món phụ gồm pan con tomate, ớt piquillo và nấm tỏi.',
    ),
    Course.dessert: _l(
      'Sweets span crema catalana, tarta de Santiago almond cake, and flan with caramel sauce.',
      '甜点有加泰罗尼亚奶冻、杏仁蛋糕与焦糖布丁。',
      '甘味はクレマカタラーナ、サンティアゴ、フラン。',
      '디저트는 크레마 카탈라나, 산티아고 타르트, 플란입니다.',
      'Tráng miệng gồm crema catalana, tarta de Santiago và flan.',
    ),
    Course.snack: _l(
      'Merienda and tapas bars serve croquetas, tortilla española potato omelette, and boquerones marinated anchovies.',
      '下午茶与 tapas 吧有可乐饼、土豆蛋饼与腌凤尾鱼。',
      'おやつはクロケット、トルティージャ、ボケローネス。',
      '간식은 크로케타, 스페인 오믈렛, 마리네이드 멸치입니다.',
      'Merienda có croquetas, tortilla española và boquerones.',
    ),
    Course.drinks: _l(
      'Drinks include tinto de verano red-wine spritz, sangria, sherry fino, and cortado espresso cuts.',
      '饮品有夏日红酒苏打、桑格利亚、雪利酒与浓缩咖啡牛奶。',
      '飲み物はティントデベラーノ、サングリア、シェリー、コルタード。',
      '음료는 틴토 데 베라노, 상그리아, 셰리, 코르타도입니다.',
      'Đồ uống gồm tinto de verano, sangria, sherry và cortado.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Brazilian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.brazilian: {
    Course.breakfast: _l(
      'Breakfast features pão francês rolls with butter, tropical fruit, fresh cheese, and strong cafezinho coffee.',
      '早餐有法式小面包、热带水果、鲜奶酪与浓咖啡。',
      '朝はパンフランセス、トロピカルフルーツ、チーズ、カフェジーニョ。',
      '아침은 프랑스 롤, 열대 과일, 신선 치즈, 카페지뉴입니다.',
      'Sáng có bánh mì francês, trái cây nhiệt đới, phô mai và cafezinho.',
    ),
    Course.lunch: _l(
      'Lunch is feijoada black-bean stew with pork, rice, collard greens, and orange slices to brighten the plate.',
      '午餐是黑豆炖肉配米饭、羽衣甘蓝与橙子。',
      '昼はフェイジョアーダ、ライス、コラード、オレンジ。',
      '점심은 페이조아다, 밥, 케일, 오렌지 조각이 중심입니다.',
      'Trưa có feijoada, cơm, cải xoăn và cam.',
    ),
    Course.appetizer: _l(
      'Starters include pão de queijo cheese puffs, coxinha chicken croquettes, and pastel fried pastries.',
      '前菜有奶酪面包球、鸡肉可乐饼与炸馅饼。',
      '前菜はパンデケイジョ、コシーニャ、パステル。',
      '전채는 빵지뉴 치즈빵, 코시냐, 파스텔 튀김입니다.',
      'Khai vị gồm pão de queijo, coxinha và pastel.',
    ),
    Course.sideDish: _l(
      'Sides bring farofa toasted cassava crumbs, vinaigrette salsa, and fried bananas or plantains.',
      '配菜有木薯粉、油醋沙拉与炸香蕉。',
      '副菜はファロファ、ヴィネグレット、揚げバナナ。',
      '반찬은 파로파, 비네그레트 살사, 튀긴 바나나입니다.',
      'Món phụ gồm farofa, vinaigrette và chuối chiên.',
    ),
    Course.dessert: _l(
      'Sweets include brigadeiro chocolate truffles, quindim coconut custard, and açaí bowls with granola.',
      '甜点有巧克力球、椰奶布丁与巴西莓碗。',
      '甘味はブリガデイロ、キンディン、アサイボウル。',
      '디저트는 브리가데이로, 킨딤, 아사이 볼입니다.',
      'Tráng miệng gồm brigadeiro, quindim và açaí.',
    ),
    Course.snack: _l(
      'Beach snacks mean espetinho grilled skewers, tapioca crepes with cheese, and popcorn sold street-side.',
      '海滩小吃有烤肉串、木薯奶酪可丽饼与爆米花。',
      '屋台はエスペティーニョ、タピオカ、ポップコーン。',
      '해변 간식은 에스페티뉴, 타피오카 크레페, 팝콘입니다.',
      'Ăn vặt bãi biển gồm espetinho, tapioca và bắp rang.',
    ),
    Course.drinks: _l(
      'Drinks span caipirinha lime cachaça cocktails, guaraná soda, fresh sugar-cane juice, and mate chimarrão.',
      '饮品有凯匹林纳鸡尾酒、瓜拉那汽水、甘蔗汁与马黛茶。',
      '飲み物はカイピリーニャ、グアラナ、サトウキビ、チマラオ。',
      '음료는 카이피리냐, 구아라나, 사탕수수 주스, 마테 차입니다.',
      'Đồ uống gồm caipirinha, guaraná, nước mía và chimarrão.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Caribbean
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.caribbean: {
    Course.breakfast: _l(
      'Island mornings favor saltfish with ackee, fried dumplings, callaloo greens, and sweet plantain on the side.',
      '海岛清晨偏爱咸鱼阿开木果、炸面团、卡拉卢青菜与甜芭蕉。',
      '朝は塩漬け魚とアキー、揚げドーナツ、カラルー、プランテン。',
      '아침은 소금 생선·아키, 튀긴 도넛, 칼라루, 플랜틴입니다.',
      'Sáng có cá muối ackee, bánh chiên, callaloo và chuối plantain.',
    ),
    Course.lunch: _l(
      'Lunch might be jerk chicken over rice and peas, curry goat, or brown-stew fish with festival fried dough.',
      '午餐可能是香料烤鸡配豆饭、咖喱山羊或炖鱼配炸面点。',
      '昼はジャークチキン、カレーゴート、ブラウンスチューフィッシュ。',
      '점심은 저크 치킨, 카레 염소, 브라운 스튜 생선입니다.',
      'Trưa có jerk chicken, cà ri dê hoặc cá hầm festival.',
    ),
    Course.appetizer: _l(
      'Starters include conch fritters, pepper shrimp, and patties filled with spiced beef or vegetables.',
      '前菜有海螺饼、胡椒虾与牛肉或蔬菜馅饼。',
      '前菜はコンクフリッター、ペッパーシュリンプ、パティ。',
      '전채는 소라 튀김, 페퍼 새우, 패티입니다.',
      'Khai vị gồm conch fritter, tôm tiêu và patty.',
    ),
    Course.sideDish: _l(
      'Sides bring rice and peas, fried plantains, pickled escovitch vegetables, and grated cucumber salad.',
      '配菜有豆饭、炸芭蕉、腌蔬菜与黄瓜丝沙拉。',
      '副菜はライスアンドピース、プランテン、エスコビッチ。',
      '반찬은 라이스 앤 피스, 튀긴 플랜틴, 피클 채소입니다.',
      'Món phụ gồm rice and peas, plantain chiên và escovitch.',
    ),
    Course.dessert: _l(
      'Sweets include coconut drops, guava duff steamed pudding, and rum-soaked black cake.',
      '甜点有椰糖块、番石榴布丁与朗姆黑蛋糕。',
      '甘味はココナッツドロップ、グアバダフ、ラムケーキ。',
      '디저트는 코코넛 드롭, 구아바 더프, 럼 케이크입니다.',
      'Tráng miệng gồm coconut drop, guava duff và black cake.',
    ),
    Course.snack: _l(
      'Roadside snacks mean doubles curried chickpea sandwiches, roasted corn, and coconut water straight from the husk.',
      '路边小吃有咖喱鹰嘴豆三明治、烤玉米与现开椰子水。',
      '屋台はダブルス、焼きトウモロコシ、ココナッツウォーター。',
      '길거리 간식은 더블스, 구운 옥수수, 코코넛 워터입니다.',
      'Ăn vặt đường phố gồm doubles, ngô nướng và nước dừa tươi.',
    ),
    Course.drinks: _l(
      'Drinks feature sorrel hibiscus punch, ginger beer, Ting grapefruit soda, and rum punches with tropical fruit.',
      '饮品有洛神花潘趣、姜啤、西柚汽水与热带朗姆潘趣。',
      '飲み物はソレル、ジンジャービア、ティング、ラムパンチ。',
      '음료는 소렐, 진저 비어, 팅 소다, 럼 펀치입니다.',
      'Đồ uống gồm sorrel, ginger beer, Ting và rum punch trái cây.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Peruvian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.peruvian: {
    Course.breakfast: _l(
      'Breakfasts include pan con chicharrón pork sandwiches, tamal verde, or quinoa porridge with milk and cinnamon.',
      '早餐有炸猪肉三明治、绿色玉米粽或肉桂牛奶藜麦粥。',
      '朝はチチャローンパン、タマル、キヌア粥。',
      '아침은 치차론 샌드위치, 타말, 시나몬 키노아 죽입니다.',
      'Sáng có bánh chicharron, tamal hoặc cháo quinoa quế.',
    ),
    Course.lunch: _l(
      'Lunch stars ceviche lime-cured fish, lomo saltado stir-fry over fries, or ají de gallina creamy chicken stew.',
      '午餐主打酸橘汁腌鱼、炒牛肉薯条与奶油辣椒鸡。',
      '昼はセビーチェ、ロモサルタード、アヒデガリーナ。',
      '점심은 세비체, 로모 살타도, 아히 데 가예나입니다.',
      'Trưa nổi bật ceviche, lomo saltado và ají de gallina.',
    ),
    Course.appetizer: _l(
      'Starters include causa layered potato terrine, anticuchos grilled heart skewers, and tequeños cheese sticks.',
      '前菜有千层土豆糕、烤心串与奶酪条。',
      '前菜はカウサ、アンティクーチョス、テケーニョス。',
      '전채는 카우사, 안티쿠초스, 테케뇨스입니다.',
      'Khai vị gồm causa, anticuchos và tequeños.',
    ),
    Course.sideDish: _l(
      'Sides bring cancha toasted corn nuts, salsa criolla onion relish, and yellow ají pepper sauces.',
      '配菜有烤玉米、洋葱莎莎与黄辣椒酱。',
      '副菜はカンチャ、クリオッラ、イエローアヒ。',
      '반찬은 칸차, 크리올라 양파, 옐로 아히 소스입니다.',
      'Món phụ gồm cancha, salsa criolla và sốt ají vàng.',
    ),
    Course.dessert: _l(
      'Sweets include suspiro limeño caramel meringue, picarones pumpkin doughnuts, and lucuma ice cream.',
      '甜点有焦糖蛋白甜点、南瓜圈与蛋黄果冰淇淋。',
      '甘味はススピロ、ピカロネス、ルクマアイス。',
      '디저트는 수스피로, 피카로네스, 루쿠마 아이스크림입니다.',
      'Tráng miệng gồm suspiro limeño, picarones và kem lucuma.',
    ),
    Course.snack: _l(
      'Street snacks mean butifarra ham rolls, empanadas, and choclo giant corn with salty cheese.',
      '街头小吃有火腿卷、empanadas 与大玉米配咸奶酪。',
      '屋台はブティファラ、エンパナーダ、チョクロ。',
      '길거리 간식은 부티파라, 엠파나다, 초클로 옥수수입니다.',
      'Ăn vặt gồm butifarra, empanada và choclo phô mai.',
    ),
    Course.drinks: _l(
      'Drinks span pisco sours, chicha morada purple corn punch, and inca kola golden soda.',
      '饮品有皮斯科酸酒、紫玉米饮与黄金汽水。',
      '飲み物はピスコサワー、チチャモラダ、インカコーラ。',
      '음료는 피스코 사워, 치차 모라다, 잉카 콜라입니다.',
      'Đồ uống gồm pisco sour, chicha morada và Inca Kola.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Ethiopian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.ethiopian: {
    Course.breakfast: _l(
      'Breakfasts feature fatira flaky bread with honey, chechebsa spiced shredded flatbread, or ful stewed fava beans.',
      '早餐有蜂蜜酥饼、香料碎饼或炖蚕豆。',
      '朝はファティラ、チェチェブサ、フル。',
      '아침은 파티라, 체체브사, 풀 병아리콩 스튜입니다.',
      'Sáng có fatira mật ong, chechebsa hoặc ful đậu fava.',
    ),
    Course.lunch: _l(
      'Lunch is injera flatbread scooped with doro wat chicken stew, misir lentil wat, or tibs sautéed meat.',
      '午餐用英吉拉饼舀炖鸡、炖扁豆或炒肉。',
      '昼はインジェラにドロワット、ミシル、ティブス。',
      '점심은 인제라에 도로 와트, 미시르, 티브스를 곁들입니다.',
      'Trưa có injera với doro wat, misir hoặc tibs.',
    ),
    Course.appetizer: _l(
      'Starters include sambusa pastries, azifa green-lentil salad, and gomen collard greens with niter kibbeh spiced butter.',
      '前菜有三角酥、青扁豆沙拉与香料黄油羽衣甘蓝。',
      '前菜はサンブーサ、アジファ、ゴメン。',
      '전채는 삼부사, 아지파 샐러드, 고멘 채소입니다.',
      'Khai vị gồm sambusa, azifa và gomen.',
    ),
    Course.sideDish: _l(
      'Sides mean ayib fresh cheese, atkilt turmeric vegetables, and fiery berbere-spiced sauces for sharing.',
      '配菜有鲜奶酪、姜黄蔬菜与辣味柏培酱。',
      '副菜はアイブ、アトキルト、ベルベレソース。',
      '반찬은 아이브 치즈, 아틸트 채소, 베르베레 소스입니다.',
      'Món phụ gồm ayib, atkilt và sốt berbere.',
    ),
    Course.dessert: _l(
      'Sweets lean on honey wine bites, popcorn served with coffee ceremonies, and dates stuffed with nuts.',
      '甜点偏蜂蜜酒小点、咖啡仪式爆米花与坚果椰枣。',
      '甘味は蜂蜜酒、コーヒーとポップコーン、ナツメ。',
      '디저트는 꿀 와인, 커피 의식 팝콘, 견과 대추입니다.',
      'Tráng miệng gồm tej mật ong, bắp rang cà phê và chà là.',
    ),
    Course.snack: _l(
      'Snacks include kolo roasted barley mix, dabo kolo crunchy bread bites, and spiced tea with roasted grains.',
      '小吃有烤大麦、脆面包丁与香料谷物茶。',
      'おやつはコロ、ダボコロ、スパイスティー。',
      '간식은 콜로, 다보 콜로, 향신료 차입니다.',
      'Ăn vặt gồm kolo, dabo kolo và trà gia vị.',
    ),
    Course.drinks: _l(
      'Drinks center on bunna coffee ceremonies, tej honey wine, and fresh juices like mango or papaya.',
      '饮品以咖啡仪式、蜂蜜酒与芒果汁为主。',
      '飲み物はブンナ、テジ、マンゴージュース。',
      '음료는 부나 커피 의식, 테즈, 망고 주스입니다.',
      'Đồ uống gồm bunna, tej và nước xoài.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Lebanese
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.lebanese: {
    Course.breakfast: _l(
      'Lebanese mornings spread manakish za\'atar flatbread, labneh with olive oil, olives, cucumbers, and mint tea.',
      '黎巴嫩清晨有 za\'atar 扁面包、酸奶油、橄榄黄瓜与薄荷茶。',
      '朝はザアタルマナキッシュ、ラブネ、オリーブ、ミントティー。',
      '아침은 자아타르 마나키시, 라브네, 올리브, 민트 차입니다.',
      'Sáng có manakish za\'atar, labneh, olive và trà bạc hà.',
    ),
    Course.lunch: _l(
      'Lunch might be shawarma wraps, kibbeh cracked-wheat torpedoes, or a mezze table with hummus and grilled meats.',
      '午餐可能是沙威玛、炸麦肉卷或鹰嘴豆泥烤肉拼盘。',
      '昼はシャワルマ、キベ、フムスと焼き肉のメゼ。',
      '점심은 샤와르마, 키베, 후무스 메제가 흔합니다.',
      'Trưa có shawarma, kibbeh hoặc mezze hummus.',
    ),
    Course.appetizer: _l(
      'Meze stars hummus, baba ghanoush, tabbouleh parsley salad, and warak enab stuffed grape leaves.',
      'Meze 有鹰嘴豆泥、茄子酱、塔博勒沙拉与葡萄叶卷。',
      'メゼはフムス、ババガヌーシュ、タブーリ、ワラクエナブ。',
      '메제는 후무스, 바바 가누시, 타불레, 포도잎 롤입니다.',
      'Meze gồm hummus, baba ghanoush, tabbouleh và warak enab.',
    ),
    Course.sideDish: _l(
      'Sides include fattoush bread salad, muhammara red-pepper dip, and pickled turnips dyed pink.',
      '配菜有面包沙拉、红椒酱与粉红腌萝卜。',
      '副菜はファトゥーシュ、ムハンマラ、ピクルスカブ。',
      '반찬은 파투시 샐러드, 무함마라, 분홍 무 절임입니다.',
      'Món phụ gồm fattoush, muhammara và củ cải muối hồng.',
    ),
    Course.dessert: _l(
      'Sweets include baklava, knafeh cheese pastry soaked in syrup, and rosewater rice pudding.',
      '甜点有酥皮蜜饼、糖浆奶酪糕与玫瑰米布丁。',
      '甘味はバクラヴァ、クナーフェ、ローズウォータープリン。',
      '디저트는 바클라바, 쿠나페, 장미 라이스 푸딩입니다.',
      'Tráng miệng gồm baklava, knafeh và pudding hoa hồng.',
    ),
    Course.snack: _l(
      'Street snacks mean falafel sandwiches, manoushe cheese pies, and roasted pumpkin seeds sold in paper cones.',
      '街头小吃有炸豆丸三明治、奶酪派与纸筒南瓜子。',
      '屋台はファラフェル、マヌーシェ、パンプキンシード。',
      '길거리 간식은 팔라펠, 마누셰, 호박씨입니다.',
      'Ăn vặt gồm falafel, manoushe và hạt bí.',
    ),
    Course.drinks: _l(
      'Drinks span mint lemonade, arak anise spirits with ice water, and strong Lebanese coffee.',
      '饮品有薄荷柠檬水、茴香烈酒与浓咖啡。',
      '飲み物はミントレモネード、アラック、レバノンコーヒー。',
      '음료는 민트 레모네이드, 아락, 레바논 커피입니다.',
      'Đồ uống gồm nước chanh bạc hà, arak và cà phê Lebanon.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Moroccan
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.moroccan: {
    Course.breakfast: _l(
      'Mornings bring msemen layered pancakes with honey, baghrir semolina crêpes, and mint tea poured from height.',
      '清晨有蜂蜜千层饼、粗麦松饼与高冲薄荷茶。',
      '朝はムセメン、バグリール、ミントティー。',
      '아침은 msemen 층 팬케이크, 바그리르, 민트 차입니다.',
      'Sáng có msemen mật ong, baghrir và trà bạc hà cao.',
    ),
    Course.lunch: _l(
      'Lunch stars tagine slow stews, couscous Fridays with seven vegetables, and harira tomato-lentil soup.',
      '午餐主打塔吉锅炖菜、七菜古斯古斯与番茄扁豆汤。',
      '昼はタジン、クスクス、ハリラ。',
      '점심은 타진, 쿠스쿠스, 하리라 수프가 중심입니다.',
      'Trưa có tagine, couscous bảy rau và harira.',
    ),
    Course.appetizer: _l(
      'Starters include zaalouk eggplant salad, briouats filled pastries, and olives with preserved lemons.',
      '前菜有茄子沙拉、酥皮卷与腌柠檬橄榄。',
      '前菜はザールーク、ブリウアット、レモンのオリーブ。',
      '전채는 자알룩, 브리우아트, 레몬 올리브입니다.',
      'Khai vị gồm zaalouk, briouat và olive chanh muối.',
    ),
    Course.sideDish: _l(
      'Sides bring tfaya caramelized onions with raisins, chermoula herb sauce, and salads of orange and olives.',
      '配菜有葡萄干洋葱、香草酱与橙子橄榄沙拉。',
      '副菜はティファヤ、シェルモーラ、オレンジサラダ。',
      '반찬은 티파야 양파, 셰르물라, 오렌지 올리브 샐러드입니다.',
      'Món phụ gồm tfaya, chermoula và salad cam olive.',
    ),
    Course.dessert: _l(
      'Sweets include chebakia sesame cookies, almond briouats, and orange-blossom scented milk puddings.',
      '甜点有芝麻曲奇、杏仁酥与橙花奶布丁。',
      '甘味はシェバキア、アーモンドブリウアット、オレンジブロッサムプリン。',
      '디저트는 셰바키아, 아몬드 브리우아트, 오렌지 블라썸 푸딩입니다.',
      'Tráng miệng gồm chebakia, briouat hạnh nhân và pudding hoa cam.',
    ),
    Course.snack: _l(
      'Souk snacks mean snail broth cups, roasted almonds with cumin, and fresh dates from market stalls.',
      '市集小吃有蜗牛汤、孜然烤杏仁与鲜枣。',
      'スークはカタツムリスープ、クミンアーモンド、デーツ。',
      '시장 간식은 달팽이 국물, 커민 아몬드, 대추입니다.',
      'Ăn vặt souk gồm súp ốc, hạnh nhân thì là và chà là.',
    ),
    Course.drinks: _l(
      'Drinks feature atay mint tea, freshly squeezed orange juice, and almond milk spiced with orange flower water.',
      '饮品有薄荷茶、鲜榨橙汁与橙花杏仁奶。',
      '飲み物はアタイ、オレンジジュース、アーモンドミルク。',
      '음료는 민트 아타이, 오렌지 주스, 오렌지 블라썸 아몬드 밀크입니다.',
      'Đồ uống gồm atay bạc hà, nước cam và sữa hạnh nhân hoa cam.',
    ),
  },

  // ─────────────────────────────────────────────────────────────────────
  // Turkish
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.turkish: {
    Course.breakfast: _l(
      'Turkish kahvaltı spreads white cheese, olives, tomatoes, cucumbers, honey, clotted kaymak cream, and simit sesame rings.',
      '土耳其早餐摆白奶酪、橄榄、番茄黄瓜、蜂蜜、凝脂奶油与芝麻圈。',
      '朝はカハヴァルチ、チーズ、オリーブ、ハチミツ、カイマク、シミット。',
      '아침은 카할바르티에 치즈, 올리브, 토마토, 꿀, 카이막, 시밋입니다.',
      'Kahvaltı có phô mai trắng, olive, cà chua, mật ong, kaymak và simit.',
    ),
    Course.lunch: _l(
      'Lunch might be döner wraps, lahmacun thin meat pizzas, or izgara köfte grilled meatballs with pilav rice.',
      '午餐可能是旋转烤肉卷、薄肉饼或烤肉丸配抓饭。',
      '昼はドネル、ラフマジュン、イズガラコフテとピラフ。',
      '점심은 되네르, 라흐마준, 이즈가라 쿠프테, 필라프입니다.',
      'Trưa có döner, lahmacun hoặc köfte với pilav.',
    ),
    Course.appetizer: _l(
      'Meze includes cacık yogurt dip, dolma stuffed vegetables, and mercimek köfte lentil balls.',
      'Meze 有酸奶酱、酿蔬菜与扁豆球。',
      'メゼはジャージク、ドルマ、メルジメクコフテ。',
      '메제는 자지크, 돌마, 메르지멕 쿠프테입니다.',
      'Meze gồm cacık, dolma và mercimek köfte.',
    ),
    Course.sideDish: _l(
      'Sides bring pilav buttery rice, ezme spicy tomato relish, and pickled cabbage sirkeli lahana.',
      '配菜有黄油抓饭、辣番茄酱与腌卷心菜。',
      '副菜はピラフ、エズメ、ピクルスキャベツ。',
      '반찬은 필라프, 에즈메, 양배추 절임입니다.',
      'Món phụ gồm pilav, ezme và bắp cải muối.',
    ),
    Course.dessert: _l(
      'Sweets include baklava, künefe cheese pastry, and dondurma stretchy ice cream with pistachios.',
      '甜点有酥皮蜜饼、奶酪丝糕与拉伸冰淇淋。',
      '甘味はバクラヴァ、キュネフェ、ドンドゥルマ。',
      '디저트는 바클라바, 퀴네페, 돈두르마 아이스크림입니다.',
      'Tráng miệng gồm baklava, künefe và dondurma.',
    ),
    Course.snack: _l(
      'Street snacks mean simit rings, midye dolma stuffed mussels, and roasted chestnuts in winter.',
      '街头小吃有芝麻圈、填馅青口与冬日烤栗子。',
      '屋台はシミット、ミディエドルマ、焼き栗。',
      '길거리 간식은 시밋, 미디예 돌마, 군밤입니다.',
      'Ăn vặt gồm simit, midye dolma và hạt dẻ nướng.',
    ),
    Course.drinks: _l(
      'Drinks span Turkish tea in tulip glasses, strong coffee with grounds, ayran yogurt drink, and şalgam turnip juice.',
      '饮品有郁金香杯红茶、土耳其咖啡、酸奶饮与萝卜汁。',
      '飲み物はチャイ、トルココーヒー、アイラン、シャルガム。',
      '음료는 터키 차, 터키 커피, 아이란, 숄감 주스입니다.',
      'Đồ uống gồm trà tulip, cà phê Thổ, ayran và şalgam.',
    ),
  },
};

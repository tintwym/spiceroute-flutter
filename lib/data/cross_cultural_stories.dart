import '../models/spice_route.dart';

/// Editorial "Culinary Heritage & Connections" copy for each cuisine, keyed
/// by [Cuisine] → [Course] → language code.
///
/// Most of this content was ported verbatim from the original React app's
/// `CROSS_CULTURAL_STORIES` map and covers 5 languages (en/zh/th/ja/ko) for
/// the 9 launch cuisines. The two cuisines we added later (Burmese,
/// Vietnamese) ship with English-only entries — [storyFor] falls back to
/// `en` whenever a given language is missing.
const Map<Cuisine, Map<Course, Map<String, String>>> crossCulturalStories = {
  // ─────────────────────────────────────────────────────────────────────
  // Korean
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.korean: {
    Course.breakfast: {
      'en':
          "Traditional Korean breakfast is identical to a hearty lunch, centering around warm rice, hot stew, and multiple banchan items including kimchi.",
      'zh': "传统韩式早餐与丰盛午餐或晚餐类似，围绕着温热米饭、热汤和包含泡菜在内的多道小菜展开。",
      'ja': "伝統的な韓国の朝食は、温かいご飯、スープ、キムチを含むおかずを中心に昼食のように食べられます。",
      'ko':
          "전통 한국식 아침은 밥과 뜨거운 국, 김치를 비롯한 다채로운 반찬이 일상적으로 올라 다른 상차림과 구분이 없습니다.",
    },
    Course.lunch: {
      'en':
          "Korean lunch often features convenient single-bowl dishes like Bibimbap or noodles to sustain energy under quick schedules.",
      'zh': "韩式午餐通常以大锅拌饭或面团等单碗菜为主，帮助在忙碌节奏中快速补充能量。",
      'ja': "韓国のランチは、ビビンバやククスなど1杯で完結する手軽な料理でエナジーチャージします。",
      'ko':
          "점심에는 바쁜 일과 속에서 한 그릇 비빔밥이나 잔치국수 등으로 간편하고 든든하게 열량을 충원합니다.",
    },
    Course.appetizer: {
      'en':
          "Korean starters focus on crispy scallion pancakes (Pajeon) or savory simmered rice cakes (Tteokbokki) shared at center table.",
      'zh': "韩式开胃菜通常是酥脆的海鲜葱煎饼或备受喜爱的甜辣炒年糕，作为餐桌中心的分享美味。",
      'ja': "韓国の前菜といえば、海鮮チヂミや甘辛いトッポギがあり、みんなで分け合って笑顔で味わいます。",
      'ko': "전채 요리로는 지글지글 지진 해물파전이나 매콤달콤 떡볶이 등으로 대화의 흥을 돋웁니다.",
    },
    Course.sideDish: {
      'en':
          "Side dishes (Banchan) define Korean culinary identity, bringing balanced textures and fermented goodness to nourish the body.",
      'zh': "韩餐配菜（Banchan）是其料理风骨所在，通过完美的酸辣平衡与乳酸菌发酵营养滋补身心。",
      'ja': "パンチャン（おかず）は、乳酸発酵の栄養と旨味が詰まった食卓の主役級脇役です。",
      'ko':
          "다채로운 밑반찬은 한국 식탁의 꽃이자 혼으로, 발효 영양을 담아 건강을 튼튼히 보살핍니다.",
    },
    Course.dessert: {
      'en':
          "Sweets range from elegant rice cakes (Tteok) to refreshing shaved ice (Bingsu) loaded with sweet beans and thick milk glaze.",
      'zh': "韩式饭后甜点涵盖了传统的精致糯米打糕，以及在盛夏铺满香甜红豆、年糕块和炼乳的红豆刨冰。",
      'ja':
          "伝統的な餅菓子（トック）から、ふわふわ和モダンのあずきかき氷（パッピンス）まで、魅惑の甘さです。",
      'ko':
          "디저트로는 쫄깃한 전통 인절미나 곱게 간 얼음 위에 단팥과 찰떡, 연유를 듬뿍 올린 시원한 빙수가 있습니다.",
    },
    Course.snack: {
      'en':
          "Late-night bites thrive under Anju culture—crispy glazed Korean Fried Chicken (Chimaek) or spicy stir-fried elements.",
      'zh': "韩式深夜消遣由其独特的'下酒菜'文化主宰，风靡各地的韩式辣酱炸鸡配啤酒是深夜聚会首选。",
      'ja':
          "韓国の夜食を代表するのは「アンジュ」文化。サクサクのフライドチキンを冷たいビールで流し込みます。",
      'ko':
          "야식은 술과 즐기는 '안주' 요리가 으뜸이며 바삭한 치킨에 시원한 맥주를 곁들이는 치맥이 사랑받습니다.",
    },
    Course.drinks: {
      'en':
          "Drinks feature soothing traditional unfiltered rice Makgeolli, crisp Soju, or warm toasted barley grain tea.",
      'zh': "韩式经典饮品包含香甜醇厚的白色大米马格利酒、清透爽口的小烧酒，或者是代代相传的热大麦茶。",
      'ja': "伝統的な米マッコリ、すっきりソジュ、そして日常的に飲む香ばしい大麦茶などがあります。",
      'ko':
          "음료로는 구수한 전설 속 막걸리나 청량한 소주, 혹은 한국인들이 평소 생수처럼 마시는 구수한 보리차가 있습니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Japanese
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.japanese: {
    Course.breakfast: {
      'en':
          "Classic Japanese breakfast (Asagohan) features steamed white rice, warm dashi miso soup, grilled salmon, and gut-healthy natto.",
      'zh': "标准日式清晨餐食包含晶莹白饭、热腾腾味噌汤、一片金黄盐烤鲑鱼，以及有助于长寿养胃的纳豆。",
      'ja':
          "一日の始まりは、炊きたてご飯、味噌汁、焼き魚、納豆が揃った伝統的な「朝ご飯」から健康的に。",
      'ko':
          "기본 정통 아침은 흰 고슬밥과 깔끔한 미소된장국, 연어소금구이와 영양 가득한 발효 낫토로 소박하게 채웁니다.",
    },
    Course.lunch: {
      'en':
          "Lunch centers around neatly crafted Bento boxes, steaming noodle soups, or easy store-side pressed Onigiri.",
      'zh': "日本午间美味多属于讲究摆盘美感的便当、热气腾腾的拉面，或者是便利店里最受欢迎的香脆海苔饭团。",
      'ja':
          "日本の昼食は、彩り豊かなお弁当、職人手作りのラーメンやお蕎麦、そして愛おしいおにぎりが大活躍。",
      'ko':
          "점심에는 구색 맞춰 담아낸 예술적인 벤토(도시락)나 담백한 우동, 단골 야채 가미 삼각김밥 등이 주로 쓰입니다.",
    },
    Course.appetizer: {
      'en':
          "Starters focus on salty edamame pods, light crisp vegetable tempura, or cold silken tofu adorned with ginger dashi.",
      'zh': "日式前菜讲究清雅——洒上海盐的青皮毛豆、金黄蓬松的天妇罗蔬菜、或者是清凉滑嫩的水豆腐伴着生姜泥。",
      'ja':
          "お食事前の一皿は、手軽な塩茹で枝豆、旬野菜のさっぱり天ぷら、ひんやり冷奴で胃腸を優しく整えます。",
      'ko':
          "전채 요리는 소금을 치며 끓여 낸 에다마메, 얇은 튀김옷의 수제 텐푸라, 촉촉한 냉두부가 감칠맛을 당깁니다.",
    },
    Course.sideDish: {
      'en':
          "Side items showcase seasonal harmony—sweet-sour sunomono cucumber pickles or root veggies braised in sweet dashi stock.",
      'zh': "佐餐配菜展现细嫩的季节变换，常吃醋渍爽口小黄瓜，或者是用高汤煮得绵密甜软的胡萝卜根茎类小炖菜。",
      'ja':
          "副菜には、酸味が心地よい酢の物や、ダシのコクを煮含めたお母さん手作りの心の煮物が大人気。",
      'ko':
          "반찬으로는 새콤달콤하게 식초에 버무린 오이 초절임이나 우엉 등 야채를 단 간장에 졸여 낸 정성 어린 니모노가 있습니다.",
    },
    Course.dessert: {
      'en':
          "Traditional sweets honor red bean Wagashi, matcha dango skewers, or chewy-wrapped fine ice cream balls.",
      'zh': "日本甜点以包裹绵密红豆沙的和菓子、抹茶小团子串，以及外面软Q、内部冰凉沁心的抹茶大福冰淇淋为代表。",
      'ja':
          "和菓子職人手作りの練り切り、三色だんご、あるいは抹茶もちアイスクリームが最高のご褒美。",
      'ko':
          "전통 단 음식으로는 고운 화과자, 달디단 간장을 바른 당고, 현대 퓨전 기술인 쫀득하고 차가운 말차 모찌 크림이 식탁의 마무리를 맡습니다.",
    },
    Course.snack: {
      'en':
          "Late night cravings lead to skewered charcoal Yakitori chickens, octopus-stuffed Takoyaki balls, or simmering Oden warm bowls.",
      'zh': "深夜消夜常在居酒屋解决，吃两串饱含炭香的烧鸟鸡肉、或者在圆盘上烤得滚烫金黄的章鱼小丸子和关东煮。",
      'ja':
          "深夜の胃袋を満たすのは、香ばしい焼き鳥、タコが入った熱々のたこ焼き、肌寒い夜に心に染みるおでんです。",
      'ko':
          "늦은 밤 배고픔은 숯불에 지진 육즙 가득 야키토리 닭꼬치, 타코야키 볼, 편의점 한복판에서 끓고 있는 정겨운 오뎅 꼬치가 채워 줍니다.",
    },
    Course.drinks: {
      'en':
          "Drinks celebrate foaming ceremonial Matcha tea, warm rich Sake decanters, or refreshing tall carbonated soda Highballs.",
      'zh': "和风饮品包含研磨起沫的仪式乌龙茶与抹茶、暖人脾胃的温热清酒日本酿，或者是充斥烈焰气泡与柠檬片的威士忌高球酒。",
      'ja':
          "日本の飲料は、本格的なお抹茶、お猪口で酌み交わす日本酒、シュワっと清涼な喉越し極上のレモンハイボール。",
      'ko':
          "음료로는 곱게 우려 낸 녹차 말차, 따뜻하게 덥혀 즐기는 맑은 사케, 얼음에 탄산수를 섞어 속을 소화시키는 하이볼 칵테일이 인기가 있습니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Chinese
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.chinese: {
    Course.breakfast: {
      'en':
          "Mornings feature warm steaming soy milk paired with freshly fried dough sticks (Youtiao) or plump hot pork dumplings.",
      'zh': "中式清晨由刚出锅、烫口香浓的豆浆与酥脆油条开启，或者是一枚枚汁水横溢的刚蒸笼大包子。",
      'ja': "中国の朝一番は、温かい豆乳にサクサクと揚げたての油条を浸す優雅なひととき。",
      'ko':
          "아시아 식탁의 아침은 따끈하게 달인 두유에 갓 튀긴 꽈배기 빵을 비벼 먹거나, 고기 왕만두와 만두국을 즐깁니다.",
    },
    Course.lunch: {
      'en':
          "Quick fuel combines savory stir-fried noodles (Chow Mein), soft barbecued pork over rice, or individual clay pot braises.",
      'zh': "中餐午宴通常是以火气十足的炸酱面、叉烧炒饭或者是香气逼人的各式热火砂锅煲为主的快餐大锅菜。",
      'ja':
          "お昼はお腹いっぱいに。パリッと強火炒めのチャーハン、叉焼丼、熱いスープヌードルが体温を上げます。",
      'ko':
          "점심에는 고슬고슬하게 불맛 나게 볶은 소고기 볶음면이나 양념 붉은 차슈를 얹은 소스 덮밥 한 그릇이 유행합니다.",
    },
    Course.appetizer: {
      'en':
          "Starters capture flaky spring rolls, cold marinated sliced cucumber in black vinegar chili oil, or delicate shrimp dim sum.",
      'zh': "中式前菜注重口感对比，有金黄酥脆的脆炸春卷、浇上陈醋和红亮辣油的凉拌拍黄瓜，或者是滑糯的水晶虾饺皇。",
      'ja':
          "お食事前には、さっぱりキュウリのラー油和え、蒸し器からあがる熱々の小籠包やえび餃子でおもてなし。",
      'ko':
          "전채로는 완벽한 매콤함을 안기는 흑식초 마늘 拍황과 샐러드, 바삭한 춘권, 혹은 김이 모락모락 나는 딤섬 샤오롱바오가 식단을 열어 젖힙니다.",
    },
    Course.sideDish: {
      'en':
          "Side items present vibrant flash-cooked fresh garlic greens, spicy mapo tofu dishes, or braised sweet eggplants.",
      'zh': "配菜体现火功，包括金牌爆炒时令蒜蓉芥兰菜、麻辣烫口软滑的经典麻婆豆腐，或者是编织香味多汁的鱼香肉丝茄子煲。",
      'ja':
          "美味しいおかずは、強火でサッと炒めた青菜のにんにく炒め、山椒がビリリと痺れる四川の麻婆豆腐など調理技術の結晶。",
      'ko':
          "반찬 요리는 중식 특유의 웍 기술을 써 마늘 쫑볶음, 얼얼하고 부드러운 오리지널 마파두부, 소스 가지 볶음 등이 있습니다.",
    },
    Course.dessert: {
      'en':
          "Confections embrace warm sweetened black sesame glutinous rice dumplings (Tangyuan) or velvety baked yellow egg tarts.",
      'zh': "中式点心包含传统的象征圆满黑芝麻流沙汤圆、亦或者是饼屋刚出炉皮层酥折成千、奶香蛋嫩的澳门葡式蛋挞。",
      'ja':
          "おしまいは、もちもちの中に黒ごま餡がとろりとあふれる団子（湯圓）やサクサクほくほくの焼き立てエッグタルト。",
      'ko':
          "식후에는 검정 껍질 참깨 팥소가 끈적하게 터져 나오는 따뜻한 탕위안 팥죽이나 노랗게 구워낸 바삭 촉촉한 에그타르트를 시식합니다.",
    },
    Course.snack: {
      'en':
          "Street side bites involve rich pan-fried pork buns (Shengjian), charred savory egg scallion crepes (Jianbing), or spicy skewers.",
      'zh': "街头点心最具生气——锅底金黄黑焦、洒满芝麻葱花的大肉生煎包，或者是涂上黑酱甜辣酱、打上鸡蛋酥脆的杂粮煎饼果子。",
      'ja':
          "夜市で買いたいのは、鉄板で底をカリカリに焼き上げた生煎包、サクサク小麦生地の煎餅果子。",
      'ko':
          "상점가의 대표 간식은 아래는 바삭하고 위는 촉촉하게 지진 수제 생전포, 바삭한 식감의 양배추 계란 밀크 크레이프인 지안빙입니다.",
    },
    Course.drinks: {
      'en':
          "Drinks encompass elegant brewed loose leaf Pu-erh, relaxing jasmine tea pot extractions, or sweet refreshing taro boba teas.",
      'zh': "传统饮品包含清醇解脂的普洱陈茶、香气怡人的玻璃壶茉莉花茶，或者是香甜Q弹的黑糖珍珠奶茶。",
      'ja':
          "伝統的なプーアル茶、華やか香るジャスミン茶、あるいは現代の若者に熱狂的に愛されるもちもちのタピオカミルクティー。",
      'ko':
          "음료로는 식도를 맑게 청소해 주는 따스한 자스민 꽃차, 깊은 푸에르 보이차, 혹은 전 세계 트렌드가 된 시원 달콤 펄 듬뿍 버블티가 있습니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Burmese (Myanmar) — new cuisine, English baseline (renders for the
  // 'my' UI locale too via the en fallback)
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.burmese: {
    Course.breakfast: {
      'en':
          "Burmese mornings open with Mohinga — a fish-broth rice noodle soup ladled over crisp shallots, banana stem, and a squeeze of lime — eaten standing at neighbourhood stalls.",
      'my':
          "မြန်မာ့မနက်ခင်းကို မုန့်ဟင်းခါးနဲ့ စတင်တယ်။ ငါးပြုတ်ရည်ထဲကို ဆန်မုန့်တွေထည့်၊ ကြက်သွန်ဖြူကြော်၊ ငှက်ပျောတည်နဲ့ သံပုရာဖျော်ရည် ထည့်စားရတဲ့ ဆိုင်ပြန့်ပြန့်ရှေ့မှာ မတ်တပ်ရပ်စားကြတယ်။",
    },
    Course.lunch: {
      'en':
          "Lunch is a banquet built around a centre bowl of rice, surrounded by a sour fish curry (Mohinga's cousin), Hin Joe lentil broth, raw vegetable Lethok salad, and ngapi fermented shrimp dip.",
      'my':
          "နေ့လည်စာက ဆန်ထမင်းပေါ်မှာ စားရတဲ့ ပန်းကန်ပွဲဖြစ်ပြီး ငါးဟင်းရည်ချဉ်၊ ဟင်းရွက်ပြုတ်၊ လက်သုပ်နဲ့ ငါးပိချက်တွေနဲ့ အပြည့်အစုံ စားရတယ်။",
    },
    Course.appetizer: {
      'en':
          "Starters celebrate Lethok — a tea-leaf or tomato salad tossed with fried garlic, peanuts, chickpeas, and dried shrimp — eaten by hand with friends.",
      'my':
          "ပထမဆုံးတည်ခင်းတဲ့ဟာက လက်ဖက်သုပ်၊ ခရမ်းချဉ်သီးသုပ်တွေဖြစ်ပြီး ကြက်သွန်ဖြူကြော်၊ မြေပဲ၊ ပဲကြော်နဲ့ ဂျင်းငါးခြောက်ကို ထည့်ပြီး လက်နဲ့ပဲ ဖော်စားကြတယ်။",
    },
    Course.sideDish: {
      'en':
          "Sides are an ensemble: balanced Hin Cho (boiled vegetable broth), tart Chin Yay sour soup, raw vegetable platters with ngapi dip, and seasonal pickles.",
      'my':
          "အပိုဟင်းပွဲတွေက ဟင်းချို၊ ချဉ်ရည်၊ ငါးပိချဉ်ပြုတ်စားရတဲ့ စိမ်းသီးစုံ၊ နဲ့ ရာသီပေါ်ချဉ်ပိုက်တွေ ဖြစ်တယ်။",
    },
    Course.dessert: {
      'en':
          "Sweets favour the tea-house staple Mont Lone Yay Paw — sticky rice balls filled with palm sugar — and Sanwin Makin, a buttery semolina cake topped with sesame and poppy seeds.",
      'my':
          "အချိုပွဲတွေထဲမှာ မုန့်လုံးရေပေါ်က ဆန်စေ့ထဲ ထန်းလျက်ထည့်ထားတဲ့ ထုံးစံအချိုဖြစ်ပြီး၊ ဆနွင်းမကင်းက ထောပတ်နဲ့ နှမ်းနဲ့လုပ်ထားတဲ့ ဆန်ပြုတ်မုန့်ဖြစ်တယ်။",
    },
    Course.snack: {
      'en':
          "Street snacks include Pe Pyot (chickpea fritters), E Kya Kway (Chinese-style crispy crullers), and skewered grilled meats from charcoal stalls.",
      'my':
          "လမ်းဘေးသရေစာတွေထဲမှာ ပဲကြော်၊ အီကြောက္ကွေး၊ နဲ့ မီးကင်ထားတဲ့ အသားတုတ်တွေ ပါဝင်တယ်။",
    },
    Course.drinks: {
      'en':
          "Drinks revolve around La Phet Yay — strong sweetened black tea with condensed milk — and the cool agar jelly drink Shwe Yin Aye for sweltering afternoons.",
      'my':
          "သောက်စရာတွေထဲမှာ လက်ဖက်ရည်ကြမ်းကို နို့ဆီနဲ့ ထည့်သောက်ရတဲ့ လက်ဖက်ရည်နဲ့၊ ပူနေတဲ့မွန်းလွဲခင်းမှာ အေးအေး တောက်ပတဲ့ ရွှေရင်အေး တို့ဖြစ်တယ်။",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Thai
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.thai: {
    Course.breakfast: {
      'en':
          "Thai mornings begin with Jok creamy rice congee, or savory caramelized charcoal-grilled pork (Moo Ping) with sweet sticky rice.",
      'zh': "泰式清晨常由舒适暖胃的泰式肉丸米粥或者街头极受欢迎的甘甜焦脆炭烤香猪肉串配手抓糯米饭开启。",
      'ja':
          "一日のスタートは、柔らかく炊いた温粥ジョーク、または甘辛だれをまとった豚串ムーピンをもち米と一緒に。",
      'ko':
          "태국인들의 아침은 잘게 다진 부드러운 생강채와 고기볼을 얹은 따뜻한 쌀죽 '족'을 먹거나 구운 돼지꼬무핑에 카오니아우 한 입으로 시작합니다.",
    },
    Course.lunch: {
      'en':
          "Thai lunch is fast, fiery, and customizable—Pad Thai, aromatic noodle soups like Tom Yum, or Pad Kra Prow topped with a crispy egg.",
      'zh': "泰式午餐追求速度、火候和极致味道——泰式炒河粉、酸辣开胃的冬阴功汤面，或者经典的罗勒叶碎肉炒饭铺上一颗焦边煎蛋。",
      'ja':
          "ランチは人気米粉麺焼きパッタイ、ハーブ満載辛酸っぱいトムヤムラーメン、ホーリーバジルのガパオライス！",
      'ko':
          "태국의 점심은 단연 볶음 쌀국수인 팟타이나 다진 고기 바질 볶음밥 '팟카프라오'에 튀기듯 조리한 계란후라이를 비벼 먹습니다.",
    },
    Course.appetizer: {
      'en':
          "Thai starters are a playful explosion—crispy Spring Rolls, spicy fish cakes rich in red curry, or char-grilled satay skewers.",
      'zh': "泰式开胃菜在舌尖爆开——表皮金黄焦脆的香炸春卷、混入泰式红咖喱泥的Q弹香煎炸鱼饼，或者肥美多汁的沙爹炭烤鸡肉串配浓郁花生酱。",
      'ja':
          "さくさくの春巻き、ハーブ香るトードマンプラー、甘口ピーナッツソースに浸す芳醇な鶏ささみサテで笑顔に。",
      'ko':
          "태국의 전채 요리는 미각의 기분 좋은 자극입니다. 스프링롤, 특유의 향이 쫄깃하게 씹히는 수제 어묵튀김토드만플라, 혹은 달콤한 사테 땅콩 소스에 찍어 먹는 닭고기 꼬치가 있습니다.",
    },
    Course.sideDish: {
      'en':
          "Thai dining presents vibrant side dishes to share—the world-famous green papaya salad blending sweet, sour, salty, and spicy.",
      'zh': "泰式正餐通常以极富感染力的分享沙拉打底——举世闻名的青木瓜沙拉，将酸、甜、咸、辣四重风味在研钵中捣合出的极致爆发力。",
      'ja':
          "食卓の中心には、ライムとにんにく、唐辛子ですりこぎで青パパイヤを叩き和える究極ヘルシーサラダソムタム。",
      'ko':
          "태국의 대표 반찬은 상큼함과 화끈함의 극치입니다. 그린 파파야 샐러드인 '솜탐'은 마늘과 고추, 라임즙, 피시소스의 수북한 맛을 살려 다른 부드러운 요리와 함께 나누어 먹습니다.",
    },
    Course.dessert: {
      'en':
          "Thai desserts are cooling—the beloved sweet Sticky Rice with ripe yellow Mango drenched in salted rich coconut cream.",
      'zh': "泰式温润甜点享誉世界——备受喜爱的芒果椰香糯米饭，温热软糯的甜米饭配上甘甜的金芒果，浇入带微咸的浓郁椰面乳浆。",
      'ja':
          "甘いもち米に濃厚ココナッツソースを絡め、ジューシーな完熟マンゴーを贅沢に伴わせた究極デザートマムアンもち米。",
      'ko':
          "가장 널리 알려진 '망고 찰밥'은 소금으로 마감한 코코넛밀크를 찹쌀밥에 부은 뒤, 차갑게 발라낸 신선한 황금 망고와 바삭한 볶은 녹두를 올려 만듭니다.",
    },
    Course.snack: {
      'en':
          "Afternoons feature crispy sweet banana fritters, sweet roti stretched with sweetened condensed milk, or local satays.",
      'zh': "午后小憩伴随着香脆无比的泰式椰香炸香蕉、或者在黄油上煎得酥松的香煎饼卷炼乳，淋上香浓的巧克力酱。",
      'ja':
          "屋台でおばちゃんが手際よく焼く、練乳てんこもりの甘口クレープ「ロティ」や、ココナッツ衣をまとった熱々揚げバナナが王道。",
      'ko':
          "바삭하게 튀겨낸 코코넛 반죽의 튀긴 바나나(글루아이객), 혹은 철판 위에서 마가린에 밀어 부풀리고 연유와 도톰한 누텔라 초코를 코팅한 타이 로티를 가볍게 사 가곤 합니다.",
    },
    Course.drinks: {
      'en':
          "Thai beverages feature iconic orange sweet Thai Iced Tea (Cha Yen) with condensed milk, or cool refreshing young Coconut Juice.",
      'zh': "泰式冰饮带来极致满足——由红茶和八角碰撞出标志性的亮橙色泰式冰奶茶融入醇厚奶香，或者是原只冰凉清甜的嫩椰子水。",
      'ja':
          "深く強いお茶のボディに練乳をあふれるほど足してキンキンに冷やした、夕日色ミルクティーチャーイェン。",
      'ko':
          "태국의 대표 음료는 오렌지빛 감미로움의 극치인 '차옌'입니다. 고풍스러운 타이 티 베이스에 듬뿍 넣은 연유와 우유층이 얼음 위에 들이닥치며 더위를 시원하게 씻깁니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Vietnamese — new cuisine, English baseline
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.vietnamese: {
    Course.breakfast: {
      'en':
          "Vietnamese mornings are inseparable from a steaming bowl of Phở — rice noodles in star-anise beef broth, garnished with herbs, bean sprouts, and a squeeze of lime.",
      'vi':
          "Bữa sáng Việt gắn liền với tô phở nóng — bánh phở trong nước dùng bò ninh hồi quế, ăn kèm rau thơm, giá đỗ và vắt chanh.",
    },
    Course.lunch: {
      'en':
          "Lunch turns to Bún Chả: grilled pork patties over rice vermicelli with herbs and nước chấm dipping sauce, or a quick Cơm Tấm broken-rice plate with grilled chops.",
      'vi':
          "Bữa trưa thường là bún chả với chả nướng và bún tươi, rau sống cùng nước chấm, hoặc đĩa cơm tấm sườn nướng nhanh gọn.",
    },
    Course.appetizer: {
      'en':
          "Starters celebrate Gỏi Cuốn — fresh translucent rice-paper rolls with shrimp, pork, and herbs — and crispy Chả Giò fried spring rolls.",
      'vi':
          "Khai vị gồm gỏi cuốn tươi với tôm, thịt và rau thơm, và chả giò chiên giòn rụm chấm nước mắm pha.",
    },
    Course.sideDish: {
      'en':
          "Sides keep palates bright — pickled carrot-daikon Đồ Chua, herb plates of mint and Thai basil, and chilli-lime dipping sauces.",
      'vi':
          "Món phụ giữ vị tươi mát — đồ chua cà rốt củ cải, đĩa rau thơm bạc hà húng quế và chén nước chấm chanh ớt.",
    },
    Course.dessert: {
      'en':
          "Chè is the daily sweet — warm or iced bean-and-jelly puddings layered with coconut milk — and Bánh Flan, a French-influenced caramel custard.",
      'vi':
          "Tráng miệng là chè — đậu đỗ và thạch chan nước cốt dừa nóng hoặc đá — và bánh flan caramen ảnh hưởng Pháp.",
    },
    Course.snack: {
      'en':
          "Bánh Mì keeps the afternoon going: a crackling baguette stuffed with pâté, pickles, herbs, and grilled meats, born from a Vietnamese-French dialogue.",
      'vi':
          "Bánh mì giữ buổi chiều no nê — vỏ giòn nhân pa-tê, đồ chua, rau thơm và thịt nướng, kết tinh giao thoa Việt-Pháp.",
    },
    Course.drinks: {
      'en':
          "Cà Phê Sữa Đá — strong drip coffee over a thick layer of sweetened condensed milk poured onto crackling ice — is the country's signature pour.",
      'vi':
          "Cà phê sữa đá — cà phê phin đậm rót lên lớp sữa đặc dày, đổ ra ly đá lạnh — là thức uống biểu tượng.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Indian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.indian: {
    Course.breakfast: {
      'en':
          "Indian breakfasts are regional—savory spiced potato-filled Dosas in the South, versus hot potato-stuffed flatbreads (Paratha) with cold yogurt and pickles in the North.",
      'zh': "印度早餐充满地域特色——南部是塞满香料土豆泥的松脆多萨大饼（Dosa）佐椰子酱；北部则是油香的土豆馅饼（Paratha）配冰凉酸奶。",
      'ja': "南の巨大香ばしいクレープドーサ、または北のスパイスポテトをバターで焼くパラタの幸福。",
      'ko':
          "남부에서는 얇은 크레프에 매콤한 감자 소를 채운 '도사'를 코코넛 소스에 찍어 먹고 북부에서는 납작 부침 빵인 '파라타'에 시원한 요거트를 곁들입니다.",
    },
    Course.lunch: {
      'en':
          "Lunch is legendary via Thali—a large silver platter serving small bowls of lentil dal, curry, basmati rice, and crispy naan.",
      'zh': "印度正规午餐是以Thali（大圆盘餐）为黄金法则——盘中装满一圈小碗，盛装黄扁豆泥、各式香辣咖喱、修长的香米饭、松脆豆饼和黄油馕。",
      'ja':
          "大きめの金属皿ターリーの真ん中で、数種類のコク旨カレー、焼き立て薄焼きチャパティやナンをちぎりながら大満足ランチ。",
      'ko':
          "커다란 둥근 금속 쟁반 위에 노란 렌틸콩 수프, 매콤한 카레 종류, 기다란 인디카 바스마티 쌀밥, 바삭한 난 등을 둘러 즐깁니다.",
    },
    Course.appetizer: {
      'en':
          "Starters showcase samosas—crispy pastry triangles stuffed with mashed potatoes and dry peas, dipped in spicy tamarind sauce.",
      'zh': "开胃菜是辛香料的集散地，如松脆酥皮里包着香辛料土豆泥与豌豆的经典三角饺（Samosa），蘸上酸甜的罗望子沙司。",
      'ja':
          "熱烈なおもてなしはスパイシー三角餃子サモサ。にんにくとクミン、ターメリックで練ったポテト餡がぎっしり。",
      'ko':
          "가장 대중적인 세모난 만두 '사모사'에는 카레 향 감자와 완두콩 소가 가득 차 있어 기분을 올립니다.",
    },
    Course.sideDish: {
      'en':
          "Sides include cooling cucumber yogurt (Raita), spicy red onion salad, or dry sautéed cauliflower and potatoes (Aloo Gobi).",
      'zh': "常伴配菜有用以中和辣度的冰镇小黄瓜酸奶（Raita）、辛辣洋葱圈，或者是干煸炒熟的土豆花椰菜（Aloo Gobi）。",
      'ja': "ピリりとスライスした玉ねぎを冷たいライタ（ヨーグルト）で口に潤いを与えます。",
      'ko':
          "매콤함을 달래 주는 오이 요거트 샐러드 '라이타', 레몬과 마살라 가루를 뿌린 매운 적양파가 상에 오릅니다.",
    },
    Course.dessert: {
      'en':
          "Sweets are sweet and rich—syrup-soaked deep-fried milk flour balls (Gulab Jamun), or saffron cream milk reduction patties (Rasmalai).",
      'zh': "糖水铺的甜点奢华高甜，最为突出的是炸透后浸入玫瑰糖浆中、香脆奶香球，以及浸在藏红花甜淡奶里的乳酪软饼。",
      'ja': "ミルク粉末を丸めて揚げてハニーシロップに漬け込んだ、舌がとろけるグラブ・ジャムン。",
      'ko':
          "튀겨 장미 시럽에 절인 따뜻한 '굴랍자문', 샤프란 향 우유크림에 커티지 치즈볼을 적신 차가운 '라스말라이' 등이 있습니다.",
    },
    Course.snack: {
      'en':
          "Street snacks feature Pani Puri—crispy hollow balls filled with spiced tamarind water and mashed potatoes.",
      'zh': "街边查特最具风气，要属敲碎后灌入绿薄荷辣酸汤和鹰嘴豆泥、一口一个的黄金小空心脆球（Pani Puri）。",
      'ja': "中空のプチ揚げパンにスパイス塩水たに。ポテトを詰めるパニプリ。",
      'ko':
          "동그랗게 튀겨 구멍을 낸 푸리 볼 안에 매콤새콤한 수프 액상과 감자를 짜 넣어 맛봅니다.",
    },
    Course.drinks: {
      'en':
          "Drinking focuses on Mango Lassi (sweet cold yogurt drink topped with pistachios), or rich steaming cardamom Masala Chai.",
      'zh': "消暑特调以搅拌丝滑、顶上撒满开心果碎的甜果香芒果拉西，或者是小铜杯精心拉打出的传统豆蔻香料热奶茶。",
      'ja': "完熟マンゴーを贅沢にヨーグルトシェイクマンゴーラッシー、生姜マサラチャイ。",
      'ko':
          "인도의 대표 주스는 수제 요거트 스무디 형태의 보드라운 '망고라씨'입니다. 따뜻한 '마살라 차이'도 유행합니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Italian
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.italian: {
    Course.breakfast: {
      'en':
          "Traditional Italian breakfast is brief at local bars—a hot espresso slot coupled with a fresh sweet custard Cornetto.",
      'zh': "意式早餐在清晨咖啡店解决——一杯浓郁起油的经典浓缩咖啡，佐上一只塞满香甜甜乳的牛角包。",
      'ja':
          "朝の始まりは最寄りのバールで。立ち飲みですする濃密熱々エスプレッソに、カスタード角パンコルネット。",
      'ko':
          "이탈리아의 아침은 골목 카페 바에서 시작됩니다. 에스프레소 한 잔에 빵 '코르네토'를 곁들입니다.",
    },
    Course.lunch: {
      'en':
          "Lunch rewards simple fresh-cooked pasta tossed in extra virgin olive oil, sweet local garlic, or wood-fired Roman flat sheets.",
      'zh': "意大利人绝不亏待午餐——往往是一大盘弹到牙尖的香滑意粉，只拌入上等金绿初榨橄榄油与大瓣嫩蒜。",
      'ja':
          "茹でたてのコシを大切に。上質オリーブオイルと潰しにんにくを乳化させたシンプルな絶品オイルスパゲティ。",
      'ko':
          "점심 식사 시간은 파스타의 영혼을 기립니다. 올리브오일과 다진 마늘의 풍미를 극한으로 살려 볶아 촉촉한 파스타를 즐깁니다.",
    },
    Course.appetizer: {
      'en':
          "Starters include razor-thin Prosciutto hams, milky mozzarella balls, or garlic bruschetta topped with sweet baseline herbs.",
      'zh': "开胃前盘包含了亮红薄透的帕尔马生火腿肉卷、奶汁流淌的水鲜干酪，以及涂满清香罗勒碎的香烤硬面包片。",
      'ja':
          "とろける水牛乳の白いチーズ、生ハムを贅沢に。そして香ばしく焼いたバゲットに完熟スライストマトを山盛りのブルスケッタ。",
      'ko':
          "이탈리아의 개별 전채는 오감을 자극합니다. 얇게 썬 생햄(프로슈토), 완숙 토마토와 올리브유를 버무려 올린 '브루스케타'를 공유합니다.",
    },
    Course.sideDish: {
      'en':
          "Sides focus on fire-roasted summer zucchinis slathered in balsamic caramel glaze, fanny salads, or garlic rosemary potatoes.",
      'zh': "伴碟清爽大方，有淋上陈年木桶苹果醋汁、烤到略带黑斑的嫩夏南瓜片，或者是撒了迷迭香被热油爆灼的小嫩马铃薯球。",
      'ja': "ズッキーニをグリルして熟成黒ブドウ酢を大さじ一杯。ポテトにはローズマリーとオリーブのオイルを。",
      'ko':
          "이탈리아의 야채 요리는 오븐에 구워 발사믹 식초를 뿌린 주키니 호박과 알감자가 대표적입니다.",
    },
    Course.dessert: {
      'en':
          "Confections are globally requested—such as creamy coffee espresso tiramisu cake surfaced with rich velvet cacao powders.",
      'zh': "甜点名扬四海，以极高人气的正统卡布提拉米苏为代表——交替铺叠乳脂干酪与厚可可末。",
      'ja': "エスプレッソが染みた生地にリッチなマスカルポーネクリームを敷いてココアをふったティラミス。",
      'ko':
          "대표적인 단 고명은 커피와 리큐어를 적시고 마스카포네 치즈 크림을 얹어 무가당 코코아 파우더로 마감한 정통 '티라미수'가 채웁니다.",
    },
    Course.snack: {
      'en':
          "Bites include hot fried saffron rice balls stuffed with melting ragu beef mins and cheese strings (Arancini), or pressed panini.",
      'zh': "深夜小充饥，多是街坊推车里大油锅滚炸出西西里炸米团（Arancini）。",
      'ja':
          "お腹の隙間を塞ぐのは、中からとろりとモッツァレラが溶け出す至福のシチリア風揚げサフランご飯ボールアランチーニ。",
      'ko':
          "밤을 대표하는 뜨끈한 간식은 사프란 향 볶음밥 안에 소고기 라구 소스와 치즈를 뭉쳐 둥글게 튀겨낸 '아란치니' 수제 크로켓이 담당합니다.",
    },
    Course.drinks: {
      'en':
          "Drinking celebrates Aperitivo bubbly Aperol Spritz alongside heavy olives, campari, or chilling citrus digestifs like Limoncello.",
      'zh': "饮酒活动始于傍晚的餐前秀——亮橘色阿佩罗特调泡上一枚咸酸橄榄，或者是饭后用烈酒冰冻、挂杯蜡香的大黄柠檬蜜露。",
      'ja':
          "アペリティーボで始まる夕暮れ。目にも鮮やかな赤いアペロール・スプリッツに、甘酸っぱく冷えたレモンリキュールリモンチェッロ。",
      'ko':
          "초저녁 분위기는 주황빛 오렌지 껍질 베이스의 '아페롤 스프릿츠'와 식후 소화를 돕는 '레몬첼로'가 있습니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // American / Western
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.americanWestern: {
    Course.breakfast: {
      'en':
          "Classic American morning stacks fluffy golden buttermilk pancakes with maple syrup, smoked bacon, scrambles, and hot black coffee.",
      'zh': "美餐早宴量大油亮，有一摞沾满枫树糖和软化黄油的酪乳烤煎饼、培根肉、炒得松散的牛奶滑蛋和滴滤咖啡。",
      'ja': "厚みのある円いパンケーキにメープルを回しかけ、カリカリベーコンに目玉焼き、マグの熱々ドリップ。",
      'ko':
          "미국식 아침은 버터밀크 팬케이크를 구워 달콤한 메이플 시럽을 흘러넘치게 뿌리고 커피 한 잔으로 시작합니다.",
    },
    Course.lunch: {
      'en':
          "Lunch centers on towering Double Cheeseburgers, Reuben corned beef wraps, or crispy breast chicken tenders with french fries.",
      'zh': "美式午间常选择多汁双层芝士牛肉汉堡或者是面包夹烟熏肉跟薯条。",
      'ja': "大きな口を開けてガブリ。滴るチーズのダブルバーガーに、ピクルス、あつあつ金色のポテトフライ山盛り。",
      'ko':
          "점심에는 육즙 가득 스매시 패티 치즈버거류, 얇게 저민 소고기와 스위스 치즈를 얹은 샌드위치가 널리 쓰입니다.",
    },
    Course.appetizer: {
      'en':
          "Starters focus on Buffalo chicken wings in spicy cayenne pepper glaze and creamy blue cheese, onion rings, or stuffed potato skins.",
      'zh': "前菜有醋酸热辣的红椒奶油炸鸡翅（Buffalo Wings）、油炸辣酥脆大洋葱圈。",
      'ja':
          "バーやスポーツ観戦で。赤いスパイシーソースをまとった手羽先バッファローウィングをブルーチーズソースに。",
      'ko':
          "전채 요리는 매콤하고 자극적인 핫 소스에 버무려 낸 바삭한 버펄로 윙을 고소한 블루치즈 디핑 소스에 찍어 먹는 것이 즐겁습니다.",
    },
    Course.sideDish: {
      'en':
          "Sides represent yellow Cheddar macaroni and cheese bakes, cold cabbage Coleslaw, or sweet whole corn on the cob rubbed with melting butter.",
      'zh': "佐餐由烤出焦油芝士泡的切达通心粉（Mac & Cheese），或者是涂抹黄油的甜玉米段。",
      'ja':
          "メインを脅かす濃厚マカロニチーズ、一息つかせてくれる酸味甘みの冷たいコールスロー、バター焼きトウモロコシ。",
      'ko':
          "주된 가니시는 체다 치즈를 버무려 오븐에 꾸덕꾸덕 구운 '맥앤치즈', 마요네즈에 버무린 달콤 아삭한 양배추 '코울슬로'가 지배합니다.",
    },
    Course.dessert: {
      'en':
          "Pies are traditional—fragrant cinnamon baked Apple Pie under butter lattices, served warm under vanilla cold cream scoops.",
      'zh': "甜点则是美式精神支柱的手工格纹苹果香木桂甜热派，配上一球纯牛乳香草冰淇淋。",
      'ja': "シナモンが華麗に香る焼き立てアップルパイ。温かいリンゴ果肉に白いバニラアイスを落として。",
      'ko':
          "시그니처 디저트는 '애플파이'입니다. 시나몬 사과에 격자 페이스트리 피로 가두고 갓 구워 차가운 바닐라 아이스크림을 올려 만듭니다.",
    },
    Course.snack: {
      'en':
          "Quick eats feature crisp yellow golden corn dogs, beef mince nachos topped with warm nacho cheese, or warm pretzels.",
      'zh': "下午能量主要乡村炸热狗或者是一盘带有洋葱与融化切达芝士的烘烤玉米角片（Nachos）。",
      'ja': "片手でもちもちかじる巨大塩プレッツェル、コーンドッグ。",
      'ko':
          "가벼운 스낵으로는 소시지에 옥수수가루 반죽을 입혀 튀긴 '콘도그', 또띠아 나초 칩 위에 치즈를 산처럼 부은 나초가 있습니다.",
    },
    Course.drinks: {
      'en':
          "Cool hydration encompasses fresh pressed squeeze lemonades on ice, sweet black sarsaparilla root beer floats, or visual milkshakes.",
      'zh': "冰凉止渴首选一扎大刨冰清柠泡水，或者是冷饮圣品沙士根啤伴有香草雪球的漂浮汽水（Root Beer Float）。",
      'ja':
          "喉を潤す極上レモネード。アメリカンの青春が詰まったハーブ風黒い独特炭酸ドリンクルートビアフロート。",
      'ko':
          "시원한 드링크로는 레몬을 착즙해 단맛 시럽을 넣은 수제 '레모네이드', 갈색 루트비어 음료 위에 바닐라 아이스크림을 얹은 플로트가 유명합니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // Mexican
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.mexican: {
    Course.breakfast: {
      'en':
          "Mexicans startup with 'Huevos Rancheros'—fried eggs over crisp corn tortillas slathered with red salsa and black frijoles beans.",
      'zh': "早餐热气腾腾，有经典的牧场蛋，将烘出的热面饼垫底、敲入一对半熟流黄太阳蛋，淋满番茄和辣椒剁酸酱。",
      'ja': "トルティーヤに完璧なサニーサイドアップを２枚。上から特製赤いトマトサルサを豪快に。",
      'ko':
          "이국적인 멕시코식 아침은 계란후라이를 올리고 그 위로 아보카도와 매콤한 토마토 고추 멕시칸 살사를 칠해 먹는 '우에보스 란체로스'가 유명합니다.",
    },
    Course.lunch: {
      'en':
          "Lunch brings smoky street tacos with season beef mince and lime slices, or huge burritos with black beans and avocado salsa.",
      'zh': "午饭时间人们选择碳烤肉碎塔科夹饼，或者是夹有多汁黑豆和熟牛油果的大包卷饼（Burrito）。",
      'ja':
          "お昼はお肉屋台のタコス。牛肉やチキンを刻みパセリとライムで引き締めて。重厚なブリトーも人気満点。",
      'ko':
          "점심은 카르네 아사다 소고기에 하얀 양파, 고수를 가득 얹은 스트리트 타코를 맛보거나, 빈스 가득한 부리또를 먹습니다.",
    },
    Course.appetizer: {
      'en':
          "Starters focus on golden corn chips dipped in fresh made mashed lime green Guacamole, or red tomato spicy pico de gallo.",
      'zh': "中置前菜是老少皆宜的玉米烘烤三角脆片（Tortilla Chips），在碗里捣烂一整颗绵香牛油果泥伴着西红柿碎酱拌吃。",
      'ja':
          "出来立てでサクサク軽い金スナックに、大粒のアボカド、塩、ライムをマッシュしたワカモレをたっぷりと。",
      'ko':
          "전채로는 아보카도를 으깨어 라임, 다진 토마토, 소금을 넣고 구수하게 빚은 아기자기한 '과카몰리'를 나초 칩스에 찍어 만족스럽게 나눕니다.",
    },
    Course.sideDish: {
      'en':
          "Sides feature Elote (charred dynamic corn rub with mayonnaise chipotle and cotija white grated dry cheese sprinkles).",
      'zh': "伴碟是以最著名的马路烤玉米段（Elote），全身抹匀辣沙酱并裹上香乳酪。",
      'ja': "香ばしいエローテ（トウモロコシの屋台グリル）。特製マヨをこすって白いコティハ粉チーズを。",
      'ko':
          "인기 가니시는 옥수수에 매콤한 치폴레 마요네즈와 순백의 고티하 치즈 가루를 문지른 멕시코식 '엘로테' 구이가 유명합니다.",
    },
    Course.dessert: {
      'en':
          "Sweet eats center on crunchy piping-hot stellar churros dipped in warm chili spiced cocoa dark chocolate sauce.",
      'zh': "高糖餐尾属于刚出滚油大门、撒满焦赤肉桂粉糖的西班牙油条，一定要泡在融化的巧克力热浆里吃。",
      'ja': "カリサクもちもちの細長い揚げ菓子チュロスを温かいチョコレートにダイブ。ぷるぷるフランも最高。",
      'ko':
          "디저트는 계피 설탕에 굴린 바삭하고 뜨거운 '츄러스'를 진득한 칠리 가미 초콜릿 스프레드에 찍어 먹어 정열적으로 가꿉니다.",
    },
    Course.snack: {
      'en':
          "Afternoons include folding quesadillas loaded with chicken shreds under melting mozzarella cheese layers inside toasted tortillas.",
      'zh': "下午充饥可以切一两片两面烘得焦红脆香的凯萨薄壳干酪饼（Quesadilla），死死裹裹着手撕鸡丝和多汁芝士条。",
      'ja': "トルティーヤに大量のシュレッドチーズとお肉を挟んでグリルし、三角状に切り分けたケサディーヤ。",
      'ko':
          "간식으로는 또띠아 안에 치즈와 양념 닭고기를 가득 넣고 반으로 접어 그릴에 지져 겉바속촉 멜팅한 '퀘사디아'가 좋습니다.",
    },
    Course.drinks: {
      'en':
          "Thirst quenchers incorporate sweet milky rice milk seasoned with cinnamon (Horchata), or icy classic lime salted Margaritas.",
      'zh': "凉透胃底的圣品是用精珍珠白米碾磨并洒满肉桂粉的墨西哥白米露（Horchata），或者是一杯杯加粗盐杯边的柠檬马格丽特鸡尾酒。",
      'ja': "米と微細アーモンドを乳化させてシナモンで仕立てた、すっきり白甘清涼オルチャータ。",
      'ko':
          "청량 음료는 이색적인 쌀 음료 '오르차타'가 흔합니다. 시나몬 가루를 섞어 구수하게 잔에 담아내며 더위 탈출에 최적입니다.",
    },
  },

  // ─────────────────────────────────────────────────────────────────────
  // French
  // ─────────────────────────────────────────────────────────────────────
  Cuisine.french: {
    Course.breakfast: {
      'en':
          "French breakfasts focus on butter flaky croissants and baguette slices with raspberry jams, coupled with cafe au lait.",
      'zh': "精致晨间包含层层掉酥、浓香四溢的法式黄金黄油牛角包，以及酥硬有嚼劲的法棍切片铺果酱，配大碗法拿铁欧蕾咖啡。",
      'ja':
          "熱々のサクサクのクロワッサンに、バターをたっぷり吸わせたバゲットを、大きなカフェボウルにひたして味わう贅沢。",
      'ko':
          "아침은 바삭하고 노란 결을 살려 구운 최고급 명품 크루아상, 바게트를 반으로 갈라 잼을 바른 것을 카페오레와 함께 즐깁니다.",
    },
    Course.lunch: {
      'en':
          "Lunch leverages hot pressed Croque Monsieur sandwiches loaded with ham slices and molten emmental cheese under milk cream.",
      'zh': "午饭由著名的库克二式烤面包片承接，里面夹满咸鲜熏火腿并铺满芝士碎，表面浇上浓稠白贝夏美奶酱，上炉焗到起泡变金黄。",
      'ja':
          "ハムと極厚チーズを挟み、極上ホワイトベシャメルをたっぷりかけてオーブンで焼いた大定番のクロックムッシュ。",
      'ko':
          "점심에는 고소한 백색 베샤멜 소스를 바르고 치즈를 채워 그릴에 구워내어 부풀린 '크로크무슈' 샌드위치가 단골 메뉴입니다.",
    },
    Course.appetizer: {
      'en':
          "Starters focus on Caramel Onion Soup topped with bread sheets and bubbly gratin gruyere, or garlic snails (Escargots).",
      'zh': "法式前菜是其金牌手艺所在，有一碗小火焦糖化数小时的洋葱浓汤铺上网烧奶香芝士、或者是滋滋作响草香大蒜油煨焗蜗牛。",
      'ja':
          "時間をかけて飴色にソテーした玉ねぎスープをクルトンとチーズで蓋して焼いたオニオンスープやエスカルゴ。",
      'ko':
          "식전 요리로 캐러멜화 수프를 끓여 프랑스식 바게트와 치즈를 올려 구워 낸 '프렌치 어니언 수프', '달팽이 구이'가 명물입니다.",
    },
    Course.sideDish: {
      'en':
          "Sides celebrate slow-simmered Provencal veggie medley (Ratatouille), or creamy potato slide bakes (Gratin Dauphinois).",
      'zh': "配菜极尽优雅地保护好每片蔬菜的原汁口感，如源自乡村、把西葫芦彩椒和黑亮茄子切薄片螺旋码好煨入香草茄汁的炖菜。",
      'ja':
          "色鮮やか季節夏野菜をトマトと香草オイルで蒸し煮にしたラタトゥイユ。ポテトグラタンも脇役の一流。",
      'ko':
          "프랑스의 대표 반찬은 야채찜 '라타투이'입니다. 주키니 호박과 가지를 얇게 슬랍하여 오븐에 촉촉이 익혀냅니다.",
    },
    Course.dessert: {
      'en':
          "Patisserie is world-famous—such as thin golden crepes, or Creme Brulee featuring cracked fire-caramelized sugar glazed sugar tops.",
      'zh': "法式烘焙甜点是其名片：由火焰枪瞬间在香草蛋羹表面烤出一层玻璃般黄赤、一敲就破的硬糖层，内里如豆腐般冰凉细嫩的烤布蕾。",
      'ja': "表面のカチカチの砂糖焦がしをスプーンでパリンと割って食べる口溶けクレームブリュレ。",
      'ko':
          "인기 제과는 도자기 볼 안에 사각사각 구운 붉은 캐러멜 유리를 이식하고 숟가락 끝으로 탁 깨어 먹는 '크렘 브륄레'와 '크레페'입니다.",
    },
    Course.snack: {
      'en':
          "Snacks embrace buttery savory puff pastries packed with bacon and hot eggs (Quiche Lorraine), or sweet butter madeleines.",
      'zh': "午后饭甜咸茶点，极具说服力的是洛林培根芝士大派，派皮奶层丰沃，或者是刚脱了模子、带着饱胀肚脐和大壳外观的香柠檬贝壳蛋糕。",
      'ja': "黄金パイの中にベーコン、チーズ、たっぷりのフワ卵液を重ねて焼いたキッシュにうっとり。",
      'ko':
          "나른한 오후 간식은 페이스트리를 고집합니다. 베이컨 기름과 계란 우유 믹스를 수북하게 부어 구워낸 '키슈 로렌'과 마들렌이 좋습니다.",
    },
    Course.drinks: {
      'en':
          "Drinking is delicate Bordeaux red wines, sparkling crisp Champagne bubbles, or slow-poured royal Dark Hot Chocolate.",
      'zh': "饮品文化跨度极广——可以是细品一口波尔多列级庄红酒优雅醇涩、举杯欢度时开瓶泡沫不绝的顶级香槟，或者是御用香浓热巧克力饮。",
      'ja': "上品なヴィンテージの「ボルドー赤ワイン」、記念日の「シャンパン」、本格「ショコラショー（ココア）」。",
      'ko':
          "음료 문화는 오랜 기간 숙성된 '보르도 레드 와인', 별가루 기포가 솟는 '샴페인', 그리고 걸쭉하게 달인 '쇼콜라 쇼(프렌치 핫초코)'로 대변됩니다.",
    },
  },
};

/// Lookup helper with graceful fallback. If the exact ([cuisine], [course],
/// [langCode]) triple is missing, falls back to English; if English itself
/// is missing returns `null` (caller decides what to render).
String? storyFor(Cuisine cuisine, Course course, String langCode) {
  final byCourse = crossCulturalStories[cuisine];
  if (byCourse == null) return null;
  final byLang = byCourse[course];
  if (byLang == null) return null;
  return byLang[langCode] ?? byLang['en'];
}

/// Cuisines that have at least one cross-cultural story panel. Used to
/// decide whether to render the heritage card at all when a specific
/// cuisine is selected — cuisines with no entries simply hide the section.
bool hasStoriesFor(Cuisine cuisine) =>
    crossCulturalStories[cuisine]?.isNotEmpty ?? false;

import '../models/spice_route.dart';
import 'cuisine_pill_bar.dart';

/// Resolves the most specific food emoji we can derive for a recipe.
///
/// Drives the circular badge over a recipe card's hero image and the
/// big emoji in the image-missing fallback.
///
/// The badge used to fall back to one icon per cuisine — every French
/// dish wore 🥐, every Italian 🍝 — which made the four-up grid feel
/// undifferentiated: three French dishes side-by-side all displayed
/// the same croissant. This resolver walks four tiers from most to
/// least specific so each dish gets a glanceable, dish-shaped cue:
///
/// 1. **Title keyword** — matches the lowercased recipe title against
///    [_dishKeywords], a curated `(substring, emoji)` table covering
///    the common dishes of the 16 cuisines we support. Multi-word and
///    longer keywords are listed first so `coq au vin` wins over a
///    hypothetical `vin` and `fried rice` over `rice`.
/// 2. **Description keyword** — same table, but searches the recipe's
///    short description. Catches dishes whose title is a proper noun
///    ("Babette's Feast") but whose blurb names the dish ("a classic
///    ratatouille").
/// 3. **Cuisine fallback** — the original
///    [CuisinePillBar.foodEmojiFor] map. Preserves the prior behavior
///    for legacy / unrecognised titles so we never go backwards.
/// 4. **Generic plate** — 🍽️ when even cuisine is null.
///
/// Pure / side-effect free, safe to call inside `build()`. The keyword
/// scan is `O(items × length)` against a list of ~120 entries; for a
/// 24-card grid that's well under a millisecond per frame.
String dishEmojiFor(SpiceRouteSummary recipe) {
  final paddedTitle = _padForWordMatch(recipe.title);
  for (final (keyword, emoji) in _paddedDishKeywords) {
    if (paddedTitle.contains(keyword)) return emoji;
  }

  final description = recipe.description;
  if (description != null && description.isNotEmpty) {
    final paddedDesc = _padForWordMatch(description);
    for (final (keyword, emoji) in _paddedDishKeywords) {
      if (paddedDesc.contains(keyword)) return emoji;
    }
  }

  if (recipe.cuisine != null) {
    return CuisinePillBar.foodEmojiFor(recipe.cuisine!);
  }
  return '🍽️';
}

/// Lowercases [text] and replaces every non-letter / non-digit code
/// unit (apostrophes, hyphens, commas, periods, parentheses, …) with
/// an ASCII space, then prefixes and suffixes the result with single
/// spaces so callers can ask `padded.contains(" $keyword ")` and get
/// word-boundary semantics for free.
///
/// Why this exists: a naive `title.contains(keyword)` produces silent
/// false positives whose blast radius is exactly one wrong emoji per
/// card. The original implementation matched `lassi` inside `classic`,
/// which short-circuited the description scan for "A classic French
/// ratatouille" and shipped 🥤 instead of 🍆. The same trap is set
/// for `tea` inside `steak`, `pie` inside `piece`, `egg` inside
/// `legume`, `ale` inside `whales`, and so on through the catch-all
/// section. Word-boundary scanning shuts down the entire class.
///
/// Multi-byte runes (é, ñ, ä, 한, あ, …) are treated as letters since
/// their code units sit above 0x7f — this preserves matches against
/// keywords like `crème brûlée` or `tortilla española`. Hyphenated
/// keywords (`gado-gado`) are normalized too so they survive the
/// padded comparison.
String _padForWordMatch(String text) {
  final lower = text.toLowerCase();
  final buf = StringBuffer(' ');
  var lastWasSpace = true;
  for (var i = 0; i < lower.length; i++) {
    final c = lower.codeUnitAt(i);
    final isLetter = (c >= 0x61 && c <= 0x7a) || c > 0x7f;
    final isDigit = c >= 0x30 && c <= 0x39;
    if (isLetter || isDigit) {
      buf.writeCharCode(c);
      lastWasSpace = false;
    } else if (!lastWasSpace) {
      // Collapse runs of separators into a single ASCII space so the
      // padded keyword can match across any contiguous gap.
      buf.write(' ');
      lastWasSpace = true;
    }
  }
  if (!lastWasSpace) buf.write(' ');
  return buf.toString();
}

/// Precomputed `(paddedKeyword, emoji)` table. We normalize each
/// keyword through [_padForWordMatch] once at first access so the
/// per-build scan is a straight `String.contains` against shapes that
/// already have spaces on both ends — no per-keyword regex cost, no
/// per-keyword string-concat cost, and hyphenated keywords like
/// `gado-gado` are normalised to the same `' gado gado '` shape that
/// the text gets, so they still match.
final List<(String, String)> _paddedDishKeywords = [
  for (final (keyword, emoji) in _dishKeywords)
    (_padForWordMatch(keyword), emoji),
];

/// `(substring, emoji)` lookup table. Order matters — entries are
/// scanned top-down and the first `String.contains` match wins, so
/// longer / more-specific keywords must sit above their shorter
/// supersets.
///
/// Roughly organised by cuisine for editability, with a broad
/// "dish-type" tail at the bottom for catch-all matches (`soup`,
/// `salad`, `cake`, …). When adding a new keyword: if it could be a
/// substring of another keyword already in the list, place the longer
/// one earlier. Examples currently honored:
///   `ice cream` before `cream` would be (we have neither).
///   `cheesecake` before `cheese` before `cake`.
///   `fried rice` before `rice`.
///   `hot chocolate` before `chocolate`.
///   `eggplant` before `egg`.
const List<(String, String)> _dishKeywords = [
  // ---------------------------------------------------------------------------
  // Multi-word dish names — must come first so e.g. `coq au vin` wins over
  // any single-word fragment like `vin`, and `mango sticky rice` wins over
  // `sticky rice` wins over `rice`.
  // ---------------------------------------------------------------------------
  ('boeuf bourguignon', '🍖'),
  ('beef bourguignon', '🍖'),
  ('coq au vin', '🍗'),
  ('croque monsieur', '🥪'),
  ('croque madame', '🥪'),
  ('crème brûlée', '🍮'),
  ('creme brulee', '🍮'),
  ('panna cotta', '🍮'),
  ('caesar salad', '🥗'),
  ('greek salad', '🥗'),
  ('cobb salad', '🥗'),
  ('caprese salad', '🥗'),
  ('niçoise', '🥗'),
  ('nicoise', '🥗'),
  ('french onion soup', '🍲'),
  ('mushroom soup', '🍲'),
  ('chicken noodle soup', '🍜'),
  ('hot and sour soup', '🍲'),
  ('apple pie', '🥧'),
  ('pumpkin pie', '🥧'),
  ('pecan pie', '🥧'),
  ('shepherd', '🥧'),
  ('chocolate cake', '🍰'),
  ('chocolate chip', '🍪'),
  ('chocolate mousse', '🍮'),
  ('hot chocolate', '☕'),
  ('ice cream', '🍦'),
  ('beef stew', '🍲'),
  ('chicken stew', '🍲'),
  ('chicken curry', '🍛'),
  ('beef curry', '🍛'),
  ('green curry', '🍛'),
  ('red curry', '🍛'),
  ('massaman', '🍛'),
  ('panang', '🍛'),
  ('butter chicken', '🍛'),
  ('chicken tikka', '🍗'),
  ('tikka masala', '🍛'),
  ('tandoori chicken', '🍗'),
  ('chicken biryani', '🍚'),
  ('lamb biryani', '🍚'),
  ('mapo tofu', '🌶️'),
  ('kung pao', '🥡'),
  ('peking duck', '🦆'),
  ('fried rice', '🍚'),
  ('hainanese chicken', '🍚'),
  ('nasi goreng', '🍚'),
  ('nasi lemak', '🍚'),
  ('mie goreng', '🍝'),
  ('char kway teow', '🍝'),
  ('chow mein', '🍜'),
  ('lo mein', '🍜'),
  ('pad thai', '🍝'),
  ('tom yum', '🍲'),
  ('tom kha', '🍲'),
  ('pho bo', '🍜'),
  ('pho ga', '🍜'),
  ('banh mi', '🥖'),
  ('bun bo', '🍜'),
  ('bun cha', '🍜'),
  ('goi cuon', '🥬'),
  ('cha gio', '🥟'),
  ('spring roll', '🥬'),
  ('summer roll', '🥬'),
  ('egg roll', '🥚'),
  ('hot pot', '🍲'),
  ('hot dog', '🌭'),
  ('mac and cheese', '🧀'),
  ('grilled cheese', '🧀'),
  ('mango sticky rice', '🥭'),
  ('sticky rice', '🍚'),
  ('miso soup', '🍵'),
  ('katsu curry', '🍛'),
  ('chicken katsu', '🍖'),
  ('teriyaki chicken', '🍗'),
  ('teriyaki beef', '🥩'),
  ('teriyaki salmon', '🐟'),
  ('miso ramen', '🍜'),
  ('shoyu ramen', '🍜'),
  ('tonkotsu', '🍜'),
  ('beef ramen', '🍜'),
  ('chicken ramen', '🍜'),
  ('beef udon', '🍜'),
  ('chicken udon', '🍜'),
  ('palak paneer', '🥬'),
  ('aloo gobi', '🥦'),
  ('chana masala', '🍲'),
  ('dal makhani', '🍲'),
  ('mango lassi', '🥤'),
  ('green tea', '🍵'),
  ('iced tea', '🥤'),
  ('tortilla española', '🥚'),
  ('tortilla espanola', '🥚'),
  ('roti canai', '🥞'),
  ('gado-gado', '🥗'),
  ('shan noodle', '🍜'),
  ('khao swè', '🍜'),
  ('khao swe', '🍜'),

  // ---------------------------------------------------------------------------
  // Korean
  // ---------------------------------------------------------------------------
  ('bibimbap', '🍚'),
  ('bulgogi', '🥩'),
  ('galbi', '🍖'),
  ('kalbi', '🍖'),
  ('kimchi', '🥬'),
  ('tteokbokki', '🍢'),
  ('japchae', '🍝'),
  ('kimbap', '🍣'),
  ('mandu', '🥟'),
  ('jjigae', '🍲'),
  ('naengmyeon', '🍜'),

  // ---------------------------------------------------------------------------
  // Japanese
  // ---------------------------------------------------------------------------
  ('sushi', '🍣'),
  ('sashimi', '🍣'),
  ('nigiri', '🍣'),
  ('onigiri', '🍙'),
  ('maki', '🍣'),
  ('ramen', '🍜'),
  ('udon', '🍜'),
  ('soba', '🍜'),
  ('tempura', '🍤'),
  ('gyoza', '🥟'),
  ('takoyaki', '🐙'),
  ('okonomiyaki', '🥞'),
  ('yakitori', '🍢'),
  ('donburi', '🍚'),
  ('omurice', '🍳'),
  ('tonkatsu', '🍖'),
  ('mochi', '🍡'),
  ('matcha', '🍵'),

  // ---------------------------------------------------------------------------
  // Chinese
  // ---------------------------------------------------------------------------
  ('dumpling', '🥟'),
  ('wonton', '🥟'),
  ('xiaolongbao', '🥟'),
  ('dim sum', '🥟'),
  ('mooncake', '🥮'),
  ('bao', '🥟'),

  // ---------------------------------------------------------------------------
  // Burmese
  // ---------------------------------------------------------------------------
  ('mohinga', '🍜'),
  ('lahpet', '🍵'),

  // ---------------------------------------------------------------------------
  // Thai
  // ---------------------------------------------------------------------------
  ('som tum', '🥗'),
  ('satay', '🍢'),

  // ---------------------------------------------------------------------------
  // Vietnamese
  // ---------------------------------------------------------------------------
  ('pho', '🍜'),

  // ---------------------------------------------------------------------------
  // Indian
  // ---------------------------------------------------------------------------
  ('biryani', '🍚'),
  ('vindaloo', '🌶️'),
  ('korma', '🍛'),
  ('tandoori', '🍗'),
  ('tikka', '🍗'),
  ('samosa', '🥟'),
  ('naan', '🍞'),
  ('dosa', '🥞'),
  ('lassi', '🥤'),
  ('chai', '🍵'),

  // ---------------------------------------------------------------------------
  // Italian
  // ---------------------------------------------------------------------------
  ('lasagna', '🍝'),
  ('spaghetti', '🍝'),
  ('carbonara', '🍝'),
  ('bolognese', '🍝'),
  ('puttanesca', '🍝'),
  ('fettuccine', '🍝'),
  ('linguine', '🍝'),
  ('penne', '🍝'),
  ('rigatoni', '🍝'),
  ('ravioli', '🥟'),
  ('tortellini', '🥟'),
  ('gnocchi', '🥟'),
  ('risotto', '🍚'),
  ('tiramisu', '🍰'),
  ('cannoli', '🥐'),
  ('bruschetta', '🍞'),
  ('focaccia', '🍞'),
  ('caprese', '🥗'),
  ('minestrone', '🍲'),
  ('gelato', '🍦'),
  ('pasta', '🍝'),
  ('pizza', '🍕'),

  // ---------------------------------------------------------------------------
  // French
  // ---------------------------------------------------------------------------
  ('quiche', '🥧'),
  ('ratatouille', '🍆'),
  ('soufflé', '🥚'),
  ('souffle', '🥚'),
  ('crêpe', '🥞'),
  ('crepe', '🥞'),
  ('bouillabaisse', '🍲'),
  ('cassoulet', '🍲'),
  ('macaron', '🍪'),
  ('baguette', '🥖'),
  ('croissant', '🥐'),
  ('éclair', '🍫'),
  ('eclair', '🍫'),
  ('tarte', '🥧'),

  // ---------------------------------------------------------------------------
  // American / Western
  // ---------------------------------------------------------------------------
  ('cheeseburger', '🍔'),
  ('hamburger', '🍔'),
  ('burger', '🍔'),
  ('bbq', '🍖'),
  ('barbecue', '🍖'),
  ('pulled pork', '🍖'),
  ('cheesecake', '🍰'),
  ('brownie', '🍫'),
  ('cookie', '🍪'),
  ('waffle', '🧇'),
  ('pancake', '🥞'),
  ('omelette', '🍳'),
  ('omelet', '🍳'),
  ('frittata', '🍳'),
  ('steak', '🥩'),
  ('meatloaf', '🥩'),

  // ---------------------------------------------------------------------------
  // Mexican
  // ---------------------------------------------------------------------------
  ('quesadilla', '🫓'),
  ('enchilada', '🌯'),
  ('burrito', '🌯'),
  ('chimichanga', '🌯'),
  ('taco', '🌮'),
  ('nachos', '🧀'),
  ('guacamole', '🥑'),
  ('salsa', '🍅'),
  ('tamale', '🫔'),
  ('mole', '🌶️'),
  ('fajita', '🥩'),
  ('churros', '🍩'),

  // ---------------------------------------------------------------------------
  // Greek
  // ---------------------------------------------------------------------------
  ('moussaka', '🍆'),
  ('souvlaki', '🍢'),
  ('gyro', '🥙'),
  ('tzatziki', '🥒'),
  ('spanakopita', '🥬'),
  ('baklava', '🍯'),
  ('dolmades', '🍃'),
  ('feta', '🧀'),

  // ---------------------------------------------------------------------------
  // Spanish
  // ---------------------------------------------------------------------------
  ('paella', '🥘'),
  ('gazpacho', '🍅'),
  ('chorizo', '🌭'),
  ('sangria', '🍷'),
  ('tapas', '🫒'),

  // ---------------------------------------------------------------------------
  // Malaysian / Indonesian
  // ---------------------------------------------------------------------------
  ('laksa', '🍜'),
  ('rendang', '🍖'),
  ('roti', '🥞'),
  ('sate', '🍢'),
  ('bakso', '🍲'),

  // ---------------------------------------------------------------------------
  // German
  // ---------------------------------------------------------------------------
  ('bratwurst', '🌭'),
  ('schnitzel', '🍖'),
  ('sauerbraten', '🍖'),
  ('sauerkraut', '🥬'),
  ('pretzel', '🥨'),
  ('strudel', '🥧'),
  ('spätzle', '🍝'),
  ('spaetzle', '🍝'),

  // ---------------------------------------------------------------------------
  // Broad dish-type and ingredient catch-alls. Scanned last so the
  // cuisine-specific entries above win when both could match. Within
  // this block, longer / more-specific words still come first
  // (eggplant before egg, chowder before broth).
  // ---------------------------------------------------------------------------
  ('chowder', '🍲'),
  ('bisque', '🍲'),
  ('stew', '🍲'),
  ('broth', '🍲'),
  ('soup', '🍲'),
  ('salad', '🥗'),
  ('sandwich', '🥪'),
  ('cake', '🍰'),
  ('tart', '🥧'),
  ('pie', '🥧'),
  ('biscuit', '🍪'),
  ('brûlée', '🍮'),
  ('brulee', '🍮'),
  ('flan', '🍮'),
  ('custard', '🍮'),
  ('pudding', '🍮'),
  ('mousse', '🍮'),
  ('sorbet', '🍦'),
  ('chocolate', '🍫'),
  ('truffle', '🍫'),
  ('donut', '🍩'),
  ('doughnut', '🍩'),
  ('noodle', '🍜'),
  ('rice', '🍚'),
  ('pilaf', '🍚'),
  ('jollof', '🍚'),
  ('pierogi', '🥟'),
  ('chicken', '🍗'),
  ('bacon', '🥓'),
  ('pork', '🥓'),
  ('beef', '🥩'),
  ('lamb', '🍖'),
  ('shrimp', '🍤'),
  ('prawn', '🍤'),
  ('lobster', '🦞'),
  ('crab', '🦀'),
  ('octopus', '🐙'),
  ('salmon', '🐟'),
  ('tuna', '🐟'),
  ('fish', '🐟'),
  ('eggplant', '🍆'),
  ('aubergine', '🍆'),
  ('egg', '🍳'),
  ('mushroom', '🍄'),
  ('tomato', '🍅'),
  ('avocado', '🥑'),
  ('pepper', '🌶️'),
  ('chili', '🌶️'),
  ('chilli', '🌶️'),
  ('cheese', '🧀'),
  ('popcorn', '🍿'),
  ('skewer', '🍢'),
  ('kebab', '🥙'),
  ('shawarma', '🥙'),
  ('falafel', '🧆'),
  ('wrap', '🌯'),
  ('bread', '🍞'),
  ('toast', '🍞'),
  ('butter', '🧈'),
  ('tea', '🍵'),
  ('coffee', '☕'),
  ('latte', '☕'),
  ('cappuccino', '☕'),
  ('espresso', '☕'),
  ('martini', '🍸'),
  ('cocktail', '🍸'),
  ('mojito', '🍸'),
  ('margarita', '🍸'),
  ('beer', '🍺'),
  ('lager', '🍺'),
  ('ale', '🍺'),
  ('wine', '🍷'),
  ('smoothie', '🥤'),
  ('milkshake', '🥤'),
  ('juice', '🥤'),
  ('curry', '🍛'),
];

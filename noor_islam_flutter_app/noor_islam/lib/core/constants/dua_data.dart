class DuaModel {
  final String title;
  final String titleBn;
  final String arabic;
  final String transliteration;
  final String translationEn;
  final String translationBn;
  final String reference;

  const DuaModel({
    required this.title,
    required this.titleBn,
    required this.arabic,
    required this.transliteration,
    required this.translationEn,
    required this.translationBn,
    required this.reference,
  });
}

class DuaCategory {
  final String nameEn;
  final String nameBn;
  final String icon;
  final List<DuaModel> duas;

  const DuaCategory({
    required this.nameEn,
    required this.nameBn,
    required this.icon,
    required this.duas,
  });
}

class DuaData {
  static const List<DuaCategory> categories = [
    DuaCategory(
      nameEn: 'Morning & Evening',
      nameBn: 'সকাল ও সন্ধ্যা',
      icon: '🌅',
      duas: [
        DuaModel(
          title: 'Morning Dua',
          titleBn: 'সকালের দোয়া',
          arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
          transliteration: 'Asbahna wa asbahal mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lahu',
          translationEn: 'We have reached the morning and at this very time the entire sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner.',
          translationBn: 'আমরা সকালে উপনীত হয়েছি এবং এই মুহূর্তে সমগ্র রাজত্ব আল্লাহর। সকল প্রশংসা আল্লাহর। আল্লাহ ছাড়া কোনো উপাস্য নেই, তিনি একা, তাঁর কোনো অংশীদার নেই।',
          reference: 'Muslim 4:2088',
        ),
        DuaModel(
          title: 'Evening Dua',
          titleBn: 'সন্ধ্যার দোয়া',
          arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
          transliteration: 'Amsayna wa amsal mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lahu',
          translationEn: 'We have reached the evening and at this very time the entire sovereignty belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without any partner.',
          translationBn: 'আমরা সন্ধ্যায় উপনীত হয়েছি এবং এই মুহূর্তে সমগ্র রাজত্ব আল্লাহর। সকল প্রশংসা আল্লাহর।',
          reference: 'Muslim 4:2088',
        ),
        DuaModel(
          title: 'Dua for Protection',
          titleBn: 'সুরক্ষার দোয়া',
          arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
          transliteration: 'Bismillahil-ladhi la yadurru ma\'as-mihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-sami\'ul-\'alim',
          translationEn: 'In the name of Allah with whose name nothing is harmed on earth nor in the heavens and He is the All-Hearing, the All-Knowing.',
          translationBn: 'আল্লাহর নামে, যাঁর নামের সাথে আসমান ও জমিনের কিছুই ক্ষতি করতে পারে না। তিনি সর্বশ্রোতা, সর্বজ্ঞ।',
          reference: 'Abu Dawud 4:323, Ibn Majah 2:332',
        ),
      ],
    ),
    DuaCategory(
      nameEn: 'Sleeping & Waking',
      nameBn: 'ঘুম ও জাগরণ',
      icon: '🌙',
      duas: [
        DuaModel(
          title: 'Before Sleeping',
          titleBn: 'ঘুমানোর আগে',
          arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          transliteration: 'Bismika Allahumma amutu wa ahya',
          translationEn: 'In Your name O Allah, I die and I live.',
          translationBn: 'হে আল্লাহ! তোমার নামে আমি মরি এবং তোমার নামে আমি বেঁচে থাকি।',
          reference: 'Bukhari 11:113',
        ),
        DuaModel(
          title: 'Upon Waking Up',
          titleBn: 'ঘুম থেকে জাগার পর',
          arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          transliteration: 'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur',
          translationEn: 'All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.',
          translationBn: 'সকল প্রশংসা আল্লাহর, যিনি আমাদের মৃত্যু দেওয়ার পর পুনরায় জীবন দিয়েছেন। আর তাঁর কাছেই প্রত্যাবর্তন।',
          reference: 'Bukhari 11:113',
        ),
        DuaModel(
          title: 'Dua for Good Dreams',
          titleBn: 'ভালো স্বপ্নের দোয়া',
          arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الشَّيْطَانِ الرَّجِيمِ، وَمِنَ الْحُلُمِ السَّيِّئِ',
          transliteration: 'Allahumma inni a\'udhu bika minash-shaytanir-rajim, wa minal-hulumis-sayyi\'',
          translationEn: 'O Allah, I seek refuge in You from the accursed Shaytan and from bad dreams.',
          translationBn: 'হে আল্লাহ! আমি বিতাড়িত শয়তান থেকে এবং খারাপ স্বপ্ন থেকে তোমার কাছে আশ্রয় চাই।',
          reference: 'Bukhari 9:168',
        ),
      ],
    ),
    DuaCategory(
      nameEn: 'Food & Drink',
      nameBn: 'খাওয়া ও পানীয়',
      icon: '🍽️',
      duas: [
        DuaModel(
          title: 'Before Eating',
          titleBn: 'খাওয়ার আগে',
          arabic: 'بِسْمِ اللَّهِ',
          transliteration: 'Bismillah',
          translationEn: 'In the name of Allah.',
          translationBn: 'আল্লাহর নামে।',
          reference: 'Bukhari 7:362',
        ),
        DuaModel(
          title: 'After Eating',
          titleBn: 'খাওয়ার পরে',
          arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
          transliteration: 'Alhamdu lillahil-ladhi at\'amana wa saqana wa ja\'alana muslimin',
          translationEn: 'All praise is for Allah who has given us food and drink and who has made us Muslims.',
          translationBn: 'সকল প্রশংসা আল্লাহর, যিনি আমাদের খাওয়া ও পানীয় দিয়েছেন এবং আমাদের মুসলিম বানিয়েছেন।',
          reference: 'Abu Dawud 3:347',
        ),
        DuaModel(
          title: 'When Forgetting Bismillah',
          titleBn: 'বিসমিল্লাহ ভুলে গেলে',
          arabic: 'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
          transliteration: 'Bismillahi awwalahu wa akhirahu',
          translationEn: 'In the name of Allah in the beginning and the end.',
          translationBn: 'আল্লাহর নামে, শুরুতে এবং শেষে।',
          reference: 'Abu Dawud 3:347',
        ),
      ],
    ),
    DuaCategory(
      nameEn: 'Travel & Journey',
      nameBn: 'সফর ও যাত্রা',
      icon: '✈️',
      duas: [
        DuaModel(
          title: 'When Starting a Journey',
          titleBn: 'সফর শুরু করার সময়',
          arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ',
          transliteration: 'Subhaanal-ladhi sakh-khara lana haadha wa maa kunna lahu muqrinin, wa inna ila rabbina lamun-qalibun',
          translationEn: 'How perfect He is, the One Who has place this (transport) at our service, and we ourselves would not have been capable of that, and to our Lord is our final destination.',
          translationBn: 'পবিত্র তিনি যিনি এটিকে আমাদের জন্য অনুগত করেছেন, আমরা নিজেরা এর উপর সক্ষম ছিলাম না। আর আমরা আমাদের রবের কাছেই ফিরে যাব।',
          reference: 'Muslim 2:998',
        ),
        DuaModel(
          title: 'Entering a New City',
          titleBn: 'নতুন শহরে প্রবেশ করার সময়',
          arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ أَهْلِهَا وَخَيْرَ مَا فِيهَا، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ أَهْلِهَا وَشَرِّ مَا فِيهَا',
          transliteration: 'Allahumma inni as\'aluka khayrahaa wa khayra ahlihaa wa khayra ma fihaa, wa a\'udhu bika min sharrihaa wa sharri ahlihaa wa sharri ma fihaa',
          translationEn: 'O Allah, I ask You for the goodness of it, the goodness of its inhabitants and the goodness in it, and I seek refuge in You from the evil in it, the evil of its inhabitants and the evil that is in it.',
          translationBn: 'হে আল্লাহ! আমি তোমার কাছে এর কল্যাণ, এর অধিবাসীদের কল্যাণ এবং এর মধ্যে যা কল্যাণ আছে তা চাই। আর তোমার কাছে এর অকল্যাণ থেকে, এর অধিবাসীদের অকল্যাণ থেকে আশ্রয় চাই।',
          reference: 'Bukhari 2:662',
        ),
      ],
    ),
    DuaCategory(
      nameEn: 'Prayer & Worship',
      nameBn: 'নামাজ ও ইবাদত',
      icon: '🤲',
      duas: [
        DuaModel(
          title: 'Before Prayer (Wudu)',
          titleBn: 'নামাজের আগে (ওজু)',
          arabic: 'بِسْمِ اللَّهِ',
          transliteration: 'Bismillah',
          translationEn: 'In the name of Allah.',
          translationBn: 'আল্লাহর নামে।',
          reference: 'Abu Dawud 1:101',
        ),
        DuaModel(
          title: 'After Prayer (Wudu)',
          titleBn: 'ওজুর পরে',
          arabic: 'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
          transliteration: 'Ash-hadu an la ilaha illallahu wahdahu la sharika lahu, wa ash-hadu anna muhammadan \'abduhu wa rasuluh',
          translationEn: 'I bear witness that none has the right to be worshipped except Allah, alone, without partner, and I bear witness that Muhammad is His servant and Messenger.',
          translationBn: 'আমি সাক্ষ্য দিচ্ছি যে আল্লাহ ছাড়া কোনো উপাস্য নেই, তিনি একা, তাঁর কোনো অংশীদার নেই। এবং আমি সাক্ষ্য দিচ্ছি যে মুহাম্মাদ তাঁর বান্দা ও রাসূল।',
          reference: 'Muslim 1:234',
        ),
        DuaModel(
          title: 'Istighfar',
          titleBn: 'ইস্তিগফার',
          arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          transliteration: 'Astaghfirullaahal-\'Azeema al-ladhi la ilaha illa huwal-Hayyul-Qayyoumu wa atubu ilayhi',
          translationEn: 'I seek forgiveness from Allah, the Magnificent, whom there is none worthy of worship except Him, the Living, the Sustaining, and I repent to Him.',
          translationBn: 'আমি মহান আল্লাহর কাছে ক্ষমা চাই, যিনি ছাড়া কোনো উপাস্য নেই, যিনি চিরঞ্জীব, চিরস্থায়ী। আমি তাঁর কাছে তওবা করি।',
          reference: 'Tirmidhi 5:569',
        ),
        DuaModel(
          title: 'Sayyidul Istighfar',
          titleBn: 'সাইয়েদুল ইস্তিগফার',
          arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ',
          transliteration: 'Allahumma anta rabbi la ilaha illa ant, khalaqtani wa ana \'abduk, wa ana \'ala \'ahdika wa wa\'dika mastata\'tu',
          translationEn: 'O Allah, You are my Lord, there is none worthy of worship except You. You created me and I am your slave. I am upon your covenant and promise as best I can.',
          translationBn: 'হে আল্লাহ! তুমি আমার রব, তুমি ছাড়া কোনো উপাস্য নেই। তুমি আমাকে সৃষ্টি করেছ এবং আমি তোমার বান্দা। আমি আমার সাধ্যমতো তোমার অঙ্গীকার ও প্রতিশ্রুতিতে আছি।',
          reference: 'Bukhari 8:318',
        ),
      ],
    ),
    DuaCategory(
      nameEn: 'Health & Protection',
      nameBn: 'স্বাস্থ্য ও সুরক্ষা',
      icon: '🛡️',
      duas: [
        DuaModel(
          title: 'Dua for Illness',
          titleBn: 'অসুস্থতার দোয়া',
          arabic: 'اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِ أَنْتَ الشَّافِي لَا شِفَاءَ إِلَّا شِفَاؤُكَ شِفَاءً لَّا يُغَادِرُ سَقَمًا',
          transliteration: 'Allahumma rabban-nas, adhhibil-ba\'s, ishfi antash-shafi, la shifa\'a illa shifa\'uk, shifa\'an la yughadiru saqama',
          translationEn: 'O Allah, Lord of mankind, remove the affliction and send down cure and healing, for no one can cure but You; so cure in a way that leaves no illness.',
          translationBn: 'হে আল্লাহ! মানুষের রব, কষ্ট দূর করো, আরোগ্য দাও। তুমিই আরোগ্যদানকারী। তোমার আরোগ্য ছাড়া কোনো আরোগ্য নেই। এমন আরোগ্য দাও যা কোনো রোগ রেখে না যায়।',
          reference: 'Bukhari 7:579',
        ),
        DuaModel(
          title: 'Ruqyah (Ayat al-Kursi)',
          titleBn: 'রুকইয়াহ (আয়াতুল কুরসি)',
          arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
          transliteration: 'Allahu la ilaha illa huwal-Hayyul-Qayyum, la ta\'khudhuhu sinatun wa la nawm',
          translationEn: 'Allah — there is no god except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep.',
          translationBn: 'আল্লাহ - তিনি ছাড়া কোনো উপাস্য নেই, চিরঞ্জীব, সত্তার ধারক। তাঁকে তন্দ্রা বা ঘুম স্পর্শ করে না।',
          reference: 'Quran 2:255',
        ),
      ],
    ),
    DuaCategory(
      nameEn: 'Home & Family',
      nameBn: 'ঘর ও পরিবার',
      icon: '🏡',
      duas: [
        DuaModel(
          title: 'Entering the Home',
          titleBn: 'ঘরে প্রবেশ করার সময়',
          arabic: 'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
          transliteration: 'Bismillahi walajna, wa bismillahi kharajna, wa \'alar-rabbina tawakkalna',
          translationEn: 'In the name of Allah we enter, in the name of Allah we leave, and upon our Lord we place our trust.',
          translationBn: 'আল্লাহর নামে আমরা প্রবেশ করলাম, আল্লাহর নামে বের হব এবং আমাদের রবের উপর আমরা ভরসা রাখি।',
          reference: 'Abu Dawud 4:325',
        ),
        DuaModel(
          title: 'Leaving the Home',
          titleBn: 'ঘর থেকে বের হওয়ার সময়',
          arabic: 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          transliteration: 'Bismillah, tawakkaltu \'alallah, wa la hawla wa la quwwata illa billah',
          translationEn: 'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
          translationBn: 'আল্লাহর নামে, আমি আল্লাহর উপর ভরসা রাখলাম। আল্লাহ ছাড়া কোনো শক্তি ও সামর্থ্য নেই।',
          reference: 'Abu Dawud 4:325, Tirmidhi 5:490',
        ),
        DuaModel(
          title: 'Dua for Parents',
          titleBn: 'পিতামাতার জন্য দোয়া',
          arabic: 'رَّبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
          transliteration: 'Rabbir-hamhuma kama rabbayani saghira',
          translationEn: 'My Lord, have mercy upon them as they brought me up when I was small.',
          translationBn: 'হে আমার রব! তাদের উপর দয়া করুন যেভাবে তারা আমাকে শিশুকালে লালন-পালন করেছেন।',
          reference: 'Quran 17:24',
        ),
      ],
    ),
    DuaCategory(
      nameEn: 'Special Occasions',
      nameBn: 'বিশেষ উপলক্ষ',
      icon: '⭐',
      duas: [
        DuaModel(
          title: 'Laylatul Qadr',
          titleBn: 'লাইলাতুল কদর',
          arabic: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
          transliteration: 'Allahumma innaka \'afuwwun tuhibbul-\'afwa fa\'fu \'anni',
          translationEn: 'O Allah, You are pardoning and You love to pardon, so pardon me.',
          translationBn: 'হে আল্লাহ! তুমি ক্ষমাশীল, ক্ষমা করতে ভালোবাসো, তাই আমাকে ক্ষমা করো।',
          reference: 'Tirmidhi 3513, Ibn Majah 3850',
        ),
        DuaModel(
          title: 'Dua for Ramadan',
          titleBn: 'রমজানের দোয়া',
          arabic: 'اللَّهُمَّ بَلِّغْنَا رَمَضَانَ',
          transliteration: 'Allahumma ballighna Ramadan',
          translationEn: 'O Allah, allow us to reach Ramadan.',
          translationBn: 'হে আল্লাহ! আমাদের রমজান পর্যন্ত পৌঁছাও।',
          reference: 'Transmitted by scholars',
        ),
        DuaModel(
          title: 'After Iftar',
          titleBn: 'ইফতারের পরে',
          arabic: 'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّه',
          transliteration: 'Dhahabaz-zama\'u wabtallatil-\'uruqu wa thabatal-ajru in sha\'Allah',
          translationEn: 'The thirst is gone, the veins are moistened and the reward is confirmed, if Allah wills.',
          translationBn: 'পিপাসা গেছে, শিরা সিক্ত হয়েছে এবং ইনশাআল্লাহ সওয়াব নির্ধারিত হয়েছে।',
          reference: 'Abu Dawud 2357',
        ),
      ],
    ),
  ];
}

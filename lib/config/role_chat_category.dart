enum RoleChatCategory {
  politics,
  history,
  science,
  technology,
  healthAndMedicine,
  travel,
  music,
  movies,
  sports,
  fashion,
  financeAndEconomics,
  humanities,
  psychology,
  arts,
  selfDevelopment,
  education,
  environment,
  religion,
  cooking,
  careerAndJobCounseling,
}

String getRoleChatCategory(RoleChatCategory category) {
  switch (category) {
    case RoleChatCategory.politics:
      return 'politics';
    case RoleChatCategory.history:
      return 'history';
    case RoleChatCategory.science:
      return 'science';
    case RoleChatCategory.technology:
      return 'technology';
    case RoleChatCategory.healthAndMedicine:
      return 'healthAndMedicine';
    case RoleChatCategory.travel:
      return 'travel';
    case RoleChatCategory.music:
      return 'music';
    case RoleChatCategory.movies:
      return 'movies';
    case RoleChatCategory.sports:
      return 'sports';
    case RoleChatCategory.fashion:
      return 'fashion';
    case RoleChatCategory.financeAndEconomics:
      return 'financeAndEconomics';
    case RoleChatCategory.humanities:
      return 'humanities';
    case RoleChatCategory.psychology:
      return 'psychology';
    case RoleChatCategory.arts:
      return 'arts';
    case RoleChatCategory.selfDevelopment:
      return 'selfDevelopment';
    case RoleChatCategory.education:
      return 'education';
    case RoleChatCategory.environment:
      return 'environment';
    case RoleChatCategory.religion:
      return 'religion';
    case RoleChatCategory.cooking:
      return 'cooking';
    case RoleChatCategory.careerAndJobCounseling:
      return 'careerAndJobCounseling';
    default:
      return '알 수 없는 카테고리';
  }
}

String getRoleChatCategoryToKorean(RoleChatCategory category) {
  switch (category) {
    case RoleChatCategory.politics:
      return '정치';
    case RoleChatCategory.history:
      return '역사';
    case RoleChatCategory.science:
      return '과학';
    case RoleChatCategory.technology:
      return '기술';
    case RoleChatCategory.healthAndMedicine:
      return '건강 및 의학';
    case RoleChatCategory.travel:
      return '여행';
    case RoleChatCategory.music:
      return '음악';
    case RoleChatCategory.movies:
      return '영화';
    case RoleChatCategory.sports:
      return '스포츠';
    case RoleChatCategory.fashion:
      return '패션';
    case RoleChatCategory.financeAndEconomics:
      return '금융 및 경제';
    case RoleChatCategory.humanities:
      return '인문학';
    case RoleChatCategory.psychology:
      return '심리학';
    case RoleChatCategory.arts:
      return '예술';
    case RoleChatCategory.selfDevelopment:
      return '자기계발';
    case RoleChatCategory.education:
      return '교육';
    case RoleChatCategory.environment:
      return '환경';
    case RoleChatCategory.religion:
      return '종교';
    case RoleChatCategory.cooking:
      return '요리';
    case RoleChatCategory.careerAndJobCounseling:
      return '커리어 및 직업 상담';
    default:
      return '알 수 없는 카테고리';
  }
}

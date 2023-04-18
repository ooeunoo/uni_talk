// 직업 분야를 정의하는 enum입니다.
// ignore_for_file: constant_identifier_names

enum JobField {
  Medical, // 의료 분야
  IT, // IT 분야
  ETC, // 기타 분야
  Design, // 디자인 분야
  Marketing, // 마케팅 분야
  Art, // 예술 분야
  Journalism, // 저널리즘 분야
  Education, // 교육 분야
  Finance, // 금융 분야
  Manufacturing, // 제조 분야
  Construction, // 건설 분야
  Retail, // 소매 분야
  FoodService, // 음식 서비스 분야
  Entertainment, // 엔터테인먼트 분야
  Science, // 과학 분야
  Government, // 정부 분야
  Legal, // 법률 분야
  SocialServices, // 사회 서비스 분야
  HumanResources, // 인사 분야
  Environmental, // 환경 분야
  Sports, // 스포츠 분야
  Agriculture, // 농업 분야
  RealEstate, // 부동산 분야
}

// 직업을 정의하는 enum입니다.
enum Job {
  // 의료 분야
  Doctor, // 의사
  Nurse, // 간호사
  PhysicalTherapist, // 물리치료사
  OccupationalTherapist, // 작업치료사
  MedicalLabTechnologist, // 의학 검사 기술자
  RadiologicTechnologist, // 방사선 기술자
  RespiratoryTherapist, // 호흡기치료사
  MentalHealthCounselor, // 정신건강 상담사
  Psychiatrist, // 정신과 의사
  GeneticCounselor, // 유전 상담사
  Dietitian, // 영양사
  Pharmacist, // 약사
  MedicalWriter, // 의학 작가
  MedicalInterpreter, // 의료 통역사
  MedicalIllustrator, // 의료 일러스트레이터
  MedicalSalesRepresentative, // 의료 기계 영업사원
  BiomedicalEngineer, // 생체 의공학자
  HealthcareAdministrator, // 의료 관리자
  Dentist, // 치과 의사
  Optometrist, // 안경사
  Chiropractor, // 카이로프랙터
  VeterinaryTechnician, // 수의사 기술자
  SpeechLanguagePathologist, // 언어 치료사

  // IT 분야
  DataEngineer, // 데이터 엔지니어
  WebDeveloper, // 웹 개발자
  CloudEngineer, // 클라우드 엔지니어
  CyberSecurityExpert, // 사이버 보안 전문가
  GameDeveloper, // 게임 개발자
  RoboticsEngineer, // 로봇 공학자
  ContentCreator, // 컨텐츠 크리에이터
  AIEngineer, // AI 엔지니어
  MobileAppDeveloper, // 모바일 앱 개발자
  MachineLearningEngineer, // 머신러닝 엔지니어
  QualityAssuranceEngineer, // 품질 보증 엔지니어
  DataScientist, // 데이터 과학자
  FrontEndDeveloper, // 프론트엔드 개발자
  IoTDeveloper, // 사물인터넷(IoT) 개발자
  BlockchainExpert, // 블록체인 전문가
  AutonomousVehicleEngineer, // 자율주행 자동차 엔지니어

  // 스포츠 분야
  SportsCoach, // 스포츠 코치
  PersonalTrainer, // 퍼스널 트레이너
  PhysicalEducationTeacher, // 체육 교사
  SportsPsychologist, // 스포츠 심리학자
  SportsNutritionist, // 스포츠 영양사
  AthleticTrainer, // 운동 트레이너
  SportsAgent, // 스포츠 에이전트
  SportsStatistician, // 스포츠 통계 전문가
  SportsPhotographer, // 스포츠 사진작가
  SportsAnnouncer, // 스포츠 해설가
  SoccerPlayer, // 축구 선수
  BasketballPlayer, // 농구 선수
  BaseballPlayer, // 야구 선수
  TennisPlayer, // 테니스 선수
  Golfer, // 골프 선수
  Swimmer, // 수영 선수
  TrackAndFieldAthlete, // 육상 선수
  Gymnast, // 체조 선수
  Skier, // 스키 선수
  Cyclist, // 사이클 선수

  // 디자인 분야
  VirtualRealityDesigner, // 가상현실(VR) 디자이너
  UIUXDesigner, // UI/UX 디자이너
  InteractionDesigner, // 인터랙션 디자이너
  SetDesigner, // 세트 디자이너
  GraphicDesigner, // 그래픽 디자이너
  InteriorDesigner, // 인테리어 디자이너
  LandscapeArchitect, // 경관 건축가
  MotionGraphicsDesigner, // 모션 그래픽 디자이너

  // 농업 분야
  AgriculturalTechnologist, // 농업 기술자

  // 부동산 분야
  RealEstateAgent, // 부동산 중개인

  // 마케팅 분야
  InternetMarketer, // 인터넷 마케터
  DigitalMarketer, // 디지털 마케터
  SEOExpert, // SEO 전문가
  PublicRelationsSpecialist, // 홍보 전문가
  SocialMediaManager, // 소셜 미디어 매니저
  BrandManager, // 브랜드 매니저
  MarketResearchAnalyst, // 시장 조사 분석가

  // 예술 분야
  VRArtist, // 가상현실 아티스트
  MediaArtist, // 미디어 아티스트
  ArtTherapist, // 아트 치료사
  Choreographer, // 안무가
  Curator, // 큐레이터
  Playwright, // 희곡작가
  ArtDirector, // 아트 디렉터
  MusicProducer, // 음악 프로듀서
  FashionDesigner, // 패션 디자이너

  // 저널리즘 분야
  Journalist, // 저널리스트
  Photojournalist, // 포토 저널리스트
  Editor, // 편집자
  NewsAnchor, // 뉴스 앵커
  InvestigativeJournalist, // 수사 저널리스트
  SportsJournalist, // 스포츠 저널리스트
  VideoEditor, // 영상 편집자

  // 교육 분야 직업
  Teacher, // 선생님
  SchoolCounselor, // 학교 상담사
  CurriculumDeveloper, // 교육과정 개발자
  SpecialEducationTeacher, // 특수 교육 전문가
  EducationalConsultant, // 교육 컨설턴트

  // 금융 분야 직업
  FinancialAdvisor, // 금융 상담사
  Accountant, // 회계사
  Actuary, // 보험계리사
  RiskAnalyst, // 리스크 분석가
  LoanOfficer, // 대출 담당자
  InvestmentBanker, // 투자 은행가

  // 제조 분야 직업
  QualityControlInspector, // 품질 검사원
  ProductionManager, // 생산 관리자
  SupplyChainManager, // 공급망 관리자
  AssemblyLineWorker, // 조립 라인 작업자
  ManufacturingEngineer, // 제조 엔지니어

  // 건설 분야 직업
  CivilEngineer, // 토목 엔지니어
  Architect, // 건축가
  ConstructionManager, // 건설 관리자
  Surveyor, // 측량사
  UrbanPlanner, // 도시 계획가

  // 소매 분야 직업
  StoreManager, // 점장
  Buyer, // 구매 담당자
  Merchandiser, // 머천다이저
  SalesAssociate, // 판매원
  RetailAnalyst, // 소매 분석가

  // 음식 서비스 분야 직업
  Chef, // 셰프
  Baker, // 제빵사
  FoodCritic, // 음식 평론가
  RestaurantManager, // 레스토랑 매니저
  FoodStylist, // 음식 스타일리스트

  // 엔터테인먼트 분야 직업
  Actor, // 배우
  FilmDirector, // 영화 감독
  Musician, // 음악가
  TalentAgent, // 연예인 에이전트
  Screenwriter, // 각본가
}

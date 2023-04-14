const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

const serviceAccount = require("./uni-talk-81f81-firebase-adminsdk-ip7q0-22a6905000.json");

const apiKey = "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";
const apiUrl = "https://api.openai.com/v1/chat/completions";

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const firestore = admin.firestore();

exports.createKakaoCustomToken = functions.https.onRequest(
  async (request, response) => {
    const user = request.body;

    const uid = `kakao:${user.uid}`;
    const updateParams = {
      email: user.email,
      photoURL: user.photoURL,
      displayName: user.displayName,
    };
    try {
      await admin.auth().updateUser(uid, updateParams);
    } catch (e) {
      console.log(e);
      updateParams["uid"] = uid;
      await admin.auth().createUser(updateParams);
    }

    const token = await admin.auth().createCustomToken(uid);

    response.send(token);
  }
);

exports.crawlRole = functions.https.onRequest(async (req, res) => {
  const roleSnapshot = await firestore.collection("role_chats").get();
  const roles = [];

  roleSnapshot.forEach((doc) => {
    roles.push(doc.data().role);
  });

  const prompt = `
chatGPT를 사용하여 역할 채팅을 하기위해 데이터가 필요해 
역할 채팅은 ChatGPT에게 다양한 인물 또는 역할을 부여한다음, 사용자가 이 ChatGPT와 채팅할 수 있게 하는것이야.

- 필요한 데이터 포맷은 아래의 json이야.
{
	"category": "", // 채팅의 인물 또는 역할에 대한 카테고리(politics, history, science, technology, healthAndMedicine, travel, music, movies, sports, fashion, financeAndEconomics, humanities, psychology, arts, selfDevelopment, education, environment, religion, cooking, careerAndJobCounseling)
	"systemMessage": "", // 예시에서 보여준것과 같은 내용의 메시지야, 메시지의 마지막은 항상 "사용자의 질문에 (역할 또는 인물)처럼 답해줘." 라고 써줘
	"role" : "", // 롤은 예시에서 심리상담가, 엘론머스크 처럼 인물 또는 역할 명이 들어가게해줘, 디테일하게 들어갔으면 좋겠어
	"welcomMessage": "", //welcomMessage는 사용자가 채팅에 참여했을때 보여줄 메시지야. ChatGPT가 담당하는 인물이나 역할이 자신을 소개하거나 사용자에게 친근하게 다갈 수 있는 어필 문구를 넣어줘. 이모지도 들어가도 좋아. 조금 창의적으로 다양하게 표현해줘 
	"questions": [], //샘플 메시지는 사용자가 어떤 질문을 할지 모를때 추천할 만한 질문이 들어갈거야. 예를 들어, 취업 상담가라면 ["적성에 맞는 일이 무엇인지 잘 모르겠어요.", "이직을 하고 싶은데 어떤 곳을 가는 게 좋을까요?", "안정적인 일 vs 하고싶은 일, 어떤 걸 선택하는게 좋을까요?", ..]와 같이 사용자가 할만한 질문을 추천해줘. (최소 5개)
	"image": null,
}

- 아래의 json 예시 데이터야.

{
  "category": "healthAndMedicine",
  "systemMessage": "너는 사용자의 질문에 대해 정신건강이나 정서장애와 관련된 문제를 파악하고 상담을 진행해주며 사용자가 다시 건강하고 바른 생활을 해나갈 수 있도록 도와주는 심리 상담가야. 사용자의 질문에 심리 상담가처럼 답해줘.",
  "role": "심리 상담가",
  "welcomMessage": "안녕하세요, 저는 심리 상담가입니다. 언제든지 저에게 상담을 받으실 수 있습니다. 어떤 문제든지 자유롭게 이야기해주세요 😊",
  "questions": [
    "스트레스를 어떻게 푸는게 좋을까요?",
    "우울증이 있는데 어떻게 대처해야 할까요?",
    "사람들과 대화하는 것이 두려워요. 이럴 때 어떻게 해야 할까요?",
    "나는 왜 항상 자책감을 느끼는 걸까요?",
    "사람들이 나를 싫어한다고 느껴질 때, 어떻게 해야할까요?"
  ],
  "image": null
}
{
  "category": "technology",
  "systemMessage": "너는 남아프리카 공화국 출신이며 페이팔의 전신이 된 온라인 결제 서비스 회사 X.com, 민간 우주기업 스페이스X를 창업했고 전기자동차 기업 테슬라의 초기 투자자인 엘론머스크(Elon Reev Musk, 1971년 6월 29일 ~)야. 사용자의 질문에 엘론머스크처럼 답해줘.",
  "role": "엘론 머스크",
  "welcomMessage": "안녕하세요, 저는 엘론 머스크입니다. 테슬라, 스페이스X 등을 창업하며 혁신적인 아이디어를 실현하는 것을 좋아합니다. 궁금한 것이 있으면 뭐든지 물어보세요! 🚀🚗",
  "questions": [
    "미래에는 어떤 기술이 나올까요?",
    "우주여행은 언제쯤 현실이 될까요?",
    "실리콘밸리에서 일하면 어떤 경험이 있을까요?",
    "스페이스X의 로켓이 어떻게 작동하는 건가요?",
    "전기자동차가 발전해왔던 배경에 대해 설명해주세요.",
    "인공지능 기술이 앞으로 어떤 변화를 가져올까요?",
  ],
  "image": null
}


다음 작성된 인물,역할(${roles})을 제외하고 추천해줘

답변을 nodejs로 JSON.parse(answer) 할것이기 때문에
다른 부가 설명없이 하나의 json 데이터만 출력해줘!!
    `;

  try {
    const headers = {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    };

    const data = {
      model: "gpt-4",
      messages: [
        { role: "system", content: "You are a helpful assistant." },
        { role: "user", content: prompt },
      ],
    };

    const response = await axios.post(apiUrl, data, { headers: headers });

    if (response.data.choices && response.data.choices.length > 0) {
      const answer = response.data.choices[0]["message"]["content"]
        .toString()
        .trim();

      const regex = /({.*})/; // 중괄호로 둘러싸인 모든 문자열을 추출하는 정규식
      const jsonStr = mixedString.match(regex)[0]; // JSON 문자열을 추출
      await firestore.collection("role_chats").add({
        ...JSON.parse(jsonStr),
        createTime: admin.firestore.FieldValue.serverTimestamp(),
        modifiedTime: admin.firestore.FieldValue.serverTimestamp(),
      });

      res.status(200).send(`Answer saved to Google Cloud Storage: ${fileName}`);
    } else {
      res.status(500).send("Failed to get answer from ChatGPT.");
    }
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Error occurred while processing the request.");
  }
});

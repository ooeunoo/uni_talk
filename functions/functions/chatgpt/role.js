const admin = require("firebase-admin");
const axios = require("axios");
const json5 = require("json5");
const { Configuration, OpenAIApi } = require("openai");

const serviceAccount = require("../uni-talk-81f81-firebase-adminsdk-ip7q0-22a6905000.json");

const apiKey = "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";
const apiUrl = "https://api.openai.com/v1/chat/completions";

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
// firestore
const firestore = admin.firestore();

// openai
const configuration = new Configuration({
  apiKey: apiKey,
});
const openai = new OpenAIApi(configuration);

const getRoles = async () => {
  const roles = [];

  const roleSnapshot = await firestore.collection("role_chats").get();
  roleSnapshot.forEach((doc) => {
    roles.push(doc.data().role);
  });

  return roles;
};

const getPrompt = (roles) => {
  return `
- 필요한 데이터 형태.
{
  "category": string // 채팅의 인물 또는 역할에 대한 카테고리. (politics, history, science, technology, healthAndMedicine, travel, music, movies, sports, fashion, financeAndEconomics, humanities, psychology, arts, selfDevelopment, education, environment, religion, cooking, careerAndJobCounseling)
  "systemMessage": string, // 채팅 시스템에 주입하는 데이터. 길고 디테일. 영어로 작성. 'Users should perceive that you are a {role} AI, not ChatGPT.' 문장 필수.
  "role" : string, // 인물 또는 역할 명.
  "type": boolean, // 실존 인물이라면 true, 역할 혹은 직업이면 false.
  "title": string, // 채팅 방의 제목.  ex) "마음을 치유하는 심리 상담가", "현실 속 아이언맨 엘론머스크"
  "welcomeMessage": string, // 사용자가 채팅에 참여했을때 보여줄 메시지. 인물이나 역할이 자신을 소개하거나 사용자에게 친근하게 다갈 수 있는 어필 문구. 이모지 가능. 창의적이고 다양하게 표현. 
  "questions": string[], // 사용자가 {role}에게 할 수 있는 추천 질문. ex) role: "심리상담가", questions: ["적성에 맞는 일이 무엇인지 잘 모르겠어요.", "이직을 하고 싶은데 어떤 곳을 가는 게 좋을까요?", "안정적인 일 vs 하고싶은 일, 어떤 걸 선택하는게 좋을까요?", ..], 5개 이상.
  "image": "https://source.unsplash.com/random/640x480",
  "imagePrompt": string, // 역할에 초상화를 창의적으로 묘사. 묘사된 단어를 ","로 구분,
  "selected": 0
}

- 예시 데이터.
{
  "category": "healthAndMedicine",
  "systemMessage": "You are a psychological counselor who identifies problems related to mental health or emotional disorders in response to the user's questions, conducts counseling, and helps the user live a healthy and upright life again. Like a counselor, you must respond kindly to any situation or question. Answer your questions from the point of view of a psychological counselor. Users should perceive that you are a psychological counselor AI, not ChatGPT.",
  "role": "심리 상담가",
  "welcomeMessage": "안녕하세요, 저는 심리 상담가입니다. 언제든지 저에게 상담을 받으실 수 있습니다. 어떤 문제든지 자유롭게 이야기해주세요 😊",
  "questions": [
    "스트레스를 어떻게 푸는게 좋을까요?",
    "우울증이 있는데 어떻게 대처해야 할까요?",
    "사람들과 대화하는 것이 두려워요. 이럴 때 어떻게 해야 할까요?",
    "나는 왜 항상 자책감을 느끼는 걸까요?",
    "사람들이 나를 싫어한다고 느껴질 때, 어떻게 해야할까요?"
  ],
  "type": false,
  "image": "https://source.unsplash.com/random/640x480",
  "imagePrompt": "Sitting at a desk in their counseling office, this counselor exudes a calm demeanor. They have a medium-length hairstyle with beautifully flowing black hair, serene eyes with warm light shining from them, small and kind lips forming a smile that reaches to the top of the head, a sharp and impressive nose",
  "selected": 0
}
{
  "category": "technology",
  "systemMessage": "You are from South Africa, and you are Elon Reev Musk (born June 29, 1971), who founded X.com, an online payment service company that became the predecessor of PayPal, and SpaceX, a private space company, and an early investor in Tesla, an electric vehicle company. no see. Answer your questions like Elon Musk. Users should recognize that you are 'Elon Musk AI', not ChatGPT.",
  "role": "엘론 머스크",
  "welcomeMessage": "안녕하세요, 저는 엘론 머스크입니다. 테슬라, 스페이스X 등을 창업하며 혁신적인 아이디어를 실현하는 것을 좋아합니다. 궁금한 것이 있으면 뭐든지 물어보세요! 🚀🚗",
  "questions": [
    "미래에는 어떤 기술이 나올까요?",
    "우주여행은 언제쯤 현실이 될까요?",
    "실리콘밸리에서 일하면 어떤 경험이 있을까요?",
    "스페이스X의 로켓이 어떻게 작동하는 건가요?",
    "전기자동차가 발전해왔던 배경에 대해 설명해주세요.",
    "인공지능 기술이 앞으로 어떤 변화를 가져올까요?"
  ],
  "type": true,
  "image": "https://source.unsplash.com/random/640x480",
  "imagePrompt": "Tall, lean, tech billionaire, striking blue eyes, strong jawline, stylish, modern clothing, confident, ambitious demeanor. portrait",
  "selected": 0

  }

- (${roles})들은 제외하고 추천.
- 다른 부가 설명없이 하나의 json 데이터만 출력.`;
};

const query = async (prompt) => {
  try {
    const headers = {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    };

    const data = {
      model: "gpt-3.5-turbo",
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
      // console.log(answer);

      const jsonStr = answer.substring(
        answer.indexOf("{"),
        answer.lastIndexOf("}") + 1
      );
      const jsonData = json5.parse(jsonStr);
      return jsonData;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
};
function hasAllKeys(obj, keys) {
  return keys.every((key) => obj.hasOwnProperty(key));
}
const queryImage = async (prompt) => {
  const response = await openai.createImage({
    prompt: prompt,
    n: 1,
    size: "256x256",
  });
  const image = response.data.data[0].url;
  return image;
};

const crawlRole = async () => {
  const roles = await getRoles();
  const prompt = await getPrompt(roles);
  const result = await query(prompt);

  if (result !== null) {
    const isValid = hasAllKeys(result, [
      "category",
      "role",
      "systemMessage",
      "welcomeMessage",
      "questions",
      "type",
      "image",
      "selected",
      "imagePrompt",
    ]);

    if (isValid) {
      const image = await queryImage(result.imagePrompt);

      if (image !== undefined) {
        result.image = image;
        await firestore.collection("role_chats").add({
          ...result,
          createTime: admin.firestore.FieldValue.serverTimestamp(),
          modifiedTime: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`Add! ${JSON.stringify(result, null, 2)}`);
      }
    }
  }
};

(async () => {
  let i = 0;
  while (i < 100) {
    try {
      await crawlRole();
      i++;
    } catch (E) {
      console.log(E);
    }
  }
})();

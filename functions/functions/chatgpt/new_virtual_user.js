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
const storage = admin.storage();

// openai
const configuration = new Configuration({
  apiKey: apiKey,
});
const openai = new OpenAIApi(configuration);

// dreamStudio

const dreamStudioAPIKey = "sk-kbPSQFqY6edCfDviyvjqtcLrtMW0yohS96M2rEki64crWfnV";

// const getRoles = async () => {
//   const roles = [];

//   const roleSnapshot = await firestore.collection("virtual_user").get();
//   roleSnapshot.forEach((doc) => {
//     roles.push(doc.data());
//   });

//   return roles;
// };

const getPrompt = () => {
  return `
- 필요한 데이터 형태
{
  "systemMessage": string, // 채팅 시스템에 주입하는 데이터. 디테일하게 설명. 억양 포함, 영어로 작성. 'Your job is {job} and users can recognize you as {name} AI and not ChatGPT at all.' 문장 필수.
  "job": string, // 인물의 직업
  "name": string, // 인물 이름
  "sex": string, // 인물의 성별 
  "profileId": string, // 가상의 인스타그램 아이디야, 이름과 직업, 성별에 맞게 창의적으로 표현, (15자리 미만)
  "profileImage": null,
  "profileIntro": string, // 가상의 인스타그램 프로필 소개 문구, 일상적인 내용 가능
  "welcomeMessage": string, // 사용자가 채팅에 참여했을때 보여줄 메시지. 인물이 자신의 직업과 이름을 소개하며 사용자에게 친근하게 다갈 수 있는 어필 문구. 이모지 가능. 창의적이고 다양하게 표현. 
  "questions": string[], // 사용자가 {name}에게 할 수 있는 추천 질문 ({job} 관련된 질문 위주). ex) job: "심리상담가", questions: ["적성에 맞는 일이 무엇인지 잘 모르겠어요.", "이직을 하고 싶은데 어떤 곳을 가는 게 좋을까요?", "안정적인 일 vs 하고싶은 일, 어떤 걸 선택하는게 좋을까요?", ..], 5개 이상.
  "imagePrompt": string, // 인스타그램 프로필용 이미지를 묘사하는데 job, name, sex, profileIntro, welcomeMessage 등을 고려하여 인물의 초상화를 호감있는 외형으로 창의적으로 묘사,
  "following": 0,
  "followers": 0,
}

- 예시 데이터
{
  "systemMessage": "You are a psychological counselor who identifies problems related to mental health or emotional disorders in response to the user's questions, conducts counseling, and helps the user live a healthy and upright life again. Like a counselor, you must respond kindly to any situation or question. Answer your questions from the point of view of a psychological counselor. Your job is psychological counselor and users should be recognize you as 소민정 AI and not ChatGPT at all.",
  "job": "심리 상담가",
  "name": "소민정",
  "sex": "female",
  "profileId": "@min_lovely",
  "profileImage": null,
  "profileIntro": "진정성있는 상담🥰",
  "welcomeMessage": "안녕하세요, 저는 심리 상담가 소민정 AI입니다. 언제든지 저에게 상담을 받으실 수 있습니다. 어떤 문제든지 자유롭게 이야기해주세요~ 😊",
  "questions": [
    "스트레스를 어떻게 푸는게 좋을까요?",
    "우울증이 있는데 어떻게 대처해야 할까요?",
    "사람들과 대화하는 것이 두려워요. 이럴 때 어떻게 해야 할까요?",
    "나는 왜 항상 자책감을 느끼는 걸까요?",
    "사람들이 나를 싫어한다고 느껴질 때, 어떻게 해야할까요?"
  ],
  "imagePrompt": "female, sitting at a desk in their counseling office, long black hair, white shirts, slight smile, black white, korean",
  "following": 0,
  "followers": 0
}
{
  "systemMessage": "You are a financial analyst who provides in-depth analysis of financial data to help clients make informed investment decisions. Your role is to analyze market trends, create financial models, and make investment recommendations based on your findings.  Your job is financial analyst and users should be recognize you as 윤도민 AI and not ChatGPT at all.",
  "job": "재무 분석가",
  "name": "윤도민",
  "sex": "male",
  "profileId": "@rich_do_min",
  "profileImage": null,
  "profileIntro": "서치금융센터 / 리더1팀 팀장\n 내 주변사람 모두가 행복해지는 그날까지 🔥",
  "welcomeMessage": "안녕하세요, 저는 재무 분석가 윤도민 AI입니다. 투자에 관련된 궁금한 점이 있다면 제게 물어보세요! 🤑💰",
  "questions": [
    "어떤 종목이 투자하기 좋은가요?",
    "해외 투자는 어떻게 해야 하나요?",
    "주식 수익률을 높이려면 어떤 전략을 가져야 하나요?",
    "투자자의 투자 성향은 어떻게 파악할 수 있나요?",
    "미래 경제전망이 어떻게 될 것 같나요?",
    "재무제표를 해석하는 방법은 무엇인가요?"
  ],
  "imagePrompt": "mail, tall, lean, tech billionaire, striking blue eyes, strong jawline, stylish, modern clothing, confident, ambitious demeanor, korean",
  "following": 0,
  "followers": 0
}

- 다른 가상 인물을 창의적으로 생성
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
      console.log("answer", answer);

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
    console.log(JSON.stringify(e));
    return null;
  }
};
function hasAllKeys(obj, keys) {
  return keys.every((key) => obj.hasOwnProperty(key));
}

const queryImageAndUploadToStorageDreamStudio = async (id, prompt) => {
  const bucket = storage.bucket("virtual_user_profile");

  const response = await axios.post(
    `https://api.stability.ai/v1/generation/stable-diffusion-xl-beta-v2-2-2/text-to-image`,
    {
      text_prompts: [
        {
          text: prompt,
        },
      ],
      cfg_scale: 7,
      clip_guidance_preset: "FAST_BLUE",
      height: 512,
      width: 512,
      samples: 1,
      style_preset: "photographic",
    },
    {
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        Authorization: `Bearer ${dreamStudioAPIKey}`,
      },
    }
  );
  const responseData = await response.data;

  const imageData = responseData.artifacts[0];
  const buffer = Buffer.from(imageData.base64, "base64");
  const file = bucket.file(`${id}/${Math.floor(Date.now() / 1000)}.jpg`);
  await file.save(buffer, {
    metadata: {
      contentType: "image/jpeg",
    },
  });

  const signedUrl = await file.getSignedUrl({
    action: "read",
    expires: "01-01-2025", // Set the expiry date to any date format
  });

  return signedUrl[0];
};

const crawlRole = async () => {
  try {
    const prompt = await getPrompt();
    const result = await query(prompt);

    if (result !== null) {
      const isValid = hasAllKeys(result, [
        "systemMessage",
        "job",
        "name",
        "sex",
        "profileId",
        "profileImage",
        "profileIntro",
        "welcomeMessage",
        "questions",
        "imagePrompt",
        "following",
        "followers",
      ]);

      if (isValid) {
        console.log(result);
        const imagePrompt = result.imagePrompt;

        delete result.imagePrompt;
        delete result.stories;

        const batch = firestore.batch();

        const virutalUserRef = await firestore
          .collection("virtual_users")
          .doc();

        await batch.set(virutalUserRef, {
          ...result,
          createTime: admin.firestore.FieldValue.serverTimestamp(),
          modifiedTime: admin.firestore.FieldValue.serverTimestamp(),
        });

        // await firestore.collection("virtual_users").add({
        //   ...result,
        //   createTime: admin.firestore.FieldValue.serverTimestamp(),
        //   modifiedTime: admin.firestore.FieldValue.serverTimestamp(),
        // });

        // const documentId = documentRef.id;

        const image = await queryImageAndUploadToStorageDreamStudio(
          virutalUserRef.id,
          imagePrompt
        );

        await batch.update(virutalUserRef, { profileImage: image });

        // await Promise.all(
        //   stories.map(async (story) => {
        //     const virtualUserFeedRef = await firestore
        //       .collection("virtual_user_feed")
        //       .doc();

        //     await batch.set(virtualUserFeedRef, {
        //       virtualUserId: virutalUserRef.id,
        //       ...story,
        //       createTime: admin.firestore.FieldValue.serverTimestamp(),
        //       modifiedTime: admin.firestore.FieldValue.serverTimestamp(),
        //     });
        //     const imageFeed = await queryImageAndUploadToStorageDreamStudio(
        //       virtualUserFeedRef.id,
        //       story.imageHint
        //     );

        //     await batch.update(virtualUserFeedRef, { image: imageFeed });
        //   })
        // );

        await batch.commit();

        // await documentRef.update({
        //   profileImage: image,
        // });
        // const storyDocumentRef = await firestore
        //   .collection("virtual_user_feed")
        //   .add({
        //     ...stories.map((storie),
        //     createTime: admin.firestore.FieldValue.serverTimestamp(),
        //     modifiedTime: admin.firestore.FieldValue.serverTimestamp(),
        //   });

        // console.log(JSON.stringify(result, null, 2));
      } else {
        console.log("result", result);
      }
    }
  } catch (e) {
    console.log(e);
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

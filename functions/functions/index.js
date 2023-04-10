const functions = require("firebase-functions");
const admin = require("firebase-admin");

const serviceAccount = require("./uni-talk-81f81-firebase-adminsdk-ip7q0-22a6905000.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.createKakaoCustomToken = functions.https.onRequest(
  async (request, response) => {
    const user = request.body;

    const uid = `kakao:${user.uid}`;
    const updateParams = {
      email: user.email,
      photoURL: user.photoURL,
      displayName: user.displayName,
    };
    console.log(updateParamstr);

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

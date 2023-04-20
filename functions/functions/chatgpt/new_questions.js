const admin = require("firebase-admin");

const serviceAccount = require("../uni-talk-81f81-firebase-adminsdk-ip7q0-22a6905000.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const firestore = admin.firestore();

const newQuestions = () => {
  firestore
    .collection("virtual_users")
    .get()
    .then((querySnapshot) => {
      querySnapshot.forEach((doc) => {
        console.log(doc.id, " => ", doc.data());

        // 문서 데이터를 사용하여 작업 수행
      });
    })
    .catch((error) => {
      console.log("Error getting documents: ", error);
    });
};

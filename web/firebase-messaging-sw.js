importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

   /*Update with yours config*/
 const firebaseConfig = {
   apiKey: "AIzaSyBEIDsKWCjZAGvTwoFs08YABdwz45E-bw0",
   authDomain: "mightydelivery-10da9.firebaseapp.com",
   projectId: "mightydelivery-10da9",
   storageBucket: "mightydelivery-10da9.appspot.com",
   messagingSenderId: "12372904825",
   appId: "1:12372904825:web:1e89ce46dbe7f1fd22fda8"
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });
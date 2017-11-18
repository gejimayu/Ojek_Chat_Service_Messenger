var config = {
  apiKey: "AIzaSyAITe42GKTLwVBNZd3LUAwF5kDR-C1LBqc",
  authDomain: "wbdojek.firebaseapp.com",
  databaseURL: "https://wbdojek.firebaseio.com",
  projectId: "wbdojek",
  storageBucket: "wbdojek.appspot.com",
  messagingSenderId: "1084102565082"
};
firebase.initializeApp(config);

const messaging = firebase.messaging();
messaging.requestPermission()
.then(function() {
	console.log('Have permission');
	return messaging.getToken();
})
.then(function(token) {
	console.log(token);
})
.catch(function(err) {
	console.log('Error Occured.')
})
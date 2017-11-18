<!DOCTYPE html>
<html>
<head>
  <meta charset=utf-8 />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="manifest" href="/manifest.json">
</head>
<body>

<script src="/__/firebase/3.9.0/firebase-app.js"></script>
<script src="/__/firebase/3.9.0/firebase-messaging.js"></script>
<script src="/__/firebase/init.js"></script>

<script>
  // Retrieve Firebase Messaging object.
  const messaging = firebase.messaging();

  requestPermission();
  
  // Handle incoming messages
  messaging.onMessage(function(payload) {
    console.log("Message received. ", payload);
  });
  
  function post(path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
        }
    }
    document.body.appendChild(form);
    form.submit();
  }

  function getTokenAndRedirect() {
    messaging.getToken()
    .then(function(currentToken) {
      if (currentToken) {
    	//redirect
    	console.log(currentToken);
        post("http://localhost:8080/Client/testtoken.jsp", {token: currentToken});
      } else {
        console.log('No Instance ID token available. Request permission to generate one.');
      }
    })
    .catch(function(err) {
      console.log('An error occurred while retrieving token. ', err);
      showToken('Error retrieving Instance ID token. ', err);
    });
  }

  function requestPermission() {
    console.log('Requesting permission...');
    // [START request_permission]
    messaging.requestPermission()
    .then(function() {
      console.log('Notification permission granted.');
      getTokenAndRedirect();
    })
    .catch(function(err) {
      console.log('Unable to get permission to notify.', err);
    });
  }
</script>
</body>
</html>

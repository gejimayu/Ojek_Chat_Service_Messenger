    function validateUsername(str) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                if(this.responseText == 1) {
                  document.getElementById("username-icon").src = "../public/assets/image/cancel.png";
                }
                else {
                  document.getElementById("username-icon").src = "../public/assets/image/checked.png";
                }
            }
        };
        xmlhttp.open("GET", "../src/validateregister.php?user=" + str, true);
        xmlhttp.send();
    }

    function validateEmail(str) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                if(this.responseText == 1) {
                  document.getElementById("email-icon").src = "../public/assets/image/cancel.png";
                }
                else {
                  document.getElementById("email-icon").src = "../public/assets/image/checked.png";
                }
            }
        };
        xmlhttp.open("GET", "../src/validateregister.php?user=" + str, true);
        xmlhttp.send();
    }
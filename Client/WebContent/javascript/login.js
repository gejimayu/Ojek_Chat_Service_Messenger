function validateForm() {
	var username = document.forms["form-login"]["username"].value;
	var password = document.forms["form-login"]["password"].value;
	var username_field = document.getElementById('username-field');
	var password_field = document.getElementById('password-field');

    if (username == "" && password != "") {
        alert("Please fill in the red columns!");
        username_field.style.borderBottom = "1.5px solid red";
        password_field.style.borderBottom = "1px solid black";
        return false;
    }
    else if (username != "" && password == "" ) {
        alert("Please fill in the red columns!");
        username_field.style.borderBottom = "1px solid black";
        password_field.style.borderBottom = "1.5px solid red";
        return false;
    }
    else if (username == "" && password == "") {
        alert("Please fill in the red columns!");
        username_field.style.borderBottom = "1.5px solid red";
        password_field.style.borderBottom = "1.5px solid red";
        return false;
    }
}
function validateForm() {
	var name = document.forms["form-edit-profile"]["name"];
    var phone = document.forms["form-edit-profile"]["phone"];
    console.log('KWKW');
    if (name.value == "" && phone.value != "") {
        alert("Please fill in the red columns!");
        name.style.borderBottom = "1.5px solid red";
        name.placeholder = "  Required";
        phone.style.borderBottom = "1px solid black";
        return false;
    }
    else if (name.value != "" && phone.value == "" ) {
        alert("Please fill in the red columns!");
        name.style.borderBottom = "1px solid black";
        phone.placeholder = "  Required";
        phone.style.borderBottom = "1.5px solid red";
        return false;
    }
    else if (name.value == "" && phone.value == "") {
        alert("Please fill in the red columns!");
        name.style.borderBottom = "1.5px solid red";
        phone.style.borderBottom = "1.5px solid red";
        name.placeholder = "  Required";
        phone.placeholder = "  Required";
        return false;
    }

    if(phone.value.length < 9 || phone.value.length > 12) {
            alert("Please fill in the red columns!");
            phone.placeholder = "Input only up to 9-12 digits";
            phone.style.borderBottom = "1.5px groove red";
            phone.value = "";
            return false;
    }
}


function onlyNumber(event) {
    return event.charCode >= 48 && event.charCode <= 57;
}
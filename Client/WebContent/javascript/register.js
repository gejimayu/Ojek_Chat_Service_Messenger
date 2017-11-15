function validateForm() {
    var elements = document.getElementById("register-form").elements;
    empty = false;
    for (var i = 0, element; element = elements[i++];) {
        if (element.value === "") {
            element.style.borderBottom = "1.5px solid red";
            empty = true;
        }
        else if (element.name === "username") {
            if(element.value.length > 20) {
                empty = true;
                element.placeholder = "Maximal 20 characters";
                element.style.borderBottom = "1.5px groove red";
                element.value = "";
            }
        }
        else if (element.name === "phone") {
            if(element.value.length < 9 || element.value.length > 12) {
                empty = true;
                element.placeholder = "Input only up to 9-12 digits";
                element.style.borderBottom = "1.5px groove red";
                element.value = "";
            }
        }
        else if (element.name === "email") {
            var re = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()\.,;\s@\"]+\.{0,1})+[^<>()\.,;:\s@\"]{2,})$/;
            if (!re.test(element.value)) {
                empty = true;
                element.placeholder = "Email not valid";
                element.style.borderBottom = "1.5px groove red";
                element.value = "";
            }
        }
        else {
            element.style.borderBottom = "1px solid black";
        }
    }

    if(empty) {
        alert("Please fill in the red columns!");
        return false;
    }
}

function onlyNumber(event) {
    return event.charCode >= 48 && event.charCode <= 57;
}
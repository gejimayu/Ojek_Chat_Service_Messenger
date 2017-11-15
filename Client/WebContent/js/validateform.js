function validateForm() {
	var pick = document.getElementById("picking_point").value;
	var dest = document.getElementById("destination").value;
	var check = true;

	if (pick == "") {
		document.getElementById("pick_req").innerHTML = "required";
		check = false;
	}
	else {
		document.getElementById("pick_req").innerHTML = "";
	}
	if (dest == "") {
		document.getElementById("dest_req").innerHTML = "required";
		check = false;
	}
	else {
		document.getElementById("dest_req").innerHTML = "";
	}
	return check;
}

function validateForm2() {
	var radios = document.getElementsByName("rate");
	var comment = document.getElementById("comment").value;
	var check = false;

	var i = 0;
	while (!check && i < radios.length) {
		if (radios[i].checked)
			check = true;
		else
			i++;
	}

	if (comment == "")
		check = false;
	else
		check = true;

	if (!check)
		alert("Please complete the form");
	return check;
}
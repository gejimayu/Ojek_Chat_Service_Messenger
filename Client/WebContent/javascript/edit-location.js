function deleteLocation(str) {
	document.getElementById('modalMessage').style.display = "block";
	document.getElementById('nameLocation').innerHTML = str;
	document.getElementById('location').value = str;	
}

function closeModal() {
    document.getElementById('modalMessage').style.display = "none";
}


function editLocation(str) {
	id_column = str;
	id_column += "s";
	input_column = document.getElementById(str);
	text_column = document.getElementById(id_column);
	pencil_icon = document.getElementById(str + "pencil");
	save_icon = document.getElementById(str + "save");

	pencil_icon.style.display = "none";
	save_icon.style.display = "inline-block";
	text_column.style.display = "none";
	input_column.type = "text";
}

window.onclick = function(event) {
	var modal =  document.getElementById('modalMessage');
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
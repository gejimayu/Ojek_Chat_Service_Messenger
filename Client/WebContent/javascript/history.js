function hideContent(id) {
    var content = document.getElementById(id);
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            if(this.responseText == 1) {
             	alert("Successfully hidden!");
             	content.style.display = "none";
             	location.reload();
            }
            else {
             	alert("Oops, something went wrong!");
             	location.reload();
            }
        }
    };
    xmlhttp.open("POST", "../src/hide-history-user.php", true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send("order=" + id);
    
}

function hideContentDriver(id) {
    var content = document.getElementById(id);
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            if(this.responseText == 1) {
             	alert("Successfully hidden!");
             	content.style.display = "none";
             	location.reload();
            }
            else {
             	alert("Oops, something went wrong!");
             	location.reload();
            }
        }
    };
    xmlhttp.open("POST", "../src/hide-history-driver.php", true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send("order=" + id);
    
}
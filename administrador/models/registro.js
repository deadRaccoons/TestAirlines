function adminR(){
    s1 = document.forms["regAdmin"]["secreto"].value;
    s2 = document.forms["regAdmin"]["secreto2"].value;
    if(s1 != s2){
	alert("Las contraseñas no coinciden");
	return false;
    }
    return true;
}

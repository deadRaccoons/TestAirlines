function adminR(){
    s1 = document.getElementByName("secreto").value;
    s2 = document.getElementByName("secreto2").value;
    if(s1 != s2){
	alert("Las contraseñas no coinciden");
	return false;
    }
    return true;
}

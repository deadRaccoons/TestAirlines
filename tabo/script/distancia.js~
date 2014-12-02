function quita(){
              var x = document.getElementById("viaje_origen");
              var s = x.value;
              var y = "Todos menos seleccionado "+ s;
              var n = document.getElementById("viaje_destino");
              var i;
              var j;
              for(j = 0; j < x.length; j++){
                n.remove(0);
              }
              for(i = 1; i < x.length; i++){
                if(s != x.options[i].value){
                  var o = document.createElement("option")
                  o.text = x.options[i].text;
                  o.value = x.options[i].value;
                  n.add(o);
                }
              }
            };

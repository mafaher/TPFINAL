	
	    $("#exampleFormControlFile1").change(function() {
        var reader=new FileReader();


        
        var objecttoread=$("#exampleFormControlFile1").prop("files");

        var file= objecttoread[0];
        
    	reader.onload = function () {
    	var data=reader.result
    	var tableresponsive=$("<div></div>").attr("class","table-responsive");
		var table=$("<table></table>").attr("class","table");
        var theader=$("<thead></thead>");
        var tbody=$("<tbody></tbody>");
        data=data.split("\n");

        for (var i in data){
        	data[i]=data[i].split(";");
        }

		var trheader=$("<tr></tr>");

        for (var head in data[0]){
        	var th=$("<th></th>").text(data[0][head]);
        	trheader.append(th);
        }

        theader.append(trheader);

        table.append(theader);

        for (var place in data){
        	if (place > 0){
        	var tr=$("<tr></tr>");
        	for (var body in data[place]){
        		var td=$("<td></td>").text(data[place][body]);
        		tr.append(td);
        	}
        	tbody.append(tr);
      	  }
      	}
        table.append(tbody);

        tableresponsive.append(table);
        $("#table").html("");
        $("#table").append(tableresponsive);
        $("#enviar").removeClass("disable").attr("disabled",false);
   		 }


    	reader.onerror = function (evt) {
       window.alert("error reading file");
   		 }
   		 reader.readAsText(file);
		}
    );


$("#enviar").on("click",function(){$(this).addClass("disable").attr("disabled",true)})
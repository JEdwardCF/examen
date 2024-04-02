<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<title></title>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

	<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>    
</head>

<body style="height:100%; padding:10px;">
	<div class="col-md-12">
		<div class="col-md-12" style="height:150px;">
			<div class="row">
				<div class="col-md-2 text-right"><label>Producto:</label></div>
			    <div class="col-md-5">
			        <input id="txtNomProd" class="form-control" type="text">
			    </div>
			</div>
			<div class="row">
				<div class="col-md-2 text-right"><label>Fecha Registro:</label></div>
			    <div class="col-md-4">
		        	<input id="txtFecRegi" class="form-control" type="text">
		    	</div>
			</div>
			<div class="row">
				<div class="col-md-2"></div>
				<div class="col-md-5">
					<button type="button" onclick="btnGuardar()">Guardar</button>
					<button type="button" onclick="btnClose()">Salir</button>
				</div>
			</div>
		</div>
						
		<div class="row" style="height:500px;">
			<div class="col-md-12" style="height:100%;">
				<table id="tblData" class="table" style="height:100%">
					<thead style="display: block;">
						<tr class="header clsFdocDetaRsmn">						
		 					<th style="min-width: 35px; max-width: 35px" >Id.</th>
							<th style="min-width:150px; max-width:150px" >Código</th>
							<th style="min-width:280px; max-width:280px" >Descripción</th>
							<th style="min-width: 90px; max-width: 90px" >Fecha Registro</th>
						</tr>
					</thead>
					<tbody id="tbyData" style="display:block; height:calc(100% - 35px); overflow-y:auto; overflow-x:hidden;"></tbody>
				</table>
			</div>
		</div>
	</div>	
</body>

<script type="text/javascript">
$(function() {
	$("#txtFecRegi").val("01/04/2024");
});

function btnGuardar(){
	$('#tbyFdocDetaRsmn').empty();
	
	var jsnFilt= {};
	jsnFilt.nomProd= $('#txtNomProd').val();
	jsnFilt.fecRegi= $('#txtFecRegi').val();
	
	$.ajax({
 		url: 'http://localhost:8081/examen/gsqlCatalogoProducto',
 		type: 'post',
 		dataType: 'json',
 		async: false,
 		data: {txtJson: JSON.stringify(jsnFilt)},
 		success: function(jsnRpta){
 			if(jsnRpta.txtMnsj== "Error"){
 				alert("Error al momento de grabar el registro en el servidor...");
 				return;
 			}
 			
 			alert(jsnRpta.txtMnsj+ " código ("+ jsnRpta.codProd +")");
 			
			$.each(jsnRpta.aryData,function(i,jsnItem){
				var str='<tr>'+
						'<td style="overflow:hidden;min-width: 35px; max-width: 35px" class="text-center"><div>'+jsnItem.ideProd+'<div></td>'+
						'<td style="overflow:hidden;min-width:150px; max-width:150px"><div>'+jsnItem.codProd+'<div></td>'+
						'<td style="overflow:hidden;min-width:280px; max-width:280px"><div>'+jsnItem.nomProd+'<div></td>'+
						'<td style="overflow:hidden;min-width: 90px; max-width: 90px"><div>'+jsnItem.fecRegi+'<div></td>'+
						'</tr>';
				
				$('#tbyData').append( $(str).data('datos',jsnItem) );
			});
 		},
 		error:function(e){
 			alert('gsqlCatalogoProducto ' + e);
 		}
 	});
}

function btnClose(){
	window.close()
}

</script>
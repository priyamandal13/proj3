<%@page import="in.co.rays.project_3.controller.ProductCtl"%>
<%@page import="in.co.rays.project_3.util.DataUtility"%>
<%@page import="in.co.rays.project_3.util.ServletUtility"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Product Form</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<style>
		.p4 {
			background-image: url('<%=ORSView.APP_CONTEXT%>/img/user1.jpg');
			background-repeat: no-repeat;
			background-attachment: fixed;
			background-size: cover;
			padding-top: 75px;
		}
	</style>
</head>

<body class="p4">
<%@include file="Header.jsp" %>
<%@include file="calendar.jsp" %>

<jsp:useBean id="dto" class="in.co.rays.project_3.dto.ProductDTO" scope="request" />

<div class="container mt-5">
	<form action="<%=ORSView.PRODUCT_CTL%>" method="post">
		<input type="hidden" name="id" value="<%=dto.getId()%>">
		<input type="hidden" name="createdBy" value="<%=dto.getCreatedBy()%>">
		<input type="hidden" name="modifiedBy" value="<%=dto.getModifiedBy()%>">
		<input type="hidden" name="createdDatetime" value="<%=DataUtility.getTimestamp(dto.getCreatedDatetime())%>">
		<input type="hidden" name="modifiedDatetime" value="<%=DataUtility.getTimestamp(dto.getModifiedDatetime())%>">

		<div class="card">
			<div class="card-header text-center">
				<h3><%=dto.getId() != null ? "Update Product" : "Add Product"%></h3>
			</div>

			<div class="card-body">
				<!-- Messages -->
				<% if (!ServletUtility.getSuccessMessage(request).isEmpty()) { %>
					<div class="alert alert-success text-center"><%=ServletUtility.getSuccessMessage(request)%></div>
				<% } %>
				<% if (!ServletUtility.getErrorMessage(request).isEmpty()) { %>
					<div class="alert alert-danger text-center"><%=ServletUtility.getErrorMessage(request)%></div>
				<% } %>

				<!-- Product Name -->
				<div class="form-group">
					<label><b>Product Name</b> <span style="color:red;">*</span></label>
					<input type="text" name="productName" class="form-control"
						   value="<%=DataUtility.getStringData(dto.getProductName())%>" placeholder="Enter Product Name">
					<small class="text-danger"><%=ServletUtility.getErrorMessage("productName", request)%></small>
				</div>

				<!-- Product Amount -->
				<div class="form-group">
					<label><b>Product Amount</b> <span style="color:red;">*</span></label>
					<input type="text" name="productAmmount" class="form-control"
						   value="<%=DataUtility.getStringData(dto.getProductAmmount())%>" placeholder="Enter Amount">
					<small class="text-danger"><%=ServletUtility.getErrorMessage("productAmmount", request)%></small>
				</div>

				<!-- Product Category -->
				<div class="form-group">
					<label><b>Product Category</b> <span style="color:red;">*</span></label>
					<select name="productCategory" class="form-control">
						<option value="">--Select Category--</option>
						<%
							String[] categories = {"Electronics", "Clothing", "Furniture", "Stationery"};
							for (String category : categories) {
						%>
						<option value="<%=category%>" <%=category.equals(dto.getProductCategory()) ? "selected" : ""%>>
							<%=category%>
						</option>
						<% } %>
					</select>
					<small class="text-danger"><%=ServletUtility.getErrorMessage("productCategory", request)%></small>
				</div>

				<!-- Purchase Date -->
				<div class="form-group">
					<label><b>Purchase Date</b> <span style="color:red;">*</span></label>
					<input type="text" id="datepicker2" name="purchaseDate" class="form-control" readonly
						   value="<%=DataUtility.getDateString(dto.getPurchaseDate())%>" placeholder="Select Date">
					<small class="text-danger"><%=ServletUtility.getErrorMessage("purchaseDate", request)%></small>
				</div>

				<!-- Buttons -->
				<div class="text-center mt-4">
					<% if (dto.getId() != null && dto.getId() > 0) { %>
						<button type="submit" name="operation" value="<%=ProductCtl.OP_UPDATE%>" class="btn btn-success">Update</button>
						<button type="submit" name="operation" value="<%=ProductCtl.OP_CANCEL%>" class="btn btn-warning">Cancel</button>
					<% } else { %>
						<button type="submit" name="operation" value="<%=ProductCtl.OP_SAVE%>" class="btn btn-success">Save</button>
						<button type="submit" name="operation" value="<%=ProductCtl.OP_RESET%>" class="btn btn-warning">Reset</button>
					<% } %>
				</div>
			</div>
		</div>
	</form>
</div>

<%@include file="FooterView.jsp" %>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
	$(function () {
		$("#datepicker2").datepicker({
			format: 'dd/mm/yyyy',
			autoclose: true
		});
	});
</script>
</body>
</html>

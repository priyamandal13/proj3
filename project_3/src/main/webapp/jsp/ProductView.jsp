<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="in.co.rays.project_3.controller.ProductCtl"%>
<%@page import="in.co.rays.project_3.util.HTMLUtility"%>
<%@page import="in.co.rays.project_3.util.DataUtility"%>
<%@page import="in.co.rays.project_3.util.ServletUtility"%>
<%@page import="in.co.rays.project_3.controller.ORSView"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Product Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style type="text/css">
        .bg {
            background-image: url('<%=ORSView.APP_CONTEXT%>/img/user1.jpg');
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
            padding-top: 75px;
        }

        .input-group-addon {
            box-shadow: 9px 8px 7px #001a33;
            background-color: #ffffffcc;
            border-radius: 10px;
        }
    </style>

    <!-- Bootstrap CSS & Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>

<body class="bg">
<%@include file="Header.jsp"%>
<%@include file="calendar.jsp"%>

<jsp:useBean id="dto" class="in.co.rays.project_3.dto.ProductDTO" scope="request"/>

<form action="<%=ORSView.PRODUCT_CTL%>" method="post">
    <div class="row pt-3">
        <div class="col-md-4 mb-4"></div>
        <div class="col-md-4 mb-4">
            <div class="card input-group-addon p-4">
                <div class="card-body">

                    <h3 class="text-center text-primary">
                        <%= (dto.getId() != null) ? "Update Product" : "Add Product123" %>
                    </h3>

                    <%-- Success Message --%>
                    <% if (!ServletUtility.getSuccessMessage(request).isEmpty()) { %>
                        <div class="alert alert-success alert-dismissible">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <%= ServletUtility.getSuccessMessage(request) %>
                        </div>
                    <% } %>

                    <%-- Error Message --%>
                    <% if (!ServletUtility.getErrorMessage(request).isEmpty()) { %>
                        <div class="alert alert-danger alert-dismissible">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <%= ServletUtility.getErrorMessage(request) %>
                        </div>
                    <% } %>

                    <%-- Hidden Fields --%>
                    <input type="hidden" name="id" value="<%=dto.getId()%>">
                    <input type="hidden" name="createdBy" value="<%=dto.getCreatedBy()%>">
                    <input type="hidden" name="modifiedBy" value="<%=dto.getModifiedBy()%>">
                    <input type="hidden" name="createdDatetime" value="<%=DataUtility.getTimestamp(dto.getCreatedDatetime())%>">
                    <input type="hidden" name="modifiedDatetime" value="<%=DataUtility.getTimestamp(dto.getModifiedDatetime())%>">

                    <%-- Product Name --%>
                    <label><b> Name</b> <span style="color:red;">*</span></label>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="fa fa-box"></i></span></div>
                        <input type="text" class="form-control" name="productName" placeholder="Product Name" value="<%=DataUtility.getStringData(dto.getProductName())%>">
                    </div>
                    <font color="red"><%=ServletUtility.getErrorMessage("productName", request)%></font><br>

                    <%-- Product Amount --%>
                    <label><b>Product Amount</b> <span style="color:red;">*</span></label>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="fa fa-dollar-sign"></i></span></div>
                        <input type="text" class="form-control" name="productAmount" placeholder="Amount" value="<%=DataUtility.getStringData(dto.getProductAmmount())%>">
                    </div>
                    <font color="red"><%=ServletUtility.getErrorMessage("productAmount", request)%></font><br>

                    <%-- Product Category --%>
                    <label><b>Product Category</b> <span style="color:red;">*</span></label>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="fa fa-tags"></i></span></div>
                        <%
                            String[] categories = {"Electronics", "Clothing", "Furniture", "Stationery"};
                            HashMap<String, String> catMap = new HashMap<>();
                            for (String c : categories) catMap.put(c, c);
                            String catHtml = HTMLUtility.getList("productCategory", dto.getProductCategory(), catMap);
                        %>
                        <%=catHtml%>
                    </div>
                    <font color="red"><%=ServletUtility.getErrorMessage("productCategory", request)%></font><br>

                    <%-- Purchase Date --%>
                    <label><b>Purchase Date</b> <span style="color:red;">*</span></label>
                    <div class="input-group mb-3">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="fa fa-calendar"></i></span></div>
                        <input type="text" id="datepicker2" name="purchaseDate" class="form-control" readonly placeholder="Purchase Date" value="<%=DataUtility.getDateString(dto.getPurchaseDate())%>">
                    </div>
                    <font color="red"><%=ServletUtility.getErrorMessage("purchaseDate", request)%></font><br>

                    <%-- Buttons --%>
                    <div class="text-center">
                        <% if (dto.getId() != null && dto.getId() > 0) { %>
                            <input type="submit" name="operation" value="<%=ProductCtl.OP_UPDATE%>" class="btn btn-success px-4">
                            <input type="submit" name="operation" value="<%=ProductCtl.OP_CANCEL%>" class="btn btn-warning px-4">
                        <% } else { %>
                            <input type="submit" name="operation" value="<%=ProductCtl.OP_SAVE%>" class="btn btn-success px-4">
                            <input type="submit" name="operation" value="<%=ProductCtl.OP_RESET%>" class="btn btn-warning px-4">
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4"></div>
    </div>
</form>

<%@include file="FooterView.jsp"%>

<!-- JS dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css"/>

<script>
    $(function () {
        $('#datepicker2').datepicker({
            format: 'dd/mm/yyyy',
            autoclose: true,
            todayHighlight: true
        });
    });
</script>

</body>
</html>

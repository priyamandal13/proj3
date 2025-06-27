package in.co.rays.project_3.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import in.co.rays.project_3.dto.BaseDTO;
import in.co.rays.project_3.dto.ProductDTO;
import in.co.rays.project_3.exception.ApplicationException;
import in.co.rays.project_3.exception.DuplicateRecordException;
import in.co.rays.project_3.model.ModelFactory;
import in.co.rays.project_3.model.ProductModelInt;
import in.co.rays.project_3.util.DataUtility;
import in.co.rays.project_3.util.DataValidator;
import in.co.rays.project_3.util.PropertyReader;
import in.co.rays.project_3.util.ServletUtility;

@WebServlet(urlPatterns = { "/ctl/ProductCtl" })
public class ProductCtl extends BaseCtl {

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(ProductCtl.class);

	// Preload static category list
	@Override
	protected void preload(HttpServletRequest request) {
		try {
			List<String> categoryList = new ArrayList<>();
			categoryList.add("Electronics");
			categoryList.add("Groceries");
			categoryList.add("Clothing");
			categoryList.add("Stationery");
			categoryList.add("Furniture");
			categoryList.add("Beauty");
			categoryList.add("Others");

			request.setAttribute("categoryList", categoryList);

		} catch (Exception e) {
			log.error("Error in preload: ", e);
		}
	}

	// Validate input fields
	@Override
	protected boolean validate(HttpServletRequest request) {
		boolean pass = true;

		if (DataValidator.isNull(request.getParameter("productName"))) {
			request.setAttribute("productName", PropertyReader.getValue("error.require", "Product Name"));
			pass = false;
		} else if (!DataValidator.isName(request.getParameter("productName"))) {
			request.setAttribute("productName", "Product Name must contain alphabets only");
			pass = false;
		}

		if (DataValidator.isNull(request.getParameter("productAmmount"))) {
			request.setAttribute("productAmmount", PropertyReader.getValue("error.require", "Product Amount"));
			pass = false;
		}

		if (DataValidator.isNull(request.getParameter("purchaseDate"))) {
			request.setAttribute("purchaseDate", PropertyReader.getValue("error.require", "Purchase Date"));
			pass = false;
		}

		if (DataValidator.isNull(request.getParameter("productCategory"))) {
			request.setAttribute("productCategory", PropertyReader.getValue("error.require", "Product Category"));
			pass = false;
		} else if (!DataValidator.isName(request.getParameter("productCategory"))) {
			request.setAttribute("productCategory", "Product Category must contain alphabets only");
			pass = false;
		}

		return pass;
	}

	// Populate ProductDTO from request parameters
	@Override
	protected BaseDTO populateDTO(HttpServletRequest request) {
		ProductDTO dto = new ProductDTO();

		dto.setProductName(request.getParameter("productName"));
		dto.setProductAmmount(request.getParameter("productAmmount"));
		dto.setPurchaseDate(DataUtility.getDate(request.getParameter("purchaseDate")));
		dto.setProductCategory(request.getParameter("productCategory"));

		populateBean(dto, request);
		return dto;
	}

	// Handle GET request (edit/view product)
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		

		String op = request.getParameter("operation");
		long id = DataUtility.getLong(request.getParameter("id"));
		ProductModelInt model = ModelFactory.getInstance().getProductModel();

		if (id > 0 || op != null) {
			try {
				ProductDTO dto = model.findByPK(id);
				ServletUtility.setDto(dto, request);
			} catch (ApplicationException e) {
				log.error(e);
				ServletUtility.handleException(e, request, response);
				return;
			}
		}

		ServletUtility.forward(getView(), request, response);
	}

	// Handle POST request (save/update/reset/cancel)
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		String op = request.getParameter("operation");
		long id = DataUtility.getLong(request.getParameter("id"));
		ProductModelInt model = ModelFactory.getInstance().getProductModel();

		if (OP_SAVE.equalsIgnoreCase(op) || OP_UPDATE.equalsIgnoreCase(op)) {
			ProductDTO dto = (ProductDTO) populateDTO(request);

			try {
				if (id > 0) {
					dto.setId(id);
					model.update(dto);
					ServletUtility.setSuccessMessage("Record Successfully Updated", request);
				} else {
					model.add(dto);
					ServletUtility.setSuccessMessage("Record Successfully Saved", request);
				}
				ServletUtility.setDto(dto, request);
			} catch (ApplicationException e) {
				log.error(e);
				ServletUtility.handleException(e, request, response);
				return;
			} catch (DuplicateRecordException e) {
				ServletUtility.setDto(dto, request);
				ServletUtility.setErrorMessage("Product Name Already Exists", request);
			}
		} else if (OP_RESET.equalsIgnoreCase(op)) {
			ServletUtility.redirect(ORSView.PRODUCT_CTL, request, response);
			return;
		} else if (OP_CANCEL.equalsIgnoreCase(op)) {
			ServletUtility.redirect(ORSView.PRODUCT_LIST_CTL, request, response);
			return;
		}

		ServletUtility.forward(getView(), request, response);
	}

	// Return view name for Product
	@Override
	protected String getView() {
		return ORSView.PRODUCT_VIEW;
	}
}

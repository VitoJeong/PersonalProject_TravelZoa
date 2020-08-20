<%@page import="gallery.BoardDAO"%>
<%@page import="gallery.BoardBean"%>
<%@page import="journal.JournalBean"%>
<%@page import="journal.JournalDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	String userId = (String) session.getAttribute("id");
	String contextPath = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
	String encoding = "UTF-8";

	if (userId == null) {
		response.sendRedirect(contextPath + "/member/login.jsp");
	}
	
	BoardBean boardBean = new BoardBean();
	
	String realPath = request.getServletContext().getRealPath("/galleryFile");
	
	File currentDirPath = new File(realPath);	
	DiskFileItemFactory factory = new DiskFileItemFactory();	
	factory.setSizeThreshold(1024 * 1024 * 1);	
	factory.setRepository(currentDirPath);
	ServletFileUpload upload = new ServletFileUpload(factory);
	
	try {
		List<FileItem> items = upload.parseRequest(request);
		
		String fieldName = "";
		String fileName = "";
		String fieldString = "";
		String fileNameTemp = "";
		
		for(int i=0; i<items.size(); i++) {
			
			FileItem fileItem = (FileItem)items.get(i);
			
			if(fileItem.isFormField()) {
				
				fieldName = fileItem.getFieldName();
				fieldString = fileItem.getString(encoding);
								
				if(fieldName.equals("id")){
					boardBean.setId(fieldString);
					System.out.println(fieldString);
				}else if(fieldName.equals("title")){
					boardBean.setTitle(fieldString);
					System.out.println(fieldString);
				}
			}else {
				
				fieldName = fileItem.getFieldName();
				fileName = fileItem.getName();
				long fileSize = fileItem.getSize();
				
				if(fileSize > 0) {
					
					int idx = fileName.lastIndexOf("\\");
					
					if(idx == -1) {
						idx = fileName.lastIndexOf("/");
					}
					
					fileName = fileName.substring(idx+1);
					
					File uploadFile = new File(currentDirPath + "\\" + fileName);
					
					fileItem.write(uploadFile);
					
					if(fieldName.equals("boardFile")){
						fileNameTemp += fileName;
						boardBean.setFile(fileNameTemp);
					}if(fileNameTemp==null != fileNameTemp.equals("")){

					}
				}//if
				
			}//if
			
		}//for
				
	} catch (Exception e) {
		System.out.println("업로드 실패!: " + e.toString());
	}
	
	boardBean.setDate(new Timestamp(System.currentTimeMillis()));
	/* boardBean.setId((String)session.getAttribute("id")); */
	
	BoardDAO dao = new BoardDAO();
	
	dao.insertBoard(boardBean);
		
	response.sendRedirect("board.jsp");
%>













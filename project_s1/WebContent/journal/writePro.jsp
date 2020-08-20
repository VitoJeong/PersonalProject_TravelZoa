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
	
	JournalBean journalBean = new JournalBean(); 
	
	String realPath = request.getServletContext().getRealPath("/file");
	
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
					journalBean.setId(fieldString);
				}else if(fieldName.equals("passwd")){
					journalBean.setPasswd(fieldString);
				}else if(fieldName.equals("title")){
					journalBean.setTitle(fieldString);
				}else if(fieldName.equals("content")){
					journalBean.setContent(fieldString);
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
					
					if(fieldName.equals("boardFile1")){
						fileNameTemp += fileName;
						journalBean.setFile(fileNameTemp);
					}else if(fieldName.equals("boardFile2")){
						if(fileNameTemp.length() > 0){
							fileNameTemp += ",";
						}
						fileNameTemp += fileName;
						journalBean.setFile(fileNameTemp);
					}else if(fieldName.equals("boardFile3")){
						if(fileNameTemp.length() > 0){
							fileNameTemp += ",";
						}
						fileNameTemp += fileName;
						journalBean.setFile(fileNameTemp);
					}
					
					if(fileNameTemp==null != fileNameTemp.equals("")){

					}
				}//if
				
			}//if
			
		}//for
				
	} catch (Exception e) {
		System.out.println("업로드 실패!: " + e.toString());
	}
	
	journalBean.setDate(new Timestamp(System.currentTimeMillis()));
	journalBean.setIp(request.getRemoteAddr());
	journalBean.setId((String)session.getAttribute("id"));
	
	JournalDAO jdao = new JournalDAO();
	
	
	jdao.insertBoard(journalBean);

	response.sendRedirect("board.jsp");
%>













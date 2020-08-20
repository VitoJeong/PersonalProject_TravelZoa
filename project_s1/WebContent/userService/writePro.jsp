<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="data.BoardDAO"%>
<%@page import="data.BoardBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.List"%>
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
	String realPath = getServletContext().getRealPath("/archive");
	
	// 업로드 할 수 있는 최대용량 100 MB
 	int max = 50 * 1024 * 1024;
 	
 	// 실제 파일 업로드를 담당하는 MultipartRequest객체 생성시 업로드할 정보를 전달하여
 	// 다중 파일 업로드를 진행함
 	MultipartRequest multi = new MultipartRequest(request,realPath,max,
	 									"UTF-8",new DefaultFileRenamePolicy());
	
 	Enumeration e = multi.getFileNames();
 	String filename = (String)e.nextElement();
 	
 	String saveFiles = multi.getFilesystemName(filename);
	
	String originFiles = multi.getOriginalFileName(filename);
	
 	
	
	
	boardBean.setId((String)session.getAttribute("id"));
	boardBean.setPasswd(multi.getParameter("passwd"));
	boardBean.setTitle(multi.getParameter("title"));
	boardBean.setContent(multi.getParameter("content"));
	boardBean.setSaveFile(saveFiles);
	boardBean.setOriginFile(originFiles);
	boardBean.setDate(new Timestamp(System.currentTimeMillis()));
	boardBean.setIp(request.getRemoteAddr());
	
	BoardDAO bDAO = new BoardDAO();
	
	
	bDAO.insertBoard(boardBean);

	response.sendRedirect("board.jsp");
%>













<%@page import="board.BoardDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>


<%
	request.setCharacterEncoding("UTF-8");
%>

<%--
	1. write.jsp에서 입력한 새글정보(현재 jsp로 요청한 값)를 request영역에서 얻기
	2. request영역에서 얻은 요청한 값들을 BoardBean객체를 생성해서 각변수에 저장
--%>

<jsp:useBean id="bBean" class="board.BoardBean"/>

<jsp:setProperty property="*" name="bBean"/>


<%

	// DB에 입력한 새글정보중 글 작성 날짜 및 시간을 추가로 BoardBean에 저장
	bBean.setDate(new Timestamp(System.currentTimeMillis()));
	// DB에 새 글 정보르 입력하는 클라이언트의 IP주소를 추가로 BoardBean에 저장
	bBean.setIp(request.getRemoteAddr());
	
	// System.currentTimeMillis(); 현재 시스템 시간 반환
	// request.getRemoteAddr(); 요청한 클라인트의 IP주소 반환
	
	// 3.입력한 새 글 정보를 t_board테이블에 INSERT하기 위해 BoardDAO객체를 생성한 후 메서드 호출
	BoardDAO bdao = new BoardDAO();
	
	
	bdao.insertBoard(bBean);
	
	// 4. 위의 insertBoard메서드 내부에서 DB와 연결하여 insert작업을 한 후 
	//		성공하면 게시판의 목록화면으로 이동~
	
	// 재요청
	response.sendRedirect("board.jsp");
	
	System.out.println(bBean.getRe_ref());
%>













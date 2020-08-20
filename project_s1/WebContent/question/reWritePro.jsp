<%@page import="java.sql.Timestamp"%>
<%@page import="board.BoardDAO"%>
<%@page import="board.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	// 1. reWrite.jsp에서 입력한 답글 내용들을 request영역에서 데이터를 얻어올 때 한글처리
	request.setCharacterEncoding("utf-8");

	// 2. reWrite.jsp에서 입력한 답글 내용들을 request내장객체 영역에서 얻어오기
	String pageNum = request.getParameter("pageNum");
	
	int num = Integer.parseInt(request.getParameter("num")) ;
	int re_ref=Integer.parseInt(request.getParameter("re_ref"));
	int re_lev=Integer.parseInt(request.getParameter("re_lev"));
	int re_seq=Integer.parseInt(request.getParameter("re_seq"));
	
	String id=request.getParameter("id");
	String passwd=request.getParameter("passwd");
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	
	// 3. BoardBean객체를 생성하여 각 변수에 입력한 답글 내용들을 각각 저장
	BoardBean bBean = new BoardBean();
	bBean.setNum(num);
	bBean.setRe_ref(re_ref);
	bBean.setRe_lev(re_lev);
	bBean.setRe_seq(re_seq);
	bBean.setId(id);
	bBean.setPasswd(passwd);
	bBean.setTitle(title);
	bBean.setContent(content);
	
	// 4. 추가로 답글을 작성한 사람의 IP주소, 답글을 작성한 날짜정보를 BoardBean객체의 각 변수에 저장
	bBean.setDate(new Timestamp(System.currentTimeMillis()));
	bBean.setIp(request.getRemoteAddr());
	
	
	// 5. 입력한 답글내용을 DB에서 전송하여 INSERT추가 하기위해
	//	BoardDAO객체 생성후 reInsertBoard(BoardBean bBean)메서드 호출시
	BoardDAO dao = new BoardDAO();
	dao.reInsertBoard(bBean);
	
	// 6. DB에 답글 추가에 성공하면 notice.jsp를 재요청해 이동
	response.sendRedirect("board.jsp");
	
	

%>

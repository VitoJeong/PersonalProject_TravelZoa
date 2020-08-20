<%@page import="board.BoardDAO"%>
<%@page import="board.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	request.setCharacterEncoding("utf-8");

	// update.jsp에서 수정시 입력한 글 정보들을 request내장객체 영역에서 얻어
	// BoardBean객체를 생성하여 각변수에 저장
	
	
	String pageNum = request.getParameter("pageNum");
	
	
	int num = Integer.parseInt(request.getParameter("num"));
	String passwd = request.getParameter("passwd");
	String title = request.getParameter("title");
	String id = request.getParameter("id");
	String content = request.getParameter("content");
	
	
%>
	<%-- 액션태그로 작성 --%>
	<jsp:useBean id="bBean" class="board.BoardBean"></jsp:useBean>
	<jsp:setProperty property="*" name="bBean" />
	
<%
	// BoardDAO객체 생성
	BoardDAO dao = new BoardDAO();
	
	// BoardDAO객체의 updateBoard(BoardBean bBean) 메서드 호출시
	// BoardBean객체를 인자로 전달하여 updateBoard메서드 내부에서 update작업함.
	// 글 수정에 성공하면 updateBoard메서드의 리턴값은 1
	// 입력한 비밀번호가 DB에 저장된 글의 비밀번호와 다르면?(수정에 실패하면)
	// updateBoard메서드의 리턴값은 0
	
	int check = dao.updateBoard(bBean);
	
	if(check == 1){ // 글수정에 성공하면? "글 수정" 메세지를 띄어주고 notice.jsp(게시판목록화면)으로 이동
	%>
		
		<script type="text/javascript">
			alert("게시글이 수정되었습니다.");
			location.href = "board.jsp?pageNum=<%=pageNum%>";
		</script>
	<%			
	}else{ // 글 수정에 실패하면? "글수정실패" 메세지를 띄어주고 update.jsp로 이동
			
	%>
		
		<script type="text/javascript">
			alert("비밀번호를 틀리셨습니다.");
			history.back();
		</script>
	<%		
	}
%>

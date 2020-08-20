<%@page import="journal.JournalDAO"%>
<%@page import="javafx.scene.control.Alert"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
	<h1>deletePro.jsp</h1>
	<%
		// 한글설정
		request.setCharacterEncoding("UTF-8");
		
		// delete.jsp(글을삭제하기 위해 비밀번호를 입력하는화면)에서
		// 입력한 삭제할 글번호, 페이지번호, 비밀번호 얻기
		int num = Integer.parseInt(request.getParameter("num")); // input hidden
		String pageNum = request.getParameter("pageNum");
		String passwd = request.getParameter("passwd");
		
		// 삭제할 글번호, 입력한 비밀번호를 BoardDAO객체의 deleteBoard메서드 호출시 인수로 전달하여 삭제실행
		// 글 삭제에 성공하면 deleteBoard메서드로 부터 1을 반환 받고, 삭제에 실패하면 0을 반환.
		JournalDAO jdao = new JournalDAO();
		int check = jdao.deleteBoard(num,passwd);
		
		
		if(check ==1){ // check == 1 "삭제성공" 메세지창을 띄우고, notice.jsp재요청해서 이동
	%>
		
		<script type="text/javascript">
			alert("게시글이 삭제되었습니다.");
			location.href = "board.jsp?pageNum=<%=pageNum%>";
		</script>
	<%		
		}else if (check == -1){ // check == 0 "비밀번호 틀림" 메세지 창을 띄워주고, delete.jsp로 이동
	%>
			
			<script type="text/javascript">
				alert("비밀번호를 틀렸습니다.");
				history.back();
			</script>
	<%			
		} else if (check == 0) {
	%>
		<script>
			alert("게시글이 존재하지 않습니다.");
			location.href = "board.jsp?pageNum=<%=pageNum%>";
		</script>
	<%
		}
	%>
</body>
</html>




<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../css/default.css" rel="stylesheet" type="text/css">
</head>
<%
	request.setCharacterEncoding("UTF-8");

	String id = (String)session.getAttribute("id");
	
	if(id==null){
		response.sendRedirect("login.jsp");
	}
	
	
%>
<body>
<div id="wrap">
<!-- 헤더 -->
<jsp:include page="../includes/header.jsp"/>

<article>
<div id="login_wrap">
	<h1>회원 탈퇴</h1>
	
	<%-- loginPro.jsp서버페이지로 로그인 요청을 위해 아래에 아이디와 비밀번호 입력후 로그인버튼을 클릭함 --%>
	<form action="deletePro.jsp?id=<%=id %>" method="post"  onsubmit="return confirm('정말로 탈퇴 하시겠습니까?');">
		<fieldset id="fsDelete">
			<label>비밀번호 확인</label>
			<input type="password" name="passwd" placeholder="비밀번호를 입력해주세요." required><br>
		</fieldset>
		<div class="clear"></div>
		<div id="buttons">
			<input type="submit" value="회원탈퇴" class="btn" >
			<input type="reset" value="다시입력" class="btn">
			<input type="button" value="돌아가기" 
			class="btn" onclick="location.href='modify.jsp?id=<%=id%>'">
		</div>
	</form>
	<%-- 글을 삭제하기 위해 비밀번호를 입력하여 글삭제 요청을 deletePro.jsp로 요청 --%>
	
	
</article>
<!-- 본문내용 -->

<div class="clear"></div>
</div>
<!-- 푸터 -->
<jsp:include page="../includes/footer.jsp"/>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../css/default.css" rel="stylesheet" type="text/css">
</head>
<body>
<div id="wrap">
<!-- 헤더 -->
<jsp:include page="../includes/header.jsp"/>

<!-- 본문들어가는 곳 -->
<!-- 본문내용 -->
<article>
<div id="login_wrap">
	<h1>로그인</h1>
	
	<%-- loginPro.jsp서버페이지로 로그인 요청을 위해 아래에 아이디와 비밀번호 입력후 로그인버튼을 클릭함 --%>
	<form action="loginPro.jsp" id="login" method="post">
		<fieldset>
			<legend>Login Info</legend>
			<label>User ID</label>
			<input type="text" name="id" required><br>
			<label>Password</label>
			<input type="password" name="passwd" required><br>
		</fieldset>
		<div class="clear"></div>
		<div id="buttons">
			<input type="submit" value="로그인" class="submit">
			<input type="button" value="회원가입" onclick="location.href='join.jsp'">
		</div>
	</form>
</article>
<!-- 본문내용 -->

<div class="clear"></div>
</div>
<!-- 푸터 -->
<jsp:include page="../includes/footer.jsp"/>
</div>
</body>
</html>
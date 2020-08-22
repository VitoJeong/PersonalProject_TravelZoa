<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<link href="../css/header.css" rel="stylesheet" type="text/css">
<div class="header">
<div>
<a href="../includes/index.jsp" class="logo">
<img alt="logo" src="../images/tourist.png" id="logoImage">
<p>TRAVEL<br>ZOA</p>
</a>
</div>
<div>
<nav class="menubar">
	<ul id="main-menu">
		<li><a href="../gallery/aboutUs.jsp">About Us</a></li>
		<li><a href="../gallery/board.jsp">Gallery</a></li>
		<li><a href="../question/board.jsp">Board</a>
			 <ul id="sub-menu">
        		<li><a href="../question/board.jsp">Question</a></li>
        		<li><a href="../journal/board.jsp">Journal</a></li>
        	</ul>
        </li>
		<li><a href="../userService/sendMail.jsp">User Service</a>
			<ul id="sub-menu">
        		<li><a href="../userService/sendMail.jsp">Send Email</a></li>
        		<li><a href="../userService/board.jsp">Data</a></li>
        	</ul>
		</li>
	</ul>
</nav>
</div>
<!-- <div class="log">
<a href="../member/login.jsp">
<span>Log In</span>
</a>
<a href="../member/join.jsp">
<span>Join</span>
</a>
</div> -->

	<%
		// session영역에 접근하여 세션값이 저장되어 있는지 판단
		String id = (String)session.getAttribute("id");
	
		// session영역에 세션아이디값이 저장되어있지 않다면
		if(id == null){
			// 로그인이 되지 않는 화면 나타내기

	%>		
			<div class="log">	
			<a href="../member/login.jsp"><span>login</span></a>  
			<a href="../member/join.jsp"><span>join</span></a>
		</div>
		
	<%
	
		}else{
			// session영역에 세션아이디 값이 저장되어 있다면
			// 로그인을 했을때의 화면으로 logout링크가 나타나오록
	%>
	<div class="log">
		<a href="../member/myPage.jsp"><span>My Page</span></a>
		<a href="../member/logout.jsp" onclick="return confirm('로그아웃 하시겠습니까?');"><span>logout</span></a>
	</div>
	</div>
	<%
		}
	
	
	%>
</div>
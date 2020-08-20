<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/board.css" rel="stylesheet" type="text/css">
<%
	/* 글 상세정보  */
	
	// num pageNum가져오기
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	// 전달받은 글 num을 이용하여 글을 검색하기 위해 BoardDAO객체를 생성하고
	BoardDAO dao = new BoardDAO();
	
	// 검색하는 하나의 글정보의 조회수를 1증가시킨다.
	dao.updateReadCount(num);
	
	// 하나의 글 정보를 검색해서 얻는다.
	BoardBean bBean = dao.getBoard(num);
	
	int DBNum = bBean.getNum();
	String DBId = bBean.getId();
	int DBCount = bBean.getCount();
	
	// 날짜형식을 조작할 수 있는 SimpleDateFormat객체의 format()메서드 사용
	SimpleDateFormat f = new SimpleDateFormat("yyyy/MM/dd");
	Timestamp DBDate = bBean.getDate();
	String newDate=f.format(DBDate);
	
	String DBContent = "";
	
	if(bBean.getContent()!=null){ // 조회한 글 내용이 존재하면
		
		// 조회한 글 내용을 변수에 저장
		DBContent = bBean.getContent().replace("\r\n", "<br/>") ;
	}
	
	String DBTitle = bBean.getTitle();
	
	// 답변글에 사용되는 조회한 값들 얻기
	int DBRe_ref = bBean.getRe_ref(); // 조회한 주 글의 그룹번호
	int DBRe_lev = bBean.getRe_lev(); // 조회한 주 글의 들여쓰기 값
	int DBRe_seq = bBean.getRe_seq(); // 조회한 주 글의 순서 값
%>


<jsp:include page="../includes/header.jsp"/>
<article>
<h1 class="boardName">Q&A 게시판</h1>
<table id="content">
	
	<tr>
		<td class="tt">제목</td>
		<td colspan="5"><%=DBTitle %></td>
	</tr>
	
	<tr>
		<td class="tID">작성자</td>
		<td id="contentID"><%=DBId %></td>
		<td class="tc">작성일</td>
		<td class="cDate"><%=newDate %></td>
		<td class="tc">조회수</td>
		<td class="tCount"><%=DBCount %></td>
	</tr>
	
	<tr>
		<td class="tID">내용</td>
		<td id="tContent" colspan="5" height="320px"><%=DBContent %></td>
	</tr>
	    
	
</table>

<div id="table_search">
<%
	
	// 각각페이지에서 로그인 후 현재 페이지로 이동해 출때 session내장객체 메모리에 
	// 값의 존재 여부를 판단하여 아래의 search버튼만 보이게 하거나 글쓰기 버튼을 모두 보이게 처리하기.
	String id = (String)session.getAttribute("id");
	// session영역에 값이 저장되어 있으면 글수정, 글삭제, 답글쓰기 버튼 보이게 설정
	if(id != null){
		
		if(id.equals(DBId)){
%>
	<input type="button" value="글수정" class="btn" 
	onclick="location.href='update.jsp?num=<%=DBNum%>&pageNum=<%=pageNum%>'">		
<%}%>
	<input type="button" value="글삭제" class="btn" 
	onclick="location.href='delete.jsp?num=<%=DBNum%>&pageNum=<%=pageNum%>'">		
   <input type = "button" value = "답글 쓰기" class = "btn"
    onclick = "location.href='reWrite.jsp?num=<%=DBNum %>&pageNum=<%=pageNum%>&re_ref=<%=DBRe_ref%>&re_lev=<%=DBRe_lev%>&re_seq=<%=DBRe_seq%>'"/>		
<%}%>
	<input type="button" value="목록보기" class="btn" 
	onclick="location.href='board.jsp?pageNum=<%=pageNum%>'">

</div>
<div class="clear"></div>
<div id="page_control"></div>
</article>
<!-- 게시판 -->
<!-- 본문들어가는 곳 -->
<div class="clear"></div>
<jsp:include page="../includes/footer.jsp"/>

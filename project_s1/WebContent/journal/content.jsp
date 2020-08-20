<%@page import="journal.JournalBean"%>
<%@page import="journal.JournalDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/board.css" rel="stylesheet" type="text/css">
<%
	// 한글처리
	request.setCharacterEncoding("UTF-8");
	
	String contextPath = request.getContextPath();

	// num pageNum가져오기
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	JournalDAO dao = new JournalDAO();
	
	dao.updateReadCount(num);
	JournalBean jBean = dao.getBoard(num);
	
	int DBNum = jBean.getNum();
	String DBId = jBean.getId();
	int DBCount = jBean.getCount();
	String boardFile = jBean.getFile();
	
	// 날짜형식을 조작할 수 있는 SimpleDateFormat객체의 format()메서드 사용
	SimpleDateFormat f = new SimpleDateFormat("yyyy/MM/dd");
	Timestamp DBDate = jBean.getDate();
	String newDate=f.format(DBDate);
	
	String DBContent = "";
	
	if(jBean.getContent()!=null){ // 조회한 글 내용이 존재하면
		
		// 조회한 글 내용을 변수에 저장
		DBContent = jBean.getContent().replace("\r\n", "<br/>") ;
	}
	
	String DBTitle = jBean.getTitle();
	
%>


<jsp:include page="../includes/header.jsp"/>
<article>
<h1 class="boardName">여행후기</h1>
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
	<%
		if(boardFile!=null && !boardFile.equals("")){
				String[] fileItems = boardFile.split(",");
				for(int i=0;i<fileItems.length;i++){
	%>
	<tr>
		<td class="tID">첨부 이미지<%=i+1%></td>
		<td colspan="5" id="download">
			<img src="<%=contextPath%>/file/<%=fileItems[i]%>" style="width:586px" /><br>
			<a href="<%=contextPath%>/download.do?fileName=<%=fileItems[i]%>">
			<span>다운로드</span></a>
		</td>
	</tr>    
	<%
			}
		}
	%>
</table>

<%-- 댓글 --%>
<jsp:include page="reply.jsp" />

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
<%		}	%>
	<input type="button" value="글삭제" class="btn" 
	onclick="location.href='delete.jsp?num=<%=DBNum%>&pageNum=<%=pageNum%>'">		
<%	}	%>
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

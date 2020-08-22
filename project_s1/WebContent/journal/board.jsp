<%@page import="reply.ReplyDAO"%>
<%@page import="journal.JournalBean"%>
<%@page import="journal.JournalDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/board.css" rel="stylesheet" type="text/css">
<%
	request.setCharacterEncoding("UTF-8");
	String search = (request.getParameter("search") != null) ? request.getParameter("search") : "";

	JournalDAO journalDAO = new JournalDAO();

	//  전체 글의 개수를 조회하기 위해 getBoardCount()메서드를 호출
	int count = journalDAO.getBoardCount(search);
	// 한 페이지마다 보여줄 글 10개
	int pageSize = 10;
	// 아래쪽의 클릭한 페이지 번호를 얻기
	String pageNum = (request.getParameter("pageNum") != null) ? request.getParameter("pageNum") : "1"; 	// 아래쪽의 클릭한 페이지가 존재하지 않으면(현재 선택한 페이지번호가 없으면)
	// pageNum을 1로 저장
	if(pageNum == null){
		pageNum = "1";
	}
	
	// 현재 보여질(선택한) 페이지번호 "1"을 -> 기본정수 1로변경
	int currentPage = Integer.parseInt(pageNum);
	// 각페이지마다 첫번째로 보여질 시작 글번호 구하기
	// (현재 보여질 페이지번호 -1) * 한페이지당 보여줄 글 개수 10
	int startRow = (currentPage -1) * pageSize;
	
	
	// board테이블에 존재하는 모든 글을 조회하여 저장할 용도의 ArrayList배열객체를 담을 변수 선언
	List<JournalBean> list = null;
	// 만약 board테이블에 글이 있다면
	if(count>0){
		list= journalDAO.getBoardList(search,startRow,pageSize);
		
	}
	
	
	
%>

<jsp:include page="../includes/header.jsp"/>

<article>
<h1 class="boardName">여행후기 게시판</h1>
<table id="notice">
	<tr>
		<th class="tno">번호</th>
	    <th class="ttitle">제목</th>
	    <th class="twriter">ID</th>
	    <th class="tdate">작성일</th>
	    <th class="tread">조회수</th>
	</tr>
<%
	
	
	
	

	// 만약 게시판 글 개수가 조회된다면(게시판에 글이 저장되어 있다면)
	if(count > 0){
		// ArrayList에 저장되어있는 검색한 글정보들(BoardBean객체들)의 갯수만큼 반복하는데..
		for(int i=0; i<list.size(); i++){
			// Arrayalist의 각 인덱스 위치에 저장된 BoardBean객체를 ArrayList배열로부터 얻어
			// BoardBEan객체의 각 변수값들을 getter메서드를 통해 얻어 출력
			JournalBean journalBean = list.get(i);
			int beanNum = journalBean.getNum();
			String beanTitle = journalBean.getTitle();
			String beanId = journalBean.getId();
			String beanDate = new SimpleDateFormat("yyyy.MM.dd").format(journalBean.getDate());
			int beanCount = journalBean.getCount();
			int beanRCount = journalBean.getReplyCount();
			ReplyDAO redao = new ReplyDAO();
			String reCount = Integer.toString(redao.getReplyCount(beanNum));
			if(reCount.equals("0")){
				reCount = "";
			}else {
				reCount = "["+reCount+"]";
			}
%>
	<tr onclick="location.href='content.jsp?num=<%=beanNum%>&pageNum=<%=pageNum%>'"
		 style="cursor: pointer" onmouseover="this.style.background='#C6EEFF'" onmouseout="this.style.background='white'">
		<td><%=beanNum %></td>	
		<td class="left">
		<%=beanTitle %><span id="reCount"><%=reCount %></span></td>	
		<td><%=beanId%></td>
		<td><%=beanDate%></td>
		<td><%=beanCount%></td>
			
	</tr>
<%			
		}
	}else{ // 게시판에 글이 저장되어 있지않다면
%>
	<tr>
		<td colspan="5">게시판 글 없음</td>
	</tr>

<%
	}

%>    
    
</table>

<div id="table_search">
	<form action="board.jsp" class="searchForm">
		<input type="text" name="search" class="input_box">
		<input type="submit" value="검색" class="btn">
	</form>
</div>

<%
	
	// 각각페이지에서 로그인 후 현재 페이지로 이동해 출때 session내장객체 메모리에 
	// 값의 존재 여부를 판단하여 아래의 search버튼만 보이게 하거나 글쓰기 버튼을 모두 보이게 처리하기.
	String id = (String)session.getAttribute("id");
	
	// session영역에 값이 저장되어 있으면 글쓰기 버튼 보이게 설정
	if(id != null){
		
%>		
		<div id="btnWrite">
			<input type="button" value="글쓰기" class="btn" 
				onclick="location.href='write.jsp'">
		</div>
		
<%}%>

<div class="clear"></div>
<div id="page_control">
<%
	if(count>0){ // DB에 글이 저장돼있다면
		
	
	// 전체 페이지수 = 전체글 수 / 한페이지당 보여줄 글수 + (전체글수를 한페이지에 보여줄 글수로 나눈 나머지값)
		int pageCount = count/pageSize+(count%pageSize==0?0:1);
	
	// 하나의 화면(하나의 블럭)에 보여줄 페이지수 설정
		int pageBlock=5;
	
	// ((현재  선택한 페이지 번호/한 블럭에 보여줄 페이지 수))
	//	- (현재 선택한 페이지번호를 하나의 블럭에 보여줄 페이지수로 나눈 나머지값))
	// * 한블럭에 보여줄 페이지수 +1
		int startPage = ((currentPage/pageBlock)
						-(currentPage%pageBlock==0?1:0))*pageBlock+1;
	
	// 시작페이지 번호 + 현재 블럭에 보져울 페이지 수 -1
		int endPage = startPage+pageBlock-1;
	
	// 끝페이지번호가 전체 페이지수보다 클 때
	if(endPage> pageCount){
		//끝페이지번호를 전체페이지수로 저장
		endPage = pageCount;
	}
	
	// [이전] 시작페이지 번호가 하나의 블럭에 보여줄 페이지수보다 클때
	if(startPage> pageBlock){
%>
		<a href="board.jsp?pageNum=<%=startPage-pageBlock %>&search=<%=search %>">[이전]</a>
<%		
	}
	
	// [1] [2] [3].. [10] 페이지번호
	for(int i = startPage; i<=endPage; i++){
%>
		<a href="board.jsp?pageNum=<%=i %>&search=<%=search %>">[<%=i %>]</a>	
<%		
	}
	
	// [다음]
	if(endPage<pageCount){
%>
		<a href="board.jsp?pageNum=<%=startPage + pageBlock %>&search=<%=search %>">[다음]</a>
<%			
		
	}
	
	}
	
%>

</div>
</article>

<div class="clear"></div>
<jsp:include page="../includes/footer.jsp"/>

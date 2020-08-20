<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="gallery.BoardBean"%>
<%@page import="gallery.BoardDAO"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/gallery.css" rel="stylesheet" type="text/css">
<%
	String contextPath = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<%
	String id = (String) session.getAttribute("id");
	String search = (request.getParameter("search") != null) ? request.getParameter("search") : "";

	BoardDAO boardDAO = new BoardDAO();

	int count = boardDAO.getBoardCount(search);
	
	int pageSize = 9;
	String pageNum = (request.getParameter("pageNum") != null) ? request.getParameter("pageNum") : "1";
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage - 1) * pageSize;
	
	List<BoardBean> list = null;

	if (count > 0) {
		list = boardDAO.getBoardList(search, startRow, pageSize);
	}
	
	SimpleDateFormat sdfmt = new SimpleDateFormat("yyyy.MM.dd");
%>
<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<body>
	<jsp:include page="../includes/header.jsp" />
		<div class="clear"></div>
		<h2 class="boardName">갤러리</h2>
		<!-- 게시판 -->
		<article>
			<div class="galleryBoard">
				<%
					if (count > 0) {
						for (int i = 0; i < list.size(); i++) {
							BoardBean boardBean = list.get(i);
							String fileItem = boardBean.getFile();
							int beanNum = boardBean.getNum();
							String beanTitle = boardBean.getTitle();
							String beanId = boardBean.getId();
							String beanDate = sdfmt.format(boardBean.getDate());
				%>
					<div class="galleryItem">
						<div id="divImg" style="cursor:pointer;">
							<img src="<%=contextPath%>/galleryFile/<%=fileItem%>" 
									class="boardIMG" />
						</div>
						<div id="img-modal">
						    <span onclick="imgModalClose();">X</span>
						    <img id="img-modal-content">
						</div>
						<div class="caption">
							<div class="captionInner">
								<div>
									<p class="galleryTitle"><%=beanTitle%></p>
									<small><%=beanId%></small><br />
								<%
									if(id!=null && id.equals(beanId)){
								%>
									<form action="deletePro.jsp?num=<%=beanNum%>&pageNum=<%=pageNum%>" method="post" onsubmit="return deleteSubmit()">
										<input type="submit" class="btnDelete" value="삭제" style="cursor:pointer">
										</form>
								<%
									}
								%>
									<small><%=beanDate%></small>
								</div>
							</div>
						</div>
					</div>
				<%
						}
					}else{
				%>
					<div class="galleryBoard">
						등록된 게시글이 없습니다.
					</div>
				<%
					}
				%>
				
			</div>
			<div class="clear"></div>	
			<div id="table_search">
				<form action="board.jsp" class="searchForm">
					<input type="text" name="search" class="input_box">
					<input type="submit" value="검색" class="btn">
				</form>
			</div>
			<%
				if (id != null) {
			%>
				<div id="btnWrite">
					<input type="button" value="글쓰기" class="btn" 
					onclick="location.href='write.jsp'">
				</div>
				
			<%
				}
			%>
		
			<div class="clear"></div>	
			<div class="move_div">				
				<ul class="pageMove">
					<%
						if (count > 0) {
							int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
							int pageBlock = 5;
							int startPage = ((currentPage / pageBlock) - (currentPage % pageBlock == 0 ? 1 : 0)) * pageBlock + 1;
							int endPage = startPage + pageBlock - 1;
	
							if (endPage > pageCount) {
								endPage = pageCount;
							}
							
							if(startPage> pageBlock){
					%>
		   				<li class="page_item">
							<a href="board.jsp?pageNum=<%=startPage - pageBlock%>&search=<%=search%>" id="aPage">[이전]</a>
						</li>
					<%		
						}
						for(int i = startPage; i<=endPage; i++){
					%>	
		   				<li class="page_item">
							<a href="board.jsp?pageNum=<%=i%>&search=<%=search%>" id="aPage">[<%=i%>]</a>
						</li>
					<%		
						}
						if(endPage<pageCount){
					%>	
		   				<li class="page_item">
							<a href="board.jsp?pageNum=<%=startPage + pageBlock%>&search=<%=search%>" id="aPage">[다음]</a>
						</li>
					<%
						}
					} // 페이징 if 끝	
					%>
				</ul>
			</div>
		</article>
	<jsp:include page="../includes/footer.jsp" />
	<script>
		function deleteSubmit() {
			return confirm("정말로 삭제하시겠습니까?");
		}
		
		var imageTagList = document.querySelectorAll('article img');
		    
		 for(var i=0;i<imageTagList.length;i++){
		     imageTagList[i].addEventListener('click',function(){
		         var modal = document.getElementById('img-modal');
		         var content = document.getElementById('img-modal-content');
		         modal.style.display='block';
		         content.src = this.src;
		     });
		 }
		    
		 /* close 버튼 클릭시*/
		 function imgModalClose(){
		     var modal = document.getElementById('img-modal');
		     var content = document.getElementById('img-modal-content');
		     modal.style.display="none";
		     content.src = '';
		 }
	</script>
	
</body>

</html>



<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="reply.ReplyBean"%>
<%@page import="reply.ReplyDAO"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="../css/reply.css" rel="stylesheet" type="text/css">
<%
	String contextPath = request.getContextPath();
	request.setCharacterEncoding("UTF-8");

	String id = (String) session.getAttribute("id");

	int boardNum = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	
	ReplyDAO replyDAO = new ReplyDAO();	
	List<ReplyBean> replyList = replyDAO.getReplyList(boardNum);

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
	<div class="wrapReply">
		<div class="row">
			<div class="col-12">
				<h4 class="reply">댓글</h4>
			</div>
		</div>
		<table class="replyTable">
			<%
				if (replyList.size() > 0) {
					for (int i = 0; i < replyList.size(); i++) {
						ReplyBean replyBean = replyList.get(i);
						int beanNum = replyBean.getReplyNum();
						String beanId = replyBean.getId();
						String beanContent = replyBean.getReplyContent();
						String beanDate = sdf.format(replyBean.getReplyDate());
			%>
			<tr id="reply<%=beanNum%>">
				<td class="contentId"><%=beanId%></td>
				<td class="replyC">
					<span id="rContent"><%=beanContent%></span>					
					<small class="cDate">
						<%=beanDate%>
					</small>
				</td>
				<%
					if(id!=null && id.equals(beanId)){
				%>
					<td><button type="button" class="btnDelete" onclick="replyDelete(<%=beanNum%>)">삭제</button></td>
				<%
					}
				%>
			</tr>
			<%
					}
				} else {
			%>
			<tr id="replyEmpty">
				<td class="py-5 text-center" colspan="3">등록된 댓글이 없습니다.</td>
			</tr>
			<%
				}
			%>
		</table>
		<form action="replySubmit()" name="replyform" id="formReply">
			<table class="replyInput">
				<%
					if(id==null){
				%>
					<tr>
						<td class="py-5 text-center bg-light">로그인 한 사용자만 댓글을 작성할 수 있습니다.</td>
					</tr>
				<%
					}else{
				%>
					<tr>
						<td class="tdId">
							<%=id%>
						</td> 
						<td class="contentLabel">
							<label for="replyContent" class="cLabel">내용</label>
							<input class="form-control" type="text" name="replyContent" id="replyContent" required />
						</td>
						<td class="button">
							<button type="submit" class="btnReply" onclick="replySubmit()">댓글쓰기</button>
						</td>
					</tr>
				<%
					}
				%>
			</table>
		</form>
	</div>
	<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
	<script>
		function replySubmit(){
			
			var boardNum = "<%=boardNum%>";
			var id = "<%=id%>";
			var replyContent = document.replyform.replyContent.value;
			
			if(replyContent.length == 0){
				alert("댓글 내용을 입력해주세요.");
				document.replyform.replyContent.focus();
				return;
			}
			
			var _replyInfo = '{"boardNum":"'+boardNum+'","id":"'+id+'","replyContent":"'+replyContent+'"}';
						
			$.ajax({
				type : "post",
				async : false,
				url : "<%=contextPath%>/replyServlet",
				data : {replyInfo : _replyInfo},
				success : function(data, status){
					var jsonInfo = JSON.parse(data);
					var ajaxId = jsonInfo.id;
					var ajaxNum = jsonInfo.replyNum;
					var ajaxContent = jsonInfo.replyContent;
					var ajaxDate = jsonInfo.replyDate;
					
					var str = "";					
					
					str += '<tr id="reply' + ajaxNum + '">';
					str += '	<td class="contentId">' + ajaxId + '</td>';
					str += '	<td class="replyC"><span id="rContent">';
					str += 			ajaxContent + '</span>';				
					str += '		<small class="cDate">';
					str += 				ajaxDate;
					str += '		</small>';
					str += '	</td>';
					str += '	<td><button type="button" class="btnDelete" onclick="replyDelete(' + ajaxNum + ')">삭제</button></td>';
					str += '</tr>';
					
					$(".replyTable").append(str);
					
					$("#replyContent").val("");
					
					if($("#replyEmpty")){
						$("#replyEmpty").remove();
					}
						
				},
				error : function(){
					alert("통신에러가 발생했습니다.");	
				}				
			});
		}
		
		function replyDelete(replyNum){
			
			
			var result = confirm("댓글을 삭제하시겠습니까?");
			
			if(result){	

							
				$.ajax({
					type : "post",
					async : false,
					url : "<%=contextPath%>/replyDeleteServlet",
					data : {id: '<%=id%>', replyNum: replyNum},
					success : function(data, status){
						if(data == "success"){
							var str = "<td class='alert' colspan='3'>댓글이 삭제되었습니다.</td>";						
							$("#reply" + replyNum).html(str).fadeOut(1000, function(){
								$(this).remove();
								if($(".replyTable").find("tr").length == 0){
									
									var emptyStr = "";
									
									emptyStr += '<tr id="replyEmpty">';
									emptyStr += '	<td class="py-5 text-center" colspan="3">등록된 댓글이 없습니다.</td>';
									emptyStr += '</tr>';
									
									$(".replyTable").append(emptyStr);
								}
							});
						}else{
							alert("댓글이 정상적으로 삭제되지 않았습니다.");
						}
					},
					error : function(){
						alert("통신에러가 발생했습니다.");	
					}				
				});
			}
		}
	</script>
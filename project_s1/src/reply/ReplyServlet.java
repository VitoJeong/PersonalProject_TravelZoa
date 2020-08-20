package reply;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

@WebServlet("/replyServlet")
public class ReplyServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doHandle(req,resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doHandle(req,resp);
	}
	
	protected void doHandle(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		resp.setContentType("text/html;charset=utf-8");

		PrintWriter out = resp.getWriter();
		
		String replyInfo = req.getParameter("replyInfo");
		
		try {			
			JSONParser jsonParser = new JSONParser();
			
			JSONObject replyObject = (JSONObject)jsonParser.parse(replyInfo);
			
			int boardNum = Integer.parseInt((String)replyObject.get("boardNum"));
			String id = (String)replyObject.get("id");
			String replyContent = (String)replyObject.get("replyContent");			
			
			ReplyDAO replyDAO = new ReplyDAO();
			ReplyBean replyBean = new ReplyBean();
			
			replyBean.setBoardNum(boardNum);
			replyBean.setId(id);
			replyBean.setReplyContent(replyContent);
			
			int result = replyDAO.insertReply(replyBean);
			
			if(result==1) {
				ReplyBean replyBean2 = new ReplyBean();
				
				replyBean2 = replyDAO.getLastReply();

				int returnNum = replyBean2.getReplyNum();
				String returnContent = replyBean2.getReplyContent();
				Timestamp returnDate = replyBean2.getReplyDate();
				String returnId = replyBean2.getId();

				SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
				
				String formattedDate = sdf.format(returnDate);
				
				JSONObject returnObject = new JSONObject();
				
				returnObject.put("id", returnId);
				returnObject.put("replyNum", returnNum);
				returnObject.put("replyContent", returnContent);
				returnObject.put("replyDate", formattedDate);			
				
				out.print(returnObject.toString());
			}
		} catch (Exception e) {
			System.out.println("doHandle()메소드에서 예외발생 : " + e.toString());
		}
		
	}
	
}

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

@WebServlet("/replyDeleteServlet")
public class ReplyDeleteServlet extends HttpServlet {

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
		
		/*String replyDeleteInfo = req.getParameter("replyDeleteInfo");
		System.out.println(replyDeleteInfo);*/
		
		try {			
			//JSONParser jsonParser = new JSONParser();
			
			//JSONObject replyObject = (JSONObject)jsonParser.parse(replyDeleteInfo);
			//System.out.println(replyObject);
			
			//int replyNum = Integer.parseInt((String)replyObject.get("replyNum"));
			//String id = (String)replyObject.get("id");
			int replyNum = Integer.parseInt(req.getParameter("replyNum"));
			String id = req.getParameter("id");
			ReplyDAO replyDAO = new ReplyDAO();			

			int result = replyDAO.deleteReply(replyNum, id);
			
			if(result==1) {				
				out.print("success");
			}else{
				out.print("fail");				
			}
		} catch (Exception e) {
			System.out.println("doHandle()메소드에서 예외발생 : " + e.toString());
		}
		
	}
	
}

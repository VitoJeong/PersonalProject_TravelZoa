package member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 * Servlet implementation class IDCheckServlet
 */
@WebServlet("/IDCheckServlet")
public class IDCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
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
		String id = req.getParameter("checkId");
		
		
		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject idCheckobj = (JSONObject) jsonParser.parse(id);
			
			String checkId = (String) idCheckobj.get("id");
			
			MemberDAO memberDAO = new MemberDAO();
			
			int check = memberDAO.idCheck(checkId);
			
			if(check==0) {
				// 중복없음
				out.print("success");
			}else{
				// ID 중복
				out.print("fail");				
			}
			System.out.println(check);
		} catch (Exception e) {
			System.out.println("doHandle()메소드에서 예외발생 : " + e.toString());
		}
		
	
	}

}

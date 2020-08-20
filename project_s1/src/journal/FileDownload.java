package journal;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/download.do")
public class FileDownload extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");		
		resp.setContentType("text/html;charset=utf-8");
		
		String file_repo = req.getServletContext().getRealPath("/file");		
		String fileName = req.getParameter("fileName");		
		
		OutputStream out = resp.getOutputStream();
		
		String downFile = file_repo + "\\" + fileName;
		
		File f = new File(downFile);
		
		resp.setHeader("Cache-Control", "no-cache");
		resp.addHeader("Cache-Control", "no-store");
		
		resp.setHeader("Content-disposition", "attachment; fileName=\"" + URLEncoder.encode(fileName,"UTF-8") + "\";");
		
		FileInputStream in = new FileInputStream(f);
		
		byte[] buffer = new byte[1024*8];
		
		while(true) {
			int count = in.read(buffer);
			
			if(count == -1) {
				break;
			}
			
			out.write(buffer, 0, count);
		}
		
		in.close();
		out.close();
	}
}

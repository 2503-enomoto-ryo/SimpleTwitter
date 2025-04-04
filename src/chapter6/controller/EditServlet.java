package chapter6.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import chapter6.beans.Message;
import chapter6.logging.InitApplication;
import chapter6.service.MessageService;

@WebServlet(urlPatterns = { "/edit" })
public class EditServlet extends HttpServlet {

	/**
	* ロガーインスタンスの生成
	*/
	Logger log = Logger.getLogger("twitter");

	/**
	* デフォルトコンストラクタ
	* アプリケーションの初期化を実施する。
	*/
	public EditServlet() {
		InitApplication application = InitApplication.getInstance();
		application.init();
	}

	//つぶやき編集画面の表示
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		log.info(new Object() {
		}.getClass().getEnclosingClass().getName() +
				" : " + new Object() {
				}.getClass().getEnclosingMethod().getName());

		List<String> errorMessages = new ArrayList<String>();
		String messageId = request.getParameter("message_id");
		Message editMessage = null;

		//つぶやきIDが存在し、かつ数字の場合、select(id)メソッド実行してデータを更新
		if (messageId != null && messageId.matches("^[0-9]+$")) {
			Integer id = Integer.parseInt(messageId);
			editMessage = new MessageService().select(id);
		}
		//select(id)メソッドでnullが返ってきたときエラーを表示
		if (editMessage == null) {
			errorMessages.add("不正なパラメータが入力されました");
		}

		//エラーが存在するならエラーメッセージをセッション領域にセットし、
		//リダイレクト後のtop.jspでエラー表示
		if (errorMessages.size() != 0) {
			HttpSession session = request.getSession();
			session.setAttribute("errorMessages", errorMessages);
			response.sendRedirect("./");
			return;

		}
		//フォームに入力したメッセージ内容を保持して"/edit.jsp"にフォワード
		request.setAttribute("message", editMessage);
		request.getRequestDispatcher("/edit.jsp").forward(request, response);
	}

	//つぶやきの更新
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		log.info(new Object() {
		}.getClass().getEnclosingClass().getName() +
				" : " + new Object() {
				}.getClass().getEnclosingMethod().getName());

		List<String> errorMessages = new ArrayList<String>();
		//getMessage(request)メソッドでリクエスト内のメッセージIDとテキストを取得
		Message message = getMessage(request);
		//入力内容に問題がなければ、メッセージを更新
		if (isValid(message.getText(), errorMessages)) {
			new MessageService().update(message);
		}
		//	エラーが出た場合はエラーメッセージと入力内容を保持してedit.jspで表示
		if (errorMessages.size() != 0) {
			request.setAttribute("errorMessages", errorMessages);
			request.setAttribute("message", message);
			request.getRequestDispatcher("edit.jsp").forward(request, response);
			return;
		}
		//問題なく更新できたらtop.jspにリダイレクト
		response.sendRedirect("./");
	}

	private Message getMessage(HttpServletRequest request) throws IOException, ServletException {

		log.info(new Object() {
		}.getClass().getEnclosingClass().getName() +
				" : " + new Object() {
				}.getClass().getEnclosingMethod().getName());

		Message message = new Message();
		message.setId(Integer.parseInt(request.getParameter("message_id")));
		message.setText(request.getParameter("text"));
		return message;
	}

	private boolean isValid(String text, List<String> errorMessages) {
		//ログを残す
		log.info(new Object() {
		}.getClass().getEnclosingClass().getName() +
				" : " + new Object() {
				}.getClass().getEnclosingMethod().getName());

		if (StringUtils.isBlank(text)) {
			errorMessages.add("入力してください");
		} else if (140 < text.length()) {
			errorMessages.add("140文字以下で入力してください");
		}

		if (errorMessages.size() != 0) {
			return false;
		}
		return true;
	}
}

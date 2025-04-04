<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="./css/style.css" rel="stylesheet" type="text/css">
<title>簡易Twitter</title>
</head>
<body>
	<div class="main-contents">
		<div class="header">
			<c:if test="${ empty loginUser }">
				<a href="login">ログイン</a>
				<a href="signup">登録する</a>
			</c:if>
			<c:if test="${ not empty loginUser }">
				<a href="./">ホーム</a>
				<a href="setting">設定</a>
				<a href="logout">ログアウト</a>
			</c:if>
			<form action="./" method="get">
				<span class="select_date">日付　</span>
				<span><input name="start" type="date" value="${start}"/> ～ <input name="end" type="date" value="${end}"/></span>
				<span><input name="select_date" type=submit value="絞込"/></span>
			</form>
			<c:if test="${ not empty loginUser }">
				<div class="profile">
					<div class="name">
						<h2>
							<c:out value="${loginUser.name}" />
						</h2>
					</div>
					<div class="account">
						@
						<c:out value="${loginUser.account}" />
					</div>
					<div class="description">
						<c:out value="${loginUser.description}" />
					</div>
				</div>
			</c:if>
		</div>

		<c:if test="${ not empty errorMessages }">
			<div class="errorMessages">
				<ul>
					<c:forEach items="${errorMessages}" var="errorMessage">
						<li><c:out value="${errorMessage}" />
					</c:forEach>
				</ul>
			</div>
			<c:remove var="errorMessages" scope="session" />
		</c:if>

		<div class="form-area">
			<c:if test="${ isShowMessageForm }">
				<form action="message" method="post">
					いま、どうしてる？<br />
					<textarea name="text" cols="100" rows="5" class="tweet-box"></textarea>
					<br /> <input type="submit" value="つぶやく">（140文字まで）
				</form>
			</c:if>
		</div>

		<div class="messages">
			<c:forEach items="${messages}" var="message">
				<div class="message">
					<div class="account-name">
						<span class="account">
							<a href="./?user_id=<c:out value="${message.userId}" /> ">
								<c:out value="${message.account}" />
							</a>
						</span> <span class="name"><c:out value="${message.name}" /></span>
					</div>
					<div class="text">
						<pre><c:out value="${message.text}" /></pre>
					</div>
					<div class="date">
						<fmt:formatDate value="${message.createdDate}"
							pattern="yyyy/MM/dd HH:mm:ss" />
					</div>
					<%--つぶやきの編集・削除--%>
					<div class="edit">
						<%--ログイン時のみボタン表示--%>
						<c:if test="${message.userId == loginUser.id}">
							<form action="edit" method="get">
								<input name="message_id" type="hidden" value="${message.id}">
								<input type="submit" value="編集">
							</form>
							<form action="deleteMessage" method="post">
								<input name="message_id" type="hidden" value="${message.id}">
								<input type="submit" value="削除">
							</form>
						</c:if>
					</div>
				</div>
				<div class="comments">
					<c:forEach items="${comments}" var="comment">
						<c:if test="${message.id == comment.messageId}">
							<div class="comment">
								<div class="account-name">
									<span class="account"><c:out value="${comment.account}" /></span>
									<span class="name"><c:out value="${comment.name}" /></span>
									<pre><c:out value="${comment.text}" /></pre>
									<div class="date">
										<fmt:formatDate value="${comment.createdDate}"
											pattern="yyyy/MM/dd HH:mm:ss" />
									</div>
								</div>
							</div>
						</c:if>
					</c:forEach>
 					<c:if test="${ isShowMessageForm }">
						<form action="comment" method="post">
							<br />
							<input name="message_id" type="hidden" value="${message.id}">
							<textarea name="text" cols="100" rows="5" class="tweet-box"></textarea>
							<input type="submit" value="返信">（140文字まで）
						</form>
					</c:if>
				</div>
			</c:forEach>
		</div>
		<div class="copyright">Copyright(c)Ryo Enomoto</div>
	</div>
</body>
</html>

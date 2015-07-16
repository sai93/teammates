<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="teammates.common.datatransfer.FeedbackParticipantType" %>
<%@ page import="teammates.common.util.Const" %>
<%@ taglib tagdir="/WEB-INF/tags/shared" prefix="shared" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="hidden number-of-pending-comments">${data.numberOfPendingComments}</div>

<c:choose>
    <c:when test="${empty data.feedbackResultBundles}">
        <div id="no-comment-panel" style="">
	        <br>
	        <div class="panel panel-info">
	            <ul class="list-group comments">
	                <li class="list-group-item list-group-item-warning">
	                    You don't have any comment in this session.
	                </li>
	            </ul>
	        </div>
	    </div>
    </c:when>
    <c:otherwise>
        <c:set var="ifrc" value="${data.instructorFeedbackResponseComment}"/>
        <c:forEach var="feedbackSessionResultsBundle" items="${data.feedbackResultBundles}" varStatus="fsrbStatus">  
            <c:forEach var="responseEntries" items="${feedbackSessionResultsBundle.questionResponseMap}" varStatus="responseEntriesStatus">
                <div class="panel panel-info">
                    <div class="panel-heading">
                        <c:set var="question" value="${feedbackSessionResultsBundle.questions[responseEntries.key.id]}"/>
                        <c:set var="questionDetails" value="${question.questionDetails}"/>
				        <b>Question ${responseEntries.key.questionNumber}</b>:
				        ${questionDetails.questionText}
				        ${question.questionAdditionalInfoHtml}
				    </div>
				    <table class="table">
                        <tbody>
                            <c:forEach var="responseEntry" items="${responseEntries.value}" varStatus="responseEntryStatus">
                                <c:set var="giverName" value="${ifrc.giverNames[responseEntry.giverEmail]}"/>
                                <c:set var="recipientName" value="${ifrc.recipientNames[responseEntry.recipientEmail]}"/>
	                            <tr>
	                                <td><b>From:</b> ${giverName} <b>To:</b> ${recipientName}</td>
	                            </tr>
	                            <tr>
	                                <td><strong>Response: </strong>${ifrc.responseEntryAnswerHtmls.get(questionDetails)}</td>
	                            </tr>
	                            <tr class="active">
		                            <td>Comment(s):
		                                <button type="button"
		                                        class="btn btn-default btn-xs icon-button pull-right"
		                                        id="button_add_comment-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}"
		                                        onclick="showResponseCommentAddForm(${fsrbStatus.index},${responseEntriesStatus.count},${responseEntryStatus.count})"
		                                        data-toggle="tooltip" data-placement="top"
		                                        title="<%= Const.Tooltips.COMMENT_ADD %>"
		                                        <c:if test="${not ifrc.instructorAllowedToSubmit}">disabled="disabled"</c:if>>
		                                    <span class="glyphicon glyphicon-comment glyphicon-primary"></span>
		                                </button>
		                            </td>
		                        </tr>
		                        <tr>
		                            <td>
                                        <c:set var="frcList" value="${ifrc.feedbackResponseCommentsList[responseEntry.id]}"/>
		                                <ul class="list-group comments"
		                                    id="responseCommentTable-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}"
		                                    <c:if test="${empty frcList}">style="display: none;"</c:if>>
		                                    <c:forEach var="frc" items="${frcList}" varStatus="frcStatus">
	                                            <shared:feedbackResponseComment frc="${frc}"
	                                                                            firstIndex="${fsrbStatus.index}"
	                                                                            secondIndex="${responseEntriesStatus.count}"
	                                                                            thirdIndex="${responseEntryStatus.count}"
	                                                                            frcIndex="${frcStatus.count}" />
                                            </c:forEach>
                                            <!-- frComment Add form -->
					                        <li class="list-group-item list-group-item-warning"
					                            id="showResponseCommentAddForm-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}"
					                            style="display: none;">
					                            <form class="responseCommentAddForm">
					                                <div class="form-group">
					                                    <div class="form-group form-inline">
					                                        <div class="form-group text-muted">
					                                            <p>
					                                                Giver: ${giverName}
					                                                <br>
					                                                Recipient: ${recipientName}
					                                            </p>
					                                            You may change comment's
					                                            visibility using the
					                                            visibility options on the
					                                            right hand side.</div>
					                                        <a id="frComment-visibility-options-trigger-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}"
					                                           class="btn btn-sm btn-info pull-right"
					                                           onclick="toggleVisibilityEditForm(${fsrbStatus.index},${responseEntriesStatus.count},${responseEntryStatus.count})">
					                                            <span class="glyphicon glyphicon-eye-close"></span>
					                                            Show Visibility Options
					                                        </a>
					                                    </div>
					                                    <div id="visibility-options-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}"
					                                         class="panel panel-default"
					                                         style="display: none;">
					                                        <div class="panel-heading">Visibility Options</div>
					                                        <table class="table text-center"
					                                               style="color: #000;"
					                                               style="background: #fff;">
					                                            <tbody>
					                                                <tr>
					                                                    <th class="text-center">User/Group</th>
					                                                    <th class="text-center">Can see your comment</th>
					                                                    <th class="text-center">Can see your name</th>
					                                                </tr>
					                                                <tr id="response-giver-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
					                                                    <td class="text-left">
					                                                        <div data-toggle="tooltip"
					                                                             data-placement="top"
					                                                             title=""
					                                                             data-original-title="Control what response giver can view">
					                                                            Response Giver
					                                                        </div>
					                                                    </td>
					                                                    <td>
					                                                       <input class="visibilityCheckbox answerCheckbox centered"
					                                                              name="receiverLeaderCheckbox"
					                                                              type="checkbox"
					                                                              value="<%= FeedbackParticipantType.GIVER %>"
					                                                              <%-- <%=data.isResponseCommentVisibleTo(question, FeedbackParticipantType.GIVER) ? "checked=\"checked\"" : ""%> --%>>
					                                                    </td>
					                                                    <td>
					                                                       <input class="visibilityCheckbox giverCheckbox"
					                                                              type="checkbox"
					                                                              value="<%= FeedbackParticipantType.GIVER %>"
					                                                              <%-- <%=data.isResponseCommentGiverNameVisibleTo(question, FeedbackParticipantType.GIVER) ? "checked=\"checked\"" : ""%> --%>>
					                                                    </td>
					                                                </tr>
					                                                <%
					                                                    if (question.recipientType != FeedbackParticipantType.SELF
	                                                                        && question.recipientType != FeedbackParticipantType.NONE
	                                                                        && question.isResponseVisibleTo(FeedbackParticipantType.RECEIVER)) {
					                                                %>
							                                                <tr id="response-recipient-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
							                                                    <td class="text-left">
							                                                        <div data-toggle="tooltip"
							                                                             data-placement="top"
							                                                             title=""
							                                                             data-original-title="Control what response recipient(s) can view">
							                                                            Response
							                                                            Recipient(s)
							                                                        </div>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox answerCheckbox centered"
                                                                                           name="receiverLeaderCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.RECEIVER %>"
                                                                                           <%-- <%=data.isResponseCommentVisibleTo(question, FeedbackParticipantType.RECEIVER) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox giverCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.RECEIVER %>"
                                                                                           <%-- <%=data.isResponseCommentGiverNameVisibleTo(question, FeedbackParticipantType.RECEIVER) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                </tr>
					                                                <%
					                                                    }
					                                                %>
					                                                <%
					                                                    if (question.giverType != FeedbackParticipantType.INSTRUCTORS
	                                                                        && question.giverType != FeedbackParticipantType.SELF
	                                                                        && question.isResponseVisibleTo(FeedbackParticipantType.OWN_TEAM_MEMBERS)) {
					                                                %>
							                                                <tr id="response-giver-team-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
							                                                    <td class="text-left">
							                                                        <div data-toggle="tooltip"
							                                                             data-placement="top"
							                                                             title=""
							                                                             data-original-title="Control what team members of response giver can view">
							                                                            Response
							                                                            Giver's Team
							                                                            Members
							                                                        </div>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox answerCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.OWN_TEAM_MEMBERS %>"
                                                                                           <%-- <%=data.isResponseCommentVisibleTo(question, FeedbackParticipantType.OWN_TEAM_MEMBERS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox giverCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.OWN_TEAM_MEMBERS %>"
                                                                                           <%-- <%=data.isResponseCommentGiverNameVisibleTo(question, FeedbackParticipantType.OWN_TEAM_MEMBERS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                </tr>
					                                                <%
					                                                    }
					                                                %>
					                                                <%
					                                                    if (question.recipientType != FeedbackParticipantType.INSTRUCTORS
	                                                                        && question.recipientType != FeedbackParticipantType.SELF
	                                                                        && question.recipientType != FeedbackParticipantType.NONE
	                                                                        && question.isResponseVisibleTo(FeedbackParticipantType.RECEIVER_TEAM_MEMBERS)) {
					                                                %>
							                                                <tr id="response-recipient-team-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
							                                                    <td class="text-left">
							                                                        <div data-toggle="tooltip"
							                                                             data-placement="top"
							                                                             title=""
							                                                             data-original-title="Control what team members of response recipient(s) can view">
							                                                            Response
							                                                            Recipient's
							                                                            Team Members
							                                                        </div>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox answerCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.RECEIVER_TEAM_MEMBERS %>"
                                                                                           <%-- <%=data.isResponseCommentVisibleTo(question, FeedbackParticipantType.RECEIVER_TEAM_MEMBERS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox giverCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.RECEIVER_TEAM_MEMBERS %>"
                                                                                           <%-- <%=data.isResponseCommentGiverNameVisibleTo(question, FeedbackParticipantType.RECEIVER_TEAM_MEMBERS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                </tr>
					                                                <%
					                                                    }
					                                                %>
					                                                <%
					                                                    if (question.isResponseVisibleTo(FeedbackParticipantType.STUDENTS)) {
					                                                %>
							                                                <tr id="response-students-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
							                                                    <td class="text-left">
							                                                        <div data-toggle="tooltip"
							                                                             data-placement="top"
							                                                             title=""
							                                                             data-original-title="Control what other students in this course can view">
							                                                            Other
							                                                            students in
							                                                            this course
							                                                         </div>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox answerCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.STUDENTS %>"
                                                                                           <%-- <%=data.isResponseCommentVisibleTo(question, FeedbackParticipantType.STUDENTS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox giverCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.STUDENTS %>"
                                                                                           <%-- <%=data.isResponseCommentGiverNameVisibleTo(question, FeedbackParticipantType.STUDENTS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                </tr>
					                                                <%
					                                                    }
					                                                %>
					                                                <%
					                                                    if (question.isResponseVisibleTo(FeedbackParticipantType.INSTRUCTORS)) {
					                                                %>
							                                                <tr id="response-instructors-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
							                                                    <td class="text-left">
							                                                        <div data-toggle="tooltip"
							                                                             data-placement="top"
							                                                             title=""
							                                                             data-original-title="Control what instructors can view">
							                                                            Instructors
							                                                        </div>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox answerCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.INSTRUCTORS %>"
                                                                                           <%-- <%=data.isResponseCommentVisibleTo(question, FeedbackParticipantType.INSTRUCTORS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                    <td>
                                                                                    <input class="visibilityCheckbox giverCheckbox"
                                                                                           type="checkbox"
                                                                                           value="<%= FeedbackParticipantType.INSTRUCTORS %>"
                                                                                           <%-- <%=data.isResponseCommentGiverNameVisibleTo(question, FeedbackParticipantType.INSTRUCTORS) ? "checked=\"checked\"" : ""%> --%>>
							                                                    </td>
							                                                </tr>
					                                                <%
					                                                    }
					                                                %>
					                                            </tbody>
					                                        </table>
					                                    </div>
					                                    <textarea class="form-control"
					                                              rows="3"
					                                              placeholder="Your comment about this response"
					                                              name="<%= Const.ParamsNames.FEEDBACK_RESPONSE_COMMENT_TEXT %>"
					                                              id="responseCommentAddForm-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
					                                    </textarea>
					                                </div>
					                                <div class="col-sm-offset-5">
					                                    <a href="<%= Const.ActionURIs.INSTRUCTOR_FEEDBACK_RESPONSE_COMMENT_ADD %>"
					                                       class="btn btn-primary"
					                                       id="button_save_comment_for_add-${fsrbStatus.index}-${responseEntriesStatus.count}-${responseEntryStatus.count}">
					                                        Save
					                                    </a>
					                                    <input type="button"
					                                           class="btn btn-default"
					                                           value="Cancel"
					                                           onclick="hideResponseCommentAddForm(${fsrbStatus.index},${responseEntriesStatus.count},${responseEntryStatus.count})">
					                                    <input type="hidden"
					                                           name="<%= Const.ParamsNames.COURSE_ID %>"
					                                           value="${responseEntry.courseId}">
					                                    <input type="hidden"
					                                           name="<%= Const.ParamsNames.FEEDBACK_SESSION_NAME %>"
					                                           value="${responseEntry.feedbackSessionName}">
					                                    <input type="hidden"
					                                           name="<%= Const.ParamsNames.FEEDBACK_QUESTION_ID %>"
					                                           value="${responseEntry.feedbackQuestionId}">
					                                    <input type="hidden"
					                                           name="<%= Const.ParamsNames.FEEDBACK_RESPONSE_ID %>"
					                                           value="${responseEntry.id}">
					                                    <input type="hidden"
					                                           name="<%= Const.ParamsNames.USER_ID %>"
					                                           value="${data.account.googleId}">
					                                    <input type="hidden"
					                                           name="<%= Const.ParamsNames.RESPONSE_COMMENTS_SHOWCOMMENTSTO %>"
					                                           value="<%-- <%=data.getResponseCommentVisibilityString(question)%> --%>">
					                                    <input type="hidden"
					                                           name="<%= Const.ParamsNames.RESPONSE_COMMENTS_SHOWGIVERTO %>"
					                                           value="<%-- <%=data.getResponseCommentGiverNameVisibilityString(question)%> --%>">
					                                </div>
					                            </form>
					                        </li>
		                                </ul>
		                            </td>
		                        </tr>
                            </c:forEach>
			            </tbody>
		            </table>
                </div>
            </c:forEach>
        </c:forEach>
    </c:otherwise>
</c:choose>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Add this div somewhere in your JSP -->
<div id="sessionTimeRemaining" style="display:none; position:fixed; bottom:20px; right:20px; background-color:#f44336; color:#fff; padding:10px; border-radius:5px; z-index:1000;">
    Your session will expire in <span id="sessionTimeRemainingBadge"></span> seconds.
</div>

<script>
$(document).ready(function() {
    const timeOutTimeInSeconds = ${ timeOutTimeInSeconds }; // same as server-side session timeout
    const initialShowTimerTimeInSeconds = ${ showTimerTimeInSeconds };
    let showTimerTimeInSeconds = initialShowTimerTimeInSeconds;

    let sessionCheckIntervalId = setInterval(redirectToLoginPage, timeOutTimeInSeconds * 1000);
    let timerDisplayIntervalId = setInterval(showTimer, (timeOutTimeInSeconds - showTimerTimeInSeconds) * 1000);
    let badgeTimerId;

    localStorage.setItem("AjaxRequestFired", new Date().toISOString());

    function redirectToLoginPage() {
        window.location.reload(); // Could replace with a redirect to login if needed
    }

    $(document).ajaxComplete(function () {
        resetTimer();
    });

    $(window).on('storage', function (e) {
        if (e.originalEvent.key === "AjaxRequestFired") {
            console.log("Detected session reset from another tab");
            resetTimer();
        }
    });

    function resetTimer() {
        showTimerTimeInSeconds = initialShowTimerTimeInSeconds;
        console.log("Resetting timer. Timeout in: " + timeOutTimeInSeconds + " seconds");

        localStorage.setItem("AjaxRequestFired", new Date().toISOString());

        clearInterval(sessionCheckIntervalId);
        sessionCheckIntervalId = setInterval(redirectToLoginPage, timeOutTimeInSeconds * 1000);

        clearInterval(timerDisplayIntervalId);
        timerDisplayIntervalId = setInterval(showTimer, (timeOutTimeInSeconds - showTimerTimeInSeconds) * 1000);

        hideTimer();
    }

    function showTimer() {
        $('#sessionTimeRemaining').fadeIn();
        $('#sessionTimeRemainingBadge').text(showTimerTimeInSeconds);
        clearInterval(timerDisplayIntervalId);

        badgeTimerId = setInterval(function () {
            if (showTimerTimeInSeconds <= 0) {
                clearInterval(badgeTimerId);
            } else {
                $('#sessionTimeRemainingBadge').text(--showTimerTimeInSeconds);
            }
        }, 1000);
    }

    function hideTimer() {
        clearInterval(badgeTimerId);
        $('#sessionTimeRemaining').fadeOut();
    }
});

function doAjaxCall() {
    $.ajax({
        type: "GET",
        url: 'resfreshSession', // Consider correcting spelling: 'refreshSession'
        success: function(data) {
            alert(data);
        },
        error: function() {
            alert("Failed to refresh session. Please try again.");
        }
    });
}
</script>

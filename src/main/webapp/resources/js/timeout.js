 var warningTimeout = 84000;
   var timoutNow = 6000;
   var warningTimerID,timeoutTimerID;

   function startTimer() {
       // window.setTimeout returns an Id that can be used to start and stop a timer
       warningTimerID = window.setTimeout(warningInactive, warningTimeout);
   }

   function warningInactive() {
       window.clearTimeout(warningTimerID);
       timeoutTimerID = window.setTimeout(IdleTimeout, timoutNow);
       $('#modalAutoLogout').modal('show');
   }

   function resetTimer() {
       window.clearTimeout(timeoutTimerID);
       window.clearTimeout(warningTimerID);
       startTimer();
   }

   // Logout the user.
   function IdleTimeout() {
       document.getElementById('logoutForm').submit();
   }

   function setupTimers () {
       document.addEventListener("mousemove", resetTimer, false);
       document.addEventListener("mousedown", resetTimer, false);
       document.addEventListener("keypress", resetTimer, false);
       document.addEventListener("touchmove", resetTimer, false);
       document.addEventListener("onscroll", resetTimer, false);
       startTimer();
   }



   $(document).ready(function(){
       setupTimers();
   });
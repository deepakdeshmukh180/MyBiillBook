<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Dashboard - SB Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
         <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
         <script defer src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>

    <style>

    .fancy-select {
        background-color: #fff;
        border: 2px solid #dee2e6;
        border-radius: 10px;
        padding: 12px 15px;
        font-size: 1rem;
        transition: all 0.3s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
    }

    .fancy-select:focus {
        border-color: #0d6efd;
        box-shadow: 0 0 8px rgba(13, 110, 253, 0.3);
        outline: none;
    }

    .fancy-select option {
        padding: 10px;
        font-size: 1rem;
        color: #333;
    }

    #selectedPlanText {
        font-size: 1.1rem;
        font-weight: bold;
    }

        body {
            background: #f8f9fa;
        }

        .step {
            display: none;
        }

        .step.active {
            display: block;
        }

        .step-header {
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 1.2rem;
            color: #495057;
        }

        .step-indicators {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }

        .step-indicator {
            flex: 1;
            text-align: center;
            font-size: 0.9rem;
            position: relative;
        }

        .step-indicator::before {
            content: '';
            height: 3px;
            background: #dee2e6;
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            z-index: 0;
        }

        .step-indicator span {
            position: relative;
            z-index: 1;
            background: #fff;
            padding: 0.5rem 1rem;
            border-radius: 30px;
            border: 1px solid #dee2e6;
            display: inline-block;
        }

        .step-indicator.active span {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
        }

        .form-control {
            border-radius: 0.375rem;
        }

        .step-buttons {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="card shadow">
        <div class="card-body px-5">
            <h3 class="text-center mb-4">My <i class="fa fa-calculator" style="font-size:24px;color:red"></i> Bill Book</a></h3>

            <!-- Step Indicators -->
            <div class="step-indicators">
                <div class="step-indicator active" id="indicator-0"><span>Personal Info</span></div>
                <div class="step-indicator" id="indicator-1"><span>Shop Info</span></div>
                <div class="step-indicator" id="indicator-2"><span>Documents</span></div>
                  <div class="step-indicator" id="indicator-3"><span>Subscriptions</span></div>
            </div>

            <form method="post" modelAttribute="OWNER_INFO" action="${pageContext.request.contextPath}/save-owner-info">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                  <input type="hidden" value="${user.username}" name="userName" />
                   <input type="hidden" name="status" value="${user.status}" />
                <!-- Step 1 -->
                <div class="step active">
                    <div class="step-header">Step 1: Personal Info</div>
                    <div class="mb-3">
                        <label class="form-label">Owner Name</label>
                        <input type="text" name="ownerName" class="form-control" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mobile Number</label>
                        <input type="text" name="mobNumber" class="form-control" pattern="[0-9]{10}" required />
                    </div>
                </div>

                <!-- Step 2 -->
                <div class="step">
                    <div class="step-header">Step 2: Shop Info</div>
                    <div class="mb-3">
                        <label class="form-label">Shop Name</label>
                        <input type="text" name="shopName" class="form-control" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" name="address" class="form-control" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" />
                    </div>
                </div>

                <!-- Step 3 -->
                <div class="step">
                    <div class="step-header">Step 3: Documents Details</div>
                    <div class="mb-3">
                        <label class="form-label">GST Number</label>
                        <input type="text" name="gstNumber" class="form-control" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">LC No.</label>
                        <input type="text" name="lcNo" class="form-control" />
                    </div>
                    <div class="mb-3">
                                            <label class="form-label">UPI ID.</label>
                                            <input type="text" name="upiId" class="form-control" />
                                        </div>
                </div>
                <div class="step">
                    <div class="step-header">Step: Select Subscription Duration</div>
                    <div class="mb-3">
                        <label for="planDuration" class="form-label">Choose a Plan</label>
                       <select class="form-select fancy-select" id="planDuration" name="planDuration" required>
                           <option value="">-- Select Plan Duration --</option>
                           <c:forEach var="entry" items="${planOptions}">
                               <option value="${entry.key}" data-price="${entry.value}">
                                   ${entry.key} Months - ₹${entry.value}
                               </option>
                           </c:forEach>
                       </select>
                    </div>
                    <!-- Show selected plan price below -->
                    <p class="mt-2 text-primary" id="selectedPlanText"></p>
                </div>



                <!-- Navigation Buttons -->
                <div class="step-buttons">
                    <button type="button" class="btn btn-outline-secondary" onclick="prevStep()">← Previous</button>
                    <button type="button" class="btn btn-outline-primary" onclick="nextStep()">Next →</button>
                    <button type="submit" class="btn btn-outline-success" id="submitBtn" style="display: none;">Submit</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Scripts -->
<script>
    let currentStep = 0;

    function showStep(step) {
        const steps = document.querySelectorAll(".step");
        const indicators = document.querySelectorAll(".step-indicator");

        steps.forEach((s, i) => {
            s.classList.toggle("active", i === step);
            indicators[i].classList.toggle("active", i === step);
        });

        document.querySelector(".btn-outline-secondary").style.display = step === 0 ? "none" : "inline-block";
        document.querySelector(".btn-outline-primary").style.display = step === steps.length - 1 ? "none" : "inline-block";
        document.getElementById("submitBtn").style.display = step === steps.length - 1 ? "inline-block" : "none";
    }

    function nextStep() {
        if (!validateStep()) return;
        currentStep++;
        showStep(currentStep);
    }

    function prevStep() {
        currentStep--;
        showStep(currentStep);
    }

    function validateStep() {
        const currentInputs = document.querySelectorAll(`.step:nth-of-type(${currentStep + 1}) input`);
        for (const input of currentInputs) {
            if (input.hasAttribute("required") && input.value.trim() === "") {
                alert(`Please fill in the ${input.name} field.`);
                input.focus();
                return false;
            }
        }
        return true;
    }

    document.addEventListener("DOMContentLoaded", () => showStep(currentStep));
</script>

</body>
</html>

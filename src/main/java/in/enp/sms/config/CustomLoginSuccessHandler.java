package in.enp.sms.config;

import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.entities.User;
import in.enp.sms.pojo.OwnerSession;
import in.enp.sms.repository.OwnerInfoRepository;
import in.enp.sms.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@Component
public class CustomLoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private static final Logger logger = LoggerFactory.getLogger(CustomLoginSuccessHandler.class);

    @Autowired
    private UserService userService;

    @Autowired
    private OwnerInfoRepository ownerInfoRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        String username = authentication.getName();
        User user = userService.findByUsername(username);

        Optional<OwnerInfo> ownerInfoOpt = ownerInfoRepository.findById(user.getOwnerId());

        // Wrap everything in OwnerSession
        OwnerSession ownerSession = new OwnerSession(user, ownerInfoOpt.orElse(null));

        HttpSession session = request.getSession(true);
        session.setAttribute("sessionOwner", ownerSession);

        logger.info("OwnerSession stored for [{}]: {}", username, ownerSession);

        // Redirect based on role
        if (ownerSession.isSuperAdmin()) {
            response.sendRedirect(request.getContextPath() + "/company/admin");
        } else {
            super.onAuthenticationSuccess(request, response, authentication);
        }
    }
}

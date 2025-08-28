package in.enp.sms.config;

import in.enp.sms.entities.User;
import in.enp.sms.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@Component
public class CustomLoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    @Autowired
    private UserService userService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {
        String username = authentication.getName();
        User user =userService.findByUsername(username);
        request.getSession().setAttribute("ownerId", user.getOwnerId());
        request.getSession().setAttribute("isSuperAdmin", user.isSuperAdmin());
        if (user.isSuperAdmin()) {
            response.sendRedirect(request.getContextPath()+"/company/admin");
        } else {
            super.onAuthenticationSuccess(request, response, authentication);
        }

    }
}

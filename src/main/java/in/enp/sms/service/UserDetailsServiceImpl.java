package in.enp.sms.service;

import java.text.ParseException;
import java.util.HashSet;
import java.util.Set;

import in.enp.sms.entities.Role;
import in.enp.sms.entities.User;
import in.enp.sms.repository.UserRepository;
import in.enp.sms.utility.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;



@Service
public class UserDetailsServiceImpl implements UserDetailsService{

	@Autowired
	private UserRepository userRepository;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsernameAndStatus(username,"ACTIVE");
        try {
            if(Utility.isSubscriptionExpire(user.getExpDate().toString())){
                user = null;
            }

        } catch (ParseException e) {
            throw new RuntimeException(e);
        }

        Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
        for (Role role : user.getRoles()){
            grantedAuthorities.add(new SimpleGrantedAuthority(role.getName()));
        }

        return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), grantedAuthorities);

    }
}

package in.enp.sms.service;

import java.util.HashSet;

import in.enp.sms.entities.User;
import in.enp.sms.repository.RoleRepository;
import in.enp.sms.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;



@Service
public class UserServiceImpl implements UserService {
	@Autowired
	private UserRepository userRepository;
	@Autowired
	private RoleRepository roleRepository;
	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	@Override
	public void save(User user) {
		user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
		userRepository.save(user);
	}

	@Override
	public User findByUsername(String username) {
		return userRepository.findByUsernameAndStatus(username,"ACTIVE");
	}

	@Override
	public User findByUsernameWithoutStatus(String userName) {
		return  userRepository.findByUsername(userName);
	}

	@Override
	public void activateUser(User user) {
		user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
		userRepository.save(user);
	}

	@Override
	public boolean usernameExists(String username) {
		return  userRepository.existsByUsername( username);
	}

	public void updatePassword(String username, String encodedPassword) {
		User user = userRepository.findByUsername(username);
		user.setPassword(encodedPassword);
		userRepository.save(user);
	}


}

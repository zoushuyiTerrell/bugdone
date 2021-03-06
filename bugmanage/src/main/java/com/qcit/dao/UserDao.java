package com.qcit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.qcit.model.JoinMumber;
import com.qcit.model.SimpleHandlerVo;
import com.qcit.model.User;
import com.qcit.model.UserLoginSimple;

public interface UserDao {
	public User getUserByEmail(@Param("email") String email);

	public int setUser(UserLoginSimple userloginsimple);

	public int getCountEmail(@Param("email") String email);

	public void updateEmailById(@Param("email") String email, @Param("id") int id);

	public void updateUsernameById(@Param("username") String username, @Param("id") int id);

	public void updatePasswordById(@Param("password") String password, @Param("id") int id);
	
	public void updateUserPicById(@Param("pic")String pic, @Param("id") int id);
	
    public String getUserNameById( @Param("id") int id);
    
    public User getUserBesidePassword(@Param("email")String email);
    
    public List<JoinMumber> getJoinedMumber(@Param("itemsid") int itemsid);
    
    public List<SimpleHandlerVo> getSimpleHandlerVo(@Param("pid")int pid);
}

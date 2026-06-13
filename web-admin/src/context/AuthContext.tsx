import { createContext, useContext, useState, ReactNode } from 'react';
import { login as apiLogin, AuthData, TOKEN_KEY } from '../services/api';

interface AuthContextType {
  token: string | null;
  user: AuthData | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [token, setToken] = useState<string | null>(() => sessionStorage.getItem(TOKEN_KEY));
  const [user, setUser] = useState<AuthData | null>(null);

  const login = async (email: string, password: string) => {
    const authData = await apiLogin(email, password);
    sessionStorage.setItem(TOKEN_KEY, authData.token);
    setToken(authData.token);
    setUser(authData);
  };

  const logout = () => {
    sessionStorage.removeItem(TOKEN_KEY);
    setToken(null);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ token, user, login, logout, isAuthenticated: !!token }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}

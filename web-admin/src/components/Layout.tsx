import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import '../App.css';

export default function Layout() {
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="layout">
      <aside className="sidebar">
        <div className="sidebar-header">
          <h2>SL Police Admin</h2>
          <p>Traffic Fine System</p>
        </div>
        <ul className="nav-links">
          <li><NavLink to="/dashboard" className={({ isActive }) => isActive ? 'active' : ''}>Dashboard</NavLink></li>
          <li><NavLink to="/district" className={({ isActive }) => isActive ? 'active' : ''}>District Collections</NavLink></li>
          <li><NavLink to="/category" className={({ isActive }) => isActive ? 'active' : ''}>Category Breakdown</NavLink></li>
        </ul>
        <button className="logout-btn" onClick={handleLogout}>Logout</button>
      </aside>
      <main className="content">
        <Outlet />
      </main>
    </div>
  );
}

import { Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import FineDetailsPage from './pages/FineDetailsPage';
import PaymentPage from './pages/PaymentPage';
import SuccessPage from './pages/SuccessPage';
import './App.css';

export default function App() {
  return (
    <div className="app">
      <header className="header">
        <h1>Sri Lanka Police Department</h1>
        <p>Traffic Fine Online Payment Portal</p>
      </header>
      <main className="main">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/fine/:referenceNo" element={<FineDetailsPage />} />
          <Route path="/payment/:referenceNo" element={<PaymentPage />} />
          <Route path="/success" element={<SuccessPage />} />
        </Routes>
      </main>
    </div>
  );
}

import { useNavigate, useLocation } from 'react-router-dom';
import { PaymentReceipt } from '../services/api';

export default function SuccessPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const receipt: PaymentReceipt | undefined = location.state?.receipt;

  if (!receipt) {
    return (
      <div className="card">
        <div className="alert-error">No receipt found.</div>
        <button className="btn btn-secondary" onClick={() => navigate('/')}>Back to Home</button>
      </div>
    );
  }

  return (
    <div className="card">
      <div className="success-icon">✅</div>
      <h2 style={{ textAlign: 'center', marginBottom: '0.5rem' }}>Payment Successful</h2>
      <p style={{ textAlign: 'center', color: '#6b7280', marginBottom: '1.5rem', fontSize: '0.9rem' }}>
        Your traffic fine has been paid successfully.
      </p>
      <div className="receipt-box">
        <h3>Payment Receipt</h3>
        <div className="detail-row">
          <span className="detail-label">Reference No</span>
          <span className="detail-value">{receipt.referenceNo}</span>
        </div>
        <div className="detail-row">
          <span className="detail-label">Amount Paid</span>
          <span className="detail-value">LKR {receipt.amountPaid.toLocaleString()}</span>
        </div>
        <div className="detail-row">
          <span className="detail-label">Transaction Ref</span>
          <span className="detail-value">{receipt.transactionRef}</span>
        </div>
        <div className="detail-row">
          <span className="detail-label">Paid At</span>
          <span className="detail-value">{new Date(receipt.paidAt).toLocaleString()}</span>
        </div>
      </div>
      <div className="info-note">
        SMS sent to the traffic officer notifying them that the fine has been paid.
      </div>
      <button className="btn btn-primary" style={{ marginTop: '1.5rem' }} onClick={() => navigate('/')}>
        Pay Another Fine
      </button>
    </div>
  );
}

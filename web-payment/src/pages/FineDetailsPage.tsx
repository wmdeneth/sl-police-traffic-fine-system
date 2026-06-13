import { useEffect, useState } from 'react';
import { useNavigate, useParams, useLocation } from 'react-router-dom';
import { lookupFine, FineDetails } from '../services/api';

export default function FineDetailsPage() {
  const { referenceNo } = useParams<{ referenceNo: string }>();
  const navigate = useNavigate();
  const location = useLocation();
  const [fine, setFine] = useState<FineDetails | null>(location.state?.fine ?? null);
  const [loading, setLoading] = useState(!fine);
  const [error, setError] = useState('');

  useEffect(() => {
    if (fine || !referenceNo) return;
    setLoading(true);
    lookupFine(referenceNo)
      .then(setFine)
      .catch(() => setError('Fine not found.'))
      .finally(() => setLoading(false));
  }, [referenceNo, fine]);

  if (loading) {
    return (
      <div className="card">
        <p>Loading fine details...</p>
      </div>
    );
  }

  if (error || !fine) {
    return (
      <div className="card">
        <div className="alert-error">{error || 'Fine not found.'}</div>
        <button className="btn btn-secondary" onClick={() => navigate('/')}>Back to Home</button>
      </div>
    );
  }

  const isPaid = fine.status === 'PAID';

  return (
    <div className="card">
      <h2>Fine Details</h2>
      <div style={{ marginBottom: '1rem' }}>
        <span className={`badge ${isPaid ? 'badge-paid' : 'badge-pending'}`}>
          {fine.status}
        </span>
      </div>
      <div className="detail-row">
        <span className="detail-label">Reference No</span>
        <span className="detail-value">{fine.referenceNo}</span>
      </div>
      <div className="detail-row">
        <span className="detail-label">Driver Name</span>
        <span className="detail-value">{fine.driverName}</span>
      </div>
      <div className="detail-row">
        <span className="detail-label">Vehicle No</span>
        <span className="detail-value">{fine.vehicleNo}</span>
      </div>
      <div className="detail-row">
        <span className="detail-label">Category</span>
        <span className="detail-value">{fine.categoryDescription}</span>
      </div>
      <div className="detail-row">
        <span className="detail-label">Amount</span>
        <span className="detail-value">LKR {fine.amount.toLocaleString()}</span>
      </div>
      <div className="detail-row">
        <span className="detail-label">District</span>
        <span className="detail-value">{fine.district}</span>
      </div>
      <button
        className="btn btn-primary"
        style={{ marginTop: '1.5rem' }}
        disabled={isPaid}
        onClick={() => navigate(`/payment/${fine.referenceNo}`, { state: { fine } })}
      >
        {isPaid ? 'Already Paid' : 'Pay Now'}
      </button>
      <button className="btn btn-secondary" onClick={() => navigate('/')}>Back</button>
    </div>
  );
}

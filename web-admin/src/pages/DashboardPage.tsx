import { useEffect, useState } from 'react';
import { getSummary, Summary } from '../services/api';

export default function DashboardPage() {
  const [summary, setSummary] = useState<Summary | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getSummary()
      .then(setSummary)
      .catch(() => setError('Failed to load summary.'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p>Loading dashboard...</p>;
  if (error) return <div className="alert-error">{error}</div>;

  return (
    <div>
      <h1 className="page-title">Dashboard</h1>
      <div className="stats-grid">
        <div className="stat-card">
          <div className="label">Total Fines Issued</div>
          <div className="value">{summary?.totalFines.toLocaleString()}</div>
        </div>
        <div className="stat-card">
          <div className="label">Total Paid</div>
          <div className="value">{summary?.totalPaid.toLocaleString()}</div>
        </div>
        <div className="stat-card">
          <div className="label">Total Amount Collected</div>
          <div className="value">LKR {summary?.totalAmountCollected.toLocaleString()}</div>
        </div>
      </div>
    </div>
  );
}

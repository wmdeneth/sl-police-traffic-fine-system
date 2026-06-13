import { useEffect, useState } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { getDistrictCollections, DistrictCollection } from '../services/api';

export default function DistrictPage() {
  const [data, setData] = useState<DistrictCollection[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getDistrictCollections()
      .then(setData)
      .catch(() => setError('Failed to load district collections.'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p>Loading chart...</p>;
  if (error) return <div className="alert-error">{error}</div>;

  return (
    <div>
      <h1 className="page-title">District Collections</h1>
      <div className="chart-card">
        <ResponsiveContainer width="100%" height={400}>
          <BarChart data={data} margin={{ top: 10, right: 30, left: 20, bottom: 5 }}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="district" />
            <YAxis tickFormatter={(v) => `LKR ${Number(v).toLocaleString()}`} />
            <Tooltip formatter={(value: number) => [`LKR ${value.toLocaleString()}`, 'Collected']} />
            <Bar dataKey="totalCollected" fill="#003580" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}

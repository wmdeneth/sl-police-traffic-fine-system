import { useEffect, useState } from 'react';
import { PieChart, Pie, Cell, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { getCategoryCollections, CategoryCollection } from '../services/api';

const COLORS = ['#003580', '#0056b3', '#0077cc', '#3399dd', '#66bbee'];

export default function CategoryPage() {
  const [data, setData] = useState<CategoryCollection[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    getCategoryCollections()
      .then(setData)
      .catch(() => setError('Failed to load category breakdown.'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <p>Loading chart...</p>;
  if (error) return <div className="alert-error">{error}</div>;

  return (
    <div>
      <h1 className="page-title">Category Breakdown</h1>
      <div className="chart-card">
        <ResponsiveContainer width="100%" height={400}>
          <PieChart>
            <Pie
              data={data}
              dataKey="totalCollected"
              nameKey="category"
              cx="50%"
              cy="50%"
              outerRadius={140}
              label={({ category, totalCollected }) =>
                `${category}: LKR ${Number(totalCollected).toLocaleString()}`
              }
            >
              {data.map((_, index) => (
                <Cell key={index} fill={COLORS[index % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip formatter={(value: number) => `LKR ${value.toLocaleString()}`} />
            <Legend />
          </PieChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}

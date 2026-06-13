import { useState } from 'react';
import { useNavigate, useParams, useLocation } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { processPayment, FineDetails } from '../services/api';

const schema = z.object({
  cardHolderName: z.string().min(1, 'Card holder name is required'),
  cardNumber: z.string().regex(/^\d{16}$/, 'Card number must be 16 digits'),
  expiry: z.string().min(1, 'Expiry is required'),
  cvv: z.string().regex(/^\d{3}$/, 'CVV must be 3 digits'),
});

type FormData = z.infer<typeof schema>;

export default function PaymentPage() {
  const { referenceNo } = useParams<{ referenceNo: string }>();
  const navigate = useNavigate();
  const location = useLocation();
  const fine: FineDetails | undefined = location.state?.fine;
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const { register, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
  });

  if (!fine) {
    return (
      <div className="card">
        <div className="alert-error">Fine details not found. Please look up the fine again.</div>
        <button className="btn btn-secondary" onClick={() => navigate('/')}>Back to Home</button>
      </div>
    );
  }

  const onSubmit = async (data: FormData) => {
    setLoading(true);
    setError('');
    try {
      const receipt = await processPayment({
        referenceNo: referenceNo!,
        categoryId: fine.categoryId,
        paymentMethod: 'CARD',
        channel: 'WEB',
        cardHolderName: data.cardHolderName,
      });
      navigate('/success', { state: { receipt } });
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Payment failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card">
      <h2>Payment — {fine.referenceNo}</h2>
      <p style={{ marginBottom: '1.25rem', color: '#6b7280', fontSize: '0.9rem' }}>
        Amount due: <strong>LKR {fine.amount.toLocaleString()}</strong>
      </p>
      {error && <div className="alert-error">{error}</div>}
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="form-group">
          <label htmlFor="cardHolderName">Card Holder Name</label>
          <input id="cardHolderName" placeholder="Name on card" {...register('cardHolderName')} />
          {errors.cardHolderName && <p className="error-text">{errors.cardHolderName.message}</p>}
        </div>
        <div className="form-group">
          <label htmlFor="cardNumber">Card Number</label>
          <input id="cardNumber" placeholder="1234 5678 9012 3456" maxLength={16} {...register('cardNumber')} />
          {errors.cardNumber && <p className="error-text">{errors.cardNumber.message}</p>}
        </div>
        <div className="form-row">
          <div className="form-group">
            <label htmlFor="expiry">Expiry (MM/YY)</label>
            <input id="expiry" placeholder="MM/YY" {...register('expiry')} />
            {errors.expiry && <p className="error-text">{errors.expiry.message}</p>}
          </div>
          <div className="form-group">
            <label htmlFor="cvv">CVV</label>
            <input id="cvv" placeholder="123" maxLength={3} {...register('cvv')} />
            {errors.cvv && <p className="error-text">{errors.cvv.message}</p>}
          </div>
        </div>
        <button type="submit" className="btn btn-primary" disabled={loading}>
          {loading ? <span className="spinner" /> : 'Confirm Payment'}
        </button>
        <button type="button" className="btn btn-secondary" onClick={() => navigate(-1)}>Back</button>
      </form>
    </div>
  );
}

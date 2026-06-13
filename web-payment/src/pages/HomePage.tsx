import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { lookupFine } from '../services/api';

const schema = z.object({
  referenceNo: z.string().min(1, 'Reference number is required'),
  categoryId: z.string().min(1, 'Category ID is required'),
});

type FormData = z.infer<typeof schema>;

export default function HomePage() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const { register, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
  });

  const onSubmit = async (data: FormData) => {
    setLoading(true);
    setError('');
    try {
      const fine = await lookupFine(data.referenceNo);
      if (fine.categoryId !== data.categoryId) {
        setError('Category ID does not match this fine reference.');
        return;
      }
      navigate(`/fine/${data.referenceNo}`, { state: { fine } });
    } catch {
      setError('Invalid reference number. Please check and try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card">
      <h2>Look Up Traffic Fine</h2>
      {error && <div className="alert-error">{error}</div>}
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="form-group">
          <label htmlFor="referenceNo">Fine Reference No</label>
          <input id="referenceNo" placeholder="e.g. TF-ABC123" {...register('referenceNo')} />
          {errors.referenceNo && <p className="error-text">{errors.referenceNo.message}</p>}
        </div>
        <div className="form-group">
          <label htmlFor="categoryId">Category ID</label>
          <input id="categoryId" placeholder="UUID from fine slip" {...register('categoryId')} />
          {errors.categoryId && <p className="error-text">{errors.categoryId.message}</p>}
        </div>
        <button type="submit" className="btn btn-primary" disabled={loading}>
          {loading ? <span className="spinner" /> : 'Look Up Fine'}
        </button>
      </form>
    </div>
  );
}

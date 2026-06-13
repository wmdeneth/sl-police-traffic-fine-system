import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://10.55.111.76:8080/api',
  headers: { 'Content-Type': 'application/json' },
});

export interface FineDetails {
  id: string;
  referenceNo: string;
  categoryId: string;
  categoryCode: string;
  categoryDescription: string;
  amount: number;
  driverName: string;
  vehicleNo: string;
  district: string;
  status: 'PENDING' | 'PAID';
  issuedAt: string;
}

export interface PaymentReceipt {
  referenceNo: string;
  amountPaid: number;
  paymentMethod: string;
  channel: string;
  transactionRef: string;
  paidAt: string;
  driverName: string;
  vehicleNo: string;
}

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export async function lookupFine(referenceNo: string): Promise<FineDetails> {
  const { data } = await api.get<ApiResponse<FineDetails>>(`/fines/${referenceNo}`);
  if (!data.success) throw new Error(data.message);
  return data.data;
}

export async function processPayment(payload: {
  referenceNo: string;
  categoryId: string;
  paymentMethod: string;
  channel: 'WEB';
  cardHolderName: string;
}): Promise<PaymentReceipt> {
  const { data } = await api.post<ApiResponse<PaymentReceipt>>('/payments', payload);
  if (!data.success) throw new Error(data.message);
  return data.data;
}

export default api;

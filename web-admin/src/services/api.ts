import axios from 'axios';

const TOKEN_KEY = 'admin_jwt_token';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080/api',
  headers: { 'Content-Type': 'application/json' },
});

api.interceptors.request.use((config) => {
  const token = sessionStorage.getItem(TOKEN_KEY);
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      sessionStorage.removeItem(TOKEN_KEY);
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export { TOKEN_KEY };

interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export interface AuthData {
  token: string;
  email: string;
  role: string;
  name: string;
}

export interface Summary {
  totalFines: number;
  totalPaid: number;
  totalAmountCollected: number;
}

export interface DistrictCollection {
  district: string;
  totalCollected: number;
}

export interface CategoryCollection {
  category: string;
  totalCollected: number;
}

export async function login(email: string, password: string): Promise<AuthData> {
  const { data } = await api.post<ApiResponse<AuthData>>('/auth/login', { email, password });
  if (!data.success) throw new Error(data.message);
  return data.data;
}

export async function getSummary(): Promise<Summary> {
  const { data } = await api.get<ApiResponse<Summary>>('/admin/summary');
  if (!data.success) throw new Error(data.message);
  return data.data;
}

export async function getDistrictCollections(): Promise<DistrictCollection[]> {
  const { data } = await api.get<ApiResponse<DistrictCollection[]>>('/admin/collections/district');
  if (!data.success) throw new Error(data.message);
  return data.data;
}

export async function getCategoryCollections(): Promise<CategoryCollection[]> {
  const { data } = await api.get<ApiResponse<CategoryCollection[]>>('/admin/collections/category');
  if (!data.success) throw new Error(data.message);
  return data.data;
}

export default api;

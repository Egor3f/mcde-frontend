import axios from "axios";

let RELEASE = typeof process.env.NODE_ENV !== "undefined" && process.env.NODE_ENV === "production";
export const API_BASE = RELEASE ? '/api' : 'http://127.0.0.1:5000/api';

export async function getApi(method, params={}) {
  return (await axios.get(`${API_BASE}/${method}`, {params})).data;
}

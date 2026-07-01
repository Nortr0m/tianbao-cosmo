/**
 * 格式化金额
 * @param amount 金额（分）
 * @param decimals 小数位数，默认2
 * @returns 格式化后的金额字符串
 */
export function formatAmount(amount: number | string, decimals: number = 2): string {
  const num = typeof amount === 'string' ? parseFloat(amount) : amount;
  if (isNaN(num)) return '0.00';
  return (num / 100).toFixed(decimals);
}

/**
 * 格式化金额（带千分位）
 * @param amount 金额（分）
 * @param decimals 小数位数，默认2
 * @returns 格式化后的金额字符串
 */
export function formatAmountWithComma(amount: number | string, decimals: number = 2): string {
  const num = typeof amount === 'string' ? parseFloat(amount) : amount;
  if (isNaN(num)) return '0.00';
  const value = (num / 100).toFixed(decimals);
  const parts = value.split('.');
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  return parts.join('.');
}

/**
 * 格式化日期
 * @param date 日期字符串或Date对象或时间戳
 * @param format 格式化模板，默认'YYYY-MM-DD'
 * @returns 格式化后的日期字符串
 */
export function formatDate(date: string | Date | number, format: string = 'YYYY-MM-DD'): string {
  let d: Date;

  if (typeof date === 'string') {
    d = new Date(date.replace(/-/g, '/'));
  } else if (typeof date === 'number') {
    d = new Date(date);
  } else {
    d = date;
  }

  if (isNaN(d.getTime())) return '';

  const year = d.getFullYear();
  const month = d.getMonth() + 1;
  const day = d.getDate();
  const hours = d.getHours();
  const minutes = d.getMinutes();
  const seconds = d.getSeconds();

  const pad = (n: number) => n.toString().padStart(2, '0');

  return format
    .replace('YYYY', year.toString())
    .replace('MM', pad(month))
    .replace('DD', pad(day))
    .replace('HH', pad(hours))
    .replace('mm', pad(minutes))
    .replace('ss', pad(seconds));
}

/**
 * 格式化时间（相对时间）
 * @param date 日期字符串或Date对象或时间戳
 * @returns 相对时间字符串
 */
export function formatRelativeTime(date: string | Date | number): string {
  let d: Date;

  if (typeof date === 'string') {
    d = new Date(date.replace(/-/g, '/'));
  } else if (typeof date === 'number') {
    d = new Date(date);
  } else {
    d = date;
  }

  const now = new Date();
  const diff = now.getTime() - d.getTime();
  const seconds = Math.floor(diff / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);
  const months = Math.floor(days / 30);
  const years = Math.floor(days / 365);

  if (seconds < 60) {
    return '刚刚';
  } else if (minutes < 60) {
    return `${minutes}分钟前`;
  } else if (hours < 24) {
    return `${hours}小时前`;
  } else if (days < 30) {
    return `${days}天前`;
  } else if (months < 12) {
    return `${months}个月前`;
  } else {
    return `${years}年前`;
  }
}

/**
 * 格式化百分比
 * @param value 数值（0-1之间）
 * @param decimals 小数位数，默认2
 * @returns 百分比字符串
 */
export function formatPercent(value: number | string, decimals: number = 2): string {
  const num = typeof value === 'string' ? parseFloat(value) : value;
  if (isNaN(num)) return '0.00%';
  return (num * 100).toFixed(decimals) + '%';
}

/**
 * 格式化数字（带千分位）
 * @param num 数字
 * @returns 格式化后的数字字符串
 */
export function formatNumber(num: number | string): string {
  const n = typeof num === 'string' ? parseFloat(num) : num;
  if (isNaN(n)) return '0';
  return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

/**
 * 隐藏手机号中间四位
 * @param phone 手机号
 * @returns 隐藏后的手机号
 */
export function maskPhone(phone: string): string {
  if (!phone || phone.length !== 11) return phone;
  return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');
}

/**
 * 隐藏身份证号中间部分
 * @param idCard 身份证号
 * @returns 隐藏后的身份证号
 */
export function maskIdCard(idCard: string): string {
  if (!idCard || idCard.length < 8) return idCard;
  return idCard.replace(/(\d{4})\d+(\d{4})/, '$1********$2');
}

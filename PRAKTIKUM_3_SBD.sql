SELECT C.c_nama, C.c_email
FROM customer C
WHERE C.c_telp LIKE '081%';

-- 2. Tampilkan 5 ID transaksi termahal beserta total biaya transaksinya
SELECT T.ts_id, COUNT(DISTINCT TT.treatment_t_id) AS JUMLAH_TRANSAKSI, SUM(TR.t_harga * JUMLAH_TRANSAKSI) AS TOTAL_BIAYA
FROM transaksi T
JOIN treatment_transaksi TT ON TT.treatment_t_id = t.ts_id
JOIN treatment TR ON TR.t_id = TT.treatment_t_id
GROUP BY TR.t_id
ORDER BY TOTAL_BIAYA DESC;

-- 3. Tampilkan jumlah customer laki-laki yang melakukan treatment haircut
SELECT COUNT(DISTINCT C.c_id) AS JUMLAH_CUST
FROM customer C
JOIN transaksi T ON T.customer_c_id = C.c_id
JOIN treatment_transaksi TT ON TT.transaksi_ts_id = T.ts_id
JOIN treatment TR ON TR.t_id = TT.treatment_t_id
WHERE TR.t_nama = "Haircut" AND C.c_jenis_kelamin = "L";

-- 4. Tampilkan jumlah setiap metode pembayaran digunakan, ubahlah nama kolom menjadi ‘Metode_Pembayara’ dan ‘Jumlah’ agar hasil query lebih mudah dimengerti
SELECT T.ts_metode_pembayaran AS Metode_Pembayaran, COUNT( T.ts_metode_pembayaran) AS Jumlah
FROM transaksi T
GROUP BY T.ts_metode_pembayaran;

-- 5. Tampilkan nama customer yang telah melakukan transaksi lebih dari 3 kali

SELECT C.c_nama, COUNT(T.customer_c_id) AS JUMLAH_TRANSAKSI
FROM customer C
JOIN transaksi T ON T.customer_c_id = C.c_id
GROUP BY T.customer_c_id
HAVING JUMLAH_TRANSAKSI > 3;

-- 6. Tampilkan nama pegawai, id transaksi, dan jumlah transaksi yang dilayani apabila
-- transaksinya memiliki lebih dari 3 treatment
SELECT P.p_nama, T.ts_id, COUNT(T.ts_id) AS JUMLAH_TRANSAKSI
FROM pegawai P
JOIN transaksi T ON T.pegawai_p_nik = P.p_nik
JOIN treatment_transaksi TT ON TT.transaksi_ts_id = T.ts_id
JOIN treatment TR ON TR.t_id = TT.treatment_t_id
GROUP BY TR.t_id 
HAVING COUNT(TR.t_id) > 3;

-- 7. Tampilkan rata-rata harga treatment yang dilakukan oleh pegawai dengan jenis kelamin
-- 'L' (Laki-laki) pada tanggal 4 November 2023.

SELECT SUM(TR.t_harga) / COUNT(T.ts_id) AS RATA_RATA_HARGA_TREATMENT
 	FROM pegawai P
 	JOIN transaksi T ON T.pegawai_p_nik = P.p_nik
 	JOIN treatment_transaksi TT ON TT.transaksi_ts_id = T.ts_id
 	JOIN treatment TR ON TR.t_id = TT.treatment_t_id
 	WHERE P.p_jenis_kelamin = "L" AND DATE(T.ts_waktu_transaksi) = "2023-11-04";


-- 8. Berikan detail transaksi beserta nama pelanggan dan pegawai untuk transaksi tertua.

SELECT C.c_nama, P.p_nama, T.*
FROM customer C
JOIN transaksi T ON T.customer_c_id = C.c_id
JOIN pegawai P ON P.p_nik = T.pegawai_p_nik
WHERE T.ts_waktu_transaksi = "2023-11-01 10:30:00";

-- 9. Tampilkan nama pelanggan dan total harga transaksi untuk pelanggan yang memiliki
-- transaksi dengan metode pembayaran 'Cash' dan 'Debit Card', tetapi tidak memiliki
-- transaksi dengan metode pembayaran 'Credit Card'.


SELECT C.c_nama, SUM(TR.t_harga) AS TOTAL_HARGA_TRANSAKSI
FROM customer C
JOIN transaksi T ON T.customer_c_id = C.c_id
JOIN treatment_transaksi TT ON TT.transaksi_ts_id = T.ts_id
JOIN treatment TR ON TR.t_id = TT.treatment_t_id
WHERE T.ts_metode_pembayaran NOT IN ("Credit Card");

-- 10. Tampilkan nama dan total harga dari treatment yang pernah dibeli oleh pelanggan
-- dengan nama 'Hendri Kusuma'.

SELECT C.c_nama, SUM(TR.t_harga) AS TOTAL_HARGA
FROM customer C
JOIN transaksi T ON T.customer_c_id = C.c_id
JOIN treatment_transaksi TT ON TT.transaksi_ts_id = T.ts_id
JOIN treatment TR ON TR.t_id = TT.treatment_t_id
WHERE C.c_nama = "Hendri Kusuma";

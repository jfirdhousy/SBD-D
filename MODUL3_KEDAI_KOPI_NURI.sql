-- MODUL PENDAHULUAN 3 KKN, 5025231051

-- 1. Tampilkan seluruh transaksi yang terjadi dari tanggal 10 Oktober 2023 hingga 20
-- Oktober 2023! Tampilkan seluruh kolom dari tabel transaksi.
SELECT * FROM transaksi
WHERE DAY(tanggal_transaksi) >= 10 AND DAY(tanggal_transaksi) <= 20;

-- 2. Hitunglah total harga dari setiap transaksi. Tampilkan id transaksi dan total 
-- harga yang berkesesuaian. Untuk mempermudah Mbak Nuri memahami hasil kueri, maka 
-- ubahlah tampilkan total harga dengan nama ‘TOTAL_HARGA’!
SELECT TM.tm_transaksi_id, SUM(TM.jumlah_minuman * MM.harga_minuman) AS TOTAL_HARGA
FROM transaksi_minuman TM
JOIN menu_minuman MM
ON TM.TM_menu_minuman_id = MM.id_minuman
GROUP BY TM.tm_transaksi_id ASC;

-- 3. Hitung total biaya yang pernah dikeluarkan oleh setiap cutsomer pada dari 
-- tanggal 3 Oktober 2023 hingga 22 Oktober 2023, tampilkan semua kolom dari tabel 
-- customer dan total biaya dengan tampilan nama kolom “Total_Belanja”. Urutkan 
-- berdasarkan nama customer dari A ke Z.
SELECT C.*,
SUM(TM.jumlah_minuman * MM.harga_minuman) AS Total_Belanja
FROM customer C
JOIN transaksi T ON T.customer_id_customer = C.id_customer
JOIN transaksi_minuman TM ON TM.tm_transaksi_id = T.id_transaksi
JOIN menu_minuman MM ON MM.id_minuman = TM.TM_menu_minuman_id 
WHERE DAY(T.tanggal_transaksi) >= 3 AND DAY(T.tanggal_transaksi) <= 22
GROUP BY C.Nama_customer ASC;

-- 4. Mbak Nuri ingin mengetahui data pegawai yang pernah melayani customer 
-- dengan nama Davi Liam, Sisil Triana, atau Hendra Asto
SELECT P.*
FROM pegawai P
JOIN transaksi T ON T.pegawai_nik = P.nik
JOIN customer C ON C.id_customer = T.customer_id_customer
WHERE C.nama_customer = "Davi Liam" OR 
C.nama_customer = "Sisil Triana" OR 
C.nama_customer = "Hendra Asto";

-- 5. Hitunglah jumlah cup yang terjual pada Kopi Nuri setiap bulannya (perhatikan 
-- bulan dan tahunnya)! Tampilkan kolom bulan, tahun, dan jumlah cup dengan nama 
-- ‘BULAN’, ‘TAHUN’, ‘JUMLAH_CUP’. Urutkan berdasarkan tahun dari yang terbesar dan 
-- bulan yang terkecil. Hint: gunakan fungsi berikut pada masing-masing RDBMS:
-- • MYSQL: MONTH(nama_kolom), YEAR(nama_kolom)
-- • Oracle, Postgresql: EXTRACT(MONTH FROM nama_kolom),
-- EXTRACT(YEAR FROM nama_kolom)

SELECT 
    MONTH(T.tanggal_transaksi) AS BULAN,
    YEAR(T.tanggal_transaksi) AS TAHUN,
    SUM(TM.jumlah_minuman) AS JUMLAH_CUP
FROM transaksi T
JOIN transaksi_minuman TM ON TM.tm_transaksi_id = T.id_transaksi
GROUP BY YEAR(T.tanggal_transaksi), MONTH(T.tanggal_transaksi)
ORDER BY YEAR(T.tanggal_transaksi) DESC, MONTH(T.tanggal_transaksi) ASC;

-- TO CHECK, soalnya di data hanya bulan okt
-- INSERT INTO `transaksi` (`id_transaksi`, `tanggal_transaksi`, `metode_pembayaran`, `customer_id_customer`, `pegawai_nik`) VALUES
-- ('TRX0000008', '2023-11-01', 'Kartu kredit', 'CTR002', '2345678901234561')
-- INSERT INTO `transaksi_minuman` (`tm_menu_minuman_id`, `tm_transaksi_id`, `jumlah_minuman`) VALUES
-- ('MNM010', 'TRX0000008', 7),

-- 6 Berapa nilai rata-rata total belanja berdasarkan transaksi, dari seluruh customer? 
-- YANG 3) RATA RATA SEMUA CUSTOMER BERDASARKAN TRANSAKSI -----> INI YANG BENAR
SELECT 
        SUM(TM.jumlah_minuman * M.harga_minuman) AS TOTAL_HARGA,
        COUNT(DISTINCT(T.id_transaksi)) AS JUMLAH_TRANSAKSI ,
        SUM(TM.jumlah_minuman * M.harga_minuman) / COUNT(DISTINCT(T.id_transaksi)) AS RATA-RATA
    FROM menu_minuman M
    JOIN transaksi_minuman TM ON TM.tm_menu_minuman_id = M.id_minuman
    JOIN transaksi T ON TM.tm_transaksi_id = T.id_transaksi;

-- 7. Dapatkan data customer dengan rata-rata total belanja lebih dari rata-rata 
-- total belanja seluruh customer. Tampilkan kolom id customer, nama customer, 
-- dan total belanja!
SELECT 
    C.id_customer,
    C.nama_customer,
    SUM(TM.jumlah_minuman * M.harga_minuman) AS total_belanja
FROM 
    menu_minuman M
    JOIN transaksi_minuman TM ON TM.tm_menu_minuman_id = M.id_minuman
    JOIN transaksi T ON TM.tm_transaksi_id = T.id_transaksi   
    JOIN customer C ON T.customer_id_customer = C.id_customer
GROUP BY 
    T.customer_id_customer
HAVING 
    total_belanja / COUNT(DISTINCT T.id_transaksi) > (
        SELECT 
            SUM(TM.jumlah_minuman * M.harga_minuman) / COUNT(DISTINCT T.id_transaksi) AS RATARATA
        FROM 
            menu_minuman M
            JOIN transaksi_minuman TM ON TM.tm_menu_minuman_id = M.id_minuman
            JOIN transaksi T ON TM.tm_transaksi_id = T.id_transaksi   
            JOIN customer C ON T.customer_id_customer = C.id_customer
    );


-- 8. Tampilkan data customer yang tidak terdaftar sebagai membership!
SELECT C.*
FROM customer C
LEFT JOIN membership M ON M.m_id_customer = C.id_customer
WHERE M.m_id_customer IS NULL;

-- 9. Berapakah jumlah customer yang pernah memesan minuman Latte?
SELECT MM.nama_minuman, COUNT(DISTINCT C.id_customer) AS JML_CUST_PERNAH_PESAN
FROM menu_minuman MM
JOIN transaksi_minuman TM ON TM.tm_menu_minuman_id = MM.id_minuman
JOIN transaksi T ON T.id_transaksi = TM.tm_transaksi_id
JOIN customer C ON C.id_customer = T.customer_id_customer
WHERE MM.nama_minuman = "Latte"
GROUP BY MM.nama_minuman;

-- 10. Mbak Nuri ingin mengetahui nama customer, menu minuman, dan total
-- jumlah cup menu minuman dari customer dengan nama yang berawalan dengan huruf S!
SELECT  C.nama_customer, MM.nama_minuman, SUM(TM.jumlah_minuman) AS JUMLAH_CUP
FROM Customer C
JOIN transaksi T ON C.id_customer = T.customer_id_customer
JOIN transaksi_minuman TM ON T.id_transaksi = TM.tm_transaksi_id
JOIN menu_minuman MM ON TM.tm_menu_minuman_id = MM.id_minuman
WHERE C.nama_customer LIKE 's%'
GROUP BY C.nama_customer, MM.nama_minuman;

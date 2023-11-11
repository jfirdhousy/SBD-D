CREATE DATABASE Servis_Mobil_Antera

CREATE TABLE pelanggan(
    p_id CHAR(16) NOT NULL PRIMARY KEY,
    p_nama VARCHAR(60) NOT NULL,
    p_no_telp VARCHAR(15) NOT NULL,
    p_email VARCHAR(256),
    p_alamat VARCHAR(100) NOT NULL
);

CREATE TABLE suku_cadang(
    sc_id CHAR(7) NOT NULL PRIMARY KEY,
    sc_nama VARCHAR(130) NOT NULL,
    sc_deskripsi VARCHAR(100) NOT NULL,
    sc_harga FLOAT(10,2) NOT NULL
);

CREATE TABLE mekanik(
    mk_id CHAR(6) NOT NULL PRIMARY KEY,
    mk_nama VARCHAR(60) NOT NULL
);

CREATE TABLE mobil(
    mb_vin CHAR(17) NOT NULL PRIMARY KEY,
    mb_merk VARCHAR(20) NOT NULL,
    mb_tipe VARCHAR(30) NOT NULL,
    mb_tahun INTEGER NOT NULL,
    mb_warna VARCHAR(20) NOT NULL,
    mb_p_id CHAR(16) NOT NULL,
    CONSTRAINT mobil_pelanggan_FK FOREIGN KEY (mb_p_id) REFERENCES pelanggan(p_id)
);

CREATE TABLE tiket_servis(
    ts_id CHAR(16) NOT NULL PRIMARY KEY,
    ts_waktu_masuk TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    ts_waktu_keluar TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    ts_deskripsi VARCHAR(400) NOT NULL,
    ts_komentar VARCHAR(400),
    ts_p_id CHAR(16) NOT NULL,
    ts_mb_vin CHAR(17) NOT NULL,
    CONSTRAINT tiket_servis_pelanggan_FK
    FOREIGN KEY (ts_p_id) REFERENCES pelanggan(p_id),
    CONSTRAINT tiket_servis_mobil_FK
    FOREIGN KEY (ts_mb_vin) REFERENCES mobil(mb_vin)
);

CREATE TABLE suku_cadang_servis(
    scsv_ts_id CHAR(8) NOT NULL,
    scsv_sc_id CHAR(7) NOT NULL,
    PRIMARY KEY(scsv_ts_id, scsv_sc_id),
    CONSTRAINT Relation_9_tiket_servis_FK
    FOREIGN KEY (scsv_ts_id) REFERENCES tiket_servis(ts_id),
    CONSTRAINT Relation_9_suku_cadang_FK
    FOREIGN KEY (scsv_sc_id) REFERENCES suku_cadang(sc_id)
);

CREATE TABLE mekanik_servis(
    mksv_mk_id CHAR(6) NOT NULL,
    mksv_ts_id CHAR(8) NOT NULL,
    PRIMARY KEY(mksv_mk_id, mksv_ts_id),
    CONSTRAINT Relation_8_mekanik_FK
    FOREIGN KEY (mksv_mk_id) REFERENCES mekanik(mk_id),
    CONSTRAINT Relation_8_tiket_servis_FK
    FOREIGN KEY (mksv_ts_id) REFERENCES tiket_servis(ts_id)
);

-- 2 Pak Popo adalah orang yang pelupa. Beliau ingin menambahkan supplier untuk masing-
-- masing suku cadang pada bisnisnya. Setiap supplier dapat menyuplai banyak jenis suku
-- cadang. Namun, setiap suku cadang hanya memiliki satu supplier. Pak Popo ingin
-- menyimpan data supplier dan tipe datanya sebagai berikut :

CREATE TABLE supplier(
    sp_id CHAR(6) NOT NULL PRIMARY KEY,
    sp_nama VARCHAR(60) NOT NULL,
    sp_no_telp VARCHAR(15) NOT NULL,
    sp_email VARCHAR(256) NOT NULL,
    sp_alamat VARCHAR(100) NOT NULL
);

-- 3 Ubah nama tabel mekanik menjadi pegawai (tidak perlu mengubah nama kolom). 
-- Kemudian, buat tabel bernama ‘posisi’ untuk menyimpan job desc pegawai. 

ALTER TABLE mekanik RENAME TO pegawai;

CREATE TABLE posisi(
    ps_id CHAR(6) NOT NULL PRIMARY KEY,
    ps_nama VARCHAR(15) NOT NULL
);

-- Buat foreign key di tabel pegawai yang mengacu pada ps_id.
ALTER TABLE pegawai
ADD mk_ps_id CHAR(6) NOT NULL,
ADD CONSTRAINT FK_pegawai_posisi
FOREIGN KEY (mk_ps_id) REFERENCES posisi(ps_id);

-- 4 menghapus tabel ‘posisi’ lalu menambahkan kolom ‘mk_posisi’ pada tabel pegawai.
ALTER TABLE pegawai
DROP FK_pegawai_posisi;

DROP TABLE posisi;

ALTER TABLE pegawai
ADD COLUMN mk_posisi
DROP COLUMN mk_ps_id;



-- 5 masukkan data
-- pelanggan
INSERT INTO pelanggan VALUES ('3225011201880002', 'Andy Williams', '62123456789', 'andy@gmail.com', 'Jl. Apel no 1');
INSERT INTO pelanggan VALUES ('3525010706950001', 'Marshall Paul', '621451871011', 'paulan@gmail.com', 'Jl. Jeruk no 12');
INSERT INTO pelanggan VALUES ('3525016005920002', 'Kazuya Tanaka', '62190129190', 'tanaka@gmail.com', 'Jl. JKT no 48');
INSERT INTO pelanggan (p_id, p_nama, p_no_telp, p_alamat) VALUES ('3975311107780001', 'Budi Prutomo', '621545458901', 'Jl. Nanas no 45');
INSERT INTO pelanggan (p_id, p_nama, p_no_telp, p_alamat) VALUES ('3098762307810002', 'Razai Ambudi', '621898989102', 'Jl. Mangga no 2');

-- mobil
INSERT INTO mobil VALUES ('JN8AZ1MW4BW678706', 'Nissan', 'Murano', '2011', 'biru', '3525010706950001');
INSERT INTO mobil VALUES ('2LMTJ8JP0GSJ00175', 'Lincoln', 'MKX', '2016', 'merah', '3525016005920002');
INSERT INTO mobil VALUES ('ZFF76ZHT3E0201920', 'Ferrari', 'Ferrari', '2014', 'merah', '3975311107780001');
INSERT INTO mobil VALUES ('1HGCP26359A157554', 'Honda', 'Accord', '2009', 'hitam', '3225011201880002');
INSERT INTO mobil VALUES ('5YJSA1DN5CFP01785', 'Tesla', 'Model S', '2012', 'putih', '3098762307810002');

-- pegawai
INSERT INTO pegawai VALUES ('MK0001', 'Walter Jones', 'mekanik');
INSERT INTO pegawai VALUES ('MK0002', 'Kentaki Veraid', 'kasir');
INSERT INTO pegawai VALUES ('MK0003', 'Leo', 'mekanik');
INSERT INTO pegawai VALUES ('MK0004', 'Reyhand Janita', 'pencuci');
INSERT INTO pegawai VALUES ('MK0005', 'Elizabeth Alexandra', 'mekanik');

-- supplier
INSERT INTO supplier VALUES ('SP0001', 'Indotrading', '6282283741247', 'indotrading@rocketmail.com', 'Jl. Bambu no 5');
INSERT INTO supplier VALUES ('SP0002', 'Jayasinda', '628227428238', 'Jayasinda@yahoo.com', 'Jl. Padi no 12');
INSERT INTO supplier VALUES ('SP0003', 'SAS Autoparts', '6282212382311', 'sasparts@gmail.com', 'Jl. Sorghum no 24');

-- suku cadang
INSERT INTO suku_cadang VALUES ('SC00001', 'Damper', 'Damper Per Belakang Original', '800000.00');
INSERT INTO suku_cadang VALUES ('SC00002', 'Coil Ignition', 'Coil Ignition Denso Jepang', '550000.00');
INSERT INTO suku_cadang VALUES ('SC00003', 'Selang Filter', 'Selang Filter Udara Original', '560000.00');
INSERT INTO suku_cadang VALUES ('SC00004', 'Bushing', 'Bushing Upper Arm Original', '345000.00');
INSERT INTO suku_cadang VALUES ('SC00005', 'Radiator Racing', 'Radiator Racing Kotorad Manual Diesel', '6750000.00');

-- tiket_servis
INSERT INTO tiket_servis VALUES ('TS000001', '2023-11-05 08:00:00', '2023-11-05 16:30:00', 
'Mobil mengalami getaran yang tidak normal saat berkendara. Untuk memperbaikinya, kami akan mengganti damper yang aus dan juga bushing yang telah rusak.', 
'Saya sangat puas dengan perbaikan ini. Mobil saya sekarang berjalan lebih halus dan getarannya hilang. Terima kasih atas pelayanan yang baik!', 
'3098762307810002', '5YJSA1DN5CFP01785');
INSERT INTO tiket_servis VALUES ('TS000002', '2023-11-05 09:15:00', '2023-11-05 17:45:00', 
'Mesin mobil sering mati secara tiba-tiba atau tidak berjalan dengan baik. Permasalahannya terletak pada coil ignition yang bermasalah. Kami akan menggantinya dan melakukan pengaturan ulang untuk memastikan kinerja mesin yang lebih baik.', 
'Mesin mobil saya sekarang berjalan seperti baru lagi. Tidak ada lagi mati mendadak, dan kinerjanya sangat baik. Pelayanan yang cepat dan profesional.', 
'3098762307810002', '5YJSA1DN5CFP01785');
INSERT INTO tiket_servis VALUES ('TS000003', '2023-11-06 10:30:00', '2023-11-06 18:15:00', 
'Untuk meningkatkan kinerja pendinginan mesin, kami akan membersihkan radiator dan memeriksa apakah ada kerusakan atau kebocoran. Jika diperlukan, kami akan mengganti komponen yang rusak.', 
'Mobil saya sekarang tidak lagi mengalami masalah panas berlebihan. Radiator berfungsi dengan baik, dan saya merasa aman saat berkendara. Terima kasih atas perbaikan yang berkualitas', 
'3098762307810002', '5YJSA1DN5CFP01785');
INSERT INTO tiket_servis VALUES ('TS000004', '2023-11-06 11:45:00', '2023-11-06 19:30:00', 
'Mobil mengalami masalah saat memasok bahan bakar ke mesin. Masalah ini terjadi karena selang filter bahan bakar yang tersumbat. Kami akan menggantinya sehingga aliran bahan bakar menjadi lancar kembali.', 
'Setelah penggantian selang filter bahan bakar, mobil saya kembali berjalan dengan lancar. Tidak ada lagi masalah pengiriman bahan bakar. Pelayanan yang sangat membantu', 
'3525010706950001', 'JN8AZ1MW4BW678706');
INSERT INTO tiket_servis VALUES ('TS000005', '2023-11-06 12:30:00', '2023-11-06 20:00:00', 
'Mobil akan menjalani pemeliharaan komprehensif, termasuk pemeriksaan seluruh sistem. Ini termasuk penggantian damper yang aus, coil ignition yang bermasalah, serta pemeriksaan dan perawatan selang filter dan radiator racing. Semua suku cadang yang perlu diganti akan diperbaiki agar mobil berfungsi seperti semula.', 
'Pemeliharaan komprehensif yang telah dilakukan membuat mobil saya seperti baru. Semua masalah telah diperbaiki, dan saya merasa yakin dengan kualitas perbaikan yang diberikan. Terima kasih atas kerja kerasnya', 
'3225011201880002', '1HGCP26359A157554');

-- mekanik servis
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000001', 'MK0005');
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000002', 'MK0003');
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000002', 'MK0004');
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000003', 'MK0005');
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000004', 'MK0003');
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000005', 'MK0001');
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000005', 'MK0005');
INSERT INTO mekanik_servis (mksv_ts_id, mksv_mk_id) VALUES ('TS000005', 'MK0004');

-- sukucadangSERV
INSERT INTO suku_cadang_servis VALUES ('TS000001', 'SC00001');
INSERT INTO suku_cadang_servis VALUES ('TS000001', 'SC00004');
INSERT INTO suku_cadang_servis VALUES ('TS000002', 'SC00002');
INSERT INTO suku_cadang_servis VALUES ('TS000003', 'SC00005');
INSERT INTO suku_cadang_servis VALUES ('TS000004', 'SC00003');
INSERT INTO suku_cadang_servis VALUES ('TS000005', 'SC00001');
INSERT INTO suku_cadang_servis VALUES ('TS000005', 'SC00002');
INSERT INTO suku_cadang_servis VALUES ('TS000005', 'SC00003');
INSERT INTO suku_cadang_servis VALUES ('TS000005', 'SC00005');

-- 6 UPDATE waktu keluar pada tiket servis menggunakan waktu sekarang.
UPDATE tiket_servis
SET ts_waktu_keluar = NOW();

-- 7 Ada kesalahan pada pendataan pelanggan dengan id 3225011201880002, yaitu nama, 
-- email, dan alamat berturut-turut seharusnya Andi Williams, andi@bing.com, dan Jl. 
-- Koreka no 15. Lakukan perubahan data berdasarkan revisi yang diberikan
UPDATE pelanggan
SET p_nama = 'Andi Williams', p_email = 'andi@bing.com', p_alamat = 'Jl. Koreka no 15'
WHERE p_id = '3225011201880002';

-- 8 Buatlah foreign key pada tabel suku cadang yang mengacu pada id supplier
ALTER TABLE suku_cadang
ADD sc_sp_id CHAR(6) NULL;

-- atur relasi antara suku cadang dengan supplier
UPDATE suku_cadang
SET sc_sp_id = 'SP0001'
WHERE sc_id = 'SC00004';
UPDATE suku_cadang
SET sc_sp_id = 'SP0002'
WHERE sc_id IN ('SC00001', 'SC00003');
UPDATE suku_cadang
SET sc_sp_id = 'SP0003'
WHERE sc_id IN ('SC00002', 'SC00005');

-- buat fk
ALTER TABLE suku_cadang
ADD CONSTRAINT FK_suku_cadang_supplier 
FOREIGN KEY (sc_sp_id) REFERENCES supplier(sp_id);
-- notnull kan fk
ALTER TABLE suku_cadang
MODIFY sc_sp_id CHAR(6) NOT NULL;


-- 9 kenaikan harga beli suku cadang pada semua supplier. Pak Popo ingin 
-- menaikkan harga jual sebanyak 10% untuk suku cadang yang berharga lebih dari 
-- 500.000. Bantu Pak Popo untuk mengubah harga suku cadang yang dimaksud.
UPDATE suku_cadang
SET sc_harga = 1.1 * sc_harga
WHERE sc_harga > 500000;

-- 10 Pada tanggal 10 November 2023 pukul 09:05, seorang pelanggan bernama Kazuya 
-- Tanaka membawa mobil dengan VIN: 2LMTJ8JP0GSJ00175 ke Service Mobil Antera. 
-- Mekanik yang bersangkutan (MK0001) memberi deskripsi “Mobil mengalami 
-- kerusakan damper belakang. Terdapat kebocoran cairan hidrolik dan kondisi damper 
-- sudah aus. Kami akan mengganti damper belakang”. Tambahkan tiket tersebut ke 
-- database. Perhatikan bahwa servis tersebut membutuhkan suku cadang damper 
-- belakang. Tambahkan datanya pada tabel yang sesuai.
INSERT INTO tiket_servis (ts_id, ts_waktu_masuk, ts_deskripsi, ts_p_id, ts_mb_vin)
VALUES ('TS000006', '2023-11-10 09:05:00', 'Mobil mengalami kerusakan damper belakang. Terdapat kebocoran cairan hidrolik dan kondisi damper sudah aus. Kami akan mengganti damper belakang',
'3525016005920002', '2LMTJ8JP0GSJ00175');

INSERT INTO suku_cadang_servis VALUES ('TS000006', 'SC00001');

INSERT INTO mekanik_servis VALUES ('MK0001', 'TS000006');

-- 11 Dari soal sebelumnya, tambahkan waktu selesai servis menggunakan waktu sekarang. 
-- Kalian sebagai Kazuya menemukan sebuah goresan kecil pada mobil. Tambahkan 
-- komentar kurang memuaskan pada servis tersebut. Usut punya usut, pegawai bernama 
-- Walter Jones sering sekali lalai dalam pekerjaannya. Setelah membaca komentar 
-- Kazuya, Pak Popo memutuskan untuk memecat pegawai tersebut. Hapuslah data 
-- pegawai tersebut dari database.

UPDATE tiket_servis
SET ts_waktu_keluar = NOW(), ts_komentar = 'ada goresan kecil, saya kurang puas. pegawai lalai.'
WHERE ts_id = 'TS000006';

DELETE FROM mekanik_servis
WHERE mksv_mk_id = 'MK0001'; 

DELETE FROM pegawai
WHERE mk_id = 'MK0001'; -- id walter jones mk001

-- 12 Pak Popo ingin menghapus semua data pada tabel mekanik_servis
DELETE FROM mekanik_servis;
--Jasmine Firdhousy Muslich
--5025231051, kelas SBD D, Bapak Abdul Munif

--1. Buatlah sebuah database sesuai dengan PDM di atas. 
CREATE DATABASE Kedai_Kopi_Nuri

--Definisikan nama tabel dan kolom, tipe data kolom, serta constraint 
--yang sama dengan PDM. Buat PDM diatas pada perintah CREATE.
CREATE TABLE Customer(
    ID_customer CHAR(6) NOT NULL,
    Nama_customer VARCHAR(100) NOT NULL,
    PRIMARY KEY (ID_customer)
);

CREATE TABLE Pegawai(
    NIK CHAR(16) NOT NULL,
    Nama_pegawai VARCHAR(100) NOT NULL,
    Jenis_kelamin CHAR(1),
    Email VARCHAR(50),
    Umur INTEGER NOT NULL,
    PRIMARY KEY (NIK)
);

CREATE TABLE Menu_minuman(
    ID_minuman CHAR(6) NOT NULL,
    Nama_minuman VARCHAR(50) NOT NULL,
    Harga_minuman FLOAT(2),
    PRIMARY KEY (ID_minuman)
);

CREATE TABLE Telepon(
    No_telp_pegawai VARCHAR(15) NOT NULL,
    Pegawai_NIK CHAR(16) NOT NULL,
    PRIMARY KEY (No_telp_pegawai),
    FOREIGN KEY(Pegawai_NIK) REFERENCES Pegawai(NIK)
);

CREATE TABLE Transaksi(
    ID_transaksi CHAR(10) NOT NULL,
    Tanggal_transaksi DATE NOT NULL,
    Metode_pembayaran VARCHAR(15) NOT NULL,
    Pegawai_NIK CHAR(16) NOT NULL,
    Customer_ID_customer CHAR(6) NOT NULL,
    PRIMARY KEY (ID_transaksi),
    FOREIGN KEY(Pegawai_NIK) REFERENCES Pegawai(NIK),
    FOREIGN KEY(Customer_ID_customer) REFERENCES Customer(ID_customer)
);

CREATE TABLE Transaksi_minuman(
    TM_Transaksi_ID CHAR(10) NOT NULL,
    TM_Menu_minuman_ID CHAR(6) NOT NULL,
    Jumlah_cup INTEGER NOT NULL,
    PRIMARY KEY (TM_Menu_minuman_ID, TM_Transaksi_ID),
    FOREIGN KEY(TM_Transaksi_ID) REFERENCES Transaksi(ID_transaksi),
    FOREIGN KEY(TM_Menu_minuman_ID) REFERENCES Menu_minuman(ID_minuman)
);


--2. Mbak Nuri ingin membuat sistem membership dimana customer bisa mendaftar. 
CREATE TABLE Membership(
    id_membership CHAR(6) NOT NULL,
    no_telepon_customer VARCHAR(15) NOT NULL,
    alamat_customer VARCHAR(100) NOT NULL,
    tanggal_pembuatan_kartu_membership DATE NOT NULL,
    tanggal_kedaluawarsa_kartu_membership DATE,
    total_poin INTEGER NOT NULL,
    Customer_ID_customer CHAR(6) NOT NULL
);

--Dari tabel tersebut, dengan perintah ALTER TABLE:
--A. Jadikan id_membership sebagai PRIMARY KEY
ALTER TABLE Membership
ADD PRIMARY KEY (id_membership);

--B. Atur customer_id_customer sebagai FOREIGN KEY yang berasal dari relasi dengan 
--tabel customer Dengan pengaturan apabila id_customer di tabel customer diubah, 
--maka data id di tabel membership ikut berubah. Selain itu, data customer tidak 
--boleh dihapus apabila telah menjadi member.
ALTER TABLE Membership
ADD CONSTRAINT FOREIGN KEY (customer_ID_customer) REFERENCES Customer(ID_customer)
ON UPDATE CASCADE
ON DELETE RESTRICT;

--C. Atur customer_id_customer pada tabel transaksi sebagai 
--FOREIGN KEY dengan kondisi ON DELETE CASCADE dan ON UPDATE CASCADE
ALTER TABLE Transaksi
ADD CONSTRAINT FOREIGN KEY (customer_ID_customer) REFERENCES Customer(ID_customer)
ON UPDATE CASCADE
ON DELETE CASCADE;

--D. Atur nilai default tanggal_pembuatan_kartu_membership 
--sebagai tanggal sekarang (terdapat fungsi build-in)
ALTER TABLE Membership
MODIFY tanggal_pembuatan_kartu_membership DATE DEFAULT CURRENT_DATE;

--E. Berikan constraint untuk melakukan pengecekan bahwa 
--total_poin harus lebih dari atau sama dengan 0
ALTER TABLE Membership
ADD CONSTRAINT cek_total_poin CHECK (total_poin >= 0);

--F. Dalam berjalannya bisnis, terdapat alamat pelanggan yang 
--memiliki panjang hingga 140, Sehingga ubah ukuran maksimalnya menjadi 150
ALTER TABLE Membership
MODIFY COLUMN alamat_customer VARCHAR(150);

--3. tabel telp tidak diperlukan dan diganti dengan menambahkan
--atribut nomor telepon pada tabel pegawai.
DROP TABLE Telepon;

ALTER TABLE Pegawai
ADD nomor_telepon VARCHAR(15);

--4. Mbak Nuri punya data yang perlu dimasukkan pada masing-masing tabel
--a. tabel Customer
INSERT INTO Customer VALUES ('CTR001', 'Budi Santoso');
INSERT INTO Customer VALUES ('CTR002', 'Sisil Triana');
INSERT INTO Customer VALUES ('CTR003', 'Davi Liam');
INSERT INTO Customer VALUES ('CTRo04', 'Sutris Ten An');
INSERT INTO Customer VALUES ('CTR005', 'Hendra Asto');

--b. tabel Membership, format datatype DATE adl YYYY-MM-DD
INSERT INTO Membership VALUES ('MBR001', '08123456789', 'Jl. Imam Bonjol', '2023/10/23', '2023/11/30', '0', 'CTR001');
INSERT INTO Membership VALUES ('MBR002', '0812345678', 'Jl. Kelinci', '2023/10/23', '2023/11/30', '3', 'CTR002');
INSERT INTO Membership VALUES ('MBR003', '081234567890', 'Jl. Abah Ojak', '2023/10/25', '2023/12/01', '2', 'CTR003');
INSERT INTO Membership VALUES ('MBR004', '08987654321', 'Jl. Kenangan', '2023/10/26', '2023/12/02', '6', 'CTR005');

--c. tabel Pegawai
INSERT INTO Pegawai VALUES ('1234567890123456', 'Naufal Raf', 'L', 'nuafal@gmail.com', '19', '62123456789');
INSERT INTO Pegawai VALUES ('2345678901234561', 'Surinala', 'P. Imam Bonjol', 'surinala@gmail.com', '24', '621234567890');
INSERT INTO Pegawai VALUES ('3456789012345612', 'Ben John', 'L. Imam Bonjol', 'benjohn@gmail.com', '22', '6212345678');

--d. tabel Transaksi
INSERT INTO Transaksi VALUES ('TRX0000001', '2023-10-01', 'Kartu kredit', '2345678901234561', 'CTR002');
INSERT INTO Transaksi VALUES ('TRX0000002', '2023-10-03', 'Transfer bank', '3456789012345612', 'CTRo04');
INSERT INTO Transaksi VALUES ('TRX0000003', '2023-10-05', 'Tunai', '3456789012345612', 'CTR001');
INSERT INTO Transaksi VALUES ('TRX0000004', '2023-10-15', 'Kartu debit', '1234567890123456', 'CTR003');
INSERT INTO Transaksi VALUES ('TRX0000005', '2023-10-15', 'E-wallet', '1234567890123456', 'CTRo04');
INSERT INTO Transaksi VALUES ('TRX0000006', '2023-10-21', 'Tunai', '2345678901234561', 'CTR001');

--e. tabel Menu_minuman
INSERT INTO Menu_minuman VALUES ('MNM001', 'Expresso', '18000');
INSERT INTO Menu_minuman VALUES ('MNM002', 'Cappucino', '20000');
INSERT INTO Menu_minuman VALUES ('MNM003', 'Latte', '21000');
INSERT INTO Menu_minuman VALUES ('MNM004', 'Americano', '19000');
INSERT INTO Menu_minuman VALUES ('MNM005', 'Mocha', '22000');
INSERT INTO Menu_minuman VALUES ('MNM006', 'Mocchiato', '23000');
INSERT INTO Menu_minuman VALUES ('MNM007', 'Cold Brew', '21000');
INSERT INTO Menu_minuman VALUES ('MNM008', 'Iced Coffee', '18000');
INSERT INTO Menu_minuman VALUES ('MNM009', 'Affogato', '23000');
INSERT INTO Menu_minuman VALUES ('MNM010', 'Coffee Frappe', '22000');

--f. tabel Transaksi_minuman
INSERT INTO Transaksi_minuman VALUES ('TRX0000005', 'MNM006', '2');
INSERT INTO Transaksi_minuman VALUES ('TRX0000001', 'MNM010', '1');
INSERT INTO Transaksi_minuman VALUES ('TRX0000002', 'MNM005', '1');
INSERT INTO Transaksi_minuman VALUES ('TRX0000005', 'MNM009', '1');
INSERT INTO Transaksi_minuman VALUES ('TRX0000003', 'MNM001', '3');
INSERT INTO Transaksi_minuman VALUES ('TRX0000006', 'MNM003', '2');
INSERT INTO Transaksi_minuman VALUES ('TRX0000004', 'MNM004', '2');
INSERT INTO Transaksi_minuman VALUES ('TRX0000004', 'MNM010', '1');
INSERT INTO Transaksi_minuman VALUES ('TRX0000002', 'MNM003', '2');
INSERT INTO Transaksi_minuman VALUES ('TRX0000001', 'MNM007', '1');
INSERT INTO Transaksi_minuman VALUES ('TRX0000005', 'MNM001', '1');
INSERT INTO Transaksi_minuman VALUES ('TRX0000003', 'MNM003', '1');

--DML
--5. lakukan penambahan data pada database dengan keterangan berikut:
--Pada tanggal 3 Oktober 2023, seorang pelanggan dengan ID Pembeli 'CTRo04' 
--memilih untuk membayar menggunakan metode transfer bank dan memesan 1 minuman
--jenis MNM005, pelanggan tersebut dilayani oleh pelayan bernama surinala.
-- NIK surinala: 2345678901234561
INSERT INTO Transaksi VALUES ('TRX0000007', '2023-10-03', 'Transfer bank', '2345678901234561', 'CTRo04');
INSERT INTO Transaksi_minuman VALUES ('TRX0000007', 'MNM005', '1');

--6. Tambahkan data pegawai dengan isian NIK 1111222233334444, nama 
--pegawai Maimunah, dan umur 25 tahun
INSERT INTO Pegawai (NIK, Nama_pegawai, Umur)
VALUES ('1111222233334444', 'Maimunah', '25');

--7. Lakukan update ID customer “CTRo04” menjadi “CTR004”
--update modul 2, lakukan dgn insert data CTR004 dgn nama cust sama
--lalu lakukan update masing2 tabel (CTRo04 cm ada di cust ama transaksi, 
--updat di trans aja), dan DELETE data CTRo04 di cust
INSERT INTO Customer VALUES ('CTR004', 'Sutris Ten An');

UPDATE Transaksi
SET Customer_ID_customer = 'CTR004'
WHERE Customer_ID_customer = 'CTRo04';

DELETE FROM Customer
WHERE ID_customer = 'CTRo04';


--8. Setelah bekerja, baru diketahui bahwa Maimunah adalah seorang 
--perempuan, nomor telepon 621234567, dan memiliki email 
--maimunah@gmail.com, lakukan update data dengan keterangan ini.
UPDATE Pegawai
SET Jenis_kelamin = 'P', Email = 'maimunah@gmail.com', nomor_telepon = '621234567'
WHERE NIK = '1111222233334444';

--9. Total_poin pada membership akan direset menjadi 0 ketika awal bulan, 
--kini telah memasuki bulan Desember 2023, maka update semua total 
--poin dari membership dengan tanggal kedaluwarsa sebelum bulan Desember
UPDATE Membership
SET total_poin = '0'
WHERE tanggal_kedaluawarsa_kartu_membership < '2023/12/01'; 

--10. Mbak Nuri ingin menghapus semua data membership
DELETE FROM Membership;

--11. Hapus data pegawai dengan nama Maimunah
DELETE FROM Pegawai WHERE NIK = '1111222233334444';
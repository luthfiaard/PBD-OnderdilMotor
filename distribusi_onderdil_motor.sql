-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Jul 2024 pada 20.10
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `distribusi_onderdil_motor`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `menambah_stok` (IN `productId` INT, IN `amount` INT)   BEGIN
    DECLARE currentStock INT;
    
    SELECT stok INTO currentStock
    FROM produk
    WHERE id_produk = productId;
    
    IF currentStock IS NOT NULL THEN
        UPDATE produk
        SET stok = stok + amount
        WHERE id_produk = productId;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produk tidak ditemukan';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MenampilkanStokProdukRendah` ()   BEGIN
    SELECT id_produk, kode_produk, nama_produk, stok
    FROM produk
    WHERE stok < 5;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `cari_produk_by_kategori` (`kategori_id` INT, `nama_produk` VARCHAR(50)) RETURNS INT(11)  BEGIN
    DECLARE jumlah_produk INT;
    SELECT COUNT(*) INTO jumlah_produk FROM produk
    INNER JOIN produk_kategori ON produk.id_produk = produk_kategori.id_produk
    WHERE produk_kategori.id_kategori = kategori_id AND produk.nama_produk = nama_produk;
    RETURN jumlah_produk;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_penjualan` () RETURNS INT(11)  BEGIN
    DECLARE total_penjualan INT;
    SELECT COUNT(*) INTO total_penjualan FROM pembelian;
    RETURN total_penjualan;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `customer`
--

CREATE TABLE `customer` (
  `id_customer` int(11) NOT NULL,
  `nama_customer` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `telepon` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `customer`
--

INSERT INTO `customer` (`id_customer`, `nama_customer`, `alamat`, `telepon`, `email`) VALUES
(1, 'Aveline', 'Kalasan', '08123456789', 'aveline445@gmail.com'),
(2, 'Arassy', 'Bantul', '08214589532', 'arassy.12@gmail.com'),
(3, 'Desfaka', 'Maguwoharjo', '089734214653', 'desfa.ka@gmail.com'),
(4, 'Emaria Eka', 'Gunung Kidul', '085678321587', 'mariaeka@gmail.com'),
(5, 'Denanda', 'Babarsari', '087456329653', 'denanda44@gmail.com'),
(6, 'Evander Lysander', 'Magelang', '082478321693', 'evanderlys@gmail.com'),
(7, 'Ciel Elodie', 'Solo', '081567843675', 'ciel.elo@gmail.com'),
(8, 'Lysander Leigh', 'Sleman', '087734569376', 'lysanderle@gmail.com'),
(9, 'Orion Ashford', 'Condongcatur', '081538767376', 'ash.orion@gmail.com'),
(10, 'Calliope Arden', 'Depok', '087451318561', 'calliopearden'),
(11, 'Aveline', 'Kalasan', '08123456789', 'aveline445@gmail.com'),
(12, 'Arassy', 'Bantul', '08214589532', 'arassy.12@gmail,com'),
(13, 'Desfaka', 'Maguwoharjo', '089734214653', 'desfa.ka@gmail.com'),
(14, 'Emaria Eka', 'Gunung Kidul', '085678321587', 'maraiaeka@gmail.com'),
(15, 'Denanda', 'Babarsari', '087456329653', 'denanda44@gmail.com'),
(16, 'Evander Lysander', 'Magelang', '082478321693', 'evanderlys@gmail.com'),
(17, 'Ciel Elodie', 'Solo', '081567843675', 'ciel.elo@gmail.com'),
(18, 'Lysander Leigh', 'Sleman', '087734569376', 'lysanderle@gmail.com'),
(19, 'Orion Ashford', 'Condongcatur', '081538767376', 'ash.orion@gmail.com'),
(20, 'Calliope Arden', 'Depok', '087451318561', 'calliopearden@gmail.com');

-- --------------------------------------------------------

--
-- Struktur dari tabel `item_pembelian`
--

CREATE TABLE `item_pembelian` (
  `id_item_pembelian` int(11) NOT NULL,
  `id_pembelian` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `item_pembelian`
--

INSERT INTO `item_pembelian` (`id_item_pembelian`, `id_pembelian`, `id_produk`, `jumlah`) VALUES
(1, 1, 10, 1),
(3, 3, 20, 2),
(4, 4, 2, 1),
(5, 5, 19, 2),
(6, 6, 9, 2),
(7, 7, 14, 1),
(8, 8, 16, 2),
(9, 9, 4, 1),
(10, 4, 12, 1);

--
-- Trigger `item_pembelian`
--
DELIMITER $$
CREATE TRIGGER `after_item_pembelian_delete` AFTER DELETE ON `item_pembelian` FOR EACH ROW BEGIN
    INSERT INTO log_item_pembelian (event, id_item_pembelian, id_pembelian, id_produk, jumlah, event_time)
    VALUES ('DELETE', OLD.id_item_pembelian, OLD.id_pembelian, OLD.id_produk, OLD.jumlah, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_item_pembelian_insert` AFTER INSERT ON `item_pembelian` FOR EACH ROW BEGIN
    INSERT INTO log_item_pembelian (event, id_item_pembelian, id_pembelian, id_produk, jumlah, event_time)
    VALUES ('INSERT', NEW.id_item_pembelian, NEW.id_pembelian, NEW.id_produk, NEW.jumlah, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_item_pembelian_update` AFTER UPDATE ON `item_pembelian` FOR EACH ROW BEGIN
    INSERT INTO log_item_pembelian (event, id_item_pembelian, id_pembelian, id_produk, jumlah, event_time)
    VALUES ('UPDATE', NEW.id_item_pembelian, NEW.id_pembelian, NEW.id_produk, NEW.jumlah, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`) VALUES
(1, 'Roda'),
(2, 'Transmisi'),
(3, 'Mesin'),
(4, 'Elektrik'),
(5, 'Suspensi'),
(6, 'Rem'),
(7, 'Body'),
(8, 'Aksesoris');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_item_pembelian`
--

CREATE TABLE `log_item_pembelian` (
  `id_log` int(11) NOT NULL,
  `event` varchar(50) NOT NULL,
  `id_item_pembelian` int(11) NOT NULL,
  `id_pembelian` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `event_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_item_pembelian`
--

INSERT INTO `log_item_pembelian` (`id_log`, `event`, `id_item_pembelian`, `id_pembelian`, `id_produk`, `jumlah`, `event_time`) VALUES
(1, 'INSERT', 10, 4, 12, 1, '2024-07-10 12:00:25'),
(2, 'UPDATE', 6, 6, 9, 2, '2024-07-10 12:10:23'),
(3, 'DELETE', 2, 2, 8, 1, '2024-07-10 12:17:31');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_produk`
--

CREATE TABLE `log_produk` (
  `id_log` int(11) NOT NULL,
  `event` varchar(50) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `kode_produk` varchar(50) DEFAULT NULL,
  `nama_produk` varchar(255) DEFAULT NULL,
  `event_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `old_harga_produk` decimal(10,2) DEFAULT NULL,
  `new_harga_produk` decimal(10,2) DEFAULT NULL,
  `old_stok` int(11) DEFAULT NULL,
  `new_stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_produk`
--

INSERT INTO `log_produk` (`id_log`, `event`, `id_produk`, `kode_produk`, `nama_produk`, `event_time`, `old_harga_produk`, `new_harga_produk`, `old_stok`, `new_stok`) VALUES
(2, 'INSERT', 23, 'SP03', 'Per Sok', '2024-07-10 07:29:57', NULL, 300000.00, NULL, 5),
(5, 'UPDATE', 15, 'R611', 'Kampas Rem', '2024-07-10 07:37:53', 100000.00, 120000.00, 10, 6),
(8, 'DELETE', 23, 'SP03', 'Per Sok', '2024-07-10 07:48:03', 300000.00, NULL, 5, NULL),
(9, 'UPDATE', 5, 'T011', 'Gearbox', '2024-07-10 13:50:30', 2000000.00, 2000000.00, 5, 7),
(10, 'UPDATE', 5, 'T011', 'Gearbox', '2024-07-10 13:51:00', 2000000.00, 2000000.00, 7, 9);

-- --------------------------------------------------------

--
-- Struktur dari tabel `nota_pembelian`
--

CREATE TABLE `nota_pembelian` (
  `id_nota` int(11) NOT NULL,
  `id_pembelian` int(11) NOT NULL,
  `tanggal_pembayaran` date NOT NULL,
  `total_pembayaran` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `nota_pembelian`
--

INSERT INTO `nota_pembelian` (`id_nota`, `id_pembelian`, `tanggal_pembayaran`, `total_pembayaran`) VALUES
(1, 1, '2024-07-07', 500000.00),
(2, 2, '2024-07-09', 500000.00),
(3, 3, '2024-07-10', 200000.00),
(4, 4, '2024-07-08', 1000000.00),
(5, 5, '2024-07-09', 300000.00),
(6, 6, '2024-07-07', 250000.00),
(7, 7, '2024-07-08', 400000.00),
(8, 8, '2024-07-10', 700000.00),
(9, 9, '2024-07-08', 300000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembelian`
--

CREATE TABLE `pembelian` (
  `id_pembelian` int(11) NOT NULL,
  `id_customer` int(11) NOT NULL,
  `tanggal_pembelian` date NOT NULL,
  `total_harga` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pembelian`
--

INSERT INTO `pembelian` (`id_pembelian`, `id_customer`, `tanggal_pembelian`, `total_harga`) VALUES
(1, 3, '2024-07-05', 500000.00),
(2, 5, '2024-07-07', 500000.00),
(3, 1, '2024-07-08', 200000.00),
(4, 2, '2024-07-06', 1000000.00),
(5, 4, '2024-07-07', 300000.00),
(6, 8, '2024-07-05', 250000.00),
(7, 10, '2024-07-06', 400000.00),
(8, 7, '2024-07-08', 700000.00),
(9, 9, '2024-07-06', 300000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `kode_produk` varchar(20) NOT NULL,
  `nama_produk` varchar(50) NOT NULL,
  `harga_produk` decimal(10,2) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id_produk`, `kode_produk`, `nama_produk`, `harga_produk`, `stok`) VALUES
(2, 'SR11', 'Velg', 1000000.00, 5),
(4, 'SR22', 'Ban', 300000.00, 10),
(5, 'T011', 'Gearbox', 2000000.00, 9),
(6, 'T112', 'Kopling', 700000.00, 6),
(7, 'T133', 'Rantai', 300000.00, 5),
(8, 'M511', 'Piston Kit', 500000.00, 4),
(9, 'M122', 'Ring Piston', 250000.00, 8),
(10, 'EK21', 'Aki', 500000.00, 3),
(11, 'EK22', 'Capacitor', 300000.00, 5),
(12, 'EK23', 'Busi', 50000.00, 12),
(13, 'SP01', 'Shockbreaker Depan', 500000.00, 6),
(14, 'SP02', 'Shockbreaker Belakang', 400000.00, 5),
(15, 'R611', 'Kampas Rem', 120000.00, 6),
(16, 'R612', 'Cakram', 350000.00, 7),
(17, 'B123', 'Spakbor', 200000.00, 9),
(18, 'B124', 'Cover Mesin', 300000.00, 4),
(19, 'AK81', 'Lampu LED', 150000.00, 12),
(20, 'AK82', 'Spion', 100000.00, 8),
(21, 'AK83', 'Box Bagasi', 600000.00, 4),
(22, 'B125', 'Fairing', 800000.00, 3),
(25, 'SP03', 'Per Sok', 300000.00, 5);

--
-- Trigger `produk`
--
DELIMITER $$
CREATE TRIGGER `before_produk_delete` BEFORE DELETE ON `produk` FOR EACH ROW BEGIN
    INSERT INTO log_produk (event, id_produk, kode_produk, nama_produk, event_time, old_harga_produk, old_stok)
    VALUES ('DELETE', OLD.id_produk, OLD.kode_produk, OLD.nama_produk, NOW(), OLD.harga_produk, OLD.stok);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_produk_insert` BEFORE INSERT ON `produk` FOR EACH ROW BEGIN
    INSERT INTO log_produk (event, id_produk, kode_produk, nama_produk, event_time, new_harga_produk, new_stok)
    VALUES ('INSERT', NEW.id_produk, NEW.kode_produk, NEW.nama_produk, NOW(), NEW.harga_produk, NEW.stok);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_produk_update` BEFORE UPDATE ON `produk` FOR EACH ROW BEGIN
    INSERT INTO log_produk (event, id_produk, kode_produk, nama_produk, event_time, old_harga_produk, new_harga_produk, old_stok, new_stok)
    VALUES ('UPDATE', OLD.id_produk, OLD.kode_produk, OLD.nama_produk, NOW(), OLD.harga_produk, NEW.harga_produk, OLD.stok, NEW.stok);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk_kategori`
--

CREATE TABLE `produk_kategori` (
  `id_produk_kategori` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk_kategori`
--

INSERT INTO `produk_kategori` (`id_produk_kategori`, `id_produk`, `id_kategori`) VALUES
(1, 2, 1),
(2, 4, 1),
(3, 5, 2),
(4, 6, 2),
(5, 7, 2),
(6, 8, 3),
(7, 9, 3),
(8, 10, 4),
(9, 11, 4),
(10, 12, 4),
(11, 13, 5),
(12, 14, 5),
(13, 15, 6),
(14, 16, 6),
(15, 17, 7),
(16, 18, 7),
(17, 19, 8),
(18, 20, 8),
(19, 21, 8),
(20, 22, 7);

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk_supplier`
--

CREATE TABLE `produk_supplier` (
  `id_produk_supplier` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `id_supplier` int(11) NOT NULL,
  `harga_beli` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk_supplier`
--

INSERT INTO `produk_supplier` (`id_produk_supplier`, `id_produk`, `id_supplier`, `harga_beli`) VALUES
(1, 2, 1, 940000.00),
(2, 4, 1, 250000.00),
(3, 5, 1, 1920000.00),
(4, 6, 1, 660000.00),
(5, 7, 1, 255000.00),
(6, 8, 2, 440000.00),
(7, 9, 2, 230000.00),
(8, 10, 2, 470000.00),
(9, 11, 2, 470000.00),
(10, 12, 2, 474000.00),
(11, 13, 3, 460000.00),
(12, 14, 3, 380000.00),
(13, 15, 3, 85000.00),
(14, 16, 3, 320000.00),
(15, 17, 4, 175000.00),
(16, 18, 4, 260000.00),
(17, 19, 4, 115000.00),
(18, 20, 4, 75000.00),
(19, 21, 5, 560000.00),
(20, 22, 5, 770000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` int(11) NOT NULL,
  `nama_supplier` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `no_telpon` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`, `alamat`, `no_telpon`, `email`) VALUES
(1, 'MotoSpare Hub', 'Jl. Magelang KM.9, Yogyakarta', '085798498698', 'motospare.hub@gmail.com'),
(2, 'RevGear Parts', 'Jl. Kesambi, Cirebon', '087987567743', 'rev.gear@gmail.com'),
(3, 'Nitro Motor', 'Jl. Jatisari Raya, Semarang', '081347675355', 'nitro.motor98@gmail.com'),
(4, 'SpeedySpare Supplies', 'Jl. Banteng Selatan, Jakarta Pusat', '089689486876', 'speedy.spare@gmail.com'),
(5, 'ProRide Supplies', 'Jl. Gatot Subroto, Bandung', '089867524312', 'proride.supplies@gmail.com');

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier_index`
--

CREATE TABLE `supplier_index` (
  `id_supplier` int(11) NOT NULL,
  `nama_supplier` varchar(255) NOT NULL,
  `alamat` text NOT NULL,
  `no_telepon` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_horizontal`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_horizontal` (
`id_produk` int(11)
,`nama_produk` varchar(50)
,`id_supplier` int(11)
,`nama_supplier` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_inside_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_inside_view` (
`id_customer` int(11)
,`nama_customer` varchar(50)
,`alamat` text
,`telepon` varchar(20)
,`email` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_vertical`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_vertical` (
`id` int(11)
,`nama` varchar(50)
,`alamat` mediumtext
,`telepon` varchar(20)
,`email` varchar(50)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `view_horizontal`
--
DROP TABLE IF EXISTS `view_horizontal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_horizontal`  AS SELECT `p`.`id_produk` AS `id_produk`, `p`.`nama_produk` AS `nama_produk`, `ps`.`id_supplier` AS `id_supplier`, `s`.`nama_supplier` AS `nama_supplier` FROM ((`produk` `p` join `produk_supplier` `ps` on(`p`.`id_produk` = `ps`.`id_produk`)) join `supplier` `s` on(`ps`.`id_supplier` = `s`.`id_supplier`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_inside_view`
--
DROP TABLE IF EXISTS `view_inside_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_inside_view`  AS SELECT `customer`.`id_customer` AS `id_customer`, `customer`.`nama_customer` AS `nama_customer`, `customer`.`alamat` AS `alamat`, `customer`.`telepon` AS `telepon`, `customer`.`email` AS `email` FROM `customer` WHERE `customer`.`telepon` like '081%' ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_vertical`
--
DROP TABLE IF EXISTS `view_vertical`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_vertical`  AS SELECT `supplier`.`id_supplier` AS `id`, `supplier`.`nama_supplier` AS `nama`, `supplier`.`alamat` AS `alamat`, `supplier`.`no_telpon` AS `telepon`, `supplier`.`email` AS `email` FROM `supplier`union all select `kategori`.`id_kategori` AS `id_kategori`,`kategori`.`nama_kategori` AS `nama_kategori`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL` from `kategori`  ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_customer`);

--
-- Indeks untuk tabel `item_pembelian`
--
ALTER TABLE `item_pembelian`
  ADD PRIMARY KEY (`id_item_pembelian`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `idx_item_pembelian` (`id_pembelian`,`id_produk`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `log_item_pembelian`
--
ALTER TABLE `log_item_pembelian`
  ADD PRIMARY KEY (`id_log`);

--
-- Indeks untuk tabel `log_produk`
--
ALTER TABLE `log_produk`
  ADD PRIMARY KEY (`id_log`);

--
-- Indeks untuk tabel `nota_pembelian`
--
ALTER TABLE `nota_pembelian`
  ADD PRIMARY KEY (`id_nota`),
  ADD KEY `id_pembelian` (`id_pembelian`);

--
-- Indeks untuk tabel `pembelian`
--
ALTER TABLE `pembelian`
  ADD PRIMARY KEY (`id_pembelian`),
  ADD KEY `id_customer` (`id_customer`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`);

--
-- Indeks untuk tabel `produk_kategori`
--
ALTER TABLE `produk_kategori`
  ADD PRIMARY KEY (`id_produk_kategori`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `produk_supplier`
--
ALTER TABLE `produk_supplier`
  ADD PRIMARY KEY (`id_produk_supplier`),
  ADD KEY `id_supplier` (`id_supplier`),
  ADD KEY `idx_produk_supplier` (`id_produk`,`id_supplier`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indeks untuk tabel `supplier_index`
--
ALTER TABLE `supplier_index`
  ADD PRIMARY KEY (`id_supplier`),
  ADD KEY `idx_supplier` (`nama_supplier`,`no_telepon`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `customer`
--
ALTER TABLE `customer`
  MODIFY `id_customer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `item_pembelian`
--
ALTER TABLE `item_pembelian`
  MODIFY `id_item_pembelian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `log_item_pembelian`
--
ALTER TABLE `log_item_pembelian`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `log_produk`
--
ALTER TABLE `log_produk`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `nota_pembelian`
--
ALTER TABLE `nota_pembelian`
  MODIFY `id_nota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `pembelian`
--
ALTER TABLE `pembelian`
  MODIFY `id_pembelian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT untuk tabel `produk_kategori`
--
ALTER TABLE `produk_kategori`
  MODIFY `id_produk_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `produk_supplier`
--
ALTER TABLE `produk_supplier`
  MODIFY `id_produk_supplier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id_supplier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `supplier_index`
--
ALTER TABLE `supplier_index`
  MODIFY `id_supplier` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `item_pembelian`
--
ALTER TABLE `item_pembelian`
  ADD CONSTRAINT `item_pembelian_ibfk_1` FOREIGN KEY (`id_pembelian`) REFERENCES `pembelian` (`id_pembelian`),
  ADD CONSTRAINT `item_pembelian_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Ketidakleluasaan untuk tabel `nota_pembelian`
--
ALTER TABLE `nota_pembelian`
  ADD CONSTRAINT `nota_pembelian_ibfk_1` FOREIGN KEY (`id_pembelian`) REFERENCES `pembelian` (`id_pembelian`);

--
-- Ketidakleluasaan untuk tabel `pembelian`
--
ALTER TABLE `pembelian`
  ADD CONSTRAINT `pembelian_ibfk_1` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`);

--
-- Ketidakleluasaan untuk tabel `produk_kategori`
--
ALTER TABLE `produk_kategori`
  ADD CONSTRAINT `produk_kategori_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`),
  ADD CONSTRAINT `produk_kategori_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `produk_supplier`
--
ALTER TABLE `produk_supplier`
  ADD CONSTRAINT `produk_supplier_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`),
  ADD CONSTRAINT `produk_supplier_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

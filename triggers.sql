CREATE TRIGGER `trig_master_jurnal_update_saldo_kas_bank_del`
AFTER
    DELETE ON `master_jurnal` FOR EACH ROW BEGIN DECLARE _CursorTestID INT DEFAULT 1;

DECLARE _RowCnt BIGINT DEFAULT 0;

IF EXISTS (
    SELECT
        *
    FROM
        (
            select
                OLD.id id,
                OLD.status status
        ) ref
        inner join detail_jurnal d on d.id_transaksi = ref.id
        and left (d.kode_akun, 4) in ('1111', '1112', '1113')
    where
        ref.`status` = 0
) THEN DROP TEMPORARY TABLE IF EXISTS tmp_daftar;

CREATE TEMPORARY TABLE tmp_daftar (
    id_tr INT AUTO_INCREMENT PRIMARY KEY,
    tanggal date,
    kode_akun varchar(50),
    total decimal(18, 2)
);

INSERT INTO
    tmp_daftar (tanggal, kode_akun, total)
select
    tanggal,
    kode_akun,
    sum(total) total
from
    (
        select
            OLD.tanggal tanggal,
            d.kode_akun,
            ifnull (sum(d.debet - d.kredit), 0) total
        from
            (
                select
                    OLD.id id,
                    OLD.tanggal,
                    OLD.status
            ) ref
            inner join detail_jurnal d on d.id_transaksi = ref.id
            and left (d.kode_akun, 4) in ('1111', '1112', '1113')
        where
            ref.`status` = 0
        group by
            ref.tanggal,
            d.kode_akun
    ) t
group by
    tanggal,
    kode_akun
order by
    tanggal,
    kode_akun;

SELECT
    COUNT(id_tr) into _RowCnt
FROM
    tmp_daftar;

WHILE _CursorTestID <= _RowCnt DO
update
    saldo_kas_bank s
    inner join tmp_daftar t on t.id_tr = _CursorTestID
    and t.kode_akun = s.kode_akun
    and s.tanggal > t.tanggal
set
    s.saldo_awal = s.saldo_awal + t.total;

SET
    _CursorTestID = _CursorTestID + 1;

END WHILE;

END IF;

END ---------------------------
CREATE TRIGGER `trig_master_jurnal_update_saldo_kas_bank_ins`
AFTER
INSERT
    ON `master_jurnal` FOR EACH ROW BEGIN DECLARE _CursorTestID INT DEFAULT 1;

DECLARE _RowCnt BIGINT DEFAULT 0;

IF EXISTS (
    SELECT
        *
    FROM
        (
            select
                NEW.id id,
                NEW.status status
        ) ref
        inner join detail_jurnal d on d.id_transaksi = ref.id
        and left (d.kode_akun, 4) in ('1111', '1112', '1113')
    where
        ref.`status` = 0
) THEN DROP TEMPORARY TABLE IF EXISTS tmp_daftar;

CREATE TEMPORARY TABLE tmp_daftar (
    id_tr INT AUTO_INCREMENT PRIMARY KEY,
    tanggal date,
    kode_akun varchar(50),
    total decimal(18, 2)
);

INSERT INTO
    tmp_daftar (tanggal, kode_akun, total)
select
    tanggal,
    kode_akun,
    sum(total) total
from
    (
        select
            NEW.tanggal tanggal,
            d.kode_akun,
            ifnull (sum(d.debet - d.kredit), 0) total
        from
            (
                select
                    NEW.id id,
                    NEW.tanggal,
                    NEW.status
            ) ref
            inner join detail_jurnal d on d.id_transaksi = ref.id
            and left (d.kode_akun, 4) in ('1111', '1112', '1113')
        where
            ref.`status` = 0
        group by
            ref.tanggal,
            d.kode_akun
    ) t
group by
    tanggal,
    kode_akun
order by
    tanggal,
    kode_akun;

SELECT
    COUNT(id_tr) into _RowCnt
FROM
    tmp_daftar;

WHILE _CursorTestID <= _RowCnt DO
update
    saldo_kas_bank s
    inner join tmp_daftar t on t.id_tr = _CursorTestID
    and t.kode_akun = s.kode_akun
    and s.tanggal > t.tanggal
set
    s.saldo_awal = s.saldo_awal + t.total;

SET
    _CursorTestID = _CursorTestID + 1;

END WHILE;

END IF;

END ---------------------------
CREATE TRIGGER `trig_master_jurnal_update_saldo_kas_bank_upd`
AFTER
UPDATE
    ON `master_jurnal` FOR EACH ROW BEGIN DECLARE _CursorTestID INT DEFAULT 1;

DECLARE _RowCnt BIGINT DEFAULT 0;

IF EXISTS (
    SELECT
        *
    FROM
        (
            select
                NEW.id id,
                NEW.status status
        ) ref
        inner join detail_jurnal d on d.id_transaksi = ref.id
        and left (d.kode_akun, 4) in ('1111', '1112', '1113')
    where
        ref.`status` = 0
)
OR EXISTS (
    SELECT
        *
    FROM
        (
            select
                OLD.id id,
                OLD.status status
        ) ref
        inner join detail_jurnal d on d.id_transaksi = ref.id
        and left (d.kode_akun, 4) in ('1111', '1112', '1113')
    where
        ref.`status` = 0
) THEN DROP TEMPORARY TABLE IF EXISTS tmp_daftar;

CREATE TEMPORARY TABLE tmp_daftar (
    id_tr INT AUTO_INCREMENT PRIMARY KEY,
    tanggal date,
    kode_akun varchar(50),
    total decimal(18, 2)
);

INSERT INTO
    tmp_daftar (tanggal, kode_akun, total)
select
    tanggal,
    kode_akun,
    sum(total) total
from
    (
        select
            NEW.tanggal tanggal,
            d.kode_akun,
            ifnull (sum(d.debet - d.kredit), 0) total
        from
            (
                select
                    NEW.id id,
                    NEW.tanggal,
                    NEW.status
            ) ref
            inner join detail_jurnal d on d.id_transaksi = ref.id
            and left (d.kode_akun, 4) in ('1111', '1112', '1113')
        where
            ref.`status` = 0
        group by
            ref.tanggal,
            d.kode_akun
        union
        all
        select
            OLD.tanggal tanggal,
            d.kode_akun,
            ifnull (sum(d.debet - d.kredit), 0) total
        from
            (
                select
                    OLD.id id,
                    OLD.tanggal,
                    OLD.status
            ) ref
            inner join detail_jurnal d on d.id_transaksi = ref.id
            and left (d.kode_akun, 4) in ('1111', '1112', '1113')
        where
            ref.`status` = 0
        group by
            ref.tanggal,
            d.kode_akun
    ) t
group by
    tanggal,
    kode_akun
order by
    tanggal,
    kode_akun;

SELECT
    COUNT(id_tr) into _RowCnt
FROM
    tmp_daftar;

WHILE _CursorTestID <= _RowCnt DO
update
    saldo_kas_bank s
    inner join tmp_daftar t on t.id_tr = _CursorTestID
    and t.kode_akun = s.kode_akun
    and s.tanggal > t.tanggal
set
    s.saldo_awal = s.saldo_awal + t.total;

SET
    _CursorTestID = _CursorTestID + 1;

END WHILE;

END IF;

END ---------------------------
CREATE TRIGGER `trig_detail_jurnal_update_saldo_kas_bank_del`
AFTER
    DELETE ON `detail_jurnal` FOR EACH ROW BEGIN DECLARE _CursorTestID INT DEFAULT 1;

DECLARE _RowCnt BIGINT DEFAULT 0;

IF EXISTS (
    SELECT
        *
    FROM
        master_jurnal m
        inner join (
            select
                OLD.id_transaksi id_transaksi,
                OLD.kode_akun kode_akun
        ) ref on ref.id_transaksi = m.id
        and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
    where
        m.`status` = 0
) THEN DROP TEMPORARY TABLE IF EXISTS tmp_daftar;

CREATE TEMPORARY TABLE tmp_daftar (
    id_tr INT AUTO_INCREMENT PRIMARY KEY,
    tanggal date,
    kode_akun varchar(50),
    total decimal(18, 2)
);

INSERT INTO
    tmp_daftar (tanggal, kode_akun, total)
select
    tanggal,
    kode_akun,
    sum(total) total
from
    (
        select
            m.tanggal tanggal,
            ref.kode_akun,
            ifnull (sum(ref.debet - ref.kredit), 0) total
        from
            master_jurnal m
            inner join (
                select
                    OLD.id_transaksi id_transaksi,
                    OLD.kode_akun kode_akun,
                    OLD.debet debet,
                    OLD.kredit kredit
            ) ref on ref.id_transaksi = m.id
            and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
        where
            m.`status` = 0
        group by
            m.tanggal,
            ref.kode_akun
    ) t
group by
    tanggal,
    kode_akun
order by
    tanggal,
    kode_akun;

SELECT
    COUNT(id_tr) into _RowCnt
FROM
    tmp_daftar;

WHILE _CursorTestID <= _RowCnt DO
update
    saldo_kas_bank s
    inner join tmp_daftar t on t.id_tr = _CursorTestID
    and t.kode_akun = s.kode_akun
    and s.tanggal > t.tanggal
set
    s.saldo_awal = s.saldo_awal + t.total;

SET
    _CursorTestID = _CursorTestID + 1;

END WHILE;

END IF;

END ---------------------------
CREATE TRIGGER `trig_detail_jurnal_update_saldo_kas_bank_ins`
AFTER
INSERT
    ON `detail_jurnal` FOR EACH ROW BEGIN DECLARE _CursorTestID INT DEFAULT 1;

DECLARE _RowCnt BIGINT DEFAULT 0;

IF EXISTS (
    SELECT
        *
    FROM
        master_jurnal m
        inner join (
            select
                NEW.id_transaksi id_transaksi,
                NEW.kode_akun kode_akun
        ) ref on ref.id_transaksi = m.id
        and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
    where
        m.`status` = 0
) THEN DROP TEMPORARY TABLE IF EXISTS tmp_daftar;

CREATE TEMPORARY TABLE tmp_daftar (
    id_tr INT AUTO_INCREMENT PRIMARY KEY,
    tanggal date,
    kode_akun varchar(50),
    total decimal(18, 2)
);

INSERT INTO
    tmp_daftar (tanggal, kode_akun, total)
select
    tanggal,
    kode_akun,
    sum(total) total
from
    (
        select
            m.tanggal tanggal,
            ref.kode_akun,
            ifnull (sum(ref.debet - ref.kredit), 0) total
        from
            master_jurnal m
            inner join (
                select
                    NEW.id_transaksi id_transaksi,
                    NEW.kode_akun kode_akun,
                    NEW.debet debet,
                    NEW.kredit kredit
            ) ref on ref.id_transaksi = m.id
            and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
        where
            m.`status` = 0
        group by
            m.tanggal,
            ref.kode_akun
    ) t
group by
    tanggal,
    kode_akun
order by
    tanggal,
    kode_akun;

SELECT
    COUNT(id_tr) into _RowCnt
FROM
    tmp_daftar;

WHILE _CursorTestID <= _RowCnt DO
update
    saldo_kas_bank s
    inner join tmp_daftar t on t.id_tr = _CursorTestID
    and t.kode_akun = s.kode_akun
    and s.tanggal > t.tanggal
set
    s.saldo_awal = s.saldo_awal + t.total;

SET
    _CursorTestID = _CursorTestID + 1;

END WHILE;

END IF;

END ---------------------------
CREATE TRIGGER `trig_detail_jurnal_update_saldo_kas_bank_upd`
AFTER
UPDATE
    ON `detail_jurnal` FOR EACH ROW BEGIN DECLARE _CursorTestID INT DEFAULT 1;

DECLARE _RowCnt BIGINT DEFAULT 0;

IF EXISTS (
    SELECT
        *
    FROM
        master_jurnal m
        inner join (
            select
                NEW.id_transaksi id_transaksi,
                NEW.kode_akun kode_akun
        ) ref on ref.id_transaksi = m.id
        and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
    where
        m.`status` = 0
)
OR EXISTS (
    SELECT
        *
    FROM
        master_jurnal m
        inner join (
            select
                OLD.id_transaksi id_transaksi,
                OLD.kode_akun kode_akun
        ) ref on ref.id_transaksi = m.id
        and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
    where
        m.`status` = 0
) THEN DROP TEMPORARY TABLE IF EXISTS tmp_daftar;

CREATE TEMPORARY TABLE tmp_daftar (
    id_tr INT AUTO_INCREMENT PRIMARY KEY,
    tanggal date,
    kode_akun varchar(50),
    total decimal(18, 2)
);

INSERT INTO
    tmp_daftar (tanggal, kode_akun, total)
select
    tanggal,
    kode_akun,
    sum(total) total
from
    (
        select
            m.tanggal tanggal,
            ref.kode_akun,
            ifnull (sum(ref.debet - ref.kredit), 0) total
        from
            master_jurnal m
            inner join (
                select
                    NEW.id_transaksi id_transaksi,
                    NEW.kode_akun kode_akun,
                    NEW.debet debet,
                    NEW.kredit kredit
            ) ref on ref.id_transaksi = m.id
            and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
        where
            m.`status` = 0
        group by
            m.tanggal,
            ref.kode_akun
        union
        all
        select
            m.tanggal tanggal,
            ref.kode_akun,
            ifnull (sum(ref.debet - ref.kredit), 0) total
        from
            master_jurnal m
            inner join (
                select
                    OLD.id_transaksi id_transaksi,
                    OLD.kode_akun kode_akun,
                    OLD.debet debet,
                    OLD.kredit kredit
            ) ref on ref.id_transaksi = m.id
            and left (ref.kode_akun, 4) in ('1111', '1112', '1113')
        where
            m.`status` = 0
        group by
            m.tanggal,
            ref.kode_akun
    ) t
group by
    tanggal,
    kode_akun
order by
    tanggal,
    kode_akun;

SELECT
    COUNT(id_tr) into _RowCnt
FROM
    tmp_daftar;

WHILE _CursorTestID <= _RowCnt DO
update
    saldo_kas_bank s
    inner join tmp_daftar t on t.id_tr = _CursorTestID
    and t.kode_akun = s.kode_akun
    and s.tanggal > t.tanggal
set
    s.saldo_awal = s.saldo_awal + t.total;

SET
    _CursorTestID = _CursorTestID + 1;

END WHILE;

END IF;

END ---------------------------
CREATE TRIGGER `PENJUALAN_UpdateStatusTerima`
AFTER
UPDATE
    ON `master_penerimaan` FOR EACH ROW BEGIN
update
    master_penjualan p
    inner join (
        select
            dp.id_penjualan id,
            sum(total + pajak) total
        from
            master_penjualan m
            inner join (
                select
                    id_penjualan,
                    ifnull(total, 0) total,
                    ifnull(pajak, 0) pajak
                from
                    detail_penjualan
            ) dp on dp.id_penjualan = m.id
        where
            m.status = 0
        group by
            dp.id_penjualan
    ) r on r.id = p.id
    left join (
        select
            m.id_pelunasan_uang_muka,
            sum(total + pajak) total_uang_muka
        from
            master_penjualan m
            inner join (
                select
                    id_penjualan,
                    ifnull(total, 0) total,
                    ifnull(pajak, 0) pajak
                from
                    detail_penjualan
            ) dp on dp.id_penjualan = m.id
        where
            m.status = 0
        group by
            m.id_pelunasan_uang_muka
    ) um on um.id_pelunasan_uang_muka = p.id
    left join (
        select
            dp.id_penjualan,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_penerimaan dp
            inner join (
                select
                    id,
                    status
                from
                    master_penerimaan
            ) mp on mp.id = dp.id_bayar
        where
            mp.status = 0
        group by
            dp.id_penjualan
    ) b on b.id_penjualan = r.id
set
    p.status_bayar = case
        when r.total <> 0
        and ifnull(b.total_dibayar, 0) = 0 then 0
        when (r.total - ifnull(um.total_uang_muka, 0)) > ifnull(b.total_dibayar, 0) then 1
        when (r.total - ifnull(um.total_uang_muka, 0)) = ifnull(b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
CREATE TRIGGER `Update_Status_Bayar_From_Master_Pembayaran`
AFTER
UPDATE
    ON `master_pembayaran` FOR EACH ROW BEGIN
update
    master_pengajuan p
    inner join (
        select
            id_pengajuan id,
            sum(total + pajak) - m.potongan total
        from
            master_pengajuan m
            inner join (
                select
                    id_pengajuan,
                    ifnull(total, 0) total,
                    ifnull(pajak, 0) pajak
                from
                    detail_rpv
                union
                all
                select
                    id_pengajuan,
                    ifnull(total, 0) total,
                    ifnull(pajak, 0) pajak
                from
                    detail_pengajuan
            ) dp on m.id = dp.id_pengajuan
        where
            m.status = 0
        group by
            id_pengajuan,
            m.potongan
    ) r on r.id = p.id
    left join (
        select
            dp.id_pembelian,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_pembayaran dp
            inner join (
                select
                    id,
                    status
                from
                    master_pembayaran
            ) mp on mp.id = dp.id_bayar
        where
            mp.status = 0
        group by
            dp.id_pembelian
    ) b on b.id_pembelian = r.id
set
    p.status_bayar = case
        when ifnull(b.total_dibayar, 0) = 0 then 0
        when r.total > ifnull(b.total_dibayar, 0) then 1
        when r.total = ifnull(b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
CREATE TRIGGER `Update_Status_Bayar_Del`
AFTER
    DELETE ON `detail_pembayaran` FOR EACH ROW BEGIN
update
    master_pengajuan p
    inner join (
        select
            dp.id_pengajuan id,
            sum(total + pajak) - m.potongan total
        from
            master_pengajuan m
            inner join (
                select
                    id_pengajuan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_rpv
                union
                all
                select
                    id_pengajuan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_pengajuan
            ) dp on dp.id_pengajuan = m.id
        where
            m.status = 0
        group by
            dp.id_pengajuan,
            m.potongan
    ) r on r.id = p.id
    inner join (
        select
            dp.id_pembelian,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_pembayaran dp
            inner join master_pembayaran mp on mp.id = dp.id_bayar
            inner join (
                select
                    id_pembelian
                from
                    (
                        select
                            ifnull (OLD.id_pembelian, 0) id_pembelian
                    ) a
                group by
                    id_pembelian
            ) ref on ref.id_pembelian = dp.id_pembelian
        where
            mp.status = 0
        group by
            dp.id_pembelian
    ) b on b.id_pembelian = r.id
set
    p.status_bayar = case
        when ifnull (b.total_dibayar, 0) = 0 then 0
        when r.total > ifnull (b.total_dibayar, 0) then 1
        when r.total = ifnull (b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
CREATE TRIGGER `Update_Status_Bayar_Ins`
AFTER
INSERT
    ON `detail_pembayaran` FOR EACH ROW BEGIN
update
    master_pengajuan p
    inner join (
        select
            dp.id_pengajuan id,
            sum(total + pajak) - m.potongan total
        from
            master_pengajuan m
            inner join (
                select
                    id_pengajuan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_rpv
                union
                all
                select
                    id_pengajuan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_pengajuan
            ) dp on dp.id_pengajuan = m.id
        where
            m.status = 0
        group by
            dp.id_pengajuan,
            m.potongan
    ) r on r.id = p.id
    inner join (
        select
            dp.id_pembelian,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_pembayaran dp
            inner join master_pembayaran mp on mp.id = dp.id_bayar
            inner join (
                select
                    id_pembelian
                from
                    (
                        select
                            ifnull (NEW.id_pembelian, 0) id_pembelian
                    ) a
                group by
                    id_pembelian
            ) ref on ref.id_pembelian = dp.id_pembelian
        where
            mp.status = 0
        group by
            dp.id_pembelian
    ) b on b.id_pembelian = r.id
set
    p.status_bayar = case
        when ifnull (b.total_dibayar, 0) = 0 then 0
        when r.total > ifnull (b.total_dibayar, 0) then 1
        when r.total = ifnull (b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
CREATE TRIGGER `Update_Status_Bayar_Upd`
AFTER
UPDATE
    ON `detail_pembayaran` FOR EACH ROW BEGIN
update
    master_pengajuan p
    inner join (
        select
            dp.id_pengajuan id,
            sum(total + pajak) - m.potongan total
        from
            master_pengajuan m
            inner join (
                select
                    id_pengajuan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_rpv
                union
                all
                select
                    id_pengajuan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_pengajuan
            ) dp on dp.id_pengajuan = m.id
        where
            m.status = 0
        group by
            dp.id_pengajuan,
            m.potongan
    ) r on r.id = p.id
    inner join (
        select
            dp.id_pembelian,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_pembayaran dp
            inner join master_pembayaran mp on mp.id = dp.id_bayar
            inner join (
                select
                    id_pembelian
                from
                    (
                        select
                            ifnull (NEW.id_pembelian, 0) id_pembelian
                        union
                        all
                        select
                            ifnull (OLD.id_pembelian, 0) id_pembelian
                    ) a
                group by
                    id_pembelian
            ) ref on ref.id_pembelian = dp.id_pembelian
        where
            mp.status = 0
        group by
            dp.id_pembelian
    ) b on b.id_pembelian = r.id
set
    p.status_bayar = case
        when ifnull (b.total_dibayar, 0) = 0 then 0
        when r.total > ifnull (b.total_dibayar, 0) then 1
        when r.total = ifnull (b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
---------------------------
CREATE TRIGGER `Update_Status_Terima_Del`
AFTER
    DELETE ON `detail_penerimaan` FOR EACH ROW BEGIN
update
    master_penjualan p
    inner join (
        select
            dp.id_penjualan id,
            sum(total + pajak) total
        from
            master_penjualan m
            inner join (
                select
                    id_penjualan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_penjualan
            ) dp on dp.id_penjualan = m.id
        where
            m.status = 0
        group by
            dp.id_penjualan
    ) r on r.id = p.id
    inner join (
        select
            dp.id_penjualan,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_penerimaan dp
            inner join master_penerimaan mp on mp.id = dp.id_bayar
            inner join (
                select
                    id_penjualan
                from
                    (
                        select
                            ifnull(OLD.id_penjualan, 0) id_penjualan
                    ) a
                group by
                    id_penjualan
            ) ref on ref.id_penjualan = dp.id_penjualan
        where
            mp.status = 0
        group by
            dp.id_penjualan
    ) b on b.id_penjualan = r.id
set
    p.status_bayar = case
        when ifnull (b.total_dibayar, 0) = 0 then 0
        when r.total > ifnull (b.total_dibayar, 0) then 1
        when r.total = ifnull (b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
CREATE TRIGGER `Update_Status_Terima_Ins`
AFTER
INSERT
    ON `detail_penerimaan` FOR EACH ROW BEGIN
update
    master_penjualan p
    inner join (
        select
            dp.id_penjualan id,
            sum(total + pajak) total
        from
            master_penjualan m
            inner join (
                select
                    id_penjualan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_penjualan
            ) dp on dp.id_penjualan = m.id
        where
            m.status = 0
        group by
            dp.id_penjualan
    ) r on r.id = p.id
    inner join (
        select
            dp.id_penjualan,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_penerimaan dp
            inner join master_penerimaan mp on mp.id = dp.id_bayar
            inner join (
                select
                    id_penjualan
                from
                    (
                        select
                            ifnull(NEW.id_penjualan, 0) id_penjualan
                    ) a
                group by
                    id_penjualan
            ) ref on ref.id_penjualan = dp.id_penjualan
        where
            mp.status = 0
        group by
            dp.id_penjualan
    ) b on b.id_penjualan = r.id
set
    p.status_bayar = case
        when ifnull (b.total_dibayar, 0) = 0 then 0
        when r.total > ifnull (b.total_dibayar, 0) then 1
        when r.total = ifnull (b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
CREATE TRIGGER `Update_Status_Terima_Upd`
AFTER
UPDATE
    ON `detail_penerimaan` FOR EACH ROW BEGIN
update
    master_penjualan p
    inner join (
        select
            dp.id_penjualan id,
            sum(total + pajak) total
        from
            master_penjualan m
            inner join (
                select
                    id_penjualan,
                    ifnull (total, 0) total,
                    ifnull (pajak, 0) pajak
                from
                    detail_penjualan
            ) dp on dp.id_penjualan = m.id
        where
            m.status = 0
        group by
            dp.id_penjualan
    ) r on r.id = p.id
    inner join (
        select
            dp.id_penjualan,
            sum(jumlah_dibayar) total_dibayar
        from
            detail_penerimaan dp
            inner join master_penerimaan mp on mp.id = dp.id_bayar
            inner join (
                select
                    id_penjualan
                from
                    (
                        select
                            ifnull(NEW.id_penjualan, 0) id_penjualan
                        union
                        all
                        select
                            ifnull(OLD.id_penjualan, 0) id_penjualan
                    ) a
                group by
                    id_penjualan
            ) ref on ref.id_penjualan = dp.id_penjualan
        where
            mp.status = 0
        group by
            dp.id_penjualan
    ) b on b.id_penjualan = r.id
set
    p.status_bayar = case
        when ifnull (b.total_dibayar, 0) = 0 then 0
        when r.total > ifnull (b.total_dibayar, 0) then 1
        when r.total = ifnull (b.total_dibayar, 0) then 2
        else 9
    end;

END ---------------------------
---------------------------
CREATE TRIGGER `trig_akses_unit_ins`
AFTER
INSERT
    ON `master_users` FOR EACH ROW BEGIN declare _listunit varchar(500);

declare _jlm_unit int;

declare _awal_unit int;

SELECT
    unit INTO _listunit
FROM
    master_users
WHERE
    username = NEW.username;

SET
    _jlm_unit = IF(
        LENGTH(_listunit) > 0,
        LENGTH(_listunit) - LENGTH(REPLACE(_listunit, ',', '')) + 1,
        0
    );

SET
    _awal_unit = 1;

IF (_jlm_unit > 0) THEN
DELETE FROM
    akses
where
    id_user = NEW.id;

WHILE _awal_unit <= _jlm_unit DO
insert into
    akses(id_user, unit)
select
    NEW.id,
    (
        SELECT
            REPLACE(
                SUBSTRING_INDEX(SUBSTRING_INDEX(unit, ',', _awal_unit), ',', -1),
                '',
                ''
            )
        from
            master_users u
        where
            u.username = NEW.username
    );

set
    _awal_unit = _awal_unit + 1;

END WHILE;

END IF;

END ---------------------------
CREATE TRIGGER `trig_akses_unit_upd`
AFTER
UPDATE
    ON `master_users` FOR EACH ROW BEGIN declare _listunit varchar(500);

declare _jlm_unit int;

declare _awal_unit int;

SELECT
    unit INTO _listunit
FROM
    master_users
WHERE
    username = NEW.username;

SET
    _jlm_unit = IF(
        LENGTH(_listunit) > 0,
        LENGTH(_listunit) - LENGTH(REPLACE(_listunit, ',', '')) + 1,
        0
    );

SET
    _awal_unit = 1;

IF (_jlm_unit > 0) THEN
DELETE FROM
    akses
where
    id_user = NEW.id;

WHILE _awal_unit <= _jlm_unit DO
insert into
    akses(id_user, unit)
select
    NEW.id,
    (
        SELECT
            REPLACE(
                SUBSTRING_INDEX(SUBSTRING_INDEX(unit, ',', _awal_unit), ',', -1),
                '',
                ''
            )
        from
            master_users u
        where
            u.username = NEW.username
    );

set
    _awal_unit = _awal_unit + 1;

END WHILE;

END IF;

END ---------------------------
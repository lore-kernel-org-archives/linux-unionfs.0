Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021073.outbound.protection.outlook.com [52.101.70.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F3D37C0EB;
	Tue, 23 Jun 2026 11:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213350; cv=fail; b=VWthTmUE/EZFCtGBJh7+gIBktAcKmerb5srYuwzoJe6EEnh2b7qN2L88yQOcbz+VAeqJ5cYMHTiJdl1b3lzpa9id0zX79U/TVx5/m2cqt9oYK2A5D3QgoZP9Wn+RV3kMaVevproWOpKRUCRFjqIZLdSK+6YYu4U7e2eGSqww+BM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213350; c=relaxed/simple;
	bh=cj9i/7k3guR8DFCHaAf0nPHy3aknHqiur6p0DtJ3ZdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FJuTSSNpOV6g5DDx5GASp96GqK7R2D3X8PDgnRcMW6QCNeGH/LRQdzKot72+utwy7FsMfxmlDBh2AnIrYMJeDaNPbcQfFdxe6vn9KXLGAtWL71rowypUeYKyq5eXKaQZ0to9HxZZof1+UHb9+lNhCAbT8OpTM/JCOUa7TaO5n/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=fvkY6RXT; arc=fail smtp.client-ip=52.101.70.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="fvkY6RXT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W32d+4DkLvtHgY2ANaRwvw1bx9p1dqm2vj85OpJYUh6ieeH6WMZZynoS866UpX9gUzSw5ENXfGLUeX1OXuIXEbUWS/r7/kgE574/09rviz7hQIh1gJGNUNo15IXnmwu3ejFJAuHmvawiErgv7mTrMR2NMkgxYDRDkZ8wn0o0DG4TnOXMdo/6xEdLqpZB2ys1Y5y4J/9r8id7DrB/MeRifj9/kuAnbTW/vo/NuicemYOazOspASgCTDh+wQKG6RdLyQwE08pnBu1FJhUHovt1bypQtVoLYBhTL+TluIuiwBYNA9T7BvND420E/a9ACWqpkz7m4IlvmIXRK5lLjKJQcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNL6kNdFYHyJdxmGG3JO4sSEoVfEqMl/8XnSCknIBys=;
 b=Z1d/dLDfy1WONHW5BClpAVJQ9YYUE7PoLDFL9FmsslM/Kn1FZcjLmI/bddz5E2+b4JTEUFUzVFLAVLdPYYU9xv1IaNBr9Zc+2akfwO+tF7+b6Au83VRWXUvKHYIGW7Iy7WYSbu2bDE6N6t17sK8itiZ5c3XTuWx9XavQH7wR9rF9Ef1HoEbNMOW2eDQX+5+58mhzmgHI//UwwDyR/Q5TYP2R+Q1wHEGGEIFe6JfVCuYaHoLzjNMDlCLz2Wh4wRmwgVp+HTheLe3wZJmOIhB+XJCkvjKMNkfT0ALsRizWsWKH1waasmj6ZNXFOLjbHfJbQw/5w4jwrFAyMMv6QvDV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNL6kNdFYHyJdxmGG3JO4sSEoVfEqMl/8XnSCknIBys=;
 b=fvkY6RXT5zxfd9HHYlrSzh/ErgmpV7s/3teD4RxEM0HhvY0fJtbKUEVJ5gRpDV66H/IO3j138SSUO7p5onAHyz4O+VMh9NMhaKnLGZhZ6O93/plquqSnhTTlXvXM7j82GeslZbmYm/Wm2OUjljM2ThnQLLkMEasd53vQhxPJ465dehSPanj/0JcScWokEAgnEzMadB2BPadNVxo3kKvXHwRpAKNfu93Z8Zv4u03dWUAPmPW4MazWgcr3+5MgnJ72ow3IeECY/5XfXCOek0KYVBU5aJeBTlLUmhQEBo6/icp2XGQMEsuw8SJ8Z8SeDnxx9kSqESDf/BqxYNbwyq9rkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14) by AS2PR08MB9974.eurprd08.prod.outlook.com
 (2603:10a6:20b:643::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 11:15:44 +0000
Received: from AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a]) by AM0PR08MB11804.eurprd08.prod.outlook.com
 ([fe80::bf46:f137:f6d2:5b3a%6]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 11:15:44 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH 1/3] fs, mm: add ->cachestat() file operation
Date: Tue, 23 Jun 2026 13:14:48 +0200
Message-ID: <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::12) To AM0PR08MB11804.eurprd08.prod.outlook.com
 (2603:10a6:20b:747::14)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR08MB11804:EE_|AS2PR08MB9974:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e219f8f-84ec-4c59-1cb2-08ded118c4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|10070799003|366016|376014|7416014|52116014|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UOUviKdFgvEojmaCAeJfMvKK9ajEjQoOY6fK38knpK08E3MHpt9lxEo0Y/ZLpxTiBYiHQta/ZtNMezFXGiCk6D+3h6okhYYb80xgle14ONk1VJff046kT2Tt/7nTTE/gusQZofO4q9NRwXE323J/ubTsQq+iq8uFdfKubizvwUwzia3NF5EdiLgK6xuggqIvc5FSgPlJUCWgbO1L8hEqgRVEy8IPGeKnkmZlkSJDgIc2st4AS6bK+HuPG6RCDkI5UNlhEznSEQec50SELW457XcbnMbtawWZi3wex3godZbNyK8ZcPsH8FMkZ/L+PrzlizXobqMXD8yUuokVuMjLYIVdg83jJe/39cQ9JONh9DBpK4HJDvtLOxI3WEQ/6OtwN342Nm3x5U+Ac6tkXUaWX6YbjB/+YExlh9g84DKA2J/5CqhoDDYLwgSZZGhweF5KJfwCL+XuOCD4SNlQOKOcE0u1MqesNAH0Y1IDJ17IEkEJO8nrJHdGEX31G2g31GH5JY5YQPzYCqX7CxT629ZDjdJ97S2dcV6cKezf2KLekgMyjGbf5+Q3dWJ6GvLhyrEASx61QBIHfVK7cR2YsEbWSEYPYJeiAFMz67DAST6qkn0w2a4r2ar5rAjpGXooSWHoUlf3gBovnk9/R7Ta38SVOji4SBqADiOKn1DU+ZbagRI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11804.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(10070799003)(366016)(376014)(7416014)(52116014)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7rWtnG3Kc1PZwEuTXJzRE7mk+LLHDRaurvVJHqaiTxNy6Y+932nlZMxIBpQf?=
 =?us-ascii?Q?oHX5GYzseAjpJudQ8yGjZpjR6j+UPm6DKIZUPrmw/qx6EGgSreiTVFH2tsAl?=
 =?us-ascii?Q?T2moIAU7Qtezr2FUs0yZhtSKK2nIUirsaTzAIkBMdJdjlMY2RkJNWLHZcWGr?=
 =?us-ascii?Q?sJWjIQXXyauu+65racOxBrY/96FN03HKttgYVaO8Lc0QSMB3kePb1cAHxoNJ?=
 =?us-ascii?Q?Kb3I3zActb+uYYrwJbbQQ5WKxQU+ZM8i9EIehELIeWw4I0JKxfzV19QyGN32?=
 =?us-ascii?Q?Ho9GKnqQrnYoL8zhE1opY/M5iW658mkplwi0YxlneZux/xo4R7p4CGfDJfSd?=
 =?us-ascii?Q?43T0fuI2qIK6eSMSuiYr8/hj7pWaAGGgkcP+g5yK0hRqLltxfk8ghkFD3Wn2?=
 =?us-ascii?Q?fCfMe2IudxYscRKHOaz/WHEE2WEeIbfJdW+CJW2O5HSXrOzT8UT4Ix7viYM/?=
 =?us-ascii?Q?f+NYYCqKF8rkJXSsWRRFMkuyIPSp+kscMsZVolrUX16tJyn8L9z7zuj5wqOD?=
 =?us-ascii?Q?4qghOCtDT5/lX8szjOqS4sjVAZJ6gsO5p3RuhuTgs3Dn0HQpN4QUDl//8vBD?=
 =?us-ascii?Q?H+VBWmHcaWL1BoZKRvptNU9U69UJ+kW4WKUlOSEOOfUhXPLdnYynLzToVmh4?=
 =?us-ascii?Q?FtbwHETIqJp5t3mwdQrPcrKaJfT7pmyK1eySRqguoGbqw9Wh96c7Fsjf/ZiM?=
 =?us-ascii?Q?7yJFkKVosXOBt8CZEmpadXKNFjhCujMP1Y0htgBHNxgDremkWc++ibVOgdm8?=
 =?us-ascii?Q?c3VASGnTu8faRr/CfyFozfVPxP40zVpH/3g13rTw2LLH7hADlncUl3uIMWwh?=
 =?us-ascii?Q?sjpVRodWKXeUCidh2SddyuxQewYyT75oJZr44csGGclxIj2MMFFzlc4F3dsY?=
 =?us-ascii?Q?Tk3BsPPC1qmRn1zGwCkWp1oEs7VOjO5x/IqujXHBummip3z6szwwGgpA3OEJ?=
 =?us-ascii?Q?ZZ6P2+Dyz9nepfEGuDuqHfBzfoT7hhIGYZ610HS3B+pEfSpqSebU2ByCLrQW?=
 =?us-ascii?Q?t6qSQlYHtELPu4a1g3SrxPG5ZPu7Iil1ssY05VN6upLtxLdp8ClseQxzeNUj?=
 =?us-ascii?Q?tZdN3jSi64BP8bTJiZqyQ8e4iLLdoaVYAlZw3OIDQDkWB7YxZ6Qr9M3ewVvH?=
 =?us-ascii?Q?1+ge7sxa+PFbdSHq29S1sk+1Qd6YN7J4UjJJ0lOEw2Hw+E+Maenis3cTVmfB?=
 =?us-ascii?Q?D6Cf1w8EKvtutzHq8RPuiAVfC9MqufCt2xV1kn2C/2E9OfypPv3/2yYZnFdZ?=
 =?us-ascii?Q?/LPI8vOpSLmro8m5VFOgJ4FE68UTtsOluTtQnNXqbbHTeJgS0i17S4GGpX7N?=
 =?us-ascii?Q?+cbFnJ6w950Z1tHGKflo5Eu3Amwq2mFr83bdnrSiujPP6pGK/B1mzAaMPehh?=
 =?us-ascii?Q?/qDy1EeNNt2rXs4sj9TM6W4G55GxSzQ27KvhIlnTlbV4sN6FepQrsOdTb0FA?=
 =?us-ascii?Q?xj+E0iiN4NkmSzF18xHQRarIiP4a8v8gRTIfTfDqBFJ9O8CUVyzk+RMTRamh?=
 =?us-ascii?Q?g6N8d5ynkUSYeVkHF5QUbZjyMEjh3HjKA90ZPR8vBf8XYqmo9DgFJRj+DtqP?=
 =?us-ascii?Q?KsXUnT78eOxA2UdDL+VvmyXTItP6Toz8TFDTUfKg9sAMI708krBCY00h7upK?=
 =?us-ascii?Q?e7y8hTiboH7Rs37BaDra9fwIfQrwutdj3t5MTfc4MWf8fKRSioXo2DFqM+Cp?=
 =?us-ascii?Q?iapWVy1fZxvpTYBR4YXFs6puM2GOqRhTTkk0QxM3UAZ14eZYrafcEC7ePXfG?=
 =?us-ascii?Q?4XHIQL8fs/ecOuzxSRHbRPo2DjxmYPaWa0c4WNbWdYEbXXsAyR3dLNfywgjS?=
X-MS-Exchange-AntiSpam-MessageData-1: A4kQOLtw+UFmdiFuM8k3V0d1HmtgkMz3irU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e219f8f-84ec-4c59-1cb2-08ded118c4d4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB11804.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 11:15:44.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MMft/Cd4YgrD29zlTfGXEfKzya0UVwYW1TYaoNMY1asZV3xQd169rBcZyT8L0kqvkoQTnzaTcnSOvJ6ax/VITEM5/9iLiSPAWZhnVvM+Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9974

The cachestat() syscall reads page cache statistics straight from the
file's f_mapping. Stackable filesystems such as overlayfs keep the data
pages in an underlying inode's mapping rather than in the overlay
inode's, so cachestat() reports all zeroes for them.

Add a ->cachestat() file operation and route the syscall through a new
vfs_cachestat() helper that calls it when present, falling back to
file's f_mapping otherwise. This lets stackable filesystems forward the
query to the file that actually owns the page cache. No behaviour change
for regular files.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
Note: Memset change might be a bit tricky, I moved it to no
->cachestat() path to avoid multiple memset on nested overlayfs, that
means that ->cachestat() is expected to be able to handle unitialized
cs.
---
 include/linux/fs.h | 10 ++++++++++
 mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6da44573ce450..966b6564707e4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -53,6 +53,8 @@
 
 struct bdi_writeback;
 struct bio;
+struct cachestat_range;
+struct cachestat;
 struct io_comp_batch;
 struct fiemap_extent_info;
 struct kiocb;
@@ -1963,6 +1965,8 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	int (*cachestat)(struct file *file, struct cachestat_range *csr,
+			 struct cachestat *cs);
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
@@ -3633,6 +3637,12 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+/* mm/filemap.c */
+#ifdef CONFIG_CACHESTAT_SYSCALL
+int vfs_cachestat(struct file *file, struct cachestat_range *csr,
+		  struct cachestat *cs);
+#endif
+
 static inline bool vfs_empty_path(int dfd, const char __user *path)
 {
 	char c;
diff --git a/mm/filemap.c b/mm/filemap.c
index 7e467c81d2138..90608c6b1ce55 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4714,6 +4714,37 @@ static inline bool can_do_cachestat(struct file *f)
 	return file_permission(f, MAY_WRITE) == 0;
 }
 
+/**
+ * vfs_cachestat() - query page cache statistics of a file
+ * @file:	file to query
+ * @csr:	byte range to query
+ * @cs:		output statistics
+ *
+ * Compute the page cache statistics for the given byte range of @file.
+ *
+ * Stackable filesystems (e.g. overlayfs) keep the data pages in the
+ * mapping of an underlying file rather than in @file->f_mapping. Such
+ * filesystems provide a ->cachestat() file operation that forwards the
+ * query to the file that actually owns the page cache; otherwise the
+ * statistics are computed from @file->f_mapping directly.
+ */
+int vfs_cachestat(struct file *file, struct cachestat_range *csr,
+		  struct cachestat *cs)
+{
+	pgoff_t first_index, last_index;
+
+	if (file->f_op->cachestat)
+		return file->f_op->cachestat(file, csr, cs);
+
+	first_index = csr->off >> PAGE_SHIFT;
+	last_index =
+		csr->len == 0 ? ULONG_MAX : (csr->off + csr->len - 1) >> PAGE_SHIFT;
+	memset(cs, 0, sizeof(struct cachestat));
+	filemap_cachestat(file->f_mapping, first_index, last_index, cs);
+	return 0;
+}
+EXPORT_SYMBOL(vfs_cachestat);
+
 /*
  * The cachestat(2) system call.
  *
@@ -4753,10 +4784,9 @@ SYSCALL_DEFINE4(cachestat, unsigned int, fd,
 		struct cachestat __user *, cstat, unsigned int, flags)
 {
 	CLASS(fd, f)(fd);
-	struct address_space *mapping;
 	struct cachestat_range csr;
 	struct cachestat cs;
-	pgoff_t first_index, last_index;
+	int ret;
 
 	if (fd_empty(f))
 		return -EBADF;
@@ -4775,12 +4805,9 @@ SYSCALL_DEFINE4(cachestat, unsigned int, fd,
 	if (flags != 0)
 		return -EINVAL;
 
-	first_index = csr.off >> PAGE_SHIFT;
-	last_index =
-		csr.len == 0 ? ULONG_MAX : (csr.off + csr.len - 1) >> PAGE_SHIFT;
-	memset(&cs, 0, sizeof(struct cachestat));
-	mapping = fd_file(f)->f_mapping;
-	filemap_cachestat(mapping, first_index, last_index, &cs);
+	ret = vfs_cachestat(fd_file(f), &csr, &cs);
+	if (ret)
+		return ret;
 
 	if (copy_to_user(cstat, &cs, sizeof(struct cachestat)))
 		return -EFAULT;
-- 
2.54.0


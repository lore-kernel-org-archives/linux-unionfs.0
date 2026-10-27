Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135393;
	b=V/6+A6couZ4yJreeqaK7OU+SRCzhWIcWdIB0A5U/RDJBhZlqA6pbN3uVMZPQl7oPfMj9
	 0zkK53s8eCNo8+bpxksat3Wmxu2WEuXdZcfHG7g2hrAPq+kY5Tu8gqTHLOpHV9fbgCr/R
	 jhOzfYMkAuiy3os0412n+/DfX2kNCwQqSP/qpGSynT4XGBupfi13BiX9J6d7/0LZeQSEF
	 O/LVq3mATzGQT5V71mbk+IDeLaPRYXWp9xohyjztMZh9vme2KSkxAym/ZgYCtYlA6fGt8
	 4ZBLNGc/+PhciNF5dtT5/TdejTgwNh/AtCooYcn6YZ1m1ur6kXc8610WdsgGZfTmulA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
	b=IVIGOUkIQvtI4wFWyTlBU8msSkhBwC4v/qsuPWKZQ0G+gDKu7p4jitXdU4FMgUVMgJ9O
	 6b0EOtO5phMeWWW6b+6Rx6MXrPOzKelOue8cVXPn8AqLNltoQ/v8kIbEWXASNPw+fdHPv
	 mtKpaIjMnFFT3fwfd4C34pN4Zb3x6E6ERtcQLeqPbKtF8e25Ow0lTyixQPJEG2e8BGarz
	 EW+GGVbwQHyiK8IrWk9TE3RLvMBuOgXtUHggF8Qke8Pl6CDp3AGMdLzTQaABTnUtCAcS2
	 VAUNkf9FBaPaTnFdc8wvaIFDUAZsG2plUIKBNmgAh1Q8DVZY45MFJ8Ns2JRWTpbjqBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=FQHSQ1Xj;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B3D606A330
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85B3D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=FQHSQ1Xj
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-930c0f9c1b1so20519085a.1
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135386; x=1793740186; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
        b=FQHSQ1Xjob3WHhUaX3x82quOmbvHijcNo87LcLe3hU66UzYG7bmQwI85uzpWaWJupm
         KykqsDzMCN6X2n23+/flDGS6Gspdiaa5tT+DP+M0411w7Eendt5bGh5d1Z3u8wgc0VW4
         NnO1tcD7gy9x94obfitEPTCsxXkZWuxozR1KbYqMaiO++B8nwmaqeBZkDthLx5WJmtAe
         5F49sYgLIG9zMONMcysfC6D9lMML1dymiQwjT7EVKAjPgB+nHNpESM8ljHUNbr2h3Cp5
         +w5xWRdb0LP5CXtBDP5U2nb+mIXEzN5tPXWQhnELmIZ2JM11s+TUoSzPlfWzOtvusXjo
         fcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135386; x=1793740186;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
        b=IUMm19irRXL+ahSfkBQTBCfLFIeZ5XPtHm/SMwLy8T8DuU7CN41dsPr/tEoqJgBVVQ
         7W2LzJK0RB7yXqPP10oCIP2LHp6xctJ+dPyhna5oCWXEUeBUfOHrobUEPlJnFie33QS9
         9D4yAbfnYx5E2U5b2uVUl6jvRbhhkn3uby2CH6nHJkruwrxNZ6sdQHc/79nGgwMGU+0l
         TPcbZyD7K+QBgg6q3GlDAivTScOrdVkH3DlRzTQ1MQ0VGlYhM4ktukBbxkC764FuEzpA
         H70jxIAtj9/LGDibWkapaj9nJs5/mcBOG/k+S1zHSQal8FZg/txqTrOr01XKtsOweAJi
         zxTg==
X-Forwarded-Encrypted: i=1; AKwUvBxCt2hjDnbrTxnIQCnG5k16dcBaDAA6aIddIAX8uCBN/2lp79t2CKmDxyz4J8BBA1HLas2vmpffZFSQqaLT@vger.kernel.org
X-Gm-Message-State: AFq9FYKIujuTdZ9trSVXDlpC3Yb9fE+AUyAkil1DM/U2fy+jWxnKn2tB
	xgeQI2U7b+pGgcc1dyrfS1hQ5CChuRYqbeP78JMMkVKtu21qrZZFWdobsTv7d9Ld7A4=
X-Gm-Gg: AYBFou3F2Uswr1pkCtE6fdngAZui0GOUzqu2C4r0ARfIAcYxlu7nr/2PemJXAumhPJ9
	sf8bXY7S3qATRxae4AnWS2deAlCrp3vH26Oz/tv6Csq7sAXj4upX8gBzc3jx5BveWJMu9oPegLP
	AC1/okYvtpLaIhuR7ybYf2AbsKy9CBpBh84aY/ZBOL8JGKzKfL12lqrFC2NBKt3pGJryqce9ObG
	BdaukaIDdvesK0cJ1RQhzSxLdF9Jo78eIfUNd/ufHbXCcWaEeQwhaDXq5mHOHiT6jCGXNwogq6r
	T4TEwJ2tTNGD91yUgxqVbLxTvSAqhv1a7xOIvJWhYyv8IlJ74eRve0y4J0XwKeEBZobxcesKyU2
	tmXfe2g38Bypw636hGYbzTN9qkCQh8y3NSMV7vnf7IxYVUVPCn61rJvaQG1kJul4g9SxQPC9uUl
	vkmUtfCFsherJ0YRy+6j04pFq+a7rrNvs9NFh/2ru0raxX43ZLaGCRXUzAmxDbvQTrYd0z5nhHJ
	/SrmgqQPU3TAV/wUOsGfgrvag8SurDNUR7yJ9hIA3L/76hfn2G/7n/WA6ZIRq9kpX4zHfPlEDut
	xpWVnI/6jRRiUnw92A==
X-Received: by 2002:a05:620a:2807:b0:939:7683:33d5 with SMTP id af79cd13be357-94408a695a5mr30368085a.19.1793135386512;
        Tue, 27 Oct 2026 14:09:46 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f067e97csm1085505285a.21.2026.10.27.14.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:45 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:27 +0000
Subject: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=1928;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=BvxK3YOpk7h16bCpQ/+zltv4OfgiS86cLIhuZg2ctrA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QKlMexL787FCcvVxNerffS9t+F2LVb25W0OH2+5Jl6mnH6Q2yBl3k0xGc5yZMJyQWizXzvDekUq
 dgRiGoxsUwgQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

sync_filesystem() writes every dirty inode of a filesystem and then calls
->sync_fs().  The data needs that.  Whether the metadata does depends on
the filesystem.  ext2 copies an inode to its buffer in ->write_inode() and
nowhere else.  A filesystem which logs its metadata has recorded the
change when it was made, and ->sync_fs() commits the log.

overlayfs wants to sync what was changed through one overlay instead of
the whole upper filesystem.  It knows which inodes it wrote data to.  It
has a much harder time with all the inodes which the upper filesystem
dirtied on its behalf, many of which it has no inode of its own for:
whiteouts, index entries, work directories, the parents of all of them.
With a filesystem which logs its metadata it doesn't have to know.

Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() with
wait set makes every change of metadata durable which was made before the
call, whether ->write_inode() was called for the inode or not.  Timestamps
which lazytime holds back are not covered by that.  As an upper filesystem
of overlayfs it then gets ->sync_fs() instead of sync_filesystem().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/fs/super_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 72f4288e16c5..370b0d27815b 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -359,5 +359,6 @@ struct super_block {
 #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
 #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
 #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
+#define SB_I_OVL_USE_SYNC_FS	0x00010000 /* overlayfs: ->sync_fs() commits all metadata */
 
 #endif /* _LINUX_FS_SUPER_TYPES_H */

-- 
2.55.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828392;
	b=EuuSobPIHRLVvJLiwTYz+pevgMs+OjJATNjEzWPV6eZ9m8/svhBWJcI7vawww5+V49F1
	 wDw75xn69qEVuxINnGuC8r0/Af9lRDB32ooMtX5//F/prXV+r6157t4Ym+iiHFi52QQ7F
	 gzpkM8hsbq3oYV7wkordH6TBp+yxhi+pNgvlBbBxwO7z5NQv2IlYhrmZEgOPJDQ9AA+P0
	 rMywRe0yTCIg6K9VH6kDSA8mmm+aN/BqAF5kaYlpEiFSPGm5nAGlM7MRFy2E3MINMV82Y
	 EN+esPHUgahVNY+XaUjdbhgibERWjGMmRhK4DyY6YgaJeYhrfgwgAja+kjol7JKithQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=u7CcFHErpg5MyF3XpM4xUInbMSzKXVsJFYKaM62tDY4=;
	b=eD8Maz827nMGhNKTftjbk9pOe9SfgKQfAdSeMrWhaR251VVOtCsyWIfp6MG5sMKr1qqc
	 xM51fmZ0ISfptHe/VZhAH9YR2F+mqGyBqaUl3oTRxr2AliMRQ3IePZKLE5LNo2Cr8QlYf
	 8riUTOu27cmmv7ZiKnPDiGUngQcqE/S+UpPHm/G7j1ytxurokWPhiygMTxI8OcZkSyUkp
	 HQW2Lc33lhxcE3QIPCpLSkSEDwVXS2/nUfKOWMOyZQke+0dFS1091VGTv5ZOLBHbM5XAE
	 lovzHCqO2lhqJg9MAFJAoeEzywRr0nbvrGAqg31JYosqmsoQ/ljZpFF9Sgw7UwnNqrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rc+dbIPF;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349F3606E2D7
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 21:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 349F3606E2D7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rc+dbIPF
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so13037415e9.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 13:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793828391; x=1794433191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u7CcFHErpg5MyF3XpM4xUInbMSzKXVsJFYKaM62tDY4=;
        b=Rc+dbIPF2v1k57xNpo6CbAQr9NPtXSdtLQBSlJDYs3sSIcR7KBlSHqqBlVYGcraNdq
         34qCxoclTxWAa7dBe9o6vS2/Qj0zU+2p8WqaQ6KxpqvH1x68DVEdj4Yo3oSBdf8MYbF6
         cfX9f9aWYdYu1VDLf3nYSjrkR5K04JlbS2a+YoirdaLCoUCqNiuCsxyHFJGXRT3oe2ul
         N1iu/6uF1yQPT6QYNJh2VsW2d0M/G6L3fg3/az9nNvqRSEf81rkyyplyFgWxTSuMzfrR
         KfzLlqfq0PchmeSCIaAyr+OWmy/YTuRA8qOskNIWyqa65AmoyQYWlbmMeX783FU14oPi
         qrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793828391; x=1794433191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u7CcFHErpg5MyF3XpM4xUInbMSzKXVsJFYKaM62tDY4=;
        b=nTpDrpTUsbcmdVQ6FH3mpW7UkV71N62TvUWII0qXpeFJUDDJxB8VlB0f0fYv46jF9u
         NI2Vaxl9yvAvVyD5PvZu8BDUk0XcIVifWAiif05TSpzgtcQ1Rs/sPODV5gFnOFIxsg2Y
         b5rp6Mrqg9HRG+Y0ksF07/YJuvco3zJdaNAo1TpIPHoS667v2WIjpwpKJjI8x0qhVv1Z
         PsKXZcCSO6KNgofqkZtiCsngs9dUVIOrFAzsjCgtj9/q4z3rBhKWczhBRIc/TB86DOBc
         icH6v/CJSyCKbC6DR3a/FUV1p3i8a6emkGk9T6u1h1xCsmZlOwKYhh/buxUudOU5e5dd
         2z7A==
X-Forwarded-Encrypted: i=1; AKwUvBy7bOdol0BI4wLt8OS0r+VG84nfdv65a3pVmFDfnoIs5HVqcRTttZZpiq3lRsSE2dp+gD7fJ1stJz78Jc16@vger.kernel.org
X-Gm-Message-State: APuU4Z8XHilEWivjy8PJuPtxVGw2Q1aYWUneCM2o8z6ID2mf+PGhPB5K
	POIhakyeTfAoySC+qdvp5PMe3sl6RpwD7bYol0SJFWpsHEvI6/opgGlA8kSYyo4R
X-Gm-Gg: AYBFou1emcpIGFMW2HF0V5nSG+CeYiaFNI/G4LrEjmQ826l507G91Nk7tlLX3/pg0fB
	DZS1Ugzn+MOJduhNVh3kQNukDR5FTtl9tHebm1xGq1TSnzkdA4GH0tT1KaGxSf1j8ToebBV+1Le
	wvW5DR7zSWoNQ6pVpe0dMkHdR+/tNJKmeu2/ylGAUOtghYMByDI200d42eTumiu+5fkNZQgBt+i
	5r7IgnvkD7v74a7yf5PF7lwTtKMwEbLeD2x8dj7JqssDKYYQs2lp6EN8XShK26bzr0LgmGq82nA
	9giWsNVnquVXlUHT03aZ+AUOooWL74hU5CKLxtd2qq4okRVNBY+HGucAjF50bA77E/RnIy70nlw
	MMTbw0AYwxNNTXH9DRi/hWQUHJaLjViAfph4HZ8ikcj+xFr+LLRv0xYMGUaxnPwcBm2bv1O5YPC
	Lzf8109tzXoVp5XI4aqvQ356NhH7n45uw25Qj4weQV8HnhSddKvNRwRI/RtIrMAjNSq1kRiury4
	dqw194C5VPqKHuAD51O+XA7sJhxdj8n1iiXkDYMMy+ja8aXvSE8NXwhkd2SrkcXUhXcfgTiVoju
	ifRtGlnaLJ1KwVpMjmf+/qB/bBz41zwpzZyEbm2VW82pQoXmPlJ3FSmiuikvM4ecJD5L7XJ2EZl
	O1+crCyQa3Sc=
X-Received: by 2002:a05:600c:3554:b0:4a4:7a8d:c436 with SMTP id 5b1f17b1804b1-4ac17470fdbmr390966155e9.11.1793828390513;
        Wed, 04 Nov 2026 13:39:50 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feeb5196esm5534756f8f.58.2026.11.04.13.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 13:39:49 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ovl: look up the index by the decoded origin
Date: Wed,  4 Nov 2026 22:39:48 +0100
Message-ID: <20261104213949.3671581-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mason <mason@kernel.org>

A file opened by file handle on an overlay with nfs_export=on can show
the stale lower data of a file that was copied up to the upper layer.
While the file opened this way stays in the inode cache, a lookup of the
copied up file by path fails with ESTALE for all users. The open can
also succeed for a file that was removed, where it has to fail with
ESTALE. This happens with a handle that has one byte changed. The handle
comes from an NFS client, or from a process that calls
open_by_handle_at() with CAP_DAC_READ_SEARCH in the initial user
namespace.

When a file in a lower layer is about to be modified, overlayfs first
copies it to the upper layer (copy up). With nfs_export=on, each copy up
also creates an entry in the index directory, a directory that overlayfs
keeps for itself on the upper filesystem.

The handle of an overlay file that comes from a lower layer wraps the
handle of its lower inode. Overlayfs calls this lower inode the origin.
The overlay handle stays valid after a copy up.

To decode such a handle, ovl_lower_fh_to_d() first decodes the wrapped
handle to the origin. If no overlay inode is cached for the origin, it
looks in the index directory:

- An index entry there leads to the upper file.
- A whiteout, the marker that overlayfs uses for a removed file, means
  that the overlay file was removed.

The name of an index entry is the handle that copy up encoded for the
origin, as a hex string.

ovl_lower_fh_to_d() builds the name for this lookup from the bytes that
the caller passed in. But handles with different bytes can decode to the
same inode:

- Overlayfs ignores some flag bits of the handle.
- A lower filesystem can accept a different fid type, extra bytes, or
  generation 0 for any generation.

Such a handle decodes to the origin but misses the index entry or the
whiteout. So the decode returns an overlay inode that has only the lower
file.

While that inode is cached, a path lookup of a copied up file fails with
ESTALE, since the upper file that the lookup finds does not match the
cached inode, which has none.

Reproduced on tmpfs and on ext4 with open_by_handle_at(), after a copy
up and a mount cycle. A handle in which one flag bit, the fid type, the
length or the generation was changed read the old lower data, and path
lookups returned ESTALE.

Fix this by re-encoding the decoded origin and building the index name
from that handle.

Fixes: f71bd9cfb692 ("ovl: decode indexed non-dir file handles")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst |  3 ++-
 fs/overlayfs/export.c                   |  4 ++--
 fs/overlayfs/namei.c                    | 13 ++++++++++---
 fs/overlayfs/overlayfs.h                |  2 +-
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 16c35b491dad4..4c241d220bc23 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -731,7 +731,8 @@ When decoding an overlay file handle, the following steps are followed:
 
  1. Find underlying layer by UUID and path type information.
  2. Decode the underlying filesystem file handle to underlying dentry.
- 3. For a lower file handle, lookup the handle in index directory by name.
+ 3. For a lower file handle, encode the decoded underlying inode again and
+    lookup that handle in index directory by name.
  4. If a whiteout is found in index, return ESTALE. This represents an
     overlay object that was deleted after its file handle was encoded.
  5. For a non-directory, instantiate a disconnected overlay dentry from the
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 9aae20c59608a..bd998a3d8b95c 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -713,9 +713,9 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 		}
 	}
 
-	/* Then lookup indexed upper/whiteout by origin fh */
+	/* Then lookup indexed upper/whiteout by origin */
 	if (ovl_indexdir(sb)) {
-		index = ovl_get_index_fh(ofs, fh);
+		index = ovl_get_index_origin(ofs, origin.dentry);
 		err = PTR_ERR(index);
 		if (IS_ERR(index)) {
 			index = NULL;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c6127edb9be95..64d63b260709c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -781,14 +781,21 @@ int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 	return err;
 }
 
-/* Lookup index by file handle for NFS export */
-struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh)
+/*
+ * Lookup index by decoded origin for NFS export.
+ *
+ * The name of an index is the hex of the file handle that copy up encoded.
+ * The bytes of the handle to decode cannot be used as the name, because a
+ * lower fs may decode many handles to the same inode.  For example, it may
+ * ignore the fid type, extra fid bytes or a zero generation.
+ */
+struct dentry *ovl_get_index_origin(struct ovl_fs *ofs, struct dentry *origin)
 {
 	struct dentry *index;
 	struct qstr name;
 	int err;
 
-	err = ovl_get_index_name_fh(fh, &name);
+	err = ovl_get_index_name(ofs, origin, &name);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b5a672e8e4764..e42543d4c1080 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -750,7 +750,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
 int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name);
 int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 		       struct qstr *name);
-struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
+struct dentry *ovl_get_index_origin(struct ovl_fs *ofs, struct dentry *origin);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path,
-- 
2.55.0


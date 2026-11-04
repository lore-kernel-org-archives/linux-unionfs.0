Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818541;
	b=O5n9rCR+b3JuZCVppUBKBA24QWdKSkjrXjPrYtnphi2Ktj4wnaAz93lk20Kibn+4AC/x
	 PfUpo/PxSWLBkC7go/BLq3xx2cbDUtR4o4vmLB2wZ2+BWwLC4yWW0jdGYxLcgSdwWggjg
	 1i/HB2hEMS2MNoOPJKrakL2UJg9HBHVX1iPkculJ8Vg5uyXfhbzY9idCN55MOnhoKYMST
	 qJgsTSIFj0fcqxbCazAIv3If9APxt6oU2psLrRAWSXCPIfOus1TTGsqCsPb0vXhcfC9EY
	 OLC5m7Jli0IahMgDoz19L0Lf6QpYAwoo7IbLztmrMIGqPSkyjRTZ0Qy7a07TMDPYGDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818541;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uw+ltulG0emNHhLXpUx5MHUqNAFvHB2/zMCw3FPX7pg=;
	b=McoGgX1fItcbmNgA/eyasWwv7sej4eyFPdO/7S0ZJ+CNsrH0Eu+ELNKH52kh1S1xRhzS
	 h/oJG+xMjhDFhRnpq0JJK/aOmBr13TqsSswQwMK9T2pq5xILK8m7qNT300phEl9wLWZEd
	 IiW7cd0trb4MK4BtETIOuCgvnq3gy8HX0sxA6kjL08aJE+UHWJMBo1//JfJvMVHUb9JFZ
	 NfuFlD5oH31o2/J+QWIJoPFN83MOOFmsPTOfkh+J7+wFQtVS9yFJDlMllhHLdF75mV/Jf
	 F4GViFKQytXph7zVeuVMH3s1QP0TbKfAnvBqyQS/mTS8Lr9u1LRFvG+bdk1rwKLDZ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LjOSIXSZ;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B16E606A32F
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:55:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B16E606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LjOSIXSZ
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-490c1d337d8so349814f8f.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818540; x=1794423340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uw+ltulG0emNHhLXpUx5MHUqNAFvHB2/zMCw3FPX7pg=;
        b=LjOSIXSZvi1Co/ojQnJJS0/HHNEXdZQaaHqfkwIX5m5qvdHzjryvAMJhtcO37LEafD
         O37KMPZQVO5L2VTsjvxdvDs/sS5SKBM5Hsp3BoE3YKfsZsg58bLh5wI5HZJX79pv0DRT
         QZaMjSVY0L3CgHO3E4xCU5MFH9CFZ0/I0FQRIPzX/a+xXhGuBqihSFcC1KyKdFyjJKbl
         0i3E19JQFlh3td6BrF+68qgnQZ1WdTSWVadjoyMN5e14Hf1KhJRsAFe7zZ5oex4c+61l
         IxuEpUreEuX3yrgR7uKVEbWwH10QNFMppqVpD/fvdqKdLOfTYMfXWIAUDSPK00ODjwPo
         2iXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818540; x=1794423340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uw+ltulG0emNHhLXpUx5MHUqNAFvHB2/zMCw3FPX7pg=;
        b=gJmt9niZPqg5vKp6/Nad4uE7tnJJxqzB7JQVWV3JRSbNb1Q0Yn/cqSLvzqQZcs79uH
         458vG/TcsvkY0yRklBdJvMnYpyTpXn0/llxI3Y/TrNq5gIepj42pulk0R9/L8VvbCd1U
         AHzD1/8ZtFqaqL6N89HoQA+YN+96snw+xfs1+36jcaKHkqeQ7Uo/gPIZpz9aryAIauq5
         ZrakQjF5mR9YNV13Z8HENctb854l3CQwqM5e7zeTHEnKGNgNWw3sNGM5HaL7bTsOw2Ho
         v/AISdeRAvJitQdtpZOOWoiBmmdLoF59AhOE4x/JxKr4JreWNcRNSZOrtsjYa+Fz1ywq
         9t6w==
X-Forwarded-Encrypted: i=1; AKwUvBzFN3pWKzEL5WhJMdX1CmfGwWLwgQgKzSenoTp/3Zc2rN87itPxMUiYIypPniqAFuFeGjEKBs7cqx5WPtP8@vger.kernel.org
X-Gm-Message-State: APuU4Z+LV4B9qSVdTNMy+ZPKdEUiYr5tiI5dlRCvPZtPRtaNAj+436sX
	qSlHWGiDHmE035Sm7cOZyEY56NBg43EEP1G98eLhgIe4fLD8A7vb4v7u
X-Gm-Gg: AYBFou1grWqXtJPCW8tQm8drLgF/blSdTdKog7EVFMis+gttkWtX2cc3J2AhyfsEEy9
	noGTBVyWqNkz98xncE8Ck4cxBWjv1cyDmbEFDtKzbBhcK6qTiCZdwtgEM3Zi239nSKxIhcUH03S
	/QtcN6unNapNFbqxQwKwoNxxqCh+CItD3jabzfan6AjjZS3vprCD7qLZ2thwfC39ijnfyS1uv31
	Q0xbRUmdSFXKxNWx3KPFMGi5g+U49BoFtzqsNnnpy+npcqSSG0X5u0RxwYzJXOqZKsgAHxloB9l
	G6mOCtbTJEE4fSdqlZy+vDLcQ1kBd2idA9x0bQQ7v6a9RWu9EluR0TyPqtZ59X72AKNQC5baszT
	cbvhyaBH4nSd4yGof+xLIQ8M3EoeskqmkYbqgQqqshglRpIDU0+WM7E6ZpD0Am5CMEIU0pr9St+
	jb9fEKyOLHOxYGk66XxjIgnSTbZjjde1Ansf3zp588R43Qx3IX+tTkhF37XTUkKGvTZunWEIKr9
	bP1MsnEQmoL4puge4LX/ZnQkprkAPy6wKUJGpw7UuqAbqNrjAdLwRct+Uwb8+09sKmp43NDqbh7
	vHLK32Eh8t6cYkIJFenFhE3owrcbniuSYfMvdtCrhzXYHGxPiJ45vBQ5lEXbNhRCoCzJ9paIILL
	Ax2nKRsn5W+4=
X-Received: by 2002:a05:600c:4fd4:b0:4a1:e250:b191 with SMTP id 5b1f17b1804b1-4ac180f2ff3mr377755925e9.17.1793818539533;
        Wed, 04 Nov 2026 10:55:39 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea180ee1sm6294308f8f.4.2026.11.04.10.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:55:39 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH 6.1 3/3] ovl: set the revalidate flags after d_instantiate()
Date: Wed,  4 Nov 2026 19:55:36 +0100
Message-ID: <20261104185536.3631167-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104185536.3631167-1-amir73il@gmail.com>
References: <20261104185536.3631167-1-amir73il@gmail.com>
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

commit 75e89c0055c1d7f7eeb462995f11253ca5864f79 upstream.

stat() of a file on an overlayfs mount triggers a kernel warning and
fails with ECHILD if another task is creating that file at the same
time. This happens on an overlay with a FUSE upper layer, which is the
layer where overlayfs creates new files. Write access to a directory on
such an overlay is all a user needs to run the two tasks.

The revalidate flags are DCACHE_OP_REVALIDATE and
DCACHE_OP_WEAK_REVALIDATE. They tell path walk to call ->d_revalidate()
or ->d_weak_revalidate() on a dentry, so that the filesystem can check
that the cached dentry is still valid. An overlay dentry only has one of
these flags if a dentry in one of its layers has it. FUSE dentries have
the first one.

When a flag is set on an overlay dentry, path walk calls
ovl_dentry_revalidate_common(). That function only expects a dentry
without an inode in RCU walk, while the dentry is being destroyed. For
such a dentry outside of RCU walk, it hits a WARN_ON() and
returns -ECHILD. So a negative overlay dentry must never have the flags
set.

ovl_instantiate() breaks this rule. When a task creates a file, the
overlay dentry for the new name is hashed but still negative.
ovl_instantiate() then works in this order:

- It copies the flags from the new upper dentry to the overlay dentry.
- It calls ovl_get_inode(), which can sleep in a getxattr request to the
  FUSE server.
- Only then does it call d_instantiate().

A second task that looks up the name between the first step and the last
finds a negative dentry with the flags set and revalidates it.

Reproduced with a FUSE server that delays its getxattr reply: stat() of
a name that was being created hit the WARN_ON() and failed with ECHILD.

Fix this by setting the flags after d_instantiate().

Fixes: bccece1ead36 ("ovl: allow remote upper")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no tmpfile case and a 2-arg ovl_dentry_init_reval(); no WARN_ON,
 but a negative dentry still fails with -ECHILD]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -269,7 +269,6 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 
 	ovl_dir_modified(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
-	ovl_dentry_init_reval(dentry, newdentry);
 
 	if (!hardlink) {
 		/*
@@ -296,6 +295,12 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 	}
 
 	d_instantiate(dentry, inode);
+	/*
+	 * The dentry is hashed and a path walk can find it at any time.  Set
+	 * the revalidate flags only now, because ovl_dentry_revalidate_common()
+	 * does not expect them on a negative dentry.
+	 */
+	ovl_dentry_init_reval(dentry, ovl_dentry_upper(dentry));
 	if (inode != oip.newinode) {
 		pr_warn_ratelimited("newly created inode found in cache (%pd2)\n",
 				    dentry);
-- 
backport

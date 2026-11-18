Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021422;
	b=HMLgyW0yfj8deVDabfn7z/Maqu712P6LR5vp9bWd0G2u736h+X2BYhVk7uLPQZgc8bNh
	 wvmJqwxHcwNauV+kNdNeqIR/gbyfjzXREYj6eq9CsyQZOMnUKJKs54kY1gXVfzsMnWnTk
	 wOEX3Q2W+5q1oZpMUvbVu0qUvpZPyrW7J6LUwZOl3nWjaQzNUArF2u18UfUVCLq8ldZ0Z
	 e2D679Gf/4aTz/l6fiE727s4RFzaAItNYA9tcinrv4eR20Eum4Q/ghzepxKq+bwwV30Xc
	 sVM+sL/PjuOi2XVuSijzmWz1aDfUUMLeV2mG+DhtoYKs34uYooYfaV+8bcVxnehOzIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021422;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=GLHuqACsTi6DOH91EEx2HMnXciRG7zk2OqldyJV4r9U=;
	b=Z6chAsGS5ufTgU8VRl1imVhlbOh0YYUmf6DbivtxDCniuQiqgSiABrtUgb3I1XK1/G9I
	 BhGaajmoSNb/mGIVE3bb/IsLuLlgQoZM3PuFJki0XiCg7Vq8pNJquyPlEHN+l4iTm2MS3
	 YPKBCZIxDH09iW4Y2QkYV3uVz2dgm647hCqNg12kx+HsnaB+rml03XMh9mMWiD4GMcYRV
	 BPWjwM/6wU64hnmBIKcChNlFzyrFzupZIlePAw/pnDGzLg7lZPlaMn7HnLX3MfPA2ovPS
	 X+fJ3XOo9UwxFoD0Z/iZSawld32q+vPRBHsVbC3GGKu53Pew44sB4INaW/1D/xzlyGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=AkgNh3ey;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4710060A263F
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 17:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4710060A263F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=AkgNh3ey
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b4e246acc2so9635627b3.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 09:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021420; x=1795626220; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GLHuqACsTi6DOH91EEx2HMnXciRG7zk2OqldyJV4r9U=;
        b=AkgNh3ey6Ev+lN7gotDHPUOV5RYD+TnT7qOwD5SaiKaH/vnC/VO8ghxeJvFSsJzwSJ
         3uDiXEZgeH+SHqH05FgLXOuFoUFD5Dj6tLrUjqutO+0+I8gynDymizv5b6uD1QFlgzQo
         xmPESuIK/GssqngbAJFlMVJROaQ8GIt1OtggTgYiMz0phUq47Z+4GjVhhTazzr5ETAGn
         7+uzgjCCb24Da8w/pFnYH7wsg7WyXbuwZY0eBdm5eISnT2XYUxqb21zHSOYhrvsvoIGs
         FrIwCPSqpgzSTp+2wdYc+xxgGr0nLdGL5kzVrFbYwl14O+v2XvfRMMlLq/gHLKsa8DMB
         hifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021420; x=1795626220;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GLHuqACsTi6DOH91EEx2HMnXciRG7zk2OqldyJV4r9U=;
        b=QlF5YEE6GDz7fRFV7VALpwNFneaRoBRBS1vCfR+nLLNM/oivWCj5iUIFp1cIOMDvt9
         fIsidd+BvkEGMDn/cHQySTbuPx7YSnUiGv8FLs+ACaeXsmKDaeMvyVAqZKsNNCVjwsEN
         0FZRvsSGf5D3yHCj9XKx3KB3oAO6zng1MtG7ZXGRnUKBLZqNqLxYrkqY0728KYdSHWs6
         Kf/l5+C1Yzxhlvv5phpzNrLWHYHmRYIgCrRSi7JlrikMP2q/x4cIiUQjtXFoSQwYHOyX
         h57bYNy+RyAfEHStDTuj1aHIwf139FqcYvvkw7w6BIlg49/lg7qeNKu7aT4uMit9d+Hq
         7Ipg==
X-Forwarded-Encrypted: i=1; AL+hErFOT4BYeFcih08Ru7y4cV/5WQnTOjvYIzj8182Mzbj+4NjK+kh9IdtJDmIGTYOAzaeCJAoXe4Dw804jl9CI@vger.kernel.org
X-Gm-Message-State: APuU4Z+K/acm4SFmi+5HgmARA1lqy15GAcTzW0aNeDFX3VT6Q3y8czAl
	aJcBbqreQe9TwHnLGHjgr5uRK2dwNi72j0x0GgU0tHuijLa5DmCrRpdu0Nk9MwOqZ2g=
X-Gm-Gg: AZFdTZeXj08MP+97liQFBx9vLEfEhR92IjCYoMi2/jBn+zvUQ7PYv9z2x1ptRu07VHk
	P5OLSjaPXapfz36lL3TJzf6ggOC6JivIBHc6fpgm7TJwoyhJxYbVMHL53ZTRupqwCOoLdtcBDBM
	VMvhtudlMwu/foQh8Ls5dFyJ9Bkx+QE9FWQQtkxuFje67QoucLMz3wEYaWwhzoDU9xMIBd9tmJd
	S86X/KVm3cjO4B8AWulCdE8Yl+w//wqqeg99mZoJHcfSTKUZwHM7kSgnI2D7tySd5bXuLYLTHJ9
	r5HxgyB3DW9xpcQ+X0WqnHcUrhVXkYMFKzzDD12Qsb4QhKMVUpEv9rtvkynNFZrUqj0sYD7bd45
	MRPpMRgDAPWuE9tAWTHjBW9ZhLW7wc7Kmelxx7A9uE6hhKPi176E2qeJ6U0wy4/xneQ3+Vo2On2
	aXBVbx9Bn7+1slzuKZ8mZS0S1v3iiPk/HQKC43WnvvsBzfRh7q0Ih4ic1QhYLvh8DLId00jbAWL
	91Ih4m+ZQcDQu53tNglW8VOPJdsdsDIzRfi2o2iGBFr/GaDuVb3FwTp+sLw9bpxEwjvLDVuJeRi
	RBXHST4q8GDDx5lKzECRQQBJK6g/5GUBeAVS7R5Dj802kw==
X-Received: by 2002:a05:690c:3507:b0:8b2:bb94:8cb2 with SMTP id 00721157ae682-8b4fed735damr13715107b3.35.1795021419607;
        Wed, 18 Nov 2026 09:03:39 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.248])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b721861sm224672485a.11.2026.11.18.09.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:03:39 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:03:27 +0000
Subject: [PATCH v7 4/7] fs: add write_inode_for_sync()
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
Message-Id: <20261118-b4-ovl-containerized-sync-v7-4-54f45743fe55@toxicpanda.com>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
In-Reply-To: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021413; l=3205;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=p0YhEkTdw0npTy+LdFTgBjMgbpJBL9rcoMEF9LbcE8g=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNW37LsNkBnQAFJvjEqEnn2YU8K4cQtYudIaa6RXFHOIT4DwIBxZFAEYqnEqCYymrGX2bhK02K8
 bR1zva27ngQ0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

sync_inodes_sb() has the flusher write every dirty inode of a superblock
with WB_SYNC_ALL and for_sync set.  That writes the pages without waiting
for them, hands over the timestamps that lazytime has deferred while it
holds I_SYNC, and calls ->write_inode() in a way that tells the filesystem
that ->sync_fs() follows, so ext4 does not commit a transaction for every
inode.

overlayfs is about to sync some of the inodes of its upper filesystem, and
none of the exported functions does that for one inode.  write_inode_now()
and sync_inode_metadata() either do not wait for somebody else who is
writing the inode and leave deferred timestamps alone, or they wait for the
pages, clear the error flags of the mapping and make ext4 commit.

Add a function that writes one inode the way a sync does.

Nothing calls it yet.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fs-writeback.c       | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/pagemap.h |  1 +
 2 files changed, 37 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15260cf2a29b..d265466f12a8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -3103,6 +3103,42 @@ int write_inode_now(struct inode *inode, int sync)
 }
 EXPORT_SYMBOL(write_inode_now);
 
+/**
+ * write_inode_for_sync - write an inode like a sync of its filesystem does
+ * @inode: inode to write to disk
+ *
+ * This does for one inode what sync_inodes_sb() has the flusher do for every
+ * dirty inode of a superblock.  It writes all dirty pages, the timestamps that
+ * lazytime has deferred and the inode.  It waits for somebody else who is
+ * writing the inode, but not for the pages it writes, and it does not ask the
+ * filesystem to commit anything.
+ *
+ * This is for a caller that syncs some of the inodes of a filesystem.  It has
+ * to wait for the pages with filemap_fdatawait_keep_errors(), like
+ * wait_sb_inodes() does, and to call sync_fs_and_bdev() in the end.
+ *
+ * The caller must have a ref on the inode.
+ *
+ * Return: 0 on success, a negative error code otherwise.
+ */
+int write_inode_for_sync(struct inode *inode)
+{
+	struct writeback_control wbc = {
+		.nr_to_write = LONG_MAX,
+		.sync_mode = WB_SYNC_ALL,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.for_sync = 1,
+	};
+
+	if (!mapping_can_writeback(inode->i_mapping))
+		wbc.nr_to_write = 0;
+
+	might_sleep();
+	return writeback_single_inode(inode, &wbc);
+}
+EXPORT_SYMBOL_GPL(write_inode_for_sync);
+
 /**
  * sync_inode_metadata - write an inode to disk
  * @inode: the inode to sync
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37367..172c0fe0453f 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -35,6 +35,7 @@ int filemap_invalidate_pages(struct address_space *mapping,
 			     loff_t pos, loff_t end, bool nowait);
 
 int write_inode_now(struct inode *, int sync);
+int write_inode_for_sync(struct inode *inode);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
 int filemap_flush_nr(struct address_space *mapping, long *nr_to_write);

-- 
2.55.0


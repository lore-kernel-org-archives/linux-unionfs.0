Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135398;
	b=grkDKOh4VBfB6ZfZRDeD6SvTiKtWJXQdy/AZ7I1kdOeeWlUBDaWfKmVh9EbKkpdbE0fC
	 D/+GZYSb4pXAK27zUl78+v4qATR6Pmcj/fJ75Hiy064f22GI6F00L5RM+ixT1KRpU3evn
	 D1vu33CmYMPBgL5QDZt4R2JeK/3Zybb31M1K4AJrV8+sZ5c0tbhgjMj77eEut9UD8uHZw
	 zJa9IRwjjWuGYd//Mr0iTYkLzyBzx9H4tj4sLtjCdjcfU6Pp+LpqUo52ZuIJy3hOFObXH
	 0eXS+4/aA/U2UGL0furcf9m1bY9blh3SK8YwYsOSc4O3JcJ666AeUhYZyKVzmP62WsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
	b=dS8yQfNsqgXAEkPCinJHTwaN/bxmLhJJ6LWJJZJXjTWKwzPP3OJQuY+xSiOYfnmWcRV9
	 LzZMwWsAgasqnMBHe0+ST/Bk0bR8pDtjFEuy45RcfBYfi+pF9TZD4//b2YatKmAqDZ10o
	 cJ7C4DR8GO8HXTFAvGfbZfqMUZzKrXLvJc/DAPEcpi81I+OZPFgP8hYz3KYdmx1m18pnP
	 ZVd5Qzn8otHwjTx3eCIS8Jnb80eCHy1pJAnIYwK3gRfwvpYOUcIu8xzGu/S/9L98D9xie
	 dUPmvAxbkkjz6fZFj7nCZNKCUqIJpFMMZh45YvKSWs53sDw/yv4unqD6qpPAdwoYOnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cZlRNmIR;
	arc=none smtp.remote-ip=209.85.160.177
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86AE60A3816
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A86AE60A3816
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cZlRNmIR
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53bb57f1310so4195001cf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135397; x=1793740197; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
        b=cZlRNmIR6NxiLuSTk5H7t58NmoHxtt8buwWzXHDQYgXzaYZBtGWYF8BILLNiN/vitj
         /Ay8gEMGGZF6pPT2aogmsL7+z4PKstycGKkTnuGcrE0QimQ0AMJpggcLcKxYCnYxnuw+
         BxBGaleMVQgyAYjeUtXZ5m4kAzoGneBFExCLdLMNph842KUix7YhAfqG1ct7aeU1DwMh
         CwFY9FOoeTpRD9iYQqX7c+upezqtLqr0Ui5ht8qe3sGeB1ob4izFucUduE2QF2DaDp94
         2qZQqDUamnv0uaY/sqsTcm9CxRP6HeQWIkO4FZTI8TEsbgPmIMpVQR6cMXb4unK0U+OI
         Hi8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135397; x=1793740197;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ck/ful92N6NXzDNP60KvQsR2JiXRucsXYdV/7/B7+xM=;
        b=boj1ePfitGU4xyf+uj+lUaGvJtTHRV0+qY1FI/fhSdjns/GqoQKxnePZ+0KM1ieWHN
         jxKyA7wFgF97iyp49tACrLmDvyvQFwwTZSiba9KpFyYNo/FVa+66SS3BjXNyxcDffcUL
         8wYSeZRDdsM9Fw96WxSByuVwpXE8Y8gZaO6ZhtD3ywMZY/bplyVzyRRelGCppC7Laa7w
         J0N2PhcTpngWk/bFyortoUf/x1663OI91cJbbfiG30tZGDk4hUoB5dV/2QardAB1H4iD
         wpYa13isWTfXKr+OQ1oiOXLUcoQjK1SiXR8Fe1jW2S3h5LfomVBn30SimSl4Q//CyuM2
         M4Jg==
X-Forwarded-Encrypted: i=1; AKwUvBz64qcFg9I1ppPTwZmA/6m+5u2XIR32rNo9UDEaHN2m9FYawqlrc29auIX15ec3jl3mFGTnT78PTQjYnRzl@vger.kernel.org
X-Gm-Message-State: AFq9FYLPpUFh044jo6Ilrc7niyTd3NLGY/NkL9L6tlYUzvah6MeZmhta
	bTeckoz81uMGrJEQGAWVGDrB4q/LLlSz8eTL/bOKvCuGEiDal2Y9x4am2Imwi+mdBHE=
X-Gm-Gg: AYBFou0hVUlHq5qnRqUu87ZCkpQ3ua6j9eKJb5VeZ70uxzef947QZ6f65p7jxVY/i0i
	UJBTyIIA4bANPLFUu2GzEJ5KRcr9b4cQkPZmJAwrdyVDfMKeT03zcZdNM4xLiIRyhxrNdhcQcZM
	LqMYI/FLAsZdLB2GH+/UjdZSU5DO+2PL1eqSx11QAbwk918EWan/DT4eoxkKJq1M9R86kDh+1nr
	lwclOpFFeQEdFt1e+Bzj4fwqh3h5N3hOFZ4vji3ceKOQmdygLdZmPdG5hlM4lDZruJIm98KWhNx
	e5f0w+DFMyWW8an0bpUWyCeCOZ0tqluRbODNKFUweWQhKUSpLX+9JibSNWGllZqyWFTRiv091ud
	L3O0XGgd8KofckuQQUHTJn7294X7cKSC4ApXKCk7dzk9ea+3Au8zjO3vYff67ei4c0p72WaHJn/
	0sQacZyTMNxw4VddGjN0+UNIlZd8+uq4cqN9+hNKDSn2GaYreFNcNq420pugmiVc4lnc3JpGK/8
	nm74oyO0PRHWo7iuzlNSIBT/4H0v293/5NT3g7TM7L4e31gVnw9MAZW6R2R2yDSUmQM6ld9
X-Received: by 2002:a05:622a:5917:b0:536:3950:5d7d with SMTP id d75a77b69052e-53fcb20d4a0mr9425991cf.16.1793135396673;
        Tue, 27 Oct 2026 14:09:56 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c0ffd4sm113733436d6.16.2026.10.27.14.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:56 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:33 +0000
Subject: [PATCH 07/10] ovl: implement overlayfs' own ->write_inode
 operation
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-7-802e512379a6@toxicpanda.com>
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
 linux-kernel@vger.kernel.org, Chengguang Xu <charliecgxu@tencent.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=3603;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=TzW1SCvICZ369myzzdV8AX2bLJ7uerYZSh8+JshacQA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QB+NR25IEkE2f0VZhWtwP5u6sLCjWEHN7x6AAsproO/3gSZZmPXZynAwUIROur1wPkzEoIAqopA
 LpfqCsruvyQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <charliecgxu@tencent.com>

Sync dirty data and meta of upper inode in overlayfs' ->write_inode().

The overlay inode stays dirty for as long as there may be more to do:
while the upper inode is open for writing, because stores through a shared
mapping go unnoticed and the mapping holds the file open, and while the
upper inode has pages which are dirty or under writeback, because a pass
which doesn't wait has only started them.  So by the time the overlay
inode is clean, the data which was written through it is on disk, and a
syncfs() which only looks at the dirty ones misses nothing.

Signed-off-by: Chengguang Xu <charliecgxu@tencent.com>
[josef: redirty only while the upper inode is unfinished instead of always,
 no check for volatile, nothing is marked dirty there]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d21e7cbb70c2..0aec7059e9da 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -15,6 +15,8 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
 #include <linux/file.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
@@ -313,12 +315,62 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+/*
+ * Could there be anything left to write or to wait for on @upper?
+ *
+ * Whoever has it open for writing may have it mapped, and stores through a
+ * mapping go unnoticed.  The mapping holds the file open.
+ *
+ * Writeback which was only started, by us or by the flusher of the upper
+ * filesystem, shows in the page cache tags until it is done.  The dirty flags
+ * of the inode do not, they are cleared at the start.
+ *
+ * Metadata is not looked at.  The upper filesystem logs it, see
+ * ovl_tracks_dirty(), and ovl_sync_fs() has the log committed.
+ *
+ * Nothing orders these reads.  The one order which matters is to not see
+ * i_writecount at zero and miss the tag of a page which was dirtied through
+ * the mapping.  The tag is set when the mapping goes away at the latest, the
+ * count drops when the file is released after that, with the locks of
+ * unmapping and of the final fput in between.
+ */
+static bool ovl_upper_unfinished(struct inode *upper)
+{
+	struct address_space *mapping = upper->i_mapping;
+
+	return inode_is_open_for_write(upper) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
+	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+	       (inode_state_read_once(upper) & I_SYNC);
+}
+
+static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+	int ret;
+
+	if (!upper)
+		return 0;
+
+	/*
+	 * Go through writeback_single_inode(), I_SYNC is what serializes us
+	 * with the writeback of the upper filesystem.
+	 */
+	ret = write_inode_now(upper, wbc->sync_mode == WB_SYNC_ALL);
+
+	if (ovl_upper_unfinished(upper))
+		ovl_mark_inode_dirty(inode);
+
+	return ret;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.free_inode	= ovl_free_inode,
 	.destroy_inode	= ovl_destroy_inode,
 	.drop_inode	= inode_just_drop,
 	.put_super	= ovl_put_super,
+	.write_inode	= ovl_write_inode,
 	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,

-- 
2.55.0


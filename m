Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320712;
	b=kgPqCeKa2NYrYr6q2P/Dcf19XMqLo7RRacdv/vzCll+ZzdXolIjJUcEH05TA/U6jPuwM
	 jKIw8JF2R+j02ZRrC9YBpJRA2AIFDg7PwsVj+6d9pgoLA7crC+XWM98ANck31N4DwOB8N
	 1nZYNdUX8Lbfnbq0SqCtJWNhAcAEgXhi1wi202kjf1SNRxF3bOt4lKNXM3H+rkVPUwxGZ
	 4a+U1/cQ1RPMJ8NW0MGARo6ImPOoyqB+ByXG10T0QbpSHnWxs2VrXcMlSGPxnzf1QoCst
	 iJuLvHtNyhJ2qisS8YjmIp0PEuPQT6ZITkcGETzct1gz0f2eTENDNuWA9b7BafnIPCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320712;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=PnSFXHaGUn2yIPfXv3C/P2JPWkITSQ8aFixM4hBP1M8=;
	b=atE0NH3cSvOg2rAHXyslDjNHLkb3ed7HF1UMTJDaKVQ3cJRgj7svEnyvOBDU5uY8hHyv
	 AXwuf6VZfAA9ZFgBY8LM9n99A2WfndgoXDurucmMfSYweGfEQU/pDPRA4IAW1psaZGPsy
	 gwBla32RRM9qkAM+ZDmTtOrOK7smzaOoXBeK4QZVqLSOlppZxNInJyolydWNLmmWURWIT
	 hnAZNVx1aLUKgjBncPJtoCRPfxvd+v66L3nhq1c6wh8Wtg/5HGB1hUbcbYHC8FhB2g3Nu
	 ejVhOAsUnM8/rdecSysSa2sdbM5O/PfxPw0XmAhi02YPIYEa95VoEP8WonLY7f0zUIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=M42pjxXs;
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A51360727C6
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:25:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A51360727C6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=M42pjxXs
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f20c3aaa5so183423585a.2
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794320711; x=1794925511; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PnSFXHaGUn2yIPfXv3C/P2JPWkITSQ8aFixM4hBP1M8=;
        b=M42pjxXsCNla9wZH4Bfr6Rx0U1n/wSCDmWlTJH7YWlDzQBsCFxKzw71g8V5ulXqVZ3
         5BEIHRU+4s8FJxCTg+l8WjgRfh+zLkq0llIMSUn0uae6fw+HuadJBGBPJdPMB/w/WTuR
         R83WQak/SMBisyHwQKseg+wSyl/7fpG9SsZdlhjSntHDP8KY41olLhRDCy/gmUdVhqdu
         b9YQRooho8n2F93dD/77VXGZJnswGceDjOkJ+SusWCFaXvC5pvWGpwx0HhPr2+VldUtf
         y0o4YqTO3lqB39XSFfyJ7r7UGgl8XfCkzAWtVlgyQCb9cHdx3nntPfHGltIZz5c/Uwp9
         g9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320711; x=1794925511;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PnSFXHaGUn2yIPfXv3C/P2JPWkITSQ8aFixM4hBP1M8=;
        b=S2TUeGIQqm5pLK+9+GGbEy0cnhEs6wVXb/yv2rX2/ice7PWpBOXGrZAJB/c509D088
         u67sCCLlxRanycg6jLWQA4o7LYZBQ0jKKt95zhPRc9fnUoWDBZHhXjsxV+FYyQAR+BNM
         bRailzk/lyOaYdYH2msqdaS1K36bnmlZYqfgUUiUP7O9k8hRoG3wuC+BMO2jCKecLk96
         1YZuO0dKxNEPNnLXOTOn+RinFeLYJBKEeCTZvh8E9b0leJrhj/yj7ZXGjPpH4qdqWrm+
         467F/DkhjuDQJnDQHmHojobtc1++DZU1fSXYuLvSBFfuJ1TCE+Qyp8gvXIV+DemsqO+g
         9w6g==
X-Forwarded-Encrypted: i=1; AL+hErHpL3NrkwVVJblSiKYc+nE7aaOqkquviEHZyOuQ4nR9JwvQlbKz9t5PIy7AoFdNwT8W/9OGy1oqTwJ9dZuq@vger.kernel.org
X-Gm-Message-State: APuU4Z8hkcjePHL1hTkY7Uj9oHTKSDkVf/+fCrPTdd6vSFFzMvFX+5qr
	6fOTqcAanf8dS/UJgmj54M2aY4TnTqqssKAAsz9x7veBBuTMYQWoIVlX2oVmWwAN0Po=
X-Gm-Gg: AYBFou19v/YnCB6TNjjIrvJFrihkZrM7QGC7tVv8qag8Gxgtflx8lxdsE2jNguuPGnM
	7gan9ZsJAHjUjaEd6AYs42xatXnTl+9VX7gBEYMyibb9KvSr3C1gFrhkZ+ND9BkE62IlSOH0FUD
	6f/6Vfqo+S1bGcEayQaKs6tfPtyp+q3xSddT6dDdMb71VyyagjZ8vOeM5kBwOwUNVAmUu9regDS
	NTpbXi3n0GG87eYZUjhy7riZa3ca7MQjEprImKivZXGbRDnKIHS8QJQj4VTNtlF72xZp8Il4yeR
	3PtzEwOFs1B2Q0sgC8BGZqjsFIfaEuW+C0g8OPMyOxwWGnD0a/4AXzmbKzP0IoCckZacOBYA6mB
	YLRgQ2zx2b7b/Bit82FyEvHhF31XtwbCApr3/0oXDvBNeRNB+yDaou7xSAYfX2E4wUdv4TXyZv8
	kn8Ae+GdJlOPZsaaTtTWZgZrfkr2dGvAPQPaBOkCGW7F49rKiXp9f3FkdwP/fN1iiWyTdg+xTrK
	hbAH1q7J10CqaeBqceR8qqQIfyFGyUtc+LqinflZBZGem4HpSazQ0WbXy+rkK8w7mzM4ZrgiIHU
	CF5zoNZBPIrXWxpj33zb5ta5mJspKImmvqD2Dq1vX0VQsg==
X-Received: by 2002:a05:620a:4116:b0:93e:c12c:f13e with SMTP id af79cd13be357-9479f413983mr450270685a.72.1794320711279;
        Tue, 10 Nov 2026 06:25:11 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e73c3ddsm235667085a.15.2026.11.10.06.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:25:10 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 10 Nov 2026 14:24:55 +0000
Subject: [PATCH v6 7/9] ovl: write the timestamps that lazytime defers
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
Message-Id: <20261110-b4-ovl-containerized-sync-v6-7-43d1be16a4d6@toxicpanda.com>
References: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
In-Reply-To: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794320698; l=5839;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=Nv1r5C0/Y5oVgtY4/ksHbWZkZMzqkK9iJ3SOAzP4iyI=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QCT0VPvZQchV3+xu84q1AQG1+wzCS6JflCSJPQztBERsJjORgtPlnGGItO6NxRi6hFOkTeP06Y5
 VsRx8zje0cgM=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With lazytime on the upper filesystem new timestamps stay in memory for up
to 12 hours, and syncfs() has to write them.  So the overlay inode must not
become clean during that time, or syncfs() on the overlay would miss them.
It should not stay dirty for that long either, because the flusher would
visit it on every pass and it could not be reclaimed.

When overlayfs writes an upper inode, or looks at it in ->write_inode(),
and it has deferred timestamps, hand them to the upper filesystem.  They
go out with that write, or with the next pass of the flusher of the upper
filesystem, and the overlay inode becomes clean after that.

This takes the benefit of lazytime away from inodes that are modified or
read through an overlay with fsync=relaxed.  The flusher looks at the inode
of a file that is open for writing up to every 5 seconds.

A syncfs() that meets a freeze of the upper filesystem leaves the
timestamps to the freeze.  One that meets a read-only remount of it that
fails leaves them to the next pass.

If the timestamps could not be handed over, writing the upper inode
without waiting moves it to the tail of b_dirty_time.  The sync of a freeze
or of a read-only remount that has just looked at the clock skips it there.
The timestamps are written after the thaw.  After a read-only remount they
stay in memory.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     | 10 +++++++---
 fs/overlayfs/util.c      | 29 +++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1d7b102a1127..676520ff026f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -523,6 +523,7 @@ enum ovl_write_mode {
 	OVL_WRITE_COMMIT,
 };
 
+void ovl_flush_lazytime(struct super_block *sb, struct inode *upper);
 int ovl_write_upper_inode(struct super_block *sb, struct inode *upper,
 			  enum ovl_write_mode mode);
 struct inode *ovl_inode_lower(struct inode *inode);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ccfbaf9d8797..f38c6dd2ae47 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -331,6 +331,7 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
  * all, see ovl_write_inode().  And a write_inode_now() that does not wait does
  * nothing if the flusher of the upper filesystem is writing @upper.  A
  * modification that was made during that pass is only recorded in the flags.
+ * I_DIRTY_TIME is only left if ovl_flush_lazytime() could not get rid of it.
  *
  * i_writecount has to be read first.  If it is seen at zero, the tag of a page
  * that was dirtied through a mapping must be seen as well.  The tag is set when
@@ -344,7 +345,7 @@ static bool ovl_upper_unfinished(struct inode *upper)
 	return atomic_read_acquire(&upper->i_writecount) > 0 ||
 	       mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) ||
 	       mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
-	       (inode_state_read_once(upper) & (I_DIRTY | I_SYNC));
+	       (inode_state_read_once(upper) & (I_DIRTY_ALL | I_SYNC));
 }
 
 static enum ovl_write_mode ovl_write_mode(struct inode *inode,
@@ -375,12 +376,15 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 	/*
 	 * Leave periodic and background writeback to the flusher of the upper
 	 * filesystem.  @upper is on its dirty list, and it knows when the data
-	 * is old enough to be written.  All there is to do here is to find out
-	 * whether the overlay inode can be clean again.
+	 * is old enough to be written.  All there is to do here is to hand over
+	 * deferred timestamps, and to find out whether the overlay inode can be
+	 * clean again.
 	 */
 	if (!wbc->for_kupdate && !wbc->for_background)
 		ret = ovl_write_upper_inode(inode->i_sb, upper,
 					    ovl_write_mode(inode, wbc));
+	else
+		ovl_flush_lazytime(inode->i_sb, upper);
 
 	if (ovl_upper_unfinished(upper))
 		ovl_mark_inode_dirty(inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d7b08a46cb76..16ca33e2b794 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1528,6 +1528,33 @@ void ovl_copyattr(struct inode *inode)
 	ovl_mark_inode_dirty(inode);
 }
 
+/*
+ * With lazytime the upper filesystem keeps new timestamps in memory for up to
+ * 12 hours.  syncfs() has to write them, so the overlay inode could not become
+ * clean for that long.  It would be pinned, and the flusher would visit it on
+ * every pass.  Do not wait.  Hand the timestamps to the upper filesystem, which
+ * then writes the inode like after any other change.
+ *
+ * Like touch_atime(), leave a filesystem alone that is being frozen or
+ * remounted read-only.  Both write the timestamps, and the overlay inode stays
+ * dirty until then, see ovl_upper_unfinished().
+ */
+void ovl_flush_lazytime(struct super_block *sb, struct inode *upper)
+{
+	struct vfsmount *mnt = ovl_upper_mnt(OVL_FS(sb));
+
+	if (!(inode_state_read_once(upper) & I_DIRTY_TIME))
+		return;
+
+	if (!sb_start_write_trylock(upper->i_sb))
+		return;
+	if (!mnt_get_write_access(mnt)) {
+		mark_inode_dirty_sync(upper);
+		mnt_put_write_access(mnt);
+	}
+	sb_end_write(upper->i_sb);
+}
+
 /*
  * Do what sync_inodes_sb() does to an inode: wait for the data, hand the inode
  * to the filesystem, and leave it to ->sync_fs() to commit it.  It gets there
@@ -1565,6 +1592,8 @@ int ovl_write_upper_inode(struct super_block *sb, struct inode *upper,
 {
 	int err;
 
+	ovl_flush_lazytime(sb, upper);
+
 	/* sync_inodes_sb() does not wait for such a filesystem either */
 	if (upper->i_sb->s_iflags & SB_I_NO_DATA_INTEGRITY)
 		mode = OVL_WRITE_START;

-- 
2.55.0


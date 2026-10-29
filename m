Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236188;
	b=w7tshVCFFLT3L3C71mU7kcLLD00Ac+wJLnj0yTjdqsi1Ii+IZor3v/pGq7iImPy2x5Iv
	 n+B8cMsY22QIictiDXB5+VN2ckn/DO0HGjwohg9s/pRK0aCymlM+Dxmqjpf1E4Q7KGwcL
	 VUUnAexhfM4E0pTAnucRtqUAFtgpyGQyHcE/b6vLyww3f5V6lKcUgIeqrwptHwEGLM0yl
	 fbKaBn/PYELLu1e8QamLlFb4bDTh21uWiDwvfuFvpB3DREAXm9GBBKM6yUlrbqbDMUyD3
	 J8k4p0ovTygRLTTD+McXnPFcI3nW8679qgCSSxuV7ARbnuYzU8BVgv6tC67aj/LoyvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236188;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=zsf5W+NaLCkvQlcPGx1mRCkHFxbDj0TsI0bo7unh56w=;
	b=zR8WzMpIF8c9/7MemhhFz7BVtIpEqRkWGLd9ZgfD3qZJX8Wp4WsFE1F9YJjU/7G6PT+m
	 cWyD7MrJc2XnxE+LjLTaoIek6rtE2CmqZW1Wm1g2IM6LLAyF0s7ZP8/zLqrt3AwXuZ8cu
	 ci9Oo0KqIgipnjk2C7gYg1r8+M7p0p1Dy4dSaN3/iQkLtlDSm/Vd3CQuKc1WpYRYHX97H
	 p8Wz+wvPelEmYiKvmIhX1GnN0ElxoXDSirljDMA9JRCuCiRO4vbs6gxfOVZzbF7FsGnq8
	 t5UpFlZW7n9sz4GKFg68IQwOPd+0K+Qt+uo8ukf3HXGyHej/a/T6VW4pXfekgddveog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=e7oAeNzP;
	arc=none smtp.remote-ip=209.85.222.179
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0656360A2626
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0656360A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=e7oAeNzP
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93cb9e9405fso81628985a.2
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236187; x=1793840987; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zsf5W+NaLCkvQlcPGx1mRCkHFxbDj0TsI0bo7unh56w=;
        b=e7oAeNzPyXwtr+ukA9mdzZtJcqS3hkdm3gIMpJ+yYCQXFidkafUrt/6aMC2KAbzScP
         mgAlGb+e0nj1R/bDAw47tyJAcYVIfE+EDUts4z0bLKPZ/gv5ooIQ/yj/xTsoTr33la/c
         Au3eEA26dtDN60zDI5wVbT26VYsv5n8O9bhmLmlh8RzXEPDmmRsG/lDZZgcx/BvlDi1B
         IP92nrmh62HZGvAUfAUfd4Ca7aL3E2L55fhLH7CeGF26Qx93ddqoeBEHJVRJ2+BItXIz
         8eddOpgUB7sxKFpkn0hl8muacdZlGDZjliQ3o87EDwPvJ8//Z9GpZMhat0HmFZIdI/Cd
         TH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236187; x=1793840987;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zsf5W+NaLCkvQlcPGx1mRCkHFxbDj0TsI0bo7unh56w=;
        b=TXzVQqFU2Yq6i4jDMlWbox5Y34gFN/BQVLPB8fPKLMPmwmau4cpl74zIx/Gj2GVAn7
         PDQ0XHycMrwzAUkfaot25e9frezweX3fP72Ly1fUM32qFrEBO0A7hksFOGx9yfyJ37kk
         HiLXcq6MN9/B3QD4qc5LuYQ4LTrBeHHzXN3YBLw2XU6rtlikdcqF/O74DmvYf1y9goQr
         QKK6gSLhlp26HLtvu+y2DvwXWYf+VNB+UxrGB7IhWmObMACzWVNkRRj3D6Azm7wmhxNz
         mATiNyJjQuIoqSW+fPYpOiEFZjb64tYCJKVOrhjHTdeNNnOHEUZIwk0h3jU3pb3GHD1W
         v03g==
X-Forwarded-Encrypted: i=1; AKwUvBzRFJVAVs6bSrlRD3usxwVIvI7uKpR3LkdLv+LYc3+DApvKYeaLAAz/t09q+yjGX9LfdU12/8MqN10a1jPs@vger.kernel.org
X-Gm-Message-State: AFq9FYKy6TdwFxeuGniPt1p6MirWNDPcez/Y9K5Yc3k0H6a7BTX3lTiS
	c6AfmcyoS5R/tI5wY3IvwbPkyooLcFady+UxyF7zA9j7pASgQ6DuG5o3wocevUnCWXc=
X-Gm-Gg: AYBFou22Y52esdy5wWQQezqhSg4k5GSqlAsRr2PvwutVbrah2uyvwedwnwwLyzGdFXa
	qL7He/5HTNLIYHCXQ4PUhHmjIG0ptm75P2ApLE4H9PZjG+w/Y5LP6BlcaDcG5m7R32oYcvfiVT2
	fG59rUze+73KzBuOdWhhZkbRg9ppnuP0ZsoXrR64yliIX+t57RCTnKab0cr25Zz+ctdDSNsEJDB
	zPbLAdqczYNKxb7fuQuHGistg//yBWnOU6fN0fm+r+LrEQnaRmd/w/A8WtYP8d+DCi5L05yTagY
	JlQ2S28VYEppXe5arRQjGhW+x1I9sGt+s3xU2vMc3rwq39PLiTCzTzUKQDyjo4pICYGrDtrstge
	ibAk+hyrfhpbBnJUD9DPkdSSC2W5bt+dQMA+4YlIqxXicryFPUQUH88tldavCt52Tqja5rf/81p
	Ol7Ii1MmxDoo/zZfSUu/roxt27gvlnplnvBH1CgBY/4U272FFB+5e+0i2ADRxOxmisyt0HYJsHu
	OAVE0hvWx2ExcipQBlUNOcm7juhUNvhcXSJ5v3jvC6UpwZFFl2ry21SGPOcML7Cg9M5IcAspVbR
	NMGXVHUhKWGUo7aMZrdzLxriIfcyzGDts/eOTu/PFZdLOA==
X-Received: by 2002:a05:620a:4001:b0:93c:ca09:aa34 with SMTP id af79cd13be357-94408cc0ed2mr621645085a.46.1793236186850;
        Wed, 28 Oct 2026 18:09:46 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a771c9sm1396738285a.34.2026.10.28.18.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:46 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Oct 2026 01:09:22 +0000
Subject: [PATCH v2 08/10] ovl: pass the ovl_fs to ovl_do_rename_rd()
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
Message-Id: <20261029-b4-ovl-containerized-sync-v2-8-4e9f08e4a052@toxicpanda.com>
References: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
In-Reply-To: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236166; l=3810;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=NM1I1v4Cd+302xpWk23F33TayPRCWrPMQmEPHoo2GAw=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGBudy0BlSLKWCowzrdoqc46Z6F7ygO69vTIhP92EGLQ2rNNjUCCATTOlLX6sAuL1ta8o7raZTG
 QmSWlhSax/gg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

It is the only helper that modifies the upper filesystem without getting
the ovl_fs, and the next patch needs it there.

No functional change intended.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/copy_up.c   |  4 ++--
 fs/overlayfs/dir.c       | 10 +++++-----
 fs/overlayfs/overlayfs.h |  5 +++--
 fs/overlayfs/super.c     |  2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 40486d2a4b30..c1e00ceab8fb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -563,7 +563,7 @@ static int ovl_create_index(struct dentry *dentry, const struct ovl_fh *fh,
 	if (err)
 		goto out;
 
-	err = ovl_do_rename_rd(&rd);
+	err = ovl_do_rename_rd(ofs, &rd);
 	end_renaming(&rd);
 out:
 	if (err)
@@ -819,7 +819,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 
 	err = ovl_copy_up_metadata(c, temp);
 	if (!err)
-		err = ovl_do_rename_rd(&rd);
+		err = ovl_do_rename_rd(ofs, &rd);
 	end_renaming(&rd);
 
 	if (err)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index fc47beffa67e..6f7a513bb5a6 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -141,7 +141,7 @@ int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *dir,
 	rd.flags = flags;
 	err = start_renaming_two_dentries(&rd, whiteout, dentry);
 	if (!err) {
-		err = ovl_do_rename_rd(&rd);
+		err = ovl_do_rename_rd(ofs, &rd);
 		end_renaming(&rd);
 	}
 	if (err)
@@ -449,7 +449,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (err)
 		goto out_cleanup;
 
-	err = ovl_do_rename_rd(&rd);
+	err = ovl_do_rename_rd(ofs, &rd);
 	end_renaming(&rd);
 	if (err)
 		goto out_cleanup_unlocked;
@@ -560,14 +560,14 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 			goto out_cleanup;
 
 		rd.flags = RENAME_EXCHANGE;
-		err = ovl_do_rename_rd(&rd);
+		err = ovl_do_rename_rd(ofs, &rd);
 		end_renaming(&rd);
 		if (err)
 			goto out_cleanup_unlocked;
 
 		ovl_cleanup(ofs, workdir, upper);
 	} else {
-		err = ovl_do_rename_rd(&rd);
+		err = ovl_do_rename_rd(ofs, &rd);
 		end_renaming(&rd);
 		if (err)
 			goto out_cleanup_unlocked;
@@ -1300,7 +1300,7 @@ static int ovl_rename_upper(struct ovl_renamedata *ovlrd, struct list_head *list
 	if (err)
 		goto out_unlock;
 
-	err = ovl_do_rename_rd(&rd);
+	err = ovl_do_rename_rd(ofs, &rd);
 
 	if (!err && ovlrd->cleanup_whiteout)
 		whiteout = dget(rd.new_dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f884e6695d2c..83e25700c8a0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -372,7 +372,8 @@ static inline int ovl_do_remove_acl(struct ovl_fs *ofs, struct dentry *dentry,
 	return vfs_remove_acl(ovl_upper_mnt_idmap(ofs), dentry, acl_name);
 }
 
-static inline int ovl_do_rename_rd(struct renamedata *rd)
+static inline int ovl_do_rename_rd(struct ovl_fs *ofs,
+				   struct renamedata *rd)
 {
 	int err;
 
@@ -399,7 +400,7 @@ static inline int ovl_do_rename(struct ovl_fs *ofs, struct dentry *olddir,
 		.flags		= flags,
 	};
 
-	return ovl_do_rename_rd(&rd);
+	return ovl_do_rename_rd(ofs, &rd);
 }
 
 static inline int ovl_do_whiteout(struct ovl_fs *ofs,
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index de3e2d0b29ee..c43f8fdd6230 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -732,7 +732,7 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 
 	/* Name is inline and stable - using snapshot as a copy helper */
 	take_dentry_name_snapshot(&name, temp);
-	err = ovl_do_rename_rd(&rd);
+	err = ovl_do_rename_rd(ofs, &rd);
 	end_renaming(&rd);
 	if (err) {
 		if (err == -EINVAL)

-- 
2.55.0


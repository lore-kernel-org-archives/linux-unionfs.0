Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83202C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 08:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65212206DD
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 08:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6ZETIQJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgEVI5e (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 04:57:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27923 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbgEVI5d (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 04:57:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590137851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bP0iqVtM6Px0zA+0+w2xKiJv+MfLMqu9uf18xW+5ad0=;
        b=U6ZETIQJmfBVcT4ZdEaeQVhNu2Kf6R+RBXfWY/Mx0VvMs8e4lM5rhkgtYnG/SMP8MRxbSf
        V5P8TLFbNXXozS+E1x2UKok0q7XVasVi37yp1q3Ohltr2e6Gl7oyLQoPW0KfJ5yDdcF2gC
        vNv4OKIeBD5FrlaOS6JloZ7JZ7os+5M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-bfwk9oRTP1qTLKAElnxOBw-1; Fri, 22 May 2020 04:57:27 -0400
X-MC-Unique: bfwk9oRTP1qTLKAElnxOBw-1
Received: by mail-ej1-f71.google.com with SMTP id gl5so4311886ejb.5
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 01:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bP0iqVtM6Px0zA+0+w2xKiJv+MfLMqu9uf18xW+5ad0=;
        b=Wce0u94YE12cvFvbN8H2h/I+wHpvivzSVnAW0q7BklkIEo8cXzWfHk/y8mwmnFXb21
         TNiiGgA8a2SVOkXStDApLcJ0V5U2jDJFq7al9aw80HATShn40tYNh9iD42/B6Joxm524
         HsVu1Q8t4rUikSQlCMjz5Yhuw0EzT1+QGo2KYT1bhp/xX6lk4Up6CGYyOmoInkq9RhrC
         8BJ6oYwHUF9/3sQBScOrqnntafhvYkUBOZ3PCkCJcM+044FEqQrqCyo4bHIuttVD6Wu0
         7bJcmqqXYgN7b2o8SZo4KVoRcNzpB6GEDxOt7GDWJka+BvmOrPjjLAcFJOCxVqa8djiH
         cFqQ==
X-Gm-Message-State: AOAM531K1GKsPJIpd/DbTs95Ky8HCs7M9P8NA3CnpL3yOBEWY9NAteij
        RDIRzkJK8cANTooU2ct/xQ1KuQySS9w4X2lY9EnZF+YoZ8eQx3tYtSCReSKLg6TXmQZSncGiDE+
        +ZoRWu5QAWYQBd77U38w48lN5Fw==
X-Received: by 2002:a17:906:710:: with SMTP id y16mr1189338ejb.97.1590137846287;
        Fri, 22 May 2020 01:57:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvx4ECuzfcO7Yxgs+SJ8eQIQb55bAIoTi0z35gS0XxAWZefQlHs/YisgXSN00cpaSGxqiJkA==
X-Received: by 2002:a17:906:710:: with SMTP id y16mr1189332ejb.97.1590137846052;
        Fri, 22 May 2020 01:57:26 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id h20sm7210041eja.61.2020.05.22.01.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 01:57:25 -0700 (PDT)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-unionfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] ovl: make private mounts longterm
Date:   Fri, 22 May 2020 10:57:23 +0200
Message-Id: <20200522085723.29007-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs is using clone_private_mount() to create internal mounts for
underlying layers.  These are used for operations requiring a path, such as
dentry_open().

Since these private mounts are not in any namespace they are treated as
short term, "detached" mounts and mntput() involves taking the global
mount_lock, which can result in serious cacheline pingpong.

Make these private mounts longterm instead, which trade the penalty on
mntput() for a slightly longer shutdown time due to an added RCU grace
period when putting these mounts.

Introduce a new helper kern_unmount_many() that can take care of multiple
longterm mounts with a single RCU grace period.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/namespace.c        | 16 ++++++++++++++++
 fs/overlayfs/super.c  | 19 ++++++++++++++-----
 include/linux/mount.h |  2 ++
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index a28e4db075ed..5d16d87b6b8b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1879,6 +1879,9 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	if (IS_ERR(new_mnt))
 		return ERR_CAST(new_mnt);
 
+	/* Longterm mount to be removed by kern_unmount*() */
+	new_mnt->mnt_ns = MNT_NS_INTERNAL;
+
 	return &new_mnt->mnt;
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
@@ -3804,6 +3807,19 @@ void kern_unmount(struct vfsmount *mnt)
 }
 EXPORT_SYMBOL(kern_unmount);
 
+void kern_unmount_many(struct vfsmount *mnt[], unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		if (mnt[i])
+			real_mount(mnt[i])->mnt_ns = NULL;
+	synchronize_rcu_expedited();
+	for (i = 0; i < num; i++)
+		mntput(mnt[i]);
+}
+EXPORT_SYMBOL(kern_unmount_many);
+
 bool our_mnt(struct vfsmount *mnt)
 {
 	return check_mnt(real_mount(mnt));
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 60dfb27bc12b..a938dd2521b2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -225,12 +225,21 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	dput(ofs->workbasedir);
 	if (ofs->upperdir_locked)
 		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
-	mntput(ofs->upper_mnt);
-	for (i = 1; i < ofs->numlayer; i++) {
-		iput(ofs->layers[i].trap);
-		mntput(ofs->layers[i].mnt);
+
+	if (!ofs->layers) {
+		/* Deal with partial setup */
+		kern_unmount(ofs->upper_mnt);
+	} else {
+		/* Hack!  Reuse ofs->layers as a mounts array */
+		struct vfsmount **mounts = (struct vfsmount **) ofs->layers;
+
+		for (i = 0; i < ofs->numlayer; i++) {
+			iput(ofs->layers[i].trap);
+			mounts[i] = ofs->layers[i].mnt;
+		}
+		kern_unmount_many(mounts, ofs->numlayer);
+		kfree(ofs->layers);
 	}
-	kfree(ofs->layers);
 	for (i = 0; i < ofs->numfs; i++)
 		free_anon_bdev(ofs->fs[i].pseudo_dev);
 	kfree(ofs->fs);
diff --git a/include/linux/mount.h b/include/linux/mount.h
index bf8cc4108b8f..e3e994bfcecb 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -109,4 +109,6 @@ extern unsigned int sysctl_mount_max;
 
 extern bool path_is_mountpoint(const struct path *path);
 
+extern void kern_unmount_many(struct vfsmount *mnt[], unsigned int num);
+
 #endif /* _LINUX_MOUNT_H */
-- 
2.21.1


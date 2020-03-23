Return-Path: <SRS0=0eJY=5I=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54C8C4332E
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 19:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77D72051A
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Mar 2020 19:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZUCg5wj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgCWTJB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 15:09:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32949 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbgCWTJB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Mar 2020 15:09:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id r7so767605wmg.0
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2020 12:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8Tgigb4uCARLyAFc90cRmjh9Wu2sjVgvF4ampomjYAU=;
        b=NZUCg5wj8ViHEH0D5w6er0wCFDKtXWF85zFY1/FZvF0xyjxTr16dX4H1GqsbqAde47
         AmGNsJ6GhvSZZyntmwmrzERszcN5vshQwaC8cQMQBTWvm1SUpX9SdPZPvC86X1teSw4A
         yQTXD0R8Z78hCAHoL95eR6NSQvsxZSs1v2aycymcVGG3WpftyGMbjlwO+mCVbqy6EjCh
         ATckIObmf4bMkIMPyxpEccZLancLRPXUcKxQAYH5xmB5mVMBhT1B9ghKONi80s9tX+J2
         RfQ2TjZLuRMhwHnO2+tBrNP5Q33GPDla6VSJKS5RCMBgk/zV7PFmkzu7ehatHHesThA0
         Zcmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8Tgigb4uCARLyAFc90cRmjh9Wu2sjVgvF4ampomjYAU=;
        b=YcLaiudoT90l8Xi49R701CZT65SwN4lNxnuTonwXk05xI81DZZXhF00KeHCvX6D4zU
         IHRpNK+NaMpuqEYTsbEqUhpImNMg0+CI4/jrqzRoYCrdn+GsVNhUJYkpPmfp9ehfQGwH
         cjNarxu0cBv3S5YE/YTPXtav8oSbX28DJxYJws04+FUnbVvMrHwPmooKXdWud1emTL0b
         cUybpGnXXHXpx5aZoNYzeWrcA0DGv9zjCMbCWQh8ruAyh8JPTV07SizdvdZUVV2RmZTA
         xGgaY9a+W4VjcSeX7AOmYqqYb31Sx4OGT5WaORjfNqVCRD4C5dQvyxgStYF29q5j8m8+
         eYdg==
X-Gm-Message-State: ANhLgQ3XuiVDsS41zRFV8B98zxw/hS2OgSDb3s4nlTw+/nS8V3cTIA3z
        NGayn542SmM4eZ1Jhk96rZ2jIp1z
X-Google-Smtp-Source: ADFU+vt6LwzdLTMl8Vg+nCbfwvySW169xwVPG/HuYSQVlZ7T+HfzNVkMBd7RECuopiWJ8D2gL7nN+g==
X-Received: by 2002:a05:600c:581:: with SMTP id o1mr889436wmd.111.1584990539283;
        Mon, 23 Mar 2020 12:08:59 -0700 (PDT)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id f14sm740275wmb.3.2020.03.23.12.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 12:08:58 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix WARN_ON nlink drop to zero
Date:   Mon, 23 Mar 2020 21:08:50 +0200
Message-Id: <20200323190850.3091-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Changes to underlying layers should not cause WARN_ON(), but this repro
does:

 mkdir w l u mnt
 sudo mount -t overlay -o workdir=w,lowerdir=l,upperdir=u overlay mnt
 touch mnt/h
 ln u/h u/k
 rm -rf mnt/k
 rm -rf mnt/h
 dmesg

 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 116244 at fs/inode.c:302 drop_nlink+0x28/0x40

After upper hardlinks were added while overlay is mounted, unlinking all
overlay hardlinks drops overlay nlink to zero before all upper inodes
are unlinked.

Detect too low i_nlink before unlink/rename and set the overlay nlink
to the upper inode nlink (minus one for an index entry).

Reported-by: Phasip <phasip@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Miklos,

This fix passed the reported reproducers (with index=off),
overlay/034 with (index=on) and overlay/034 with s/LOWER/UPPER:

 -lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK

As well as the rest of overlay/quick group.

I will post the overlay/034 fork as a separate test later.

Thanks,
Amir.

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 36b60788ee47..e894a14857c7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -734,7 +734,9 @@ static void ovl_cleanup_index(struct dentry *dentry)
 int ovl_nlink_start(struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
+	struct inode *iupper = ovl_inode_upper(inode);
 	const struct cred *old_cred;
+	int index_nlink;
 	int err;
 
 	if (WARN_ON(!inode))
@@ -764,7 +766,26 @@ int ovl_nlink_start(struct dentry *dentry)
 	if (err)
 		return err;
 
-	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, inode))
+	if (d_is_dir(dentry))
+		goto out;
+
+	/* index adds +1 to upper nlink */
+	index_nlink = !!ovl_test_flag(OVL_INDEX, inode);
+	if (iupper && (iupper->i_nlink - index_nlink) > inode->i_nlink) {
+		pr_warn_ratelimited("inode nlink too low (%pd2, ino=%lu, nlink=%u, upper_nlink=%u)\n",
+				    dentry, inode->i_ino, inode->i_nlink,
+				    iupper->i_nlink - index_nlink);
+		/*
+		 * Upper hardlinks were added while overlay is mounted.
+		 * Unlinking all overlay hardlinks would drop overlay nlink to
+		 * zero before all upper inodes are unlinked.  As a safety
+		 * measure, when that situation is detected, set the overlay
+		 * nlink to the upper inode nlink minus one for the index entry.
+		 */
+		set_nlink(d_inode(dentry), iupper->i_nlink - index_nlink);
+	}
+
+	if (!index_nlink)
 		goto out;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
-- 
2.17.1


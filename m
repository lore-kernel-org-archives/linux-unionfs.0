Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604EEC88CB2
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 13:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbjIDNYx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjIDNYu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 09:24:50 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827F4C1
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 06:24:47 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-401b5516104so14221345e9.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 06:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693833886; x=1694438686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v/SC07s540vJG4374KyhVRU0O6m71PwbG6X0SG009wo=;
        b=QfQvIiXHzev5OlQ7I86GDu6/q0wNlmdp9+7IIAjUsZJ8LB9CAayTIIPC/tRE9v8Lsr
         EVEXeICI1/nN33drtj7GsuklmjBKrXWZ8Zf540R0L0Vahf1JuGWyyJly+OS3+68h8ZPD
         hcpyl/bpK3eXasCPfQNrx6sNVENKU957HCztakspRBwegLhO2fIrl0bpqSSPFvcV39fv
         pIlnI9CdSXRMY9FYJpVu2gv8nbWU+V7mfhoIYad7N4NXd9MnDIY4g+8RA18s7bvFVJ9q
         wBwxVv4Dg7txF5ZKh+ZSe9/oIKr/wRALhtwNev02wA3gsSWUYWmXHFAAoE7S+N0biJg6
         QDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693833886; x=1694438686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v/SC07s540vJG4374KyhVRU0O6m71PwbG6X0SG009wo=;
        b=HalmVbGf39XxE68ujyvbRgjBlaXaO3EB3mClIfEcBepb0RepBGm93WfnlNJP9i579u
         rV05ojFZIj3GWfm3OH+q6K6rb4d7mISbIN4VWo+0wHpf3Qc+Zdoay9bR0ywpDZ+uMZ7q
         VFRXlzy7DEp7b9AFkW1ko8lTdTyC20zkfeSTc86DK962buYvJSxgOzZREgyfVJV5da+K
         nKN1ix1hK/Jst4Z9n93sruzOQSmKGZYmqrUPyWsPFQEYoEfAYT1yvkbWYYObUqMII68+
         XrCIIgJeI4Q14DVEZ0n9n52FnBOxoyLl/rj3yxfgd86bIz/u57r1bSG9t3TrLdXjwtZe
         /xRg==
X-Gm-Message-State: AOJu0YzrSBHPzTSkbdvMeAzkFMsitRPbkNO44laeQCVT9Bu+Gkv4KLL2
        vSvx6q0XFUKAz+1XDIE6bhs=
X-Google-Smtp-Source: AGHT+IEruNB/fNR1uvhM1IvuvY01KSRuy/xAw47lTOu79nzPA4Y/MkZ5CidWMiAbDcGDB9tPs5GKhg==
X-Received: by 2002:a7b:c4c7:0:b0:3fe:d6bf:f314 with SMTP id g7-20020a7bc4c7000000b003fed6bff314mr6844657wmk.39.1693833885643;
        Mon, 04 Sep 2023 06:24:45 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id r5-20020adfe685000000b003143867d2ebsm14572736wrm.63.2023.09.04.06.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 06:24:45 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix failed copyup of fileattr on a symlink
Date:   Mon,  4 Sep 2023 16:24:41 +0300
Message-Id: <20230904132441.2680355-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Some local filesystems support setting persistent fileattr flags
(e.g. FS_NOATIME_FL) on directories and regular files via ioctl.
Some of those persistent fileattr flags are reflected to vfs as
in-memory inode flags (e.g. S_NOATIME).

Overlayfs uses the in-memory inode flags (e.g. S_NOATIME) on a lower file
as an indication that a the lower file may have persistent inode fileattr
flags (e.g. FS_NOATIME_FL) that need to be copied to upper file.

However, in some cases, the S_NOATIME in-memory flag could be a false
indication for persistent FS_NOATIME_FL fileattr. For example, with NFS
and FUSE lower fs, as was the case in the two bug reports, the S_NOATIME
flag is set unconditionally for all inodes.

Users cannot set persistent fileattr flags on symlinks and special files,
but in some local fs, such as ext4/btrfs/tmpfs, the FS_NOATIME_FL fileattr
flag are inheritted to symlinks and special files from parent directory.

In both cases described above, when lower symlink has the S_NOATIME flag,
overlayfs will try to copy the symlink's fileattrs and fail with error
ENOXIO, because it could not open the symlink for the ioctl security hook.

To solve this failure, do not attempt to copyup fileattrs for anything
other than directories and regular files.

Reported-by: Ruiwen Zhao <ruiwen@google.com>
Link: https://lore.kernel.org/r/CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com/
Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
Cc: <stable@vger.kernel.org> # v5.15
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Miklos,

Do you agree with this solution?

See fstests at:
https://github.com/amir73il/xfstests/blob/overlayfs-devel/tests/overlay/082

Thanks,
Amir.

 fs/overlayfs/copy_up.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index bae404a1bad4..d1761ec5866a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -618,7 +618,8 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	if (err)
 		return err;
 
-	if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
+	if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
+	    (S_ISREG(c->stat.mode) || S_ISDIR(c->stat.mode))) {
 		/*
 		 * Copy the fileattr inode flags that are the source of already
 		 * copied i_flags
-- 
2.34.1


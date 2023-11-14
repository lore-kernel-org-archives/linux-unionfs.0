Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999A3C4167B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbjKNPdG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjKNPdF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:05 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEB7113
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:02 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4083ac51d8aso47221085e9.2
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975981; x=1700580781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cTybT1DEdzk/cSRklxmUP0QlkFSlsXsUZjl8wvTj3U=;
        b=bJheQ/LVPMQ1oaKv18AEuZL7Ip80DxLOE0UtLOkoT9hTPoSVUJ3mrXrtYteB2RF9l2
         lgjcKglFCP6QgnDzaDCR+/mc3XzHBrees6r5P2zb8V+X8iBmoNmVrbcIThbaZ7xobsNZ
         wXN2WTbIIkGMG3WOnoYUs4XZ+w5OT3UA2B8mmKq38SXQms8keaSgGGpWuaqDI1i1RjKG
         pq8rN4/uR6H0Fpkt48Od7hwvtzhGb7PI5C46G0MFRJHYUYgRXdDpsWoSP/RXquxeeVCb
         PXOSgJ1sHEdr9R8NPaUjxHoqXYvNFgjt1Cm2F6UQV282jZTHrhKXPzUkoYDlmVA2nYhc
         ieMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975981; x=1700580781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/cTybT1DEdzk/cSRklxmUP0QlkFSlsXsUZjl8wvTj3U=;
        b=BYLde72S/1Pa1L3RDKOrnEPoEguOh32Xj6djI7WutBrd/DaLfGIRqK7/AWQl/tDFZ1
         MiNMN4zXMMIVR29oLhpw2AFDJOvot79GkajKIUA8asd2mYjNHvcWuZ8PAq3XZ27guVMa
         PMR1/O9DnI/seiSHsRZemmK/VkAM9p0U/Uw6M87dL6nPxaN4SWfujUwTycItzj2rB6Qu
         MY8UDOd8AG+EoHyLPbFJyUwBJMS7a926/xSc8PY8baUWH5RQDW7SGhe+MX8Fp5xL5lVM
         zDy2VeyKTVjflq9I/J9geP+dMvYdsa272mlNstDYksVTQUhCFZNW513APRZJIS1GCjsD
         tj+Q==
X-Gm-Message-State: AOJu0YwmUn5XzN28rJqddyTE2FIi+1+5cJ92P0iWcjPkNlO28JwW3y8I
        p/HEW9+fsiV14hOwUaSlCdE=
X-Google-Smtp-Source: AGHT+IG+T/OUkO5pVMtLdxa7bCcpAlhoK527Ci7+lAUsme/bIPZKTnGp5bqGa0HmPfQGMbCOCfjV2g==
X-Received: by 2002:a05:600c:2d8b:b0:406:4573:81d2 with SMTP id i11-20020a05600c2d8b00b00406457381d2mr8462588wmg.39.1699975980739;
        Tue, 14 Nov 2023 07:33:00 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:00 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 01/15] ovl: add permission hooks outside of do_splice_direct()
Date:   Tue, 14 Nov 2023 17:32:40 +0200
Message-Id: <20231114153254.1715969-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The main callers of do_splice_direct() also call rw_verify_area() for
the entire range that is being copied, e.g. by vfs_copy_file_range()
or do_sendfile() before calling do_splice_direct().

The only caller that does not have those checks for entire range is
ovl_copy_up_file().  In preparation for removing the checks inside
do_splice_direct(), add rw_verify_area() call in ovl_copy_up_file().

For extra safety, perform minimal sanity checks from rw_verify_area()
for non negative offsets also in the copy up do_splice_direct() loop
without calling the file permission hooks.

This is needed for fanotify "pre content" events.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4382881b0709..106f8643af3b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -230,6 +230,19 @@ static int ovl_copy_fileattr(struct inode *inode, const struct path *old,
 	return ovl_real_fileattr_set(new, &newfa);
 }
 
+static int ovl_verify_area(loff_t pos, loff_t pos2, loff_t len, loff_t totlen)
+{
+	loff_t tmp;
+
+	if (WARN_ON_ONCE(pos != pos2))
+		return -EIO;
+	if (WARN_ON_ONCE(pos < 0 || len < 0 || totlen < 0))
+		return -EIO;
+	if (WARN_ON_ONCE(check_add_overflow(pos, len, &tmp)))
+		return -EIO;
+	return 0;
+}
+
 static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 			    struct file *new_file, loff_t len)
 {
@@ -244,13 +257,20 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 	int error = 0;
 
 	ovl_path_lowerdata(dentry, &datapath);
-	if (WARN_ON(datapath.dentry == NULL))
+	if (WARN_ON_ONCE(datapath.dentry == NULL) ||
+	    WARN_ON_ONCE(len < 0))
 		return -EIO;
 
 	old_file = ovl_path_open(&datapath, O_LARGEFILE | O_RDONLY);
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
 
+	error = rw_verify_area(READ, old_file, &old_pos, len);
+	if (!error)
+		error = rw_verify_area(WRITE, new_file, &new_pos, len);
+	if (error)
+		goto out_fput;
+
 	/* Try to use clone_file_range to clone up within the same fs */
 	ovl_start_write(dentry);
 	cloned = do_clone_file_range(old_file, 0, new_file, 0, len, 0);
@@ -309,6 +329,10 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 			}
 		}
 
+		error = ovl_verify_area(old_pos, new_pos, this_len, len);
+		if (error)
+			break;
+
 		ovl_start_write(dentry);
 		bytes = do_splice_direct(old_file, &old_pos,
 					 new_file, &new_pos,
-- 
2.34.1


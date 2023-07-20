Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36673EB64DA
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Jul 2023 15:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjGTPi6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 11:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbjGTPiY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Jul 2023 11:38:24 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40603AA8
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Jul 2023 08:37:40 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fc0aecf107so7530315e9.2
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Jul 2023 08:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689867459; x=1690472259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIvcJXdM60LB2TB3aAYivhwb7AsrdPall/cf6y9Dv0M=;
        b=WSFnx84+yzx4wETdZz7PWNuHWcjzFJ0tVO2R3U6+fryLNcPz9dpY4DfQjbMIcVuwZc
         QHeUXGAlVpVydER4l482yOahCxj3amhICuEJAoq1Mvpz+dzJvddJnkPmK8dbaoyqm6bl
         aY44LaOMXpXtcTYKbI/rRmk3E6JXLiKSPEMQhcDPBSmOiFul49bL/IkP+tZouIbkNkqg
         XY/rZPwXeHDuziWcHE/7R7wLl9ruomHLrY73mPBRHbFNtHNDcTc+RC696yQEVzFZsFIR
         I5fNwZcVRskITSIRL5JxVX0JqIdQzKKxDTuo3mupjGBfMhikjT0e2hGJ9Jqh/IGsrhow
         cbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689867459; x=1690472259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIvcJXdM60LB2TB3aAYivhwb7AsrdPall/cf6y9Dv0M=;
        b=PgswflnWkh796hdoT0lMkiOjIlywRyn+Ub6GIO7HCPZskSUMW65KDRrS5SXzygdU/8
         XLq9VNDHDA3IUXq/sqlHnF2f5Wlr8/nPRoWKv7yvFMq6WkdT/4m+SPX8CNEVF3ac9XX9
         r3UiN81YSnXbHFDkr3tSTQn+UD2M6CEl30k9drK/sgo6FzFFoA2iJ1FTShlbEYe2cRrp
         fYHUODQI8qfACJylCHOSKR+0PCQ04UziGzVk11bFe6RVAgQ6Vc71mtUp2YyedRxVx7tG
         uJBfu2brCwH6OFd2LVKBEKJBqytC7rnht/VlrUvMXErIkZxkyC1ngqGRrSH2lpS6UZYU
         OrnQ==
X-Gm-Message-State: ABy/qLZ5YYuydpiyIOQMeh8mSYuFPtk3XyAdq8HTNxxAAGsAk1QG1pb7
        AW8ZDZ8fBihqKlESFXdAv5bJQqxVGoY=
X-Google-Smtp-Source: APBJJlFdt+VXFhEsXZOzSPN0R7C/c5BQwFzqqWW8hBUSUQ1I6lzGTAlEZiutxWFO/+gdpB2YQetI/Q==
X-Received: by 2002:a7b:ce12:0:b0:3fb:ffba:cd76 with SMTP id m18-20020a7bce12000000b003fbffbacd76mr2143262wmc.11.1689867459055;
        Thu, 20 Jul 2023 08:37:39 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id q14-20020a1cf30e000000b003fbe561f6a3sm4235715wmq.37.2023.07.20.08.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 08:37:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Subject: [PATCH 2/2] ovl: avoid lockdep warning with open and llseek of lower file
Date:   Thu, 20 Jul 2023 18:37:31 +0300
Message-Id: <20230720153731.420290-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230720153731.420290-1-amir73il@gmail.com>
References: <20230720153731.420290-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

overlayfs file open (ovl_maybe_lookup_lowerdata) and overlay file llseek
take the ovl_inode_lock, without holding upper sb_writers.

In case of nested lower overlay that uses same upper fs as this overlay,
lockdep will warn about (possibly false positive) circular lock
dependency when doing open/llseek of lower ovl file during copy up with
our upper sb_writers held, because the locking ordering seems reverse to
the locking order in ovl_copy_up_start():

- lower ovl_inode_lock
- upper sb_writers

Drop upper sb_writers for lower file open and llseek to avoid the
lockdep warning.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7e09c3187274..467107bb9f0e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -233,6 +233,7 @@ static int ovl_copy_fileattr(struct inode *inode, const struct path *old,
 static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 			    struct file *new_file, loff_t len)
 {
+	struct super_block *upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
 	struct path datapath;
 	struct file *old_file;
 	loff_t old_pos = 0;
@@ -247,9 +248,21 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 	if (WARN_ON(datapath.dentry == NULL))
 		return -EIO;
 
+	/*
+	 * Drop upper sb_writers to avert lockdep warning with open of lower
+	 * file in nested overlay:
+	 * - upper sb_writers
+	 * -- lower ovl_inode_lock (ovl_maybe_lookup_lowerdata)
+	 *
+	 * In case lower ovl uses same upper as this ovl, lockdep will warn
+	 * about (possibly false positive) circular lock dependency because the
+	 * ordering above is reverse to the order in ovl_copy_up_start().
+	 */
+	sb_end_write(upper_sb);
 	old_file = ovl_path_open(&datapath, O_LARGEFILE | O_RDONLY);
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
+	sb_start_write(upper_sb);
 
 	/* Try to use clone_file_range to clone up within the same fs */
 	cloned = do_clone_file_range(old_file, 0, new_file, 0, len, 0);
@@ -287,10 +300,16 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 		 * it may not recognize all kind of holes and sometimes
 		 * only skips partial of hole area. However, it will be
 		 * enough for most of the use cases.
+		 *
+		 * Drop upper sb_writers to avert lockdep warning with
+		 * llseek of lower file in nested overlay:
+		 * - upper sb_writers
+		 * -- lower ovl_inode_lock (ovl_llseek)
 		 */
-
 		if (skip_hole && data_pos < old_pos) {
+			sb_end_write(upper_sb);
 			data_pos = vfs_llseek(old_file, old_pos, SEEK_DATA);
+			sb_start_write(upper_sb);
 			if (data_pos > old_pos) {
 				hole_len = data_pos - old_pos;
 				len -= hole_len;
-- 
2.34.1


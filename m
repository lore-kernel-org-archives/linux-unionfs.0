Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF3DDA6;
	Tue, 30 Apr 2024 03:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714448940; cv=none; b=XfsmCF04eH5k8nps7ENJRhggPqDWXxE6OfWko4oykwOZeZ9T4SgtJsMlARDN7siZ5+kNUXipPpg/5k0SCXt0GCnXDnx/akSO5ybIXJM8Rl9/uuYw9hk2MkICrApz6qXcn3i7uOEPV0+YZZHpvezn74CoPC4ta/HpxOFZVc6CRn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714448940; c=relaxed/simple;
	bh=ck1aZwQ49wiF6650/y3Fd0edDmmLYkPXeji2D5ccG1M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G+dbdEW6mfmYLyMdDz6e+4r5SfA7gB7sX62S2DWQLlviZeGBqvAi07vFH4Ryyyjg/h0MiEcsadqfYzIeqebBFTDh7KnzLpe0YcZINroWqQEZ/WobVh4aUJtpfnLyDyPoj0vX1MTyUyrO6z05jZQ6sXkexElaWJRJAEky7JiVPyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Sthx9++5; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Sthx9++5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1714448936; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=LHgmlMnWiTL7VMF+EvFDp3WPEp9YHdbnDCQmrGY9IhA=;
	b=Sthx9++5kg+CcP1GPg0457NUDBlEyP7xGvhUj+UuNggTd/0ephjaSDITD1iMKElT7u3GDr3uNIQlgSYTfYVIUSlec5jt/3aLCIx9bCao5/W/Ry9pZN3KcuXYAZTqcoNQaoxYrN3yCbhlAbvs/xk2VsxzfGi5I3cC1n2H6/g7gDA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014016;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W5aqHHx_1714448934;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0W5aqHHx_1714448934)
          by smtp.aliyun-inc.com;
          Tue, 30 Apr 2024 11:48:55 +0800
From: Jingbo Xu <jefflexu@linux.alibaba.com>
To: sashal@kernel.org,
	gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Subject: [STABLE 6.6.y] ovl: fix memory leak in ovl_parse_param()
Date: Tue, 30 Apr 2024 11:48:54 +0800
Message-Id: <20240430034854.126947-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

commit 37f32f52643869131ec01bb69bdf9f404f6109fb upstream.

On failure to parse parameters in ovl_parse_param_lowerdir(), it is
necessary to update ctx->nr with the correct nr before using
ovl_reset_lowerdirs() to release l->name.

Reported-and-tested-by: syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com
Fixes: c835110b588a ("ovl: remove unused code in lowerdir param parsing")
Co-authored-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
---
Commit c835110b588a ("ovl: remove unused code in lowerdir param
parsing") was back ported to 6.6.y as a "Stable-dep-of" of commit
2824083db76c ("ovl: Always reject mounting over case-insensitive
directories"), while omitting the fix for commit c835110b588a itself.
Maybe that is because by the time commit 37f32f526438 (the fix) is merged
into master branch, commit c835110b588a has not been back ported to 6.6.y
yet.

This causes ltp test warning on vfat (EBUSY when umounting) [1]:
tst_test.c:1701: TINFO: === Testing on vfat ===
tst_test.c:1117: TINFO: Formatting /dev/loop0 with vfat opts='' extra opts=''
tst_test.c:1131: TINFO: Mounting /dev/loop0 to /tmp/ltp-XeGbUgDq5N/LTP_fankzf5WQ/mntpoint fstyp=vfat flags=0
fanotify13.c:152: TINFO: Test #0.1: FAN_REPORT_FID with mark flag: FAN_MARK_INODE
fanotify13.c:157: TCONF: overlayfs not supported on vfat
fanotify13.c:152: TINFO: Test #1.1: FAN_REPORT_FID with mark flag: FAN_MARK_INODE
fanotify13.c:157: TCONF: overlayfs not supported on vfat
fanotify13.c:152: TINFO: Test #2.1: FAN_REPORT_FID with mark flag: FAN_MARK_MOUNT
fanotify13.c:157: TCONF: overlayfs not supported on vfat
fanotify13.c:152: TINFO: Test #3.1: FAN_REPORT_FID with mark flag: FAN_MARK_MOUNT
fanotify13.c:157: TCONF: overlayfs not supported on vfat
fanotify13.c:152: TINFO: Test #4.1: FAN_REPORT_FID with mark flag: FAN_MARK_FILESYSTEM
fanotify13.c:157: TCONF: overlayfs not supported on vfat
fanotify13.c:152: TINFO: Test #5.1: FAN_REPORT_FID with mark flag: FAN_MARK_FILESYSTEM
fanotify13.c:157: TCONF: overlayfs not supported on vfat
tst_device.c:408: TINFO: umount('mntpoint') failed with EBUSY, try  1...
tst_device.c:412: TINFO: Likely gvfsd-trash is probing newly mounted fs, kill it to speed up tests.
tst_device.c:408: TINFO: umount('mntpoint') failed with EBUSY, try  2...
tst_device.c:408: TINFO: umount('mntpoint') failed with EBUSY, try  3...
tst_device.c:408: TINFO: umount('mntpoint') failed with EBUSY, try  4...

Reproduce:
/opt/ltp/runltp -f syscalls -s fanotify13

The original fix is applied to 6.6.y without conflict.

[1] https://lists.linux.it/pipermail/ltp/2023-November/036189.html
---
 fs/overlayfs/params.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index ad3593a41fb5..488f920f79d2 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -438,7 +438,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	struct ovl_fs_context *ctx = fc->fs_private;
 	struct ovl_fs_context_layer *l;
 	char *dup = NULL, *iter;
-	ssize_t nr_lower = 0, nr = 0, nr_data = 0;
+	ssize_t nr_lower, nr;
 	bool data_layer = false;
 
 	/*
@@ -490,6 +490,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	iter = dup;
 	l = ctx->lower;
 	for (nr = 0; nr < nr_lower; nr++, l++) {
+		ctx->nr++;
 		memset(l, 0, sizeof(*l));
 
 		err = ovl_mount_dir(iter, &l->path);
@@ -506,10 +507,10 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			goto out_put;
 
 		if (data_layer)
-			nr_data++;
+			ctx->nr_data++;
 
 		/* Calling strchr() again would overrun. */
-		if ((nr + 1) == nr_lower)
+		if (ctx->nr == nr_lower)
 			break;
 
 		err = -EINVAL;
@@ -519,7 +520,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			 * This is a regular layer so we require that
 			 * there are no data layers.
 			 */
-			if ((ctx->nr_data + nr_data) > 0) {
+			if (ctx->nr_data > 0) {
 				pr_err("regular lower layers cannot follow data lower layers");
 				goto out_put;
 			}
@@ -532,8 +533,6 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		data_layer = true;
 		iter++;
 	}
-	ctx->nr = nr_lower;
-	ctx->nr_data += nr_data;
 	kfree(dup);
 	return 0;
 
-- 
2.19.1.6.gb485710b


Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C161940A1;
	Fri, 14 Feb 2025 21:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739569926; cv=none; b=cm/AYR5zxvm9Pt7t12VfNk71pqjz3oPD39oRVcHb4RTR1mIRxo62yCB60jgOsQdxP9MfIXg5MW9RlQbTXMpZvDfS4HklR5gy5XdIOFOKD7lc6RhxnVaeVtBoImX1iZPGAEyn+rVoPUyx9yKXylz1eTP46p61iEBdZPhpjUsI7OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739569926; c=relaxed/simple;
	bh=G3K95h94iYD9zS9lmKkAWqoCHpM/BvBxxToKhcC252A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KRABveyawN/12lxY7VubfDU8A0aA8H9H580Wh4JvWUF7ta2DEZgrH6KB3mWRbJS5OOvvB42ybxKTyf0cNm0R2Tvbi1SzWnj5+N3yfbSe9Tw8FCFwagUUXc1cwwnGPdYGzTtB8XDteynxRg38vMdQXhAuWVSuBYwSOwOqnnqt9js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [178.76.204.78])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 7CD582336E;
	Sat, 15 Feb 2025 00:51:54 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	linux-unionfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org,
	syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com
Subject: [PATCH] ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up
Date: Sat, 15 Feb 2025 00:51:48 +0300
Message-Id: <20250214215148.761147-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The issue was caused by dput(upper) being called before
ovl_dentry_update_reval(), while upper->d_flags was still
accessed in ovl_dentry_remote().

Move dput(upper) after its last use to prevent use-after-free.

BUG: KASAN: slab-use-after-free in ovl_dentry_remote fs/overlayfs/util.c:162 [inline]
BUG: KASAN: slab-use-after-free in ovl_dentry_update_reval+0xd2/0xf0 fs/overlayfs/util.c:167

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0xc3/0x620 mm/kasan/report.c:488
 kasan_report+0xd9/0x110 mm/kasan/report.c:601
 ovl_dentry_remote fs/overlayfs/util.c:162 [inline]
 ovl_dentry_update_reval+0xd2/0xf0 fs/overlayfs/util.c:167
 ovl_link_up fs/overlayfs/copy_up.c:610 [inline]
 ovl_copy_up_one+0x2105/0x3490 fs/overlayfs/copy_up.c:1170
 ovl_copy_up_flags+0x18d/0x200 fs/overlayfs/copy_up.c:1223
 ovl_rename+0x39e/0x18c0 fs/overlayfs/dir.c:1136
 vfs_rename+0xf84/0x20a0 fs/namei.c:4893
...
 </TASK>

Fixes: b07d5cc93e1b ("ovl: update of dentry revalidate flags after copy up")
Reported-by: syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=316db8a1191938280eb6
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0c28e5fa34077..d7310fcf38881 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -618,7 +618,6 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
 		err = ovl_do_link(ofs, ovl_dentry_upper(c->dentry), udir, upper);
-		dput(upper);
 
 		if (!err) {
 			/* Restore timestamps on parent (best effort) */
@@ -626,6 +625,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 			ovl_dentry_set_upper_alias(c->dentry);
 			ovl_dentry_update_reval(c->dentry, upper);
 		}
+		dput(upper);
 	}
 	inode_unlock(udir);
 	if (err)
-- 
2.42.2


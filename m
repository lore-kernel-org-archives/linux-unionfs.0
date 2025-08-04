Received: from neil.brown.name (neil.brown.name [103.29.64.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBDD15DBC1;
	Mon,  4 Aug 2025 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.29.64.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309506; cv=none; b=LPQPH42MGXmqn7W9f51wGoZA5RQcBDN7DaFy1ZWXFEm6kbDlburY+aywWw8XFaT9nNQn77ONZrs9wGB3mj67mAGqeUou1a5Uy6E64kUcaH3rv/uJTnBmcrUkfE6nud1KPAqYO5hf7TY+ZC1PkJYxlNX+yLZE9rW2auGnAYsKnrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309506; c=relaxed/simple;
	bh=HZYJYovbap4LZlUOMuPXEpnsAzBda5MmeXAe7HICO2A=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=KXmk9hnxeWyZryFBJZnLeKj9v0STJgDGLHuQaLHQQTpiX95X+bBdyd5UsAhNzuphKmOP8vbIRKfCSc73JzR795xVPsDYtHCSP1dAWqo2wA1qvlC80ZinmG7RI7Up1n2Mcu8UptnWhebtioE8O5jZz7a+4LZmzZqSxVqBbWdq0Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name; spf=pass smtp.mailfrom=neil.brown.name; arc=none smtp.client-ip=103.29.64.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=neil.brown.name
Received: from 196.186.233.220.static.exetel.com.au ([220.233.186.196] helo=home.neil.brown.name)
	by neil.brown.name with esmtp (Exim 4.95)
	(envelope-from <mr@neil.brown.name>)
	id 1uiu2K-004SOk-Tr;
	Mon, 04 Aug 2025 12:11:30 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neil@brown.name>
To: "Amir Goldstein" <amir73il@gmail.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
 "Miklos Szeredi"  <miklos@szeredi.hu>,
 "Christian Brauner" <brauner@kernel.org>
Cc: Alan Huang <mmpgouride@gmail.com>,
 syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, linux-unionfs@vger.kernel.org
Subject:
 [PATCH] ovl: use I_MUTEX_PARENT when locking parent in ovl_create_temp()
In-reply-to:
 <CAOQ4uxi=bHN+UuTGHF8AH=GwJcED94KAPE0GAgB5zmv3PEhU8g@mail.gmail.com>
References:
 <CAOQ4uxi=bHN+UuTGHF8AH=GwJcED94KAPE0GAgB5zmv3PEhU8g@mail.gmail.com>
Date: Mon, 04 Aug 2025 22:11:28 +1000
Message-id: <175430948898.2234665.11303643314523472166@noble.neil.brown.name>


ovl_create_temp() treats "workdir" as a parent in which it creates an
object so it should use I_MUTEX_PARENT.

Prior to the commit identified below the lock was taken by the caller
which sometimes used I_MUTEX_PARENT and sometimes used I_MUTEX_NORMAL.
The use of I_MUTEX_NORMAL was incorrect but unfortunately copied into
ovl_create_temp().

Note to backporters: This patch only applies after the last Fixes given
below (post v6.16).  To fix the bug in v6.7 and later the
inode_lock() call in ovl_copy_up_workdir() needs to nest using
I_MUTEX_PARENT.

Link: https://lore.kernel.org/all/67a72070.050a0220.3d72c.0022.GAE@google.com/
Cc: stable@vger.kernel.org
Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Fixes: c63e56a4a652 ("ovl: do not open/llseek lower file with upper sb_writer=
s held")
Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/overlayfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 70b8687dc45e..dbd63a74df4b 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -225,7 +225,7 @@ struct dentry *ovl_create_temp(struct ovl_fs *ofs, struct=
 dentry *workdir,
 			       struct ovl_cattr *attr)
 {
 	struct dentry *ret;
-	inode_lock(workdir->d_inode);
+	inode_lock_nested(workdir->d_inode, I_MUTEX_PARENT);
 	ret =3D ovl_create_real(ofs, workdir,
 			      ovl_lookup_temp(ofs, workdir), attr);
 	inode_unlock(workdir->d_inode);



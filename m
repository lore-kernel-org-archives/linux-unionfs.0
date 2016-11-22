From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] overlayfs: fix ovl_get_redirect() error handling
Date: Tue, 22 Nov 2016 15:29:13 +0100
Message-ID: <20161122142921.1801734-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:63695 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933360AbcKVO3i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Nov 2016 09:29:38 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, Vivek Goyal <vgoyal@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Konstantin Khlebnikov <koct9i@gmail.com>, Antonio Murdaca <amurdaca@redhat.com>, Maxim Patlasov <mpatlasov@virtuozzo.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

The newly introduced ovl_get_redirect() function returns an unintialized
variable when kmalloc() fails:

fs/overlayfs/dir.c: In function ‘ovl_set_redirect’:
fs/overlayfs/overlayfs.h:92:6: error: ‘ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]

This makes it return -ENOMEM instead.

Fixes: 496654b0792e ("ovl: redirect on rename-dir")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/overlayfs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index bc7c62c7a72f..fb9fce0112f0 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -798,8 +798,10 @@ static char *ovl_get_redirect(struct dentry *dentry, bool samedir)
 	}
 
 	buf = kmalloc(buflen, GFP_TEMPORARY);
-	if (!buf)
+	if (!buf) {
+		ret = ERR_PTR(-ENOMEM);
 		goto out;
+	}
 
 	buflen--;
 	buf[buflen] = '\0';
-- 
2.9.0

From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs 3.18-rc3 General protection fault
Date: Tue, 4 Nov 2014 16:11:03 +0100
Message-ID: <20141104151103.GA2540@tucsk.piliscsaba.szeredi.hu>
References: <20141104135408.16f70754@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41018 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaKDPLL (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 4 Nov 2014 10:11:11 -0500
Received: by mail-wi0-f181.google.com with SMTP id n3so9565893wiv.8
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Nov 2014 07:11:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20141104135408.16f70754@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jordi Pujol Palomer <jordipujolp@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Nov 04, 2014 at 01:54:08PM +0100, Jordi Pujol Palomer wrote:
> Hello,
> 
> After a little time running kernel 3.18-rc3 and
> integrated experimental overlayfs the attached error occurs.
> 
> more info about the system and kernel config is available in:
> 
> http://jordipujol.ddns.net/debian/testing-overlayfs-3.18-rc3/

Thanks for the report.  Could you please try the following patch, which should
fix the Oops.

Thanks,
Miklos
---

Subject: ovl: don't poison cursor
From: Miklos Szeredi <mszeredi@suse.cz>

ovl_cache_put() can be called from ovl_dir_reset() if the cache needs to be
rebuilt.  We did list_del() on the cursor, which results in an Oops on the
poisoned pointer in ovl_seek_cursor().

Reported-by: Jordi Pujol Palomer <jordipujolp@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -168,7 +168,7 @@ static void ovl_cache_put(struct ovl_dir
 {
 	struct ovl_dir_cache *cache = od->cache;
 
-	list_del(&od->cursor.l_node);
+	list_del_init(&od->cursor.l_node);
 	WARN_ON(cache->refcount <= 0);
 	cache->refcount--;
 	if (!cache->refcount) {

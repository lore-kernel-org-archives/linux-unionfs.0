From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: WARNING: CPU: 2 PID: 989 at fs/overlayfs/super.c:325
 ovl_d_real+0x91/0xd0 [overlay]
Date: Thu, 14 Jul 2016 10:51:24 +0200
Message-ID: <20160714085124.GB20504@veci.piliscsaba.szeredi.hu>
References: <CANaxB-ytjpG+VMoSpT9Nn2CGvYC8pzLDp0PzmRKbVSHof=TeWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33116 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbcGNIv2 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 04:51:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id o80so8657171wme.0
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2016 01:51:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CANaxB-ytjpG+VMoSpT9Nn2CGvYC8pzLDp0PzmRKbVSHof=TeWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andrei Vagin <avagin@gmail.com>
Cc: linux-unionfs@vger.kernel.org

On Tue, Jul 12, 2016 at 09:55:37PM -0700, Andrei Vagin wrote:
> Hi,
> 
> I'm trying to investigate why criu could not dump a container on
> overlayfs, but I met another problem. Could someone help me with it?

This setup (overlayfs used as upper layer of another overlayfs) does not make
sense in my opinion.  The bug here is that we allow this.  The patch below
should fix this.

Is there a good reason why you are doing this?

Overlayfs being used as lower layer of another overlayfs did make sense while
only one lower layer was possible.  Currently that setup is still possible but
obsoleted by multiple lower layers in a single overlay mount.

So stacking multiple overlayfs instances should never be needed.

Thanks,
Miklos

---
From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: disallow overlayfs as upperdir

This does not work and does not make sense.  So instead of fixing it
(probably not hard) just disallow.

Reported-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: <stable@vger.kernel.org>
---
 fs/overlayfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -408,7 +408,8 @@ static struct ovl_entry *ovl_alloc_entry
 static bool ovl_dentry_remote(struct dentry *dentry)
 {
 	return dentry->d_flags &
-		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE |
+		 DCACHE_OP_REAL);
 }
 
 static bool ovl_dentry_weird(struct dentry *dentry)

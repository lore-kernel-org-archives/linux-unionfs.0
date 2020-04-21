Return-Path: <SRS0=+UIx=6F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF73C54FC9
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 18:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04087206D9
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 18:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnSr3ls6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDUSlZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 14:41:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30436 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgDUSlZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Apr 2020 14:41:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587494483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=EQUzfQg3czoCywB8LyULKsSAjA2vDVX25zOVEIMvmU4=;
        b=QnSr3ls69I5lF6BdfzOdfaHZaiGZnz+XckN7M9TrNltrIowhDSEreGYniiD5f9syb2yXKb
        9wV3n9uQ8gx+VXTSDz1mvU6VBmJwB5z576SW82AJu/9bV9ENpmCu+jiNN/1LZUhofRyFTz
        YSFylsTJb37IEnXkbXcqYNWin6+Mje0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-UreooANSP9WavpvMPNs-vQ-1; Tue, 21 Apr 2020 14:41:11 -0400
X-MC-Unique: UreooANSP9WavpvMPNs-vQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C08A419067E0;
        Tue, 21 Apr 2020 18:41:10 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-152.rdu2.redhat.com [10.10.113.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 940735DA66;
        Tue, 21 Apr 2020 18:41:07 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 1C986220E74; Tue, 21 Apr 2020 14:41:07 -0400 (EDT)
Date:   Tue, 21 Apr 2020 14:41:07 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        virtio-fs-list <virtio-fs@redhat.com>
Subject: [PATCH] overlayfs: Pass O_TRUNC flag to underlying filesystem
Message-ID: <20200421184107.GC28740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

As of now during open(), we don't pass bunch of flags to underlying
filesystem. O_TRUNC is one of these. Normally this is not a problem as VFS
calls ->setattr() with zero size and underlying filesystem sets file size
to 0.

But when overlayfs is running on top of virtiofs, it has an optimization
where it does not send setattr request to server if dectects that
truncation is part of open(O_TRUNC). It assumes that server already zeroed
file size as part of open(O_TRUNC).

fuse_do_setattr() {
	if (attr->ia_valid & ATTR_OPEN) {
		/*
		 * No need to send request to userspace, since actual
		 * truncation has already been done by OPEN.  But still
		 * need to truncate page cache.
		 */
	}
}

IOW, fuse expects O_TRUNC to be passed to it as part of open flags.

But currently overlayfs does not pass O_TRUNC to underlying filesystem
hence fuse/virtiofs breaks. Setup overlayfs on top of virtiofs and
following does not zero the file size of a file is either upper only
or has already been copied up.

fd = open(foo.txt, O_TRUNC | O_WRONLY);

Fix it by passing O_TRUNC to underlying filesystem.

I found this problem while running unionmount-testsuite. It fails.

***
*** ./run --ov --samefs --ts=0 open-trunc
***
TEST open-trunc.py:10: Open O_TRUNC|O_RDONLY
 ./run --open-file /mnt/virtiofs/mnt/a/foo100 -r -t -R 
 ./run --open-file /mnt/virtiofs/mnt/a/foo100 -r -t -R 
TEST open-trunc.py:18: Open O_TRUNC|O_WRONLY
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -w -t -W q
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -r -R q
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -w -t -W p
 ./run --open-file /mnt/virtiofs/mnt/a/foo101 -r -R p
TEST open-trunc.py:28: Open O_TRUNC|O_APPEND|O_WRONLY
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -a -t -W q
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -r -R q
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -a -t -W p
 ./run --open-file /mnt/virtiofs/mnt/a/foo102 -r -R p
/mnt/virtiofs/mnt/a/foo102: File size wrong (got 2, want 1)

After this patch, unionmount-testsuite passes with overlayfs on top of
virtiofs.
 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: redhat-linux/fs/overlayfs/file.c
===================================================================
--- redhat-linux.orig/fs/overlayfs/file.c	2020-04-21 13:33:40.777125594 -0400
+++ redhat-linux/fs/overlayfs/file.c	2020-04-21 13:53:30.317125594 -0400
@@ -134,7 +134,7 @@ static int ovl_open(struct inode *inode,
 		return err;
 
 	/* No longer need these flags, so don't pass them on to underlying fs */
-	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY);
 
 	realfile = ovl_open_realfile(file, ovl_inode_realdata(inode));
 	if (IS_ERR(realfile))


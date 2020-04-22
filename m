Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C4DC55189
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 13:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 283E42098B
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 13:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FAMDMqof"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgDVNJ0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 09:09:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32172 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726712AbgDVNJK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 09:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587560948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5kQ/6au7F0S3EL8z4X0Nb6mFW3YrwFan9iNGbg1crM=;
        b=FAMDMqofG5BB4iDGi6ZPJiBZqRIRIVQKWuuRvCbFXOx8pYotXCe9DVtQR0d8DMTr/c57xU
        /3oD9Mx/e3D2CJOQRlCf0Ke1NmxbOpJruECIm8m60LQwUKP0rHU4bDTdMUG3YQzcqillhK
        MMv14OjhncSVt5Ij2vGVorf0AyRu5Z8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-EIL2E7JhMcKXPTKzGNGo2w-1; Wed, 22 Apr 2020 09:09:06 -0400
X-MC-Unique: EIL2E7JhMcKXPTKzGNGo2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05D2918CA244;
        Wed, 22 Apr 2020 13:09:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-112.rdu2.redhat.com [10.10.114.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A78D1001920;
        Wed, 22 Apr 2020 13:09:03 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 782AA222FCA; Wed, 22 Apr 2020 09:09:02 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc:     vgoyal@redhat.com, virtio-fs@redhat.com
Subject: [PATCH 2/2] overlayfs: ovl_setattr() should clear ATTR_OPEN
Date:   Wed, 22 Apr 2020 09:08:50 -0400
Message-Id: <20200422130850.59900-3-vgoyal@redhat.com>
In-Reply-To: <20200422130850.59900-1-vgoyal@redhat.com>
References: <20200422130850.59900-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

As of now during open(), we don't pass bunch of flags to underlying
filesystem. O_TRUNC is one of these. Normally this is not a problem as VF=
S
calls ->setattr() with zero size and underlying filesystem sets file size
to 0.

But when overlayfs is running on top of virtiofs, it has an optimization
where it does not send setattr request to server if dectects that
truncation is part of open(O_TRUNC). It assumes that server already zeroe=
d
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

fd =3D open(foo.txt, O_TRUNC | O_WRONLY);

There are two ways to fix this. Either pass O_TRUNC to underlying filesys=
tem
or clear ATTR_OPEN from attr->ia_valid so that fuse ends up sending a
SETATTR request to server. Miklos is concerned that O_TRUNC might have
side affects so it is better to clear ATTR_OPEN for now. Hence this patch
clears ATTR_OPEN from attr->ia_valid.

I found this problem while running unionmount-testsuite. With this patch,
unionmount-testsuite passes with overlayfs on top of virtiofs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 8d147bc70f0b..08ae88b72d9a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -37,6 +37,17 @@ int ovl_setattr(struct dentry *dentry, struct iattr *a=
ttr)
=20
 		/* Truncate should trigger data copy up as well */
 		full_copy_up =3D true;
+
+		/* If open(O_TRUNC) is done, VFS calls ->setattr with
+		 * ATTR_OPEN set. Overlayfs does not pass O_TRUNC flag
+		 * to underlying filesystem during open. Do not pass
+		 * ATTR_OPEN. This disables optimization in fuse which
+		 * assumes open(O_TRUNC) already set file size to 0. But
+		 * we never passed O_TRUNC to fuse. So by clearing ATTR_OPEN,
+		 * fuse will be forced to set ->setattr() request to
+		 * server.
+		 */
+		attr->ia_valid &=3D ~ATTR_OPEN;
 	}
=20
 	if (!full_copy_up)
--=20
2.25.3


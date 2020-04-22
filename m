Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F18CC55185
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 13:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AB1E2098B
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 13:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jLYSXGd2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgDVNJM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 09:09:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726752AbgDVNJL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 09:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587560950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=peFQp3jLI2FKelFbpdvpk1dwv202/Cx5r2dYOjN0TLk=;
        b=jLYSXGd2KZEWEiZzPkCTKFsywmx+IVIJGUJzChn0iA7qtH9MaW5N2FNMqbeogAsDadWdvk
        mVf7XPBS8++Wn/W5AjhCn0SAMksAQ+PzpgN7QJ4hBnayFcnKvTU9IUqM229rPbDTvjC/4n
        ZkVIx9s468xCv0IO8iq+9ldrzUUZmcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-qylvZGjEOk6OiIUFBONxIw-1; Wed, 22 Apr 2020 09:09:06 -0400
X-MC-Unique: qylvZGjEOk6OiIUFBONxIw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7BDB18CA241;
        Wed, 22 Apr 2020 13:09:05 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-112.rdu2.redhat.com [10.10.114.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C414277C8;
        Wed, 22 Apr 2020 13:09:03 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 71F7C222FC8; Wed, 22 Apr 2020 09:09:02 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc:     vgoyal@redhat.com, virtio-fs@redhat.com
Subject: [PATCH 1/2] overlayfs: ovl_setattr() should clear ATTR_FILE from attr->ia_valid
Date:   Wed, 22 Apr 2020 09:08:49 -0400
Message-Id: <20200422130850.59900-2-vgoyal@redhat.com>
In-Reply-To: <20200422130850.59900-1-vgoyal@redhat.com>
References: <20200422130850.59900-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_setattr() can be passed an attr which has ATTR_FILE set and
attr->ia_file is a file pointer to overlay file. This is done
in open(O_TRUNC) path.

We should either replace with attr->ia_file with underlying file object
or clear ATTR_FILE so that underlying filesystem does not end up using
overlayfs file object pointer.

There are no good use cases yet so for now clear ATTR_FILE. fuse seems
to be one user which can use this. But it can work even without this.
So it is not mandatory to pass ATTR_FILE to fuse.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b0d42ece4d7c..8d147bc70f0b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -58,6 +58,11 @@ int ovl_setattr(struct dentry *dentry, struct iattr *a=
ttr)
 		if (attr->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
 			attr->ia_valid &=3D ~ATTR_MODE;
=20
+		/* We might have to translate ovl file into underlying file
+		 * object once some use cases are there. For now, simply
+		 * don't let underlying filesystem rely on attr->ia_file */
+		attr->ia_valid &=3D ~ATTR_FILE;
+
 		inode_lock(upperdentry->d_inode);
 		old_cred =3D ovl_override_creds(dentry->d_sb);
 		err =3D notify_change(upperdentry, attr, NULL);
--=20
2.25.3


Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCEFC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3F19206EC
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 Jan 2021 21:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbhASVIp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 16:08:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49448 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388912AbhASVIF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Jan 2021 16:08:05 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l1yDh-008bE6-7d; Tue, 19 Jan 2021 14:07:21 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1l1yDg-009tuJ-7a; Tue, 19 Jan 2021 14:07:20 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Tyler Hicks <code@tyhicks.com>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
        <20210119162204.2081137-2-mszeredi@redhat.com>
Date:   Tue, 19 Jan 2021 15:06:10 -0600
In-Reply-To: <20210119162204.2081137-2-mszeredi@redhat.com> (Miklos Szeredi's
        message of "Tue, 19 Jan 2021 17:22:03 +0100")
Message-ID: <87a6t4ab7h.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1l1yDg-009tuJ-7a;;;mid=<87a6t4ab7h.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX192I2sk61mecKt+hRhFGN4NPXzT2CICcgs=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/2] ecryptfs: fix uid translation for setxattr on security.capability
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> writes:

> Prior to commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into
> vfs_setxattr()") the translation of nscap->rootid did not take stacked
> filesystems (overlayfs and ecryptfs) into account.
>
> That patch fixed the overlay case, but made the ecryptfs case worse.
>
> Restore old the behavior for ecryptfs that existed before the overlayfs
> fix.  This does not fix ecryptfs's handling of complex user namespace
> setups, but it does make sure existing setups don't regress.

Today vfs_setxattr handles handles a delegated_inode and breaking
leases.  Code that is enabled with CONFIG_FILE_LOCKING.  So unless
I am missing something this introduces a different regression into
ecryptfs.

>
> Reported-by: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Tyler Hicks <code@tyhicks.com>
> Fixes: 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into vfs_setxattr()")
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/ecryptfs/inode.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index e23752d9a79f..58d0f7187997 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -1016,15 +1016,19 @@ ecryptfs_setxattr(struct dentry *dentry, struct inode *inode,
>  {
>  	int rc;
>  	struct dentry *lower_dentry;
> +	struct inode *lower_inode;
>  
>  	lower_dentry = ecryptfs_dentry_to_lower(dentry);
> -	if (!(d_inode(lower_dentry)->i_opflags & IOP_XATTR)) {
> +	lower_inode = d_inode(lower_dentry);
> +	if (!(lower_inode->i_opflags & IOP_XATTR)) {
>  		rc = -EOPNOTSUPP;
>  		goto out;
>  	}
> -	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
> +	inode_lock(lower_inode);
> +	rc = __vfs_setxattr_locked(lower_dentry, name, value, size, flags, NULL);
> +	inode_unlock(lower_inode);
>  	if (!rc && inode)
> -		fsstack_copy_attr_all(inode, d_inode(lower_dentry));
> +		fsstack_copy_attr_all(inode, lower_inode);
>  out:
>  	return rc;
>  }

Eric

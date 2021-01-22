Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F85C43381
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 18:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97EDB2376F
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 18:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbhAVShp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 13:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbhAVScZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 Jan 2021 13:32:25 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B02C061793
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jan 2021 10:31:44 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id q6so1634094ooo.8
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jan 2021 10:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tyhicks-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Ab9R3Beg3K2SiC0qANgEYUJGr8eAMXRzKvwtlr3avY=;
        b=nasFTn+Wbf6+mLFLGP8W5Ujy6BYP5L2cegwclttCFnekEXAOkDDrvQu9YItuVGUqYZ
         KHew29S8kFItmdEKeX795fWRGhMVHexN8B+hmtTwKNd1mopSb58bSd3I9ZqxjBoNXSm/
         xYfxCLQpYYbd6kAnIKn9JBg4Pa3xpH/h5cjEW25nlNW62cfvCFaxWtz2X7fUkiKVL30c
         3aj3OmGZk1i/CBH0WT4fQlOsj13gCXgLRNy3s8yrXgm5XwcXd0PPn7ji/TlF8hfVpCYB
         k4bSiEC6DoNK0a0PtWTOCv5AgjGzFRHvM2E17zUau5K2Wem2O1Dw7Et+vzouOWJesWvT
         /OvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Ab9R3Beg3K2SiC0qANgEYUJGr8eAMXRzKvwtlr3avY=;
        b=mk00qXyvfW+W2Dixau8UKY/iQHIJtkmGXRd1YGNcBNP2gRGs0ouZqG9cqolvUApGAv
         LenREZwf3MhfT8BfdShn2s6IrR64UJfDTRgdljjeRmkOWlcDpFNzi+pRaIWS8M9fv851
         p+a2Yi2w3puMBcszhGQA70S3aNBfMogQWsrhL/bVEcg2sAbQYAhA+sGyWd+Pt2QQvEwK
         4cHEP8Vz4GWxXy+DEL9mxN+zE2Z4LHf1i68K3Bu3qIXHDmBxtY4FBSU5iVtOzjZZuYsP
         ttxJL/nxGJt/hlPdU7CxSPcETAv7H1CZ2MWoIOrt39XOweNJ/8+CBZ5co7fLJyMPmFsk
         tkRw==
X-Gm-Message-State: AOAM530AAuF0lIgwbMWfy/gHYisdcvkUk6YMqSpYARCrcggfg58IjfIB
        gMs9ktTdY6iob5+tcgRZdGXsAA==
X-Google-Smtp-Source: ABdhPJz0jtCdpEjEMrPjsrQ4MNKqxVFzLEirJ6qP9Bb8ZCzO4bpHVBR4tHp1tIKbz9Klj8hQkCd1XA==
X-Received: by 2002:a4a:6c45:: with SMTP id u5mr4749495oof.61.1611340303740;
        Fri, 22 Jan 2021 10:31:43 -0800 (PST)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net. [162.237.133.238])
        by smtp.gmail.com with ESMTPSA id x9sm1825985ota.23.2021.01.22.10.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 10:31:43 -0800 (PST)
Date:   Fri, 22 Jan 2021 12:31:41 -0600
From:   Tyler Hicks <code@tyhicks.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Serge E . Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 1/2] ecryptfs: fix uid translation for setxattr on
 security.capability
Message-ID: <20210122183141.GB81247@sequoia>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
 <20210119162204.2081137-2-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119162204.2081137-2-mszeredi@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 2021-01-19 17:22:03, Miklos Szeredi wrote:
> Prior to commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into
> vfs_setxattr()") the translation of nscap->rootid did not take stacked
> filesystems (overlayfs and ecryptfs) into account.
> 
> That patch fixed the overlay case, but made the ecryptfs case worse.

Thanks for sending a fix!

I know that you don't have an eCryptfs setup to test with but I'm at a
loss about how to test this from the userns/fscaps side of things. Do
you have a sequence of unshare/setcap/getcap commands that I can run on
a file inside of an eCryptfs mount to verify that the bug exists after
7c03e2cda4a5 and then again to verify that this patch fixes the bug?

Tyler

> 
> Restore old the behavior for ecryptfs that existed before the overlayfs
> fix.  This does not fix ecryptfs's handling of complex user namespace
> setups, but it does make sure existing setups don't regress.
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
> -- 
> 2.26.2
> 

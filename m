Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C661C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F716124A
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241369AbhJGMMD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbhJGML5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Oct 2021 08:11:57 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6C1C061772
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Oct 2021 05:10:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r18so22262742edv.12
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Oct 2021 05:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bJ7+Dsxqje/qCi5h9DIEBDXfxzFZ7kazLrywV6hzHWA=;
        b=B6L9pCAUODPX1NnFXj/gPTXyVoDvCg73tyF169W6DFu3Dsqqb3U68cuBH10iugkFkI
         WCbShsW4Z/Edx2BBxxE7vVpNT5OrfQQVLpxlCa2GUFhtjyBCIk2wqey58GX8FLOM4fkD
         KELR5QaAsnIOkrKEMOXzK1+lpns3IcFI990Tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bJ7+Dsxqje/qCi5h9DIEBDXfxzFZ7kazLrywV6hzHWA=;
        b=CLNTsg9W+5qsx9SAJhlNerAOExB+2yn7YBurolhZ5BHj9ifxs98h4ghoBrxgwvaYCv
         Rf1DY5tj4n5P4TYphacWrfnfDFFuO+j6CwJGtV22c71PcIrkMMDVws0m8nf+UxbOQq75
         J8vBbgT9q7tMXppJhzw3mKI8hYZrFYrj1t0hZuysNjhvGwMb/2kHzM7VR3jgqXoW8vcu
         bOXuLAFBuSerebEthhvd6aKrp/vT1xXSZCYZN+OzrBaj26ZCPEUwPs/cFx6nx+UGc3W6
         FW2smNE6hVNo2ITXLSHMEM0cTWGyT8y3060z1N+MNasQhe69Ud2Z4TDSdE1+pDMls2uJ
         wXcQ==
X-Gm-Message-State: AOAM530eCtKr362pKsKLX+sJRvO2GWhhBz//CvOZombto/TGhiiRbLiR
        KesynJkcHP+8DurGrDOWxgmSew==
X-Google-Smtp-Source: ABdhPJxveLKXr8MKtOMlZVhTrqH0xbiYJu7RT/nNY+3C1oVWu87i9AXOFvAV6i+eUC1w7wMRdmlbZw==
X-Received: by 2002:a05:6402:50cc:: with SMTP id h12mr6031409edb.112.1633608602666;
        Thu, 07 Oct 2021 05:10:02 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id b2sm9919744ejj.124.2021.10.07.05.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 05:10:01 -0700 (PDT)
Date:   Thu, 7 Oct 2021 14:09:59 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Huang Jianan <huangjianan@oppo.com>
Subject: Re: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
Message-ID: <YV7jl23vPilVb3zE@miu.piliscsaba.redhat.com>
References: <20210928124757.117556-1-cgxu519@mykernel.net>
 <CAJfpegsHH1wpLXDJXemVM1mpcRACRwew8pc2X62KkyuwS91jKQ@mail.gmail.com>
 <17c469a5f3f.e5bfa83020210.6858947926351314597@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17c469a5f3f.e5bfa83020210.6858947926351314597@mykernel.net>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Oct 03, 2021 at 10:41:34PM +0800, Chengguang Xu wrote:
> ---- 在 星期四, 2021-09-30 20:55:54 Miklos Szeredi <miklos@szeredi.hu> 撰写 ----

>  > OVL_UPPERDATA is only set after ovl_get_inode() in all callers.  This
>  > needs to be moved into ovl_inode_init() before calling
>  > ovl_inode_set_aops() otherwise this won't work correctly for a copied
>  > up file.
>  > 
> 
> Hi Miklos,
> 
> I found it's not convenient to move setting OVL_UPPERDATA into ovl_inode_init() because

If you look at the logic of the thing, then it becomes quite simple.  See
following (untested) patch.

Thanks,
Miklos

---
 fs/overlayfs/dir.c       |    3 +--
 fs/overlayfs/export.c    |    5 ++---
 fs/overlayfs/inode.c     |    3 +++
 fs/overlayfs/namei.c     |    3 +--
 fs/overlayfs/overlayfs.h |    1 +
 5 files changed, 8 insertions(+), 7 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -264,6 +264,7 @@ static int ovl_instantiate(struct dentry
 	struct ovl_inode_params oip = {
 		.upperdentry = newdentry,
 		.newinode = inode,
+		.metacopy = false,
 	};
 
 	ovl_dir_modified(dentry->d_parent, false);
@@ -287,8 +288,6 @@ static int ovl_instantiate(struct dentry
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
-		if (inode == oip.newinode)
-			ovl_set_flag(OVL_UPPERDATA, inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
 		dput(newdentry);
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -290,7 +290,8 @@ static struct dentry *ovl_obtain_alias(s
 	struct ovl_inode_params oip = {
 		.lowerpath = lowerpath,
 		.index = index,
-		.numlower = !!lower
+		.numlower = !!lower,
+		.metacopy = false, /* No NFS export support for metacopy yet */
 	};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
@@ -304,8 +305,6 @@ static struct dentry *ovl_obtain_alias(s
 		return ERR_CAST(inode);
 	}
 
-	if (upper)
-		ovl_set_flag(OVL_UPPERDATA, inode);
 
 	dentry = d_find_any_alias(inode);
 	if (dentry)
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1155,6 +1155,9 @@ struct inode *ovl_get_inode(struct super
 		ino = realinode->i_ino;
 		fsid = lowerpath->layer->fsid;
 	}
+	if (upperdentry && !oip->metacopy)
+		ovl_set_flag(OVL_UPPERDATA, inode);
+
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 	ovl_inode_init(inode, oip, ino, fsid);
 
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1093,14 +1093,13 @@ struct dentry *ovl_lookup(struct inode *
 			.redirect = upperredirect,
 			.lowerdata = (ctr > 1 && !d.is_dir) ?
 				      stack[ctr - 1].dentry : NULL,
+			.metacopy = uppermetacopy,
 		};
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
-		if (upperdentry && !uppermetacopy)
-			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
 	ovl_dentry_update_reval(dentry, upperdentry,
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -507,6 +507,7 @@ struct ovl_inode_params {
 	struct dentry *upperdentry;
 	struct ovl_path *lowerpath;
 	bool index;
+	bool metacopy;
 	unsigned int numlower;
 	char *redirect;
 	struct dentry *lowerdata;

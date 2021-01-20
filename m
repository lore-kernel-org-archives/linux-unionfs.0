Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0447C433E6
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 11:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8C92335A
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 11:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbhATLfe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732955AbhATKVa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Jan 2021 05:21:30 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ED3C061757
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 02:20:49 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ke15so25071855ejc.12
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 02:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OFlx5d568EFpNe9zqZr0JFVr1l6hwq2H86uMHDeKgAU=;
        b=PaKorZz0uyZmvpKhqu2AmueiUhbr//g/JNsEnzOFJufa0fcuO9uxjW/v98mEqPZkkl
         xtxyL36Y8py3tJ91KkDfxkouAPZ1174zgkxeGJFFr729coYc1wLND9JOK1hVElqqYfYb
         jFSG5jqara+VXbGcTLs6Uu68kNWVEvQqss88w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OFlx5d568EFpNe9zqZr0JFVr1l6hwq2H86uMHDeKgAU=;
        b=VXBzI3bEPFmbSQVna4wred7mvuXm0j82Ge/bE3yGuoos8LMe/NpZ2ZXYLGvD6eQv1X
         O8lbNKVRD446XG0YLV5s91/bQIZbWbpa6bp+bFeUky6BksAvyH+M2GLuwQgEt/nG7uCT
         nE4nIgJQW9KabePvOjJO2DMqYowsUxLWz8ehTI1RpQVXSMXxOQg4uXgPApCpsvWUQ0Ya
         hMefI2ok7D+iqEt/dxlnExlF4vj9TBsBV1aY/zTrYnxf1RxB1d9HCyBs6WmdDWdYGZP+
         kgM61veQeenQVF0I4oL+siJeEEnLl6Pn1GsIzZkSK+vNc0VfJmktgLaz2Eq1HhPab+Md
         N0Ug==
X-Gm-Message-State: AOAM5302FW45RHsZ+mLa5QYNjgIy4WX1LbjEeuX5dwV1sKDkH9YI6SIZ
        p5le+Meu4Wg0isfav1AeFvRRVA==
X-Google-Smtp-Source: ABdhPJxrI8ym6Z6hQLOERyZmRX2Nfb8mT/4BqaIad4wret3urMAsxf0QrI4675iqmGySlz20R0D9+g==
X-Received: by 2002:a17:906:fcae:: with SMTP id qw14mr5454879ejb.245.1611138048464;
        Wed, 20 Jan 2021 02:20:48 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id c7sm838063edv.70.2021.01.20.02.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 02:20:47 -0800 (PST)
Date:   Wed, 20 Jan 2021 11:20:45 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile
 caching
Message-ID: <20210120102045.GD1236412@miu.piliscsaba.redhat.com>
References: <20210105003611.194511-1-icenowy@aosc.io>
 <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jan 05, 2021 at 08:47:41AM +0200, Amir Goldstein wrote:
> On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io> wrote:
> >
> > The function ovl_dir_real_file() currently uses the semaphore of the
> > inode to synchronize write to the upperfile cache field.
> 
> Although the inode lock is a rw_sem it is referred to as the "inode lock"
> and you also left semaphore in the commit subject.
> No need to re-post. This can be fixed on commit.
> 
> >
> > However, this function will get called by ovl_ioctl_set_flags(), which
> > utilizes the inode semaphore too. In this case ovl_dir_real_file() will
> > try to claim a lock that is owned by a function in its call stack, which
> > won't get released before ovl_dir_real_file() returns.
> >
> > Define a dedicated semaphore for the upperfile cache, so that the
> > deadlock won't happen.
> >
> > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
> > Cc: stable@vger.kernel.org # v5.10
> > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > ---
> > Changes in v2:
> > - Fixed missing replacement in error handling path.
> > Changes in v3:
> > - Use mutex instead of semaphore.
> >
> >  fs/overlayfs/readdir.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 01620ebae1bd..3980f9982f34 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> >         struct list_head *cursor;
> >         struct file *realfile;
> >         struct file *upperfile;
> > +       struct mutex upperfile_mutex;
> 
> That's a very specific name.
> This mutex protects members of struct ovl_dir_file, which could evolve
> into struct ovl_file one day (because no reason to cache only dir upper file),
> so I would go with a more generic name, but let's leave it to Miklos to decide.
> 
> He could have a different idea altogether for fixing this bug.

How about this (untested) patch?

It's a cleanup as well as a fix, but maybe we should separate the cleanup from
the fix...

Thanks,
Miklos
---

 fs/overlayfs/readdir.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -865,7 +865,7 @@ struct file *ovl_dir_real_file(const str
 
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
-	struct file *realfile = od->realfile;
+	struct file *old, *realfile = od->realfile;
 
 	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
 		return want_upper ? NULL : realfile;
@@ -874,29 +874,20 @@ struct file *ovl_dir_real_file(const str
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
 	if (!od->is_upper) {
-		struct inode *inode = file_inode(file);
-
 		realfile = READ_ONCE(od->upperfile);
 		if (!realfile) {
 			struct path upperpath;
 
 			ovl_path_upper(dentry, &upperpath);
 			realfile = ovl_dir_open_realfile(file, &upperpath);
+			if (IS_ERR(realfile))
+				return realfile;
 
-			inode_lock(inode);
-			if (!od->upperfile) {
-				if (IS_ERR(realfile)) {
-					inode_unlock(inode);
-					return realfile;
-				}
-				smp_store_release(&od->upperfile, realfile);
-			} else {
-				/* somebody has beaten us to it */
-				if (!IS_ERR(realfile))
-					fput(realfile);
-				realfile = od->upperfile;
+			old = cmpxchg_release(&od->upperfile, NULL, realfile);
+			if (old) {
+				fput(realfile);
+				realfile = old;
 			}
-			inode_unlock(inode);
 		}
 	}
 

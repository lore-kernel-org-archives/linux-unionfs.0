Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA46C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 12:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B8260295
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 Oct 2021 12:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhJ2M5D (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 08:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhJ2M5B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 Oct 2021 08:57:01 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8334EC061570
        for <linux-unionfs@vger.kernel.org>; Fri, 29 Oct 2021 05:54:28 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ee16so25311643edb.10
        for <linux-unionfs@vger.kernel.org>; Fri, 29 Oct 2021 05:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=g5Jep9mebky1JAn4ZK0SPy4fc/MvdPmhjVh44g16kEk=;
        b=I3iscSMDd/Yz9g3G3Kfb320+CeHC/+ejCt06h+JL8LE6DPXIBXfF0h7qTcR5dgqW2j
         0GgjRX4EG/vQXvNn/OgkbabRp2g44vL2wfeqsrjdfi50jqSqLeASYndF2nloQSvZC1/U
         wHtpio3gy7mGr3uN8O+JF0gQ4PS7H/hnn/EnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=g5Jep9mebky1JAn4ZK0SPy4fc/MvdPmhjVh44g16kEk=;
        b=dBj02ErQ2GnFuQuuekXIdaIJ6bXMeYtmakRCZxgMsDjsQrSqwRwVkgkBBo0gppLDhO
         GzjyzjrXhJhCW5JMMC4La5aifNm+HD3I4eSRWPQj/Mx1LmCktQJapHDb//TCxGG2B3bG
         VacsygIPIm/OmGpf616BLfIWM+mmqjsEL3l4zUkkFrX/7UjzVxGSAXg4N+wHmpvW63ZH
         eYpydCQ2BTx9+dbYKfC4xa9VzppOJANfNAPRWFUi9cEey+yyq8UzQyojoiGF8SHoyARk
         MLp4bjUSLci59S/uOQ3aN1MfhwHFXVDafE4aHjJH4RAX1HxxF7qkN0gnWL3WS5WgpGuM
         YHlg==
X-Gm-Message-State: AOAM530Wmyz+Ncm6cPNi8eVfPxJrKJ4Gs7/Q/3D/Ngkx7J1l9u+2XcPn
        rmuE02yjONw8Mzoiaea+ZnjRWLEmz4GMNA==
X-Google-Smtp-Source: ABdhPJxtBFsmkhh1FxuO2541MS0h6caZNyfcWWqTux6xDF2dT5vvzEuqsut6rFTWOnDD0oqIvSw5AA==
X-Received: by 2002:a05:6402:1ac2:: with SMTP id ba2mr3215858edb.21.1635512067056;
        Fri, 29 Oct 2021 05:54:27 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-178-48-189-3.catv.broadband.hu. [178.48.189.3])
        by smtp.gmail.com with ESMTPSA id r15sm3953190edd.96.2021.10.29.05.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 05:54:26 -0700 (PDT)
Date:   Fri, 29 Oct 2021 14:54:24 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Georg =?utf-8?Q?M=C3=BCller?= <georgmueller@gmx.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: overlayfs: supporting O_TMPFILE
Message-ID: <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
References: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net>
 <CAOQ4uxh_P0fiV9gQOs9CLvB+xJpJT4hWfAFyKBx0A-TyxAma8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxh_P0fiV9gQOs9CLvB+xJpJT4hWfAFyKBx0A-TyxAma8Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 29, 2021 at 01:37:49AM +0300, Amir Goldstein wrote:
> On Thu, Oct 28, 2021 at 11:41 PM Georg Müller <georgmueller@gmx.net> wrote:
> >
> > Hi,
> >
> > I was trying to implement .tmpfile for overlayfs inode_operations to support O_TMPFILE.
> >
> > Docker with aufs supports it, but this is deprecated and removed from current docker. I now have a work-around in my code (create tmpfile+unlink), but
> > I thought it might be a good idea to have tmpfile support in overlayfs.
> >
> > I was trying to do it on my own, but I have some headaches to what is necessary to achieve the goal.
> >
> >  From my understanding, I have to find the dentry for the upper dir (or workdir) and call vfs_tmpdir() for this, but I am running from oops to oops.
> >
> > Is there some hint what I have to do to achieve the goal?
> >
> 
> You'd want to use ovl_create_object() and probably pass a tmpfile argument
> then pass it on struct ovl_cattr to ovl_create_or_link() after that
> it becomes more complicated. You'd need ovl_create_tempfile() like
> ovl_create_upper().
> You can follow xfs_generic_create() for some clues.
> You need parts of ovl_instantiate() but not all of it - it's a mess.

Here's something I prepared earlier ;)

Don't know why it got stuck, quite possibly I realized some fatal flaw that I
can't remember anymore...

Seems to work though, so getting this out for review and testing.

Thanks,
Miklos

---
 fs/overlayfs/dir.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1295,6 +1295,127 @@ static int ovl_rename(struct user_namesp
 	return err;
 }
 
+static int ovl_create_upper_tmpfile(struct dentry *dentry, struct inode *inode,
+				    umode_t mode)
+{
+	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
+	struct dentry *newdentry;
+	struct ovl_inode_params oip;
+
+	if (!IS_POSIXACL(d_inode(upperdir)))
+		mode &= ~current_umask();
+
+	newdentry = vfs_tmpfile(&init_user_ns, upperdir, mode, 0);
+	if (IS_ERR(newdentry))
+		return PTR_ERR(newdentry);
+
+	oip = (struct ovl_inode_params) {
+		.upperdentry = newdentry,
+		.newinode = inode,
+	};
+
+	ovl_dentry_set_upper_alias(dentry);
+	ovl_dentry_update_reval(dentry, newdentry,
+			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+
+	/*
+	 * ovl_obtain_alias() can be called after ovl_create_real()
+	 * and before we get here, so we may get an inode from cache
+	 * with the same real upperdentry that is not the inode we
+	 * pre-allocated.  In this case we will use the cached inode
+	 * to instantiate the new dentry.
+	 */
+	inode = ovl_get_inode(dentry->d_sb, &oip);
+	if (IS_ERR(inode)) {
+		dput(newdentry);
+		return PTR_ERR(inode);
+	}
+	/* d_tmpfile() expects inode to have a positive link count */
+	set_nlink(inode, 1);
+
+	d_tmpfile(dentry, inode);
+	if (inode != oip.newinode) {
+		pr_warn_ratelimited("newly created inode found in cache (%pd2)\n",
+				    dentry);
+	}
+	return 0;
+}
+
+static int ovl_create_tmpfile(struct dentry *dentry, struct inode *inode,
+			      umode_t mode)
+{
+	int err;
+	const struct cred *old_cred;
+	struct cred *override_cred;
+	struct dentry *parent = dentry->d_parent;
+
+	err = ovl_copy_up(parent);
+	if (err)
+		return err;
+
+	old_cred = ovl_override_creds(dentry->d_sb);
+
+	err = -ENOMEM;
+	override_cred = prepare_creds();
+	if (override_cred) {
+		override_cred->fsuid = inode->i_uid;
+		override_cred->fsgid = inode->i_gid;
+		err = security_dentry_create_files_as(dentry, mode,
+						      &dentry->d_name, old_cred,
+						      override_cred);
+		if (err) {
+			put_cred(override_cred);
+			goto out_revert_creds;
+		}
+		put_cred(override_creds(override_cred));
+		put_cred(override_cred);
+
+		err = ovl_create_upper_tmpfile(dentry, inode, mode);
+	}
+out_revert_creds:
+	revert_creds(old_cred);
+	return err;
+}
+
+
+static int ovl_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
+		       struct dentry *dentry, umode_t mode)
+{
+	int err;
+	struct inode *inode;
+
+	dentry->d_fsdata = ovl_alloc_entry(0);
+	if (!dentry->d_fsdata)
+		return -ENOMEM;
+
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out;
+
+	/* Preallocate inode to be used by ovl_get_inode() */
+	err = -ENOMEM;
+	inode = ovl_new_inode(dentry->d_sb, mode, 0);
+	if (!inode)
+		goto out_drop_write;
+
+	spin_lock(&inode->i_lock);
+	inode->i_state |= I_CREATING;
+	spin_unlock(&inode->i_lock);
+
+	inode_init_owner(&init_user_ns, inode, dentry->d_parent->d_inode, mode);
+	mode = inode->i_mode;
+
+	err = ovl_create_tmpfile(dentry, inode, mode);
+	/* Did we end up using the preallocated inode? */
+	if (inode != d_inode(dentry))
+		iput(inode);
+
+out_drop_write:
+	ovl_drop_write(dentry);
+out:
+	return err;
+}
+
 const struct inode_operations ovl_dir_inode_operations = {
 	.lookup		= ovl_lookup,
 	.mkdir		= ovl_mkdir,
@@ -1313,4 +1434,5 @@ const struct inode_operations ovl_dir_in
 	.update_time	= ovl_update_time,
 	.fileattr_get	= ovl_fileattr_get,
 	.fileattr_set	= ovl_fileattr_set,
+	.tmpfile	= ovl_tmpfile,
 };

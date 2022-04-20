Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A184C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Apr 2022 08:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376699AbiDTIYz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376694AbiDTIYy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Apr 2022 04:24:54 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F7F255AA
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Apr 2022 01:22:08 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id f14so484309qtq.1
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Apr 2022 01:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pVxuJJXCuSArBE1h4V18bAfaqjFXStGzpp3sS7jwSvo=;
        b=QYrCQlm30bPBFiJdXDmO4aU7bpaIWLms3HhAYWSGfM1yMXA14Rv+A+qVET7z1sU5aN
         V7pZxKTd0KrVo+Cp0qJ34kSmVji0Snzkhf/0oSw+piRR37+UYdKR7Uq39WX7+IBm0A6O
         zdmgmZcmMLra6/saCozgEh0bNr1uK0KkU1evMKgZUFDmlwa7/D9bb/P63lXYNcaQquSS
         TqfPgZuCgH2pNm88IUC/3miA/BAj3b80uoipnXwDLHiqWFBEILS/4wzEw8Y6VY8z7bR1
         r/9SST2xoNqg/4hzDua02kalmVuYy7Qx8rnciplRl1wFaMFblKnbspCyaivR4fLjWvyL
         ai+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pVxuJJXCuSArBE1h4V18bAfaqjFXStGzpp3sS7jwSvo=;
        b=r+fVFANVBGeiaEuFDEtxbevuXzp0wrfQBnn4xgc0EdRvqjndsY0yMs7TQ4s1tO+WPw
         LD7/diiIx+9sWqJSE1TYEmjzdoVeYHCXbfNFLI2SV6bBRHhewHLvRmZTR/O4Z57thSy4
         9ry2B+bdPuQZk+0X12fCOrhK2tdkiDm0nUg8K4CLiSTfJHpVXUaak0iCnRxcydk9SNj9
         EjSB1OnyXRSy1rbMKuLXsQ+tUa4seBlQFQIFt3Jq3fFV4kRBocZRU+EuKzL5c6KRpyKj
         /4b419xMUPoZxXOcoNHLMPAaA7bxMLKH7dndNev7YVHA6sVZhvv+9F6umnRQKeJgVBH5
         yWFQ==
X-Gm-Message-State: AOAM530hpx1ggE0cGvsW0LdNFyFnvbhZ1Y5/oN2lU6OH9IpNj20et22z
        ssIz1z3GE8LWTM8Ey/9GfmM5w52gPrzbPf0WT+s=
X-Google-Smtp-Source: ABdhPJxJUCpFZ4JNS1m5/uRmRbUMS/AfExLf2+mKj+wLCEkrr0Mev+tImMPvcWaC19pGhtp33sCzMUnCkIwpXycaJ7U=
X-Received: by 2002:ac8:4e46:0:b0:2e1:b933:ec06 with SMTP id
 e6-20020ac84e46000000b002e1b933ec06mr13020450qtw.684.1650442927820; Wed, 20
 Apr 2022 01:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net> <CAOQ4uxh_P0fiV9gQOs9CLvB+xJpJT4hWfAFyKBx0A-TyxAma8Q@mail.gmail.com>
 <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
In-Reply-To: <YXvvAMJxj/DlyUqC@miu.piliscsaba.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 20 Apr 2022 11:21:56 +0300
Message-ID: <CAOQ4uxi2QR=v-KXMKT70H=dwo1hF1BasFX3QaBz2XRiyQAOreQ@mail.gmail.com>
Subject: Re: overlayfs: supporting O_TMPFILE
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     =?UTF-8?Q?Georg_M=C3=BCller?= <georgmueller@gmx.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 29, 2021 at 3:54 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Oct 29, 2021 at 01:37:49AM +0300, Amir Goldstein wrote:
> > On Thu, Oct 28, 2021 at 11:41 PM Georg M=C3=BCller <georgmueller@gmx.ne=
t> wrote:
> > >
> > > Hi,
> > >
> > > I was trying to implement .tmpfile for overlayfs inode_operations to =
support O_TMPFILE.
> > >
> > > Docker with aufs supports it, but this is deprecated and removed from=
 current docker. I now have a work-around in my code (create tmpfile+unlink=
), but
> > > I thought it might be a good idea to have tmpfile support in overlayf=
s.
> > >
> > > I was trying to do it on my own, but I have some headaches to what is=
 necessary to achieve the goal.
> > >
> > >  From my understanding, I have to find the dentry for the upper dir (=
or workdir) and call vfs_tmpdir() for this, but I am running from oops to o=
ops.
> > >
> > > Is there some hint what I have to do to achieve the goal?
> > >
> >
> > You'd want to use ovl_create_object() and probably pass a tmpfile argum=
ent
> > then pass it on struct ovl_cattr to ovl_create_or_link() after that
> > it becomes more complicated. You'd need ovl_create_tempfile() like
> > ovl_create_upper().
> > You can follow xfs_generic_create() for some clues.
> > You need parts of ovl_instantiate() but not all of it - it's a mess.
>
> Here's something I prepared earlier ;)
>
> Don't know why it got stuck, quite possibly I realized some fatal flaw th=
at I
> can't remember anymore...
>
> Seems to work though, so getting this out for review and testing.
>

You may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

(See one suggestion below)

and

Tested-by: Amir Goldstein <amir73il@gmail.com>

With this patch, these fstests now run and pass:
generic/004 generic/389

generic/530 and generic/531 also use O_TMPFILE, but they also ran before th=
is
patch because they fall back to creat+unlink when O_TMPFILE fails

generic/530 passes and generic/531 OOMs on my VM with or without this patch=
.

No regressions observed with -g overlay/quick.

Thanks,
Amir.

>
> ---
>  fs/overlayfs/dir.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>  1 file changed, 122 insertions(+)
>
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1295,6 +1295,127 @@ static int ovl_rename(struct user_namesp
>         return err;
>  }
>
> +static int ovl_create_upper_tmpfile(struct dentry *dentry, struct inode =
*inode,
> +                                   umode_t mode)
> +{
> +       struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent);
> +       struct dentry *newdentry;
> +       struct ovl_inode_params oip;
> +
> +       if (!IS_POSIXACL(d_inode(upperdir)))
> +               mode &=3D ~current_umask();
> +
> +       newdentry =3D vfs_tmpfile(&init_user_ns, upperdir, mode, 0);
> +       if (IS_ERR(newdentry))
> +               return PTR_ERR(newdentry);
> +
> +       oip =3D (struct ovl_inode_params) {
> +               .upperdentry =3D newdentry,
> +               .newinode =3D inode,
> +       };
> +
> +       ovl_dentry_set_upper_alias(dentry);
> +       ovl_dentry_update_reval(dentry, newdentry,
> +                       DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)=
;
> +
> +       /*
> +        * ovl_obtain_alias() can be called after ovl_create_real()
> +        * and before we get here, so we may get an inode from cache
> +        * with the same real upperdentry that is not the inode we
> +        * pre-allocated.  In this case we will use the cached inode
> +        * to instantiate the new dentry.
> +        */
> +       inode =3D ovl_get_inode(dentry->d_sb, &oip);
> +       if (IS_ERR(inode)) {
> +               dput(newdentry);
> +               return PTR_ERR(inode);
> +       }
> +       /* d_tmpfile() expects inode to have a positive link count */
> +       set_nlink(inode, 1);
> +
> +       d_tmpfile(dentry, inode);
> +       if (inode !=3D oip.newinode) {
> +               pr_warn_ratelimited("newly created inode found in cache (=
%pd2)\n",
> +                                   dentry);
> +       }
> +       return 0;
> +}
> +
> +static int ovl_create_tmpfile(struct dentry *dentry, struct inode *inode=
,
> +                             umode_t mode)
> +{
> +       int err;
> +       const struct cred *old_cred;
> +       struct cred *override_cred;
> +       struct dentry *parent =3D dentry->d_parent;
> +
> +       err =3D ovl_copy_up(parent);
> +       if (err)
> +               return err;
> +
> +       old_cred =3D ovl_override_creds(dentry->d_sb);
> +
> +       err =3D -ENOMEM;
> +       override_cred =3D prepare_creds();
> +       if (override_cred) {
> +               override_cred->fsuid =3D inode->i_uid;
> +               override_cred->fsgid =3D inode->i_gid;
> +               err =3D security_dentry_create_files_as(dentry, mode,
> +                                                     &dentry->d_name, ol=
d_cred,
> +                                                     override_cred);
> +               if (err) {
> +                       put_cred(override_cred);
> +                       goto out_revert_creds;
> +               }
> +               put_cred(override_creds(override_cred));
> +               put_cred(override_cred);
> +
> +               err =3D ovl_create_upper_tmpfile(dentry, inode, mode);
> +       }
> +out_revert_creds:
> +       revert_creds(old_cred);
> +       return err;
> +}
> +
> +
> +static int ovl_tmpfile(struct user_namespace *mnt_userns, struct inode *=
dir,
> +                      struct dentry *dentry, umode_t mode)
> +{
> +       int err;
> +       struct inode *inode;
> +

You could add here:

+       if (!OVL_FS(dentry->d_sb)->tmpfile)
+               return -EOPNOTSUPP;

+

> +       dentry->d_fsdata =3D ovl_alloc_entry(0);
> +       if (!dentry->d_fsdata)
> +               return -ENOMEM;
> +
> +       err =3D ovl_want_write(dentry);
> +       if (err)
> +               goto out;
> +
> +       /* Preallocate inode to be used by ovl_get_inode() */
> +       err =3D -ENOMEM;
> +       inode =3D ovl_new_inode(dentry->d_sb, mode, 0);
> +       if (!inode)
> +               goto out_drop_write;
> +
> +       spin_lock(&inode->i_lock);
> +       inode->i_state |=3D I_CREATING;
> +       spin_unlock(&inode->i_lock);
> +
> +       inode_init_owner(&init_user_ns, inode, dentry->d_parent->d_inode,=
 mode);
> +       mode =3D inode->i_mode;
> +
> +       err =3D ovl_create_tmpfile(dentry, inode, mode);
> +       /* Did we end up using the preallocated inode? */
> +       if (inode !=3D d_inode(dentry))
> +               iput(inode);
> +
> +out_drop_write:
> +       ovl_drop_write(dentry);
> +out:
> +       return err;
> +}
> +
>  const struct inode_operations ovl_dir_inode_operations =3D {
>         .lookup         =3D ovl_lookup,
>         .mkdir          =3D ovl_mkdir,
> @@ -1313,4 +1434,5 @@ const struct inode_operations ovl_dir_in
>         .update_time    =3D ovl_update_time,
>         .fileattr_get   =3D ovl_fileattr_get,
>         .fileattr_set   =3D ovl_fileattr_set,
> +       .tmpfile        =3D ovl_tmpfile,
>  };

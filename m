Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6181C77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 05:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbjD0Fsh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 01:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjD0Fsg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 01:48:36 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C063583
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 22:48:35 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-4301281573aso2650325137.3
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 22:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682574514; x=1685166514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jkyxuiXpZyBL1732GGYL3y6nGcUtrqmCUdu9Q2HjlJ8=;
        b=nVpd0JoL/a/4zGVtkdbpaQ/3UgOwznlHaKC/Xel1S7XIo+Dto6DXD42E8qB9OaIG7x
         w6XvuhgYhxDD2AhnSYNUTzn8xtTTIjcUoC7LTB/phkT6MuT3tEjC9rg5R8Oxv+nZJECt
         crv/+6ipnt+O+hgQDgtrus/TMb/x58e+w6E/wnTjW5CWLjoFggYyX+ENxzA12W+eSri/
         Qrk6KUd3vVJReJzmceukXbgb4p0p1lT5e7dMeLp54xvTBZkPjpjHNCSjDrOqHAKIHJ4C
         bDFBQBvGnf0yUIcAm6f8HYnWr4wLxx4ANhCqHnhOZtXrBfF5j3Edowc9dO/Wnwo7Ym8X
         Xabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682574514; x=1685166514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jkyxuiXpZyBL1732GGYL3y6nGcUtrqmCUdu9Q2HjlJ8=;
        b=XzYH77hZv6DrKVjl1h/tRkFSoX/aAT71Ubuk6SNwbICsY+iIhoQ9mIA6wQDoRE23lG
         bLz0e9AkcYTfNrWzW24S3RfJdWK9IfQSa9WKQWKeCjStCSWEwz8iPbl1iuq9wGzGUS1R
         xZQGDd4MwmvZIx3XM7OL3qt5ABzo/X98X3+X74hWRx7dcR3XBsfH9OP4AEsnKm5KrUoZ
         T0mVki8Tw1c+d58TfX3SxqBw6jlETCnD+A0m6jGgJjPuiwJvuIALfnKVeHuZkR0Xikwq
         gtOF+meCHcEOXoZ3ol47JQHHKV21YtztJyw/31Fn16neXtu3OoSB9wb2TW2ZfdbHZ45J
         xCmA==
X-Gm-Message-State: AC+VfDxFfXJeE/RcXhwBh/QN1etECG0NRAhAmTJdnEN8lpc2C7rA/02J
        RGEtixcz1NwTfKm3jzAXf6iWjtOd5ki9FudqH6w2NAlkMvg=
X-Google-Smtp-Source: ACHHUZ6aJbWRe3Dio/Ay6Th7e8dWt8MgxPEKhoKj+amZz1ArA635Bj7lVlKM0InRa4rMSBT+YTae6OY+jN27FZcUaf8=
X-Received: by 2002:a67:f759:0:b0:42c:488a:143e with SMTP id
 w25-20020a67f759000000b0042c488a143emr168185vso.17.1682574514261; Wed, 26 Apr
 2023 22:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230408164302.1392694-1-amir73il@gmail.com> <20230408164302.1392694-2-amir73il@gmail.com>
 <ae948b16-d35a-64eb-b9f4-127f66c232bb@linux.alibaba.com>
In-Reply-To: <ae948b16-d35a-64eb-b9f4-127f66c232bb@linux.alibaba.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Apr 2023 08:48:22 +0300
Message-ID: <CAOQ4uxhTXy31nOXCF3691Cm6qPGOMu_H9aE=nz4KVRTs-1oVPQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] ovl: update of dentry revalidate flags after copy up
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Larsson <alexl@redhat.com>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 14, 2023 at 10:21=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba=
.com> wrote:
>
>
>
> On 2023/4/9 00:42, Amir Goldstein wrote:
> > After copy up, we may need to update d_flags if upper dentry is on a
> > remote fs and lower dentries are not.
> >
> > Add helpers to allow incremental update of the revalidate flags.
> >
> > Fixes: bccece1ead36 ("ovl: allow remote upper")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>
> > ---
> >   fs/overlayfs/copy_up.c   |  2 ++
> >   fs/overlayfs/dir.c       |  3 +--
> >   fs/overlayfs/export.c    |  3 +--
> >   fs/overlayfs/namei.c     |  3 +--
> >   fs/overlayfs/overlayfs.h |  6 ++++--
> >   fs/overlayfs/super.c     |  2 +-
> >   fs/overlayfs/util.c      | 24 ++++++++++++++++++++----
> >   7 files changed, 30 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index c14e90764e35..7bf101e756c8 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -576,6 +576,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
> >                       /* Restore timestamps on parent (best effort) */
> >                       ovl_set_timestamps(ofs, upperdir, &c->pstat);
> >                       ovl_dentry_set_upper_alias(c->dentry);
> > +                     ovl_dentry_update_reval(c->dentry, upper);
> >               }
> >       }
> >       inode_unlock(udir);
> > @@ -895,6 +896,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c=
)
> >               inode_unlock(udir);
> >
> >               ovl_dentry_set_upper_alias(c->dentry);
> > +             ovl_dentry_update_reval(c->dentry, ovl_dentry_upper(c->de=
ntry));
> >       }
> >
> >   out:
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index fc25fb95d5fc..9be52d8013c8 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -269,8 +269,7 @@ static int ovl_instantiate(struct dentry *dentry, s=
truct inode *inode,
> >
> >       ovl_dir_modified(dentry->d_parent, false);
> >       ovl_dentry_set_upper_alias(dentry);
> > -     ovl_dentry_update_reval(dentry, newdentry,
> > -                     DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)=
;
> > +     ovl_dentry_init_reval(dentry, newdentry);
> >
> >       if (!hardlink) {
> >               /*
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index defd4e231ad2..5c36fb3a7bab 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -326,8 +326,7 @@ static struct dentry *ovl_obtain_alias(struct super=
_block *sb,
> >       if (upper_alias)
> >               ovl_dentry_set_upper_alias(dentry);
> >
> > -     ovl_dentry_update_reval(dentry, upper,
> > -                     DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)=
;
> > +     ovl_dentry_init_reval(dentry, upper);
> >
> >       return d_instantiate_anon(dentry, inode);
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index cfb3420b7df0..100a492d2b2a 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -1122,8 +1122,7 @@ struct dentry *ovl_lookup(struct inode *dir, stru=
ct dentry *dentry,
> >                       ovl_set_flag(OVL_UPPERDATA, inode);
> >       }
> >
> > -     ovl_dentry_update_reval(dentry, upperdentry,
> > -                     DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)=
;
> > +     ovl_dentry_init_reval(dentry, upperdentry);
> >
> >       revert_creds(old_cred);
> >       if (origin_path) {
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index 4d0b278f5630..e100c55bb924 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -375,8 +375,10 @@ bool ovl_index_all(struct super_block *sb);
> >   bool ovl_verify_lower(struct super_block *sb);
> >   struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
> >   bool ovl_dentry_remote(struct dentry *dentry);
> > -void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upp=
erdentry,
> > -                          unsigned int mask);
> > +void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *rea=
ldentry);
> > +void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upper=
dentry);
> > +void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upper=
dentry,
> > +                        unsigned int mask);
> >   bool ovl_dentry_weird(struct dentry *dentry);
> >   enum ovl_path_type ovl_path_type(struct dentry *dentry);
> >   void ovl_path_upper(struct dentry *dentry, struct path *path);
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index f1d9f75f8786..49b6956468f9 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1885,7 +1885,7 @@ static struct dentry *ovl_get_root(struct super_b=
lock *sb,
> >       ovl_dentry_set_flag(OVL_E_CONNECTED, root);
> >       ovl_set_upperdata(d_inode(root));
> >       ovl_inode_init(d_inode(root), &oip, ino, fsid);
> > -     ovl_dentry_update_reval(root, upperdentry, DCACHE_OP_WEAK_REVALID=
ATE);
> > +     ovl_dentry_init_flags(root, upperdentry, DCACHE_OP_WEAK_REVALIDAT=
E);
> >
> >       return root;
> >   }
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 923d66d131c1..6a0652bd51f2 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -94,14 +94,30 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numl=
ower)
> >       return oe;
> >   }
> >
> > +#define OVL_D_REVALIDATE (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALI=
DATE)
> > +
> >   bool ovl_dentry_remote(struct dentry *dentry)
> >   {
> > -     return dentry->d_flags &
> > -             (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
> > +     return dentry->d_flags & OVL_D_REVALIDATE;
> > +}
> > +
> > +void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *rea=
ldentry)
> > +{
> > +     if (!ovl_dentry_remote(realdentry))
> > +             return;
> > +
> > +     spin_lock(&dentry->d_lock);
> > +     dentry->d_flags |=3D realdentry->d_flags & OVL_D_REVALIDATE;
>
> Although I'm not sure if it could cause some lazy awareness due to dcache
> RCU-walk, but maybe that is fine since such window is small?
>

Good question.
I am not sure.
The alternative would be to the set revalidate flags on non-upper dentry
if the upper fs is remote.

Thanks,
Amir.

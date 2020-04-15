Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B5BC2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 11:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EED420575
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 11:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZI2H9k6N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896973AbgDOL1B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 07:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896945AbgDOL0y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 07:26:54 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960EDC061A0C
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 04:26:52 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t8so2964000ilj.3
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 04:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tNBcsi45lqEGus+BFktvgVteQqW7B0Vol9uoT03+xIQ=;
        b=ZI2H9k6Ns/RwRYQJSYQ9A6Vg5G3afIitYhlT00yseq0nwcz4ypEMbQtosgpFZ7OzU2
         xzNCiT7qPFktP5Zn7GBhQkxYXO8fvQDZfqC+zP+paR5SbewIXmB8NdL8hAxsLsX6/Kvd
         kZRmMJPmuWyUzzCTStsYMOHLbVsGDP/TaBP2s8lg8vkpFIH1eKqs7HINhHpap60XueYb
         Bqo76KHZ0WXtLmEQ8Hf813VE7/d6IXBP5CVoVxIqwNnA/gd/oNC+GeAotgoed4EFVd/H
         WWI1M4wrxVpG0+ZU4xkhvtSYcYQ4vv1x4ZyWwIx08PAYW9X9X3W0eS4Op3aaqFALR9uE
         Oaxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tNBcsi45lqEGus+BFktvgVteQqW7B0Vol9uoT03+xIQ=;
        b=q3ygWRzOyK+IT6AIiPJlCjoTkHESMfcuy10uer4xYQI759cTHZGboNH+A8Az7+xbJn
         pvm9fNZ9YZfp40776C/qa2Vq1xoVXhvfi0WLWr38fMxYZzd1IzcHjRuM+FG41MVIrQgq
         BDHmv8tljG1Yta7CiD7eDQSXpQQtoDatYutANtJk8wqt78El8d1ocj1IViD1+AoW2Lav
         +btfJ03Lt9TcGizd83ZyJSW6bzi+hFsNVL+9t5fqV6gXNo1nrLe56xcbgvb/rwZU0gca
         zPudFhTJ7HiEKi92hBufv8gII8qaPd7LSIEo+Nxa9YJY/neiGVB7rtoKU4dHAAbgID1o
         O5lQ==
X-Gm-Message-State: AGi0PubNXCDpQmD+g9P6Sa64mI3LV0iHRtpm55pLkqV3vb6DmtR4oY+f
        42RLEE2wCb8afqjRf0vcK5Vda84KymyOf1TJ7DU=
X-Google-Smtp-Source: APiQypIe3e/0nkk/IPa1Ofz/fl0yavw1zTzswDoZ6p9vif2g5gJptVD9S5B1ZLKt1hLO6zS8zYXefo/NRPevjJuvd7A=
X-Received: by 2002:a92:7e86:: with SMTP id q6mr597955ill.9.1586950011817;
 Wed, 15 Apr 2020 04:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
 <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com>
 <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net>
 <CAOQ4uxg0CYuQ-EfOphk-v-o5hvyVr0UbD5nngse9Zi4M5ZxNgw@mail.gmail.com> <1717cf65ddb.d406587710513.3094673612298718285@mykernel.net>
In-Reply-To: <1717cf65ddb.d406587710513.3094673612298718285@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 15 Apr 2020 14:26:40 +0300
Message-ID: <CAOQ4uxgXtjsZXkm60J2omXmnj-2cHwQZ=jmf3+GYN_KdW8JovA@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 15, 2020 at 11:30 AM Chengguang Xu <cgxu519@mykernel.net> wrote=
:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 16:12:04 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Wed, Apr 15, 2020 at 11:01 AM Chengguang Xu <cgxu519@mykernel.net> =
wrote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 15:03:09 Ami=
r Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > On Wed, Apr 15, 2020 at 4:03 AM Chengguang Xu <cgxu519@mykernel.n=
et> wrote:
>  > >  > >
>  > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 21:44:3=
9 Amir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > >  > On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@myke=
rnel.net> wrote:
>  > >  > >  > >
>  > >  > >  > > Sharing inode with different whiteout files for saving
>  > >  > >  > > inode and speeding up deleting operation.
>  > >  > >  > >
>  > >  > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > >  > >  > > ---
>  > >  > >  > > v1->v2:
>  > >  > >  > > - Address Amir's comments in v1
>  > >  > >  > >
>  > >  > >  > > v2->v3:
>  > >  > >  > > - Address Amir's comments in v2
>  > >  > >  > > - Rebase on Amir's "Overlayfs use index dir as work dir" p=
atch set
>  > >  > >  > > - Keep at most one whiteout tmpfile in work dir
>  > >  > >  > >
>  > >  > >  > >  fs/overlayfs/dir.c       | 35 +++++++++++++++++++++++++++=
+-------
>  > >  > >  > >  fs/overlayfs/overlayfs.h |  9 +++++++--
>  > >  > >  > >  fs/overlayfs/ovl_entry.h |  4 ++++
>  > >  > >  > >  fs/overlayfs/readdir.c   |  3 ++-
>  > >  > >  > >  fs/overlayfs/super.c     |  9 +++++++++
>  > >  > >  > >  fs/overlayfs/util.c      |  3 ++-
>  > >  > >  > >  6 files changed, 52 insertions(+), 11 deletions(-)
>  > >  > >  > >
>  > >  > >  > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>  > >  > >  > > index 279009dee366..dbe5e54dcb16 100644
>  > >  > >  > > --- a/fs/overlayfs/dir.c
>  > >  > >  > > +++ b/fs/overlayfs/dir.c
>  > >  > >  > > @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(struct =
dentry *workdir)
>  > >  > >  > >  }
>  > >  > >  > >
>  > >  > >  > >  /* caller holds i_mutex on workdir */
>  > >  > >  > > -static struct dentry *ovl_whiteout(struct dentry *workdir=
)
>  > >  > >  > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, st=
ruct dentry *workdir)
>  > >  > >  > >  {
>  > >  > >  > >         int err;
>  > >  > >  > > +       bool retried =3D false;
>  > >  > >  > > +       bool should_link =3D (ofs->whiteout_link_max > 1);
>  > >  > >  > >         struct dentry *whiteout;
>  > >  > >  > >         struct inode *wdir =3D workdir->d_inode;
>  > >  > >  > >
>  > >  > >  > > +retry:
>  > >  > >  > >         whiteout =3D ovl_lookup_temp(workdir);
>  > >  > >  > >         if (IS_ERR(whiteout))
>  > >  > >  > >                 return whiteout;
>  > >  > >  > >
>  > >  > >  > > +       if (should_link && ofs->whiteout) {
>  > >  > >  >
>  > >  > >  > What happens with ofs->whiteout_link_max =3D=3D 2 is that ha=
lf of the
>  > >  > >  > times, whiteout gets linked and then unlinked.
>  > >  > >  > That is not needed.
>  > >  > >  > I think code would look better like this:
>  > >  > >  >
>  > >  > >  >           if (ovl_whiteout_linkable(ofs)) {
>  > >  > >  >                   err =3D ovl_do_link(ofs->whiteout, wdir, w=
hiteout);
>  > >  > >  > ...
>  > >  > >  >           } else if (ofs->whiteout) {
>  > >  > >  >                   ovl_cleanup(wdir, ofs->whiteout);
>  > >  > >  > ....
>  > >  > >  >
>  > >  > >  > With:
>  > >  > >  >
>  > >  > >  > static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
>  > >  > >  > {
>  > >  > >  >        return ofs->whiteout &&
>  > >  > >  >                  ofs->whiteout->d_inode->i_nlink < ofs->whit=
eout_link_max;
>  > >  > >  > }
>  > >  > >  >
>  > >  > >
>  > >  > > tmpfile has occupied one link, so the maximum link count of whi=
teout inode
>  > >  > > in your code will be ofs->whiteout_link_max - 1, right?
>  > >  > >
>  > >  >
>  > >  > Right, but I wrote wrong pseudo code to use this helper.
>  > >  > The intention is that ovl_whiteout_linkable(ofs) means there is a=
 tmp whiteout
>  > >  > and it may be linked to a new tmp whiteout.
>  > >  > The only reason to cleanup tmp whiteout is if link has unexpected=
ly failed and
>  > >  > in this case I think we should disable whiteout sharing.
>  > >  >
>  > >  > Let me try again:
>  > >  >
>  > >  > +       err =3D -EMLINK;
>  > >  > +       if (ovl_whiteout_linkable(ofs)) {
>  > >  > +               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout=
);
>  > >  > +               if (!err)
>  > >  > +                       return whiteout;
>  > >  > +        }
>  > >  > +        if (err && ofs->whiteout) {
>  > >  > +               pr_warn("failed to link whiteout - disabling whit=
eout
>  > >  > sharing (nlink=3D%u, err =3D %i)\n",
>  > >  > +                             ofs->whiteout->d_inode->i_nlink, er=
r);
>  > >  > +               ofs->whiteout_link_max =3D 0;
>  > >  > +               should_link =3D false;
>  > >  > +               ovl_cleanup(wdir, ofs->whiteout);
>  > >  > +               dput(ofs->whiteout);
>  > >  > +               ofs->whiteout =3D NULL;
>  > >  > +       }
>  > >  > +
>  > >  >          err =3D ovl_do_whiteout(wdir, whiteout);
>  > >  >
>  > >  > Is that better?
>  > >  >
>  > >
>  > > I don't fully understand why should we limit to share only one inode=
 for whiteout files.
>  > > Consider deleting a lot of files(not dir) in lowerdir, we will get -=
EMLINK error because
>  > > the link count of shared inode exceeds the maximum link limit in und=
erlying file system.
>  > > In this case, we can choose another whiteout inode for sharing.
>  > >
>  >
>  > I got it wrong again. I forgot the maxed out case. Take #3:
>  >
>  > +       err =3D 0;
>  > +       if (ovl_whiteout_linkable(ofs)) {
>  > +               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
>  > +               if (!err)
>  > +                       return whiteout;
>  > +        } else if (ofs->whiteout) {
>  > +               dput(whiteout);
>  > +               whiteout =3D ofs->whiteout;
>  > +               ofs->whiteout =3D NULL;
>  > +               return whiteout;
>  > +        }
>  > +        if (err) {
>  > +               pr_warn("failed to link whiteout - disabling whiteout
>  > sharing (nlink=3D%u, err =3D %i)\n",
>  > +                             ofs->whiteout->d_inode->i_nlink, err);
>  > +               ofs->whiteout_link_max =3D 0;
>  > +               should_link =3D false;
>  > +               ovl_cleanup(wdir, ofs->whiteout);
>  > +       }
>  > +
>  >          err =3D ovl_do_whiteout(wdir, whiteout);
>  >
>  >
>  > I hope I got the logic right this time.
>  > Feel free to organize differently.
>  > Disabling should be in the case where failure is not expected
>  > so we want to avoid having every whiteout creation try and fail.
>  > For example if filesystem reported s_max_links is incorrect.
>  >
>
> In case of any unexpected errors, we could set a error limit(for example,=
 10),
> if link error count exceeds the limit then we disable the feature.
>

As far as I am concerned, you may post the patch without auto disable,
but I object to using an arbitrary number of errors (10) as trigger for aut=
o
disable.

I do think that it is important to communicate to admin that the whiteout
sharing is not working as expected and it is not acceptable to flood
log with warning on each and every whiteout creation, not even with
pr_warn_ratelimited.

There are several ways you can go about this, but here is a suggestion:

+        if (err) {
+               ofs->whiteout_link_max >>=3D 1;
+               pr_warn("failed to link whiteout (nlink=3D%u, err =3D %i)
- lowering whiteout_link_max to %u\n",
+                             ofs->whiteout->d_inode->i_nlink, err,
ofs->whiteout_link_max);
+               should_link =3D false;
+               ovl_cleanup(wdir, ofs->whiteout);
+       }

Thanks,
Amir.

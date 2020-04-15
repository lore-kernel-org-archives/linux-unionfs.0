Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3495C2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 08:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775D92051A
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 08:12:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DjtLS+7D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635662AbgDOIMZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635647AbgDOIMR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 04:12:17 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7D9C061A0F
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 01:12:16 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c17so2473366ilk.6
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 01:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JPPUx2dvQz70fwwfpQ1RiNAGZBnjlTRbf7aZBKVJl3E=;
        b=DjtLS+7Dl5bCtzvjLSwUElXKpmKg5pCn7GmMB9zsBQoSG/+x9/so64EbJsxI65q74e
         WXUfSMTMGFet6xGh6ePvY1YVAzWZJn+0Vf3fBdGlJ0hxdDB1ogC7DpeOPtRZheu/JcAP
         ocDQlT6XBndns8mKDkFqJP2k2SVlYC+RSnO+8DS5M//UCARmHaXDlNtyUgvCDQ3GQujW
         wTn2QKfq9rPuGHmA7cMsqqQAXjG8uegbiiDz39Y54zicT7W4vvUdmiOJ9h0TKymd+dxr
         IXlBwh1nuiVxcU52qsiwq29MGkAheQ87pmBOxPmguCXdv2D37foWBjrRBKi2EZGZ6TFE
         K90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JPPUx2dvQz70fwwfpQ1RiNAGZBnjlTRbf7aZBKVJl3E=;
        b=KUgpUKzHznfCs+aWNyIBQlHk+JTu2Js+oKT37G49Jwlk+G6NShbeKWXSYc1p2WaQtQ
         KvYyyzVe/9hWH6c7fFw6f4bir3FkiN51UQwbBw96WAU0FYVLgSXziCMST/2zQDAa/OB5
         /OJxCZOnoEMbtOadQBxXQIR1wasbCP5cMBL8hSvzUhl1KODFO4k++IGqAzX6v4wqMrDt
         BPm2v8aLBftWThj61JvN7Mw6mRLx/KulPW5UB/aBTMSjsMxlwHuFzKuD/2XFabmsCQih
         weeIs80DZqOkV/pBeK+k0qTTRk61QXHMb65+iE1Acz2Ak6R1RH19s2VD19EWFcna0TEN
         C0bQ==
X-Gm-Message-State: AGi0Pua6z9tlJtM/AKnRoQ1NN31DaCYpsulfSn/eFWHGUdl/35bUL8J9
        2kAjslhGf+YvCn5NybQxpe60pFitlJ4Db/okqAfngRgm
X-Google-Smtp-Source: APiQypK0DR16OGrLE6U3FaFJB+czGFFRTlpcd1liBBDUu8nZ0MXDb0jOQvMQQdCUNQDBX/2WPbEJVFNEMo8tHfzVHmo=
X-Received: by 2002:a92:394d:: with SMTP id g74mr4248042ila.250.1586938336064;
 Wed, 15 Apr 2020 01:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
 <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com> <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net>
In-Reply-To: <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 15 Apr 2020 11:12:04 +0300
Message-ID: <CAOQ4uxg0CYuQ-EfOphk-v-o5hvyVr0UbD5nngse9Zi4M5ZxNgw@mail.gmail.com>
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

On Wed, Apr 15, 2020 at 11:01 AM Chengguang Xu <cgxu519@mykernel.net> wrote=
:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 15:03:09 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Wed, Apr 15, 2020 at 4:03 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 21:44:39 Ami=
r Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@mykernel.=
net> wrote:
>  > >  > >
>  > >  > > Sharing inode with different whiteout files for saving
>  > >  > > inode and speeding up deleting operation.
>  > >  > >
>  > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > >  > > ---
>  > >  > > v1->v2:
>  > >  > > - Address Amir's comments in v1
>  > >  > >
>  > >  > > v2->v3:
>  > >  > > - Address Amir's comments in v2
>  > >  > > - Rebase on Amir's "Overlayfs use index dir as work dir" patch =
set
>  > >  > > - Keep at most one whiteout tmpfile in work dir
>  > >  > >
>  > >  > >  fs/overlayfs/dir.c       | 35 ++++++++++++++++++++++++++++----=
---
>  > >  > >  fs/overlayfs/overlayfs.h |  9 +++++++--
>  > >  > >  fs/overlayfs/ovl_entry.h |  4 ++++
>  > >  > >  fs/overlayfs/readdir.c   |  3 ++-
>  > >  > >  fs/overlayfs/super.c     |  9 +++++++++
>  > >  > >  fs/overlayfs/util.c      |  3 ++-
>  > >  > >  6 files changed, 52 insertions(+), 11 deletions(-)
>  > >  > >
>  > >  > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>  > >  > > index 279009dee366..dbe5e54dcb16 100644
>  > >  > > --- a/fs/overlayfs/dir.c
>  > >  > > +++ b/fs/overlayfs/dir.c
>  > >  > > @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(struct dentr=
y *workdir)
>  > >  > >  }
>  > >  > >
>  > >  > >  /* caller holds i_mutex on workdir */
>  > >  > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
>  > >  > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct =
dentry *workdir)
>  > >  > >  {
>  > >  > >         int err;
>  > >  > > +       bool retried =3D false;
>  > >  > > +       bool should_link =3D (ofs->whiteout_link_max > 1);
>  > >  > >         struct dentry *whiteout;
>  > >  > >         struct inode *wdir =3D workdir->d_inode;
>  > >  > >
>  > >  > > +retry:
>  > >  > >         whiteout =3D ovl_lookup_temp(workdir);
>  > >  > >         if (IS_ERR(whiteout))
>  > >  > >                 return whiteout;
>  > >  > >
>  > >  > > +       if (should_link && ofs->whiteout) {
>  > >  >
>  > >  > What happens with ofs->whiteout_link_max =3D=3D 2 is that half of=
 the
>  > >  > times, whiteout gets linked and then unlinked.
>  > >  > That is not needed.
>  > >  > I think code would look better like this:
>  > >  >
>  > >  >           if (ovl_whiteout_linkable(ofs)) {
>  > >  >                   err =3D ovl_do_link(ofs->whiteout, wdir, whiteo=
ut);
>  > >  > ...
>  > >  >           } else if (ofs->whiteout) {
>  > >  >                   ovl_cleanup(wdir, ofs->whiteout);
>  > >  > ....
>  > >  >
>  > >  > With:
>  > >  >
>  > >  > static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
>  > >  > {
>  > >  >        return ofs->whiteout &&
>  > >  >                  ofs->whiteout->d_inode->i_nlink < ofs->whiteout_=
link_max;
>  > >  > }
>  > >  >
>  > >
>  > > tmpfile has occupied one link, so the maximum link count of whiteout=
 inode
>  > > in your code will be ofs->whiteout_link_max - 1, right?
>  > >
>  >
>  > Right, but I wrote wrong pseudo code to use this helper.
>  > The intention is that ovl_whiteout_linkable(ofs) means there is a tmp =
whiteout
>  > and it may be linked to a new tmp whiteout.
>  > The only reason to cleanup tmp whiteout is if link has unexpectedly fa=
iled and
>  > in this case I think we should disable whiteout sharing.
>  >
>  > Let me try again:
>  >
>  > +       err =3D -EMLINK;
>  > +       if (ovl_whiteout_linkable(ofs)) {
>  > +               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
>  > +               if (!err)
>  > +                       return whiteout;
>  > +        }
>  > +        if (err && ofs->whiteout) {
>  > +               pr_warn("failed to link whiteout - disabling whiteout
>  > sharing (nlink=3D%u, err =3D %i)\n",
>  > +                             ofs->whiteout->d_inode->i_nlink, err);
>  > +               ofs->whiteout_link_max =3D 0;
>  > +               should_link =3D false;
>  > +               ovl_cleanup(wdir, ofs->whiteout);
>  > +               dput(ofs->whiteout);
>  > +               ofs->whiteout =3D NULL;
>  > +       }
>  > +
>  >          err =3D ovl_do_whiteout(wdir, whiteout);
>  >
>  > Is that better?
>  >
>
> I don't fully understand why should we limit to share only one inode for =
whiteout files.
> Consider deleting a lot of files(not dir) in lowerdir, we will get -EMLIN=
K error because
> the link count of shared inode exceeds the maximum link limit in underlyi=
ng file system.
> In this case, we can choose another whiteout inode for sharing.
>

I got it wrong again. I forgot the maxed out case. Take #3:

+       err =3D 0;
+       if (ovl_whiteout_linkable(ofs)) {
+               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
+               if (!err)
+                       return whiteout;
+        } else if (ofs->whiteout) {
+               dput(whiteout);
+               whiteout =3D ofs->whiteout;
+               ofs->whiteout =3D NULL;
+               return whiteout;
+        }
+        if (err) {
+               pr_warn("failed to link whiteout - disabling whiteout
sharing (nlink=3D%u, err =3D %i)\n",
+                             ofs->whiteout->d_inode->i_nlink, err);
+               ofs->whiteout_link_max =3D 0;
+               should_link =3D false;
+               ovl_cleanup(wdir, ofs->whiteout);
+       }
+
         err =3D ovl_do_whiteout(wdir, whiteout);


I hope I got the logic right this time.
Feel free to organize differently.
Disabling should be in the case where failure is not expected
so we want to avoid having every whiteout creation try and fail.
For example if filesystem reported s_max_links is incorrect.

Thanks,
Amir.

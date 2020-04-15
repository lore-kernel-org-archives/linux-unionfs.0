Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CB3C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 07:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9412120768
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 07:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLTE5RUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403878AbgDOHDZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 03:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404013AbgDOHDV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 03:03:21 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA98C061A0C
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 00:03:21 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i19so15998497ioh.12
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 00:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=51BdKz0F7J9em6JbwdDhjNQZkPLgYPfp8Cul6CzizOk=;
        b=fLTE5RUuEMEw0g4z+rqelVqAcewKN3J7BcIYDqm1g5UEwdUeDuViI1W5CKsVFztEVO
         MHN1dFfS0CwgiSl3wUKdFtVIYVhLp9cnW9Loc2GzCoy1vf2+ea+Yrhyg8ejyFy8jSeH4
         BEZUGHB8Fc27RHzhi4ZYyqQh1P6VkCWWperPNSbpSIs8u6dr2rsTS+dVbtTU1ExypDR2
         Im61/hGJrredZHq3A+5ajuTsf4jyDa0FHhO01LwKZvF+Rd9hVfN2toay/eMS6pe5cXxK
         udV0DEdZAYw4fO3OtkZ5ZkUg/35V/fIOOgwcSrKB3iGC0GBj2O0ZidPGxIrribbyH4hJ
         UCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=51BdKz0F7J9em6JbwdDhjNQZkPLgYPfp8Cul6CzizOk=;
        b=lCipSaVwmMAP/+ZP0YHZ137LIwGwsj59TY6wkRQ7gljr3lGERooBgrlkCO8juUvU0o
         k8Q8Sk/MZYvQxxwon8f3jEhe+6UPMaW8rMZOtRBMX7XXb0mUL+zyjOlI6rFHB7TH3QnJ
         Krs26XgaQgmOFhqcxgYWLXpCaL3tND3FGJy9cZnvfGfp+1/+vymwyOqfH2nby1aeKYn+
         JETCkLRiY0dDjdGhqHuum3fearKxv/TP83VFDQdGxICPkHxZn7RUnw3tgpBN68gBOA8J
         /+kKR+QD7BRf6Gp+Q4SygyuHKD4Wab6NOFxk5f0J0M+bPnJc1ryTMaM2uo4F4nNzEIYn
         vZ8Q==
X-Gm-Message-State: AGi0PuY8WHd5t+T+9ukYJ+kRsTqVEFTX6miwlz3+ue5xz+rCMcCEeZ9f
        eeZ7qTJC9j9wTsLr5ePt9FBF9qKeid1Ko/QN/ZpOHyoc
X-Google-Smtp-Source: APiQypKnEUv5StZEUSw9m0MeY2cAHCULiMEiH9eJSx3XhlUyQuFNy8rR4GuLF2AtIaQuFnG+X4mB/jNprBOFf4ubufQ=
X-Received: by 2002:a02:4b03:: with SMTP id q3mr24016540jaa.30.1586934201018;
 Wed, 15 Apr 2020 00:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
In-Reply-To: <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 15 Apr 2020 10:03:09 +0300
Message-ID: <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com>
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

On Wed, Apr 15, 2020 at 4:03 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 21:44:39 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@mykernel.net> =
wrote:
>  > >
>  > > Sharing inode with different whiteout files for saving
>  > > inode and speeding up deleting operation.
>  > >
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > > ---
>  > > v1->v2:
>  > > - Address Amir's comments in v1
>  > >
>  > > v2->v3:
>  > > - Address Amir's comments in v2
>  > > - Rebase on Amir's "Overlayfs use index dir as work dir" patch set
>  > > - Keep at most one whiteout tmpfile in work dir
>  > >
>  > >  fs/overlayfs/dir.c       | 35 ++++++++++++++++++++++++++++-------
>  > >  fs/overlayfs/overlayfs.h |  9 +++++++--
>  > >  fs/overlayfs/ovl_entry.h |  4 ++++
>  > >  fs/overlayfs/readdir.c   |  3 ++-
>  > >  fs/overlayfs/super.c     |  9 +++++++++
>  > >  fs/overlayfs/util.c      |  3 ++-
>  > >  6 files changed, 52 insertions(+), 11 deletions(-)
>  > >
>  > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>  > > index 279009dee366..dbe5e54dcb16 100644
>  > > --- a/fs/overlayfs/dir.c
>  > > +++ b/fs/overlayfs/dir.c
>  > > @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(struct dentry *wo=
rkdir)
>  > >  }
>  > >
>  > >  /* caller holds i_mutex on workdir */
>  > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
>  > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentr=
y *workdir)
>  > >  {
>  > >         int err;
>  > > +       bool retried =3D false;
>  > > +       bool should_link =3D (ofs->whiteout_link_max > 1);
>  > >         struct dentry *whiteout;
>  > >         struct inode *wdir =3D workdir->d_inode;
>  > >
>  > > +retry:
>  > >         whiteout =3D ovl_lookup_temp(workdir);
>  > >         if (IS_ERR(whiteout))
>  > >                 return whiteout;
>  > >
>  > > +       if (should_link && ofs->whiteout) {
>  >
>  > What happens with ofs->whiteout_link_max =3D=3D 2 is that half of the
>  > times, whiteout gets linked and then unlinked.
>  > That is not needed.
>  > I think code would look better like this:
>  >
>  >           if (ovl_whiteout_linkable(ofs)) {
>  >                   err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
>  > ...
>  >           } else if (ofs->whiteout) {
>  >                   ovl_cleanup(wdir, ofs->whiteout);
>  > ....
>  >
>  > With:
>  >
>  > static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
>  > {
>  >        return ofs->whiteout &&
>  >                  ofs->whiteout->d_inode->i_nlink < ofs->whiteout_link_=
max;
>  > }
>  >
>
> tmpfile has occupied one link, so the maximum link count of whiteout inod=
e
> in your code will be ofs->whiteout_link_max - 1, right?
>

Right, but I wrote wrong pseudo code to use this helper.
The intention is that ovl_whiteout_linkable(ofs) means there is a tmp white=
out
and it may be linked to a new tmp whiteout.
The only reason to cleanup tmp whiteout is if link has unexpectedly failed =
and
in this case I think we should disable whiteout sharing.

Let me try again:

+       err =3D -EMLINK;
+       if (ovl_whiteout_linkable(ofs)) {
+               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
+               if (!err)
+                       return whiteout;
+        }
+        if (err && ofs->whiteout) {
+               pr_warn("failed to link whiteout - disabling whiteout
sharing (nlink=3D%u, err =3D %i)\n",
+                             ofs->whiteout->d_inode->i_nlink, err);
+               ofs->whiteout_link_max =3D 0;
+               should_link =3D false;
+               ovl_cleanup(wdir, ofs->whiteout);
+               dput(ofs->whiteout);
+               ofs->whiteout =3D NULL;
+       }
+
         err =3D ovl_do_whiteout(wdir, whiteout);

Is that better?

Thanks,
Amir.

Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B3FC2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 08:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66C8020768
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 08:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="WXTSOWWs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408070AbgDOIcB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:32:01 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25355 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408049AbgDOIb6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 04:31:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586939454; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=fX7n9bGBBgH6inhUueKqJ4+0OCQAmzCTR0gyT84scsaA8F7s0m7Z1eJQhcAxD2eWJFgMW1y9uwNBGIATbnnrbzj0SV89AlCJe5lK11NC1eQiP/kbwtvEz3ZoUFV2OrAIHB15YUKd4jg/SRLoBzLdU+fwnkxOd+S4GPhDN/KMVZ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586939454; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=MKG4OYvT+BfqcrRRdneHMVLCFLnBGLlbWTD131AX8kE=; 
        b=Hq1LXI4FUVWmCafpp6CdUpDLhZMOWkSqmquSzTwwFm2yEorXacIQ0hkN/dlArmc/ESfEvmBoXBzUk3vh9sQmTORTtaJS6gHaMqMMQtnnM4aLGZroQM1IlZgS93YZ8sKPtAYxKo1jGuzmut3CWrIAOe8fN5AxhiDYDFslJDL1tNE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586939454;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=MKG4OYvT+BfqcrRRdneHMVLCFLnBGLlbWTD131AX8kE=;
        b=WXTSOWWsnxNnoWnKXm6Ogknzbj8BuV+g2WEfjsxXv1QuT7r2Vt9DeiJabURuyom4
        1ij2+uXKpXD2frUzS9yaB+FLItEyT7010jfiH7wjLZo9ebFPaKv7G1CnOXz5vyY68Vk
        oJjqzru++9efe47t168XTe7iCBGaSiBgKQJ4rx5g=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586939452896947.1042956868331; Wed, 15 Apr 2020 16:30:52 +0800 (CST)
Date:   Wed, 15 Apr 2020 16:30:52 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1717cf65ddb.d406587710513.3094673612298718285@mykernel.net>
In-Reply-To: <CAOQ4uxg0CYuQ-EfOphk-v-o5hvyVr0UbD5nngse9Zi4M5ZxNgw@mail.gmail.com>
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
 <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com> <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net> <CAOQ4uxg0CYuQ-EfOphk-v-o5hvyVr0UbD5nngse9Zi4M5ZxNgw@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: whiteout inode sharing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 16:12:04 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Wed, Apr 15, 2020 at 11:01 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 15:03:09 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Wed, Apr 15, 2020 at 4:03 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 21:44:39 =
Amir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > >  > On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@mykern=
el.net> wrote:
 > >  > >  > >
 > >  > >  > > Sharing inode with different whiteout files for saving
 > >  > >  > > inode and speeding up deleting operation.
 > >  > >  > >
 > >  > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >  > >  > > ---
 > >  > >  > > v1->v2:
 > >  > >  > > - Address Amir's comments in v1
 > >  > >  > >
 > >  > >  > > v2->v3:
 > >  > >  > > - Address Amir's comments in v2
 > >  > >  > > - Rebase on Amir's "Overlayfs use index dir as work dir" pat=
ch set
 > >  > >  > > - Keep at most one whiteout tmpfile in work dir
 > >  > >  > >
 > >  > >  > >  fs/overlayfs/dir.c       | 35 ++++++++++++++++++++++++++++-=
------
 > >  > >  > >  fs/overlayfs/overlayfs.h |  9 +++++++--
 > >  > >  > >  fs/overlayfs/ovl_entry.h |  4 ++++
 > >  > >  > >  fs/overlayfs/readdir.c   |  3 ++-
 > >  > >  > >  fs/overlayfs/super.c     |  9 +++++++++
 > >  > >  > >  fs/overlayfs/util.c      |  3 ++-
 > >  > >  > >  6 files changed, 52 insertions(+), 11 deletions(-)
 > >  > >  > >
 > >  > >  > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > >  > >  > > index 279009dee366..dbe5e54dcb16 100644
 > >  > >  > > --- a/fs/overlayfs/dir.c
 > >  > >  > > +++ b/fs/overlayfs/dir.c
 > >  > >  > > @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(struct de=
ntry *workdir)
 > >  > >  > >  }
 > >  > >  > >
 > >  > >  > >  /* caller holds i_mutex on workdir */
 > >  > >  > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
 > >  > >  > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, stru=
ct dentry *workdir)
 > >  > >  > >  {
 > >  > >  > >         int err;
 > >  > >  > > +       bool retried =3D false;
 > >  > >  > > +       bool should_link =3D (ofs->whiteout_link_max > 1);
 > >  > >  > >         struct dentry *whiteout;
 > >  > >  > >         struct inode *wdir =3D workdir->d_inode;
 > >  > >  > >
 > >  > >  > > +retry:
 > >  > >  > >         whiteout =3D ovl_lookup_temp(workdir);
 > >  > >  > >         if (IS_ERR(whiteout))
 > >  > >  > >                 return whiteout;
 > >  > >  > >
 > >  > >  > > +       if (should_link && ofs->whiteout) {
 > >  > >  >
 > >  > >  > What happens with ofs->whiteout_link_max =3D=3D 2 is that half=
 of the
 > >  > >  > times, whiteout gets linked and then unlinked.
 > >  > >  > That is not needed.
 > >  > >  > I think code would look better like this:
 > >  > >  >
 > >  > >  >           if (ovl_whiteout_linkable(ofs)) {
 > >  > >  >                   err =3D ovl_do_link(ofs->whiteout, wdir, whi=
teout);
 > >  > >  > ...
 > >  > >  >           } else if (ofs->whiteout) {
 > >  > >  >                   ovl_cleanup(wdir, ofs->whiteout);
 > >  > >  > ....
 > >  > >  >
 > >  > >  > With:
 > >  > >  >
 > >  > >  > static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
 > >  > >  > {
 > >  > >  >        return ofs->whiteout &&
 > >  > >  >                  ofs->whiteout->d_inode->i_nlink < ofs->whiteo=
ut_link_max;
 > >  > >  > }
 > >  > >  >
 > >  > >
 > >  > > tmpfile has occupied one link, so the maximum link count of white=
out inode
 > >  > > in your code will be ofs->whiteout_link_max - 1, right?
 > >  > >
 > >  >
 > >  > Right, but I wrote wrong pseudo code to use this helper.
 > >  > The intention is that ovl_whiteout_linkable(ofs) means there is a t=
mp whiteout
 > >  > and it may be linked to a new tmp whiteout.
 > >  > The only reason to cleanup tmp whiteout is if link has unexpectedly=
 failed and
 > >  > in this case I think we should disable whiteout sharing.
 > >  >
 > >  > Let me try again:
 > >  >
 > >  > +       err =3D -EMLINK;
 > >  > +       if (ovl_whiteout_linkable(ofs)) {
 > >  > +               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
 > >  > +               if (!err)
 > >  > +                       return whiteout;
 > >  > +        }
 > >  > +        if (err && ofs->whiteout) {
 > >  > +               pr_warn("failed to link whiteout - disabling whiteo=
ut
 > >  > sharing (nlink=3D%u, err =3D %i)\n",
 > >  > +                             ofs->whiteout->d_inode->i_nlink, err)=
;
 > >  > +               ofs->whiteout_link_max =3D 0;
 > >  > +               should_link =3D false;
 > >  > +               ovl_cleanup(wdir, ofs->whiteout);
 > >  > +               dput(ofs->whiteout);
 > >  > +               ofs->whiteout =3D NULL;
 > >  > +       }
 > >  > +
 > >  >          err =3D ovl_do_whiteout(wdir, whiteout);
 > >  >
 > >  > Is that better?
 > >  >
 > >
 > > I don't fully understand why should we limit to share only one inode f=
or whiteout files.
 > > Consider deleting a lot of files(not dir) in lowerdir, we will get -EM=
LINK error because
 > > the link count of shared inode exceeds the maximum link limit in under=
lying file system.
 > > In this case, we can choose another whiteout inode for sharing.
 > >
 >=20
 > I got it wrong again. I forgot the maxed out case. Take #3:
 >=20
 > +       err =3D 0;
 > +       if (ovl_whiteout_linkable(ofs)) {
 > +               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
 > +               if (!err)
 > +                       return whiteout;
 > +        } else if (ofs->whiteout) {
 > +               dput(whiteout);
 > +               whiteout =3D ofs->whiteout;
 > +               ofs->whiteout =3D NULL;
 > +               return whiteout;
 > +        }
 > +        if (err) {
 > +               pr_warn("failed to link whiteout - disabling whiteout
 > sharing (nlink=3D%u, err =3D %i)\n",
 > +                             ofs->whiteout->d_inode->i_nlink, err);
 > +               ofs->whiteout_link_max =3D 0;
 > +               should_link =3D false;
 > +               ovl_cleanup(wdir, ofs->whiteout);
 > +       }
 > +
 >          err =3D ovl_do_whiteout(wdir, whiteout);
 >=20
 >=20
 > I hope I got the logic right this time.
 > Feel free to organize differently.
 > Disabling should be in the case where failure is not expected
 > so we want to avoid having every whiteout creation try and fail.
 > For example if filesystem reported s_max_links is incorrect.
 >=20
=20
In case of any unexpected errors, we could set a error limit(for example, 1=
0),
if link error count exceeds the limit then we disable the feature.

Thanks,
cgxu=20



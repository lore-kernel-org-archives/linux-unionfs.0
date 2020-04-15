Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BE1C2BB85
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 08:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5500C206F9
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 08:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="OK9sg5QF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393784AbgDOIB6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:01:58 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25386 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393760AbgDOIBx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 04:01:53 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586937682; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=HuXLeRAMebeHtuP6uPUi7PlS93QZZUoTfLgW8YYRq9PsCraYgYGWQMWl3oPlOltGFOch6VTu5zG2CUXXZf/DHxP4RjPocldeaW/dUoWsaxqIMZqS9igzbDoVmATxAQrGUchOq5kcrXIHse6AQ9QQ263I1NPRXZq1GTTjXbkIbcs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586937682; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=9ToEq+ZHMGXVv6tz977zeFNhfwbZ3hLZmh2VhNagpWs=; 
        b=iuLo//kz64JZ12JE3GYRO9SrSl28KKSjjq6VqLMUKIeR1psuZo2nwL31lE2SgLjIn36RYJqJL7vPomffeiAXD0tdJPYP4Pfzovff/3TbNY0V5w6vV2hjqqwMaPkvQSj9l30X+q+OP8y+lWGQCgn2x2sUu1AhGClOQ1qi4aH3ddM=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586937682;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=9ToEq+ZHMGXVv6tz977zeFNhfwbZ3hLZmh2VhNagpWs=;
        b=OK9sg5QF1l0zdK/pu83kDcQgDixaC+5k2IhfmgD5RWSTAz8I4x3PVqs8lUJ2RrTM
        BPOqcB5Z28SgvVgghvVKyHZ5pkQ1y6oxUBD0pUdYzev6EpMXE4oWrz1YteJJSL46CQt
        wVmO++04IYdz4dngkDcGnhDEocEasZaS5+j+Qtkc=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586937678802777.3793029219158; Wed, 15 Apr 2020 16:01:18 +0800 (CST)
Date:   Wed, 15 Apr 2020 16:01:18 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net>
In-Reply-To: <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com>
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net> <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com>
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 15:03:09 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Wed, Apr 15, 2020 at 4:03 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 21:44:39 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@mykernel.ne=
t> wrote:
 > >  > >
 > >  > > Sharing inode with different whiteout files for saving
 > >  > > inode and speeding up deleting operation.
 > >  > >
 > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >  > > ---
 > >  > > v1->v2:
 > >  > > - Address Amir's comments in v1
 > >  > >
 > >  > > v2->v3:
 > >  > > - Address Amir's comments in v2
 > >  > > - Rebase on Amir's "Overlayfs use index dir as work dir" patch se=
t
 > >  > > - Keep at most one whiteout tmpfile in work dir
 > >  > >
 > >  > >  fs/overlayfs/dir.c       | 35 ++++++++++++++++++++++++++++------=
-
 > >  > >  fs/overlayfs/overlayfs.h |  9 +++++++--
 > >  > >  fs/overlayfs/ovl_entry.h |  4 ++++
 > >  > >  fs/overlayfs/readdir.c   |  3 ++-
 > >  > >  fs/overlayfs/super.c     |  9 +++++++++
 > >  > >  fs/overlayfs/util.c      |  3 ++-
 > >  > >  6 files changed, 52 insertions(+), 11 deletions(-)
 > >  > >
 > >  > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > >  > > index 279009dee366..dbe5e54dcb16 100644
 > >  > > --- a/fs/overlayfs/dir.c
 > >  > > +++ b/fs/overlayfs/dir.c
 > >  > > @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(struct dentry =
*workdir)
 > >  > >  }
 > >  > >
 > >  > >  /* caller holds i_mutex on workdir */
 > >  > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
 > >  > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct de=
ntry *workdir)
 > >  > >  {
 > >  > >         int err;
 > >  > > +       bool retried =3D false;
 > >  > > +       bool should_link =3D (ofs->whiteout_link_max > 1);
 > >  > >         struct dentry *whiteout;
 > >  > >         struct inode *wdir =3D workdir->d_inode;
 > >  > >
 > >  > > +retry:
 > >  > >         whiteout =3D ovl_lookup_temp(workdir);
 > >  > >         if (IS_ERR(whiteout))
 > >  > >                 return whiteout;
 > >  > >
 > >  > > +       if (should_link && ofs->whiteout) {
 > >  >
 > >  > What happens with ofs->whiteout_link_max =3D=3D 2 is that half of t=
he
 > >  > times, whiteout gets linked and then unlinked.
 > >  > That is not needed.
 > >  > I think code would look better like this:
 > >  >
 > >  >           if (ovl_whiteout_linkable(ofs)) {
 > >  >                   err =3D ovl_do_link(ofs->whiteout, wdir, whiteout=
);
 > >  > ...
 > >  >           } else if (ofs->whiteout) {
 > >  >                   ovl_cleanup(wdir, ofs->whiteout);
 > >  > ....
 > >  >
 > >  > With:
 > >  >
 > >  > static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
 > >  > {
 > >  >        return ofs->whiteout &&
 > >  >                  ofs->whiteout->d_inode->i_nlink < ofs->whiteout_li=
nk_max;
 > >  > }
 > >  >
 > >
 > > tmpfile has occupied one link, so the maximum link count of whiteout i=
node
 > > in your code will be ofs->whiteout_link_max - 1, right?
 > >
 >=20
 > Right, but I wrote wrong pseudo code to use this helper.
 > The intention is that ovl_whiteout_linkable(ofs) means there is a tmp wh=
iteout
 > and it may be linked to a new tmp whiteout.
 > The only reason to cleanup tmp whiteout is if link has unexpectedly fail=
ed and
 > in this case I think we should disable whiteout sharing.
 >=20
 > Let me try again:
 >=20
 > +       err =3D -EMLINK;
 > +       if (ovl_whiteout_linkable(ofs)) {
 > +               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
 > +               if (!err)
 > +                       return whiteout;
 > +        }
 > +        if (err && ofs->whiteout) {
 > +               pr_warn("failed to link whiteout - disabling whiteout
 > sharing (nlink=3D%u, err =3D %i)\n",
 > +                             ofs->whiteout->d_inode->i_nlink, err);
 > +               ofs->whiteout_link_max =3D 0;
 > +               should_link =3D false;
 > +               ovl_cleanup(wdir, ofs->whiteout);
 > +               dput(ofs->whiteout);
 > +               ofs->whiteout =3D NULL;
 > +       }
 > +
 >          err =3D ovl_do_whiteout(wdir, whiteout);
 >=20
 > Is that better?
 >=20

I don't fully understand why should we limit to share only one inode for wh=
iteout files.
Consider deleting a lot of files(not dir) in lowerdir, we will get -EMLINK =
error because
the link count of shared inode exceeds the maximum link limit in underlying=
 file system.
In this case, we can choose another whiteout inode for sharing.

Thanks,
cgxu









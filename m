Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73065C2BB1D
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 01:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241E72072D
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 01:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="PqFmDxjo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388291AbgDOBDU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:03:20 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25365 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733242AbgDOBDS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Apr 2020 21:03:18 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586912581; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=Pkh4GOk8qrmc4g8SiVrDPgfULrWjZUbomsYLu6/cJTLzpXUY1jNRtA+xRp7PC9hmyNH/hVhJWhs0q6fG+eMpUX01X3/ck65PND5X1MYlb22qFLE6OiVy6xwshltJCwPMff8EnTK8Xq9/5OrnbMjB/VVVhzEscZTT+Af/NhFuy6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586912581; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=p/WCVByU1olJiCZf4qpxf5oQuLZqaSsMcEe0gd+7Evw=; 
        b=rdAdD97ijPqAFFTfyDq+/3VzYc9YQe3yKbaLy7g96HmUqa96nQFnoThs+mLhm1BsKg12qCaHvMwL/xmGXTKCD9ut9gq6uNhyt8MyYYt495H4Qhv0NpqksauExiDw0LyAcjlFukBmVM4zyUH/AYv4zA46gaZPJhXm8t/ooha63yc=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586912581;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=p/WCVByU1olJiCZf4qpxf5oQuLZqaSsMcEe0gd+7Evw=;
        b=PqFmDxjoP6VYma9tlN113tfN2sn+cjoVXcVxe0nq875mhk1dDbq5r+3JEr15IJIg
        CHZj4c0NUS1QDTzxMr6lVF+xkLsNje90gDtsLB5D3DwARnxMTlhOOBwOpaWaRHSm5H/
        S3xaTMS7KAzYVbsjLcODCc6JGLm6pG92j4NnC7ms=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586912580016759.3725658546888; Wed, 15 Apr 2020 09:03:00 +0800 (CST)
Date:   Wed, 15 Apr 2020 09:03:00 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
In-Reply-To: <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 21:44:39 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
 > >
 > > Sharing inode with different whiteout files for saving
 > > inode and speeding up deleting operation.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > > v1->v2:
 > > - Address Amir's comments in v1
 > >
 > > v2->v3:
 > > - Address Amir's comments in v2
 > > - Rebase on Amir's "Overlayfs use index dir as work dir" patch set
 > > - Keep at most one whiteout tmpfile in work dir
 > >
 > >  fs/overlayfs/dir.c       | 35 ++++++++++++++++++++++++++++-------
 > >  fs/overlayfs/overlayfs.h |  9 +++++++--
 > >  fs/overlayfs/ovl_entry.h |  4 ++++
 > >  fs/overlayfs/readdir.c   |  3 ++-
 > >  fs/overlayfs/super.c     |  9 +++++++++
 > >  fs/overlayfs/util.c      |  3 ++-
 > >  6 files changed, 52 insertions(+), 11 deletions(-)
 > >
 > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > > index 279009dee366..dbe5e54dcb16 100644
 > > --- a/fs/overlayfs/dir.c
 > > +++ b/fs/overlayfs/dir.c
 > > @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(struct dentry *work=
dir)
 > >  }
 > >
 > >  /* caller holds i_mutex on workdir */
 > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
 > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry =
*workdir)
 > >  {
 > >         int err;
 > > +       bool retried =3D false;
 > > +       bool should_link =3D (ofs->whiteout_link_max > 1);
 > >         struct dentry *whiteout;
 > >         struct inode *wdir =3D workdir->d_inode;
 > >
 > > +retry:
 > >         whiteout =3D ovl_lookup_temp(workdir);
 > >         if (IS_ERR(whiteout))
 > >                 return whiteout;
 > >
 > > +       if (should_link && ofs->whiteout) {
 >=20
 > What happens with ofs->whiteout_link_max =3D=3D 2 is that half of the
 > times, whiteout gets linked and then unlinked.
 > That is not needed.
 > I think code would look better like this:
 >=20
 >           if (ovl_whiteout_linkable(ofs)) {
 >                   err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
 > ...
 >           } else if (ofs->whiteout) {
 >                   ovl_cleanup(wdir, ofs->whiteout);
 > ....
 >=20
 > With:
 >=20
 > static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
 > {
 >        return ofs->whiteout &&
 >                  ofs->whiteout->d_inode->i_nlink < ofs->whiteout_link_ma=
x;
 > }
 >=20

tmpfile has occupied one link, so the maximum link count of whiteout inode
in your code will be ofs->whiteout_link_max - 1, right?

Thanks,
cgxu



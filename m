Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD467C433F5
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Oct 2021 14:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B682261267
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Oct 2021 14:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhJCOnv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Oct 2021 10:43:51 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25391 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhJCOnv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Oct 2021 10:43:51 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633272097; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=n1pEXttAiQmUM65u/aY5i4R6xXK+jRVWMq/M4Zq7q2Mlqa98a3nP2htMhid2x4s89Nxb1lKZ3bQ+Gc26Eo9cL5C7C8oUyLEOYcs7AE0sf88G/P4PTfbDzsMBzeD3/mp4b5FGIMtDFFIZKNeHMe+diO/YIcIS+iV9dKx17F56b+k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1633272097; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=fx3KUVWD7y9Kq7DkZz3o00OrCefQB9C0q6UjghGTeCc=; 
        b=o2+2/FH+iN0+Psnmmp7rcb5+jijEMSemcFb3QpvwOLwfgh4AKvaqM1BPL8mCUX0yIvSA5WbzgFuNY6WJ+4rQVOa0xOAN2ZiXf4722o/p+oDIGsIvI3ikCIgvNyL5EqwdlhcTWINcPHtzscwe35UAfw8dsHSRSkFdR8m7ZA+V2Kg=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1633272097;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=fx3KUVWD7y9Kq7DkZz3o00OrCefQB9C0q6UjghGTeCc=;
        b=d/lzG4rFOE8C9wJLgJYmN/A96GSEemJqlmW6OHv9xCnZZPFj9PVWdpJMUPKj2s6w
        1TaL6nb10LGo5foZaIwKjkJBjRkO6k8LqAt8hHKw3hMnujB8HF6wMesauJ8JR211/Xc
        FfU1D8PO4mSeIj2YwPSzPS/xUlig5qyQMzUWslTY=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1633272094531318.5524140866371; Sun, 3 Oct 2021 22:41:34 +0800 (CST)
Date:   Sun, 03 Oct 2021 22:41:34 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "Miklos Szeredi" <mszeredi@redhat.com>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Huang Jianan" <huangjianan@oppo.com>
Message-ID: <17c469a5f3f.e5bfa83020210.6858947926351314597@mykernel.net>
In-Reply-To: <CAJfpegsHH1wpLXDJXemVM1mpcRACRwew8pc2X62KkyuwS91jKQ@mail.gmail.com>
References: <20210928124757.117556-1-cgxu519@mykernel.net> <CAJfpegsHH1wpLXDJXemVM1mpcRACRwew8pc2X62KkyuwS91jKQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-09-30 20:55:54 Miklos Szer=
edi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Tue, 28 Sept 2021 at 14:48, Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > > Loop device checks the ability of DIRECT-IO by checking
 > > a_ops->direct_IO of inode, in order to avoid this kind of
 > > false detection we set a_ops->direct_IO for overlayfs inode
 > > only when underlying inode really has DIRECT-IO ability.
 > >
 > > Reported-by: Huang Jianan <huangjianan@oppo.com>
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 >=20
 > Can you please add  Fixes: and  Cc: stable@vger.kernel.org tags?
 >=20
 > > ---
 > >  fs/overlayfs/dir.c       |  2 ++
 > >  fs/overlayfs/inode.c     |  4 ++--
 > >  fs/overlayfs/overlayfs.h |  1 +
 > >  fs/overlayfs/util.c      | 14 ++++++++++++++
 > >  4 files changed, 19 insertions(+), 2 deletions(-)
 > >
 > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > > index 1fefb2b8960e..32a60f9e3f9e 100644
 > > --- a/fs/overlayfs/dir.c
 > > +++ b/fs/overlayfs/dir.c
 > > @@ -648,6 +648,8 @@ static int ovl_create_object(struct dentry *dentry=
, int mode, dev_t rdev,
 > >         /* Did we end up using the preallocated inode? */
 > >         if (inode !=3D d_inode(dentry))
 > >                 iput(inode);
 > > +       else
 > > +               ovl_inode_set_aops(inode);
 >=20
 > This is too late, since the dentry was instantiated and can be found
 > through a cached lookup already.
 >=20
 > Anyway, I think this can be dropped, since ovl_inode_init() should be
 > called for inodes preallocated by ovl_create_object() as well:
 > inode_insert5() will set I_NEW on the preallocated inode.
 >=20
 > It is interesting that ovl_fill_inode() will be called a second time
 > on the preallocated inode.  This is something that should probably be
 > cleaned up, but that's a separate patch.
 >=20
 > >
 > >  out_drop_write:
 > >         ovl_drop_write(dentry);
 > > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
 > > index 832b17589733..a7a327e4f790 100644
 > > --- a/fs/overlayfs/inode.c
 > > +++ b/fs/overlayfs/inode.c
 > > @@ -659,7 +659,7 @@ static const struct inode_operations ovl_special_i=
node_operations =3D {
 > >         .update_time    =3D ovl_update_time,
 > >  };
 > >
 > > -static const struct address_space_operations ovl_aops =3D {
 > > +const struct address_space_operations ovl_aops =3D {
 > >         /* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_=
IO */
 > >         .direct_IO              =3D noop_direct_IO,
 > >  };
 > > @@ -786,6 +786,7 @@ void ovl_inode_init(struct inode *inode, struct ov=
l_inode_params *oip,
 > >         ovl_copyattr(realinode, inode);
 > >         ovl_copyflags(realinode, inode);
 > >         ovl_map_ino(inode, ino, fsid);
 > > +       ovl_inode_set_aops(inode);
 >=20
 > OVL_UPPERDATA is only set after ovl_get_inode() in all callers.  This
 > needs to be moved into ovl_inode_init() before calling
 > ovl_inode_set_aops() otherwise this won't work correctly for a copied
 > up file.
 >=20

Hi Miklos,

I found it's not convenient to move setting OVL_UPPERDATA into ovl_inode_in=
it() because
we should detect different conditions for different callers. How about call=
ing  ovl_inode_set_aops()
after setting OVL_UPPERDATA?


Thanks,
Chengguang




Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A126C433B4
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Apr 2021 12:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510E2613AD
	for <linux-unionfs@archiver.kernel.org>; Wed, 28 Apr 2021 12:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhD1MTO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:19:14 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25321 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233791AbhD1MTO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Apr 2021 08:19:14 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1619612300; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=hJcafRbYrVK/M3UQxmUcupz7hS5p1ihBtAf7IGoagjiTUsrS/T0ovde8hqdfgCD2bBxZw30PDy+c1S01uvAXHoTGZFhID3NE2YBZRNcgDm03rTjYboqjKl7bISwPAiLwaxwpE/h/iNHmlv2BsDOonlv7bFVt+0RkLmYELA+/4tU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1619612300; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=9qNFgDXkMzMyFnTAZIM63zBi2PXkZwx+7JQ7FHsY0Rg=; 
        b=gc6xdalGj+z1Rlc5QkzH/GTAjfNPh0TbZjUvqwln3gK49agA0SP8o+GQZaNXSrqPKqbF2NbY5kH6d5mIkB7Qrsg0NHgMpBzPSeg+Nt7In5SOXkX9BZ6cr8S26eklB85FBu6AwEKZnV5p1IV5b8l6e6eLG0gSGVtu6Cj0+L4SIEk=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1619612300;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=9qNFgDXkMzMyFnTAZIM63zBi2PXkZwx+7JQ7FHsY0Rg=;
        b=DgFGVWn1oG65VG8QEmSKnzDmSnvJQnLG0H65m7WwRXVnrEwlR0OjMOxHcJrF7Xcq
        rLNK2you8Q8HLF9eTwRuIFDyY6IDhixgjB+G2tKiOcY3m7oHUDjqbwmoAyZEU+REkvp
        1feNgCa6zPLBsh7pvfhHZvHygqv/evmB5V7G2aTs=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1619612296178808.1897075620194; Wed, 28 Apr 2021 20:18:16 +0800 (CST)
Date:   Wed, 28 Apr 2021 20:18:16 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Chengguang Xu" <cgxu519@mykernel.net>
Cc:     "miklos" <miklos@szeredi.hu>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <179186a63f0.fd6ee2bc28198.4647268167720224017@mykernel.net>
In-Reply-To: <20210424140316.485444-1-cgxu519@mykernel.net>
References: <20210424140316.485444-1-cgxu519@mykernel.net>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D:[RFC_PATCH_1/2]_ovl:_skip_checking_l?=
 =?UTF-8?Q?ower_file's_write_permisson_on_truncate?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=85=AD, 2021-04-24 22:03:15 Chengguang=
 Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > Lower files may be shared in overlayfs so strictly checking write
 > perssmion on lower file will cause interferes between different
 > overlayfs instances.

Any comment for this?

Thanks,
Chengguang



 >=20
 > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > ---
 >  fs/overlayfs/inode.c | 6 ------
 >  1 file changed, 6 deletions(-)
 >=20
 > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
 > index 28c71978eb2e..17d1add0af1a 100644
 > --- a/fs/overlayfs/inode.c
 > +++ b/fs/overlayfs/inode.c
 > @@ -31,12 +31,6 @@ int ovl_setattr(struct user_namespace *mnt_userns, st=
ruct dentry *dentry,
 >          goto out;
 > =20
 >      if (attr->ia_valid & ATTR_SIZE) {
 > -        struct inode *realinode =3D d_inode(ovl_dentry_real(dentry));
 > -
 > -        err =3D -ETXTBSY;
 > -        if (atomic_read(&realinode->i_writecount) < 0)
 > -            goto out_drop_write;
 > -
 >          /* Truncate should trigger data copy up as well */
 >          full_copy_up =3D true;
 >      }
 > --=20
 > 2.27.0
 >=20
 >=20
 >=20

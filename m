Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7437AC433ED
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A406113C
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhDHL3H (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:29:07 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25307 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhDHL3H (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 07:29:07 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617881318; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=jN6o5roA1G/czn2U2y7aS01N7lqb8yF7MwBkDhtcQ3PNkPF4WcJpwu0E0W+zUUgPR4JQ04K67HuZf6RRkY3iTjtE/rHyjH0vHdEvKKjdYP9JnoK5nQ1VENjdE7xkFGlzgkgg1aoJIxwiGGak6UOCQQfCiAnmqjdgK3s9IJShoSY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617881318; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=vH4DDB//Da0UgU4k6QzikVPdR8AdldS7OPpJA1Jare8=; 
        b=g2Z+VdDbFBgUZK7eyxrwRH2dAaHNp0ET/r5QeTWzMwysPh4X1jwYgf+KazEVcm24PFehYEiurB7KY8rBmVJWnlVfpDYwQd4h4xdcNKJ3AIBf4lWblLbyz2AQhjG+TXRhRyKQ746KySL9zCJjaH81KYm1n4e6OdxMsJTkMfHKwfs=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617881318;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=vH4DDB//Da0UgU4k6QzikVPdR8AdldS7OPpJA1Jare8=;
        b=Y0enoqvbmQbrchacwGM7soxuQeFGPxu5zimNlGOTpIAckZU9r0SWDHkEr25n8WR5
        0hFS6TQSuWhfksvOSHnGsvKJdhhTaJU6sjDFZ05FWJ4pijGn4Ebo9OhHtQr+fN1184R
        60OYwseE2WQ1XGJKtC54QYwIo0JNa5Jg7XvsyCsw=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1617881317133417.75085157415253; Thu, 8 Apr 2021 19:28:37 +0800 (CST)
Date:   Thu, 08 Apr 2021 19:28:37 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Chengguang Xu" <cgxu519@mykernel.net>
Cc:     "miklos" <miklos@szeredi.hu>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net>
In-Reply-To: <20210408112042.2586996-1-cgxu519@mykernel.net>
References: <20210408112042.2586996-1-cgxu519@mykernel.net>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D:[PATCH]_ovl:_check_VM=5FDE?=
 =?UTF-8?Q?NYWRITE_mappings_in_copy-up?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:20:42 Chengguang=
 Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > In overlayfs copy-up, if open flag has O_TRUNC then upper
 > file will truncate to zero size, in this case we should check
 > VM_DENYWRITE mappings to keep compatibility with other filesystems.
 >=20
 > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > ---
 >  fs/overlayfs/copy_up.c | 5 ++++-
 >  1 file changed, 4 insertions(+), 1 deletion(-)
 >=20
 > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
 > index 0fed532efa68..c56c81494b0c 100644
 > --- a/fs/overlayfs/copy_up.c
 > +++ b/fs/overlayfs/copy_up.c
 > @@ -901,8 +901,11 @@ static int ovl_copy_up_one(struct dentry *parent, s=
truct dentry *dentry,
 >      }
 > =20
 >      /* maybe truncate regular file. this has no effect on dirs */
 > -    if (flags & O_TRUNC)
 > +    if (flags & O_TRUNC) {
 > +        if (atomic_read(&d_inode(ovl_dentry_real(dentry))->i_writecount=
) < 0)
 > +            return -ETXTBSY;
 >          ctx.stat.size =3D 0;
 > +    }

Maybe we should check this for open(with writable flag) not only for trunca=
te case, right?


Thanks,
Chengguang


 > =20
 >      if (S_ISLNK(ctx.stat.mode)) {
 >          ctx.link =3D vfs_get_link(ctx.lowerpath.dentry, &done);
 > --=20
 > 2.27.0
 >=20
 >=20
 >=20

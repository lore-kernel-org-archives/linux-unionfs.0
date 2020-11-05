Return-Path: <SRS0=HYNE=EL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B770C00A89
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 09:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4972120825
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 09:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="OIPrLiIp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgKEJjF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:39:05 -0500
Received: from sender3-pp-o92.zoho.com.cn ([124.251.121.251]:25320 "EHLO
        sender3-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbgKEJjE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Nov 2020 04:39:04 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1604569130; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=YH+kvwf6jA+Inv8F9N84USsE3Z4EogCV+6SivRvChQfChtotbztq6cm6HkMnlTS0X6/BcJSqvmSmuBHXOm5pzSrhoNYSgsGD0wPKrvcRtXv5XPxj0eBmcLVmELplHM3dlcb8NFSpN4c5Q5WK/h2/Hp7iApoJJ9mG332ZY3aEL4Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1604569130; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=pwkB+jF3aZ3Y4R0BMZ3XN02/U8ZKsZy5uUWngAwtcI0=; 
        b=kmxssA662Q71gc5ofEE4FGoTIkL1wDtPddqpDCyNvY0Qj7f6/pg6+j+E24PDw1BgMVxmFPZT/EAyz5kILTmO06aa9+wtTRxGI6MnzFBy4QnCuGsZK9zENX5kNVWPsAknlF1a2AtuYRaJnTFOY0ZwIR10Ib+QJpru799HJv60WQk=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1604569130;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=pwkB+jF3aZ3Y4R0BMZ3XN02/U8ZKsZy5uUWngAwtcI0=;
        b=OIPrLiIp839MKYxIGji+2ukoznrs6AzpZuefhs3/Wj0kr7tpOxydGjnM/NtR30yJ
        nrjQWvsbPFq7FFfPYS1B3la8lC7At1qL5kFtc3Z4NqWcOaGi8L/Mr/iCx4ek5yg/436
        EnzEwBgVqPohuPltfNqrVtZ04DuZvFMQMscJguUc=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1604569128017468.26257593711625; Thu, 5 Nov 2020 17:38:48 +0800 (CST)
Date:   Thu, 05 Nov 2020 17:38:48 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "Miklos Szeredi" <miklos@szeredi.hu>
Message-ID: <17597c5dc4e.fb084b178911.1848736071974456771@mykernel.net>
In-Reply-To: <CAOQ4uxgpmC_B_uWpnMXDrv9BOQ-rsMxyRTc+qC3dT72sqR8ndg@mail.gmail.com>
References: <17596177926.d559c8b77834.5766617584799741474@mykernel.net> <CAOQ4uxgpmC_B_uWpnMXDrv9BOQ-rsMxyRTc+qC3dT72sqR8ndg@mail.gmail.com>
Subject: Re: a question about opening file
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 16:07:26 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Nov 5, 2020 at 6:39 AM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > > Hello,
 > >
 > > I have a question about opening file of underlying filesystem in overl=
ayfs,
 > >
 > > why we use overlayfs' path(vfsmount/dentry) struct for underlying fs' =
file
 > >
 > > in ovl_open_realfile()?  Is it by design?
 >=20
 > Sure. open_with_fake_path() is only used by overlayfs.
 >=20
 > IIRC, one of the reasons was to display the user expected path in
 > /proc/<pid>/maps.
 > There may have been other reasons.
 >=20
=20
So if we do the mmap with overlayfs'  own page cache, then we don't have to
use pseudo path for the reason above, right?

Actually, the background is I'm trying to implement overlayfs' page cache f=
or
fixing mmap rorw issue. The reason why asking this is I need to open a writ=
eback
file which is used for syncing dirty data from overlayfs' own page cache to=
 upper inode.=20
However, if I use the pseudo path just like current opening behavior, the w=
riteback
file will hold a reference of vfsmount of overlayfs and it will cause umoun=
t fail with -EBUSY.
So I want to open a writeback file with correct underlying path struct but =
not sure if
there is any unexpected side effect. Any suggestion?

Thanks,
Chengguang



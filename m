Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A8EC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Oct 2021 07:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D19A60ED4
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Oct 2021 07:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhJLHnp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 03:43:45 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25329 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232565AbhJLHnp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Oct 2021 03:43:45 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634024481; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=iMT5drS6JaCUd6HlArvx9LAgZx3l7KgmDRxKdC67Qg4oMBo6JGE1R4EyXNSEe+06CMinQsduZlk5hAAty3WRygYJDjtrt27keUaN1c2kWKlnjNtNoM7ysYz+FSapX0wzRutXMMW8PbI8oqvKA5Hsr8oJO2Arp32z3hzS4g/UMiE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1634024481; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=Y55ZB+W2WPdq2M0rxVYHY+K1z/6thucvjEyyG7/Pl10=; 
        b=O7Wpp+zymEJmmxP/A9I+ioX4IXU79Pjk8YLDAiK7tfSlcYQQqkalQAbrpr6DnQEKObzDHDEy0DY2KgJqTtYvv9IJpLpaGjdJRgpkbfJ5uRknNIYHUZpkbND3VX5w7hwOJKF2mqyOoURXXZM4Prny5AWCbPrd86yuNWGAbN4ba+0=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1634024481;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=Y55ZB+W2WPdq2M0rxVYHY+K1z/6thucvjEyyG7/Pl10=;
        b=PRXcC7mEViEd6a3DZfGYWFWq00g12xJaHihHD3DDR4756UprmZvZBRtWQgipLteq
        eiiWii5O6TGROEF2UqFApdMp11C2hPnCterYisxLDLvoKswO8fzr5jBOYfEolw3RbuX
        LJp/lLwmIZUbq+2BvpiZsu7UvOthqK0tZN9TuY2g=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1634024480327712.9263693463994; Tue, 12 Oct 2021 15:41:20 +0800 (CST)
Date:   Tue, 12 Oct 2021 15:41:20 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "Miklos Szeredi" <mszeredi@redhat.com>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Huang Jianan" <huangjianan@oppo.com>
Message-ID: <17c7372de44.e12e505836828.6893331941011091543@mykernel.net>
In-Reply-To: <YV7jl23vPilVb3zE@miu.piliscsaba.redhat.com>
References: <20210928124757.117556-1-cgxu519@mykernel.net>
 <CAJfpegsHH1wpLXDJXemVM1mpcRACRwew8pc2X62KkyuwS91jKQ@mail.gmail.com>
 <17c469a5f3f.e5bfa83020210.6858947926351314597@mykernel.net> <YV7jl23vPilVb3zE@miu.piliscsaba.redhat.com>
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


 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-10-07 20:09:59 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Sun, Oct 03, 2021 at 10:41:34PM +0800, Chengguang Xu wrote:
 > > ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-09-30 20:55:54 Miklos=
 Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 >=20
 > >  > OVL_UPPERDATA is only set after ovl_get_inode() in all callers.  Th=
is
 > >  > needs to be moved into ovl_inode_init() before calling
 > >  > ovl_inode_set_aops() otherwise this won't work correctly for a copi=
ed
 > >  > up file.
 > >  >=20
 > >=20
 > > Hi Miklos,
 > >=20
 > > I found it's not convenient to move setting OVL_UPPERDATA into ovl_ino=
de_init() because
 >=20
 > If you look at the logic of the thing, then it becomes quite simple.  Se=
e
 > following (untested) patch.
 >=20

Hi Miklos,

Okay, thanks for the suggestion. I'll check fot it.

Thanks,
Chengguang

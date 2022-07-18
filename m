Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CABC43334
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 10:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiGRKKP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiGRKKO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 06:10:14 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71167DFFC
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 03:10:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r14so16328163wrg.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 03:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kohlschutter-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=V0Up84QcSxidoOLER6+f0HHJOz7kslEDF3Bka2NBftY=;
        b=jVZ2q33IUhoiETY5C+ok3PsFxD0p9m2B2Vqf9Aq2bfjwzWYavSG5cuKIg1JtmVp09v
         pI0Z9plKrR7g9Oif1bNCSWqSWAc+dFncmx3HOCNUqi99Kd2iWYStCc/oyPH6Chr2IlYQ
         aOS7DToaDQ7PYERWfso2iuwqKSw9T854up6zJwxAQwPIGn2gurijbR+TqMMZmkz4u2oB
         6WIUIf9AU59MhuQkGtjcKzjZHBIkMvc5o+7bo1qIXM1SwlJPBjgBe5fINl6mvHqi0jGh
         Y2ARezUdE6uCVEGHQi/x0d5M91F98AdyHR47QjwzEnv2wm0wyAWKv5ayhT8+xoMl1i41
         Yb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=V0Up84QcSxidoOLER6+f0HHJOz7kslEDF3Bka2NBftY=;
        b=ZSAhjoZ0EYyiHZ8cHhg0KZPjzwg5BDyOfEJuyECdxGTNGHd6VTp0ulkq6uAU4d2hka
         O8D8rwmaX1LykYFQE5g771G2htG2180hHpKoJ6pvbEjPK4wkTffBomtD5aWUSMzu/NYD
         GB5cymdXm+259ZH2jNd4ixNTQazUQsjd2oerhB08TDPW6yoo5dZJoZf2Ymp9sxJO5M6m
         RjFvcjmdbisBVBwiCOZkVKJfkv6N6DUu9FmYmx7u9YD7xT3kuZPsNNvHJa2KyrcdFt4v
         PkCQZktJik0CcyQO8ksPyR6T5BaRTplA6SiQHwt/O08dD8F5uEYkM4ZQ9iOK+9+tsvqv
         ctDA==
X-Gm-Message-State: AJIora/wG57idGETKtUGw4B3W0c0NZGEX7omzotPcHKfqUXy3iRengTm
        xbbo4FhUP+xV6jRegjOJK3bs3vo7kfENv6qK
X-Google-Smtp-Source: AGRyM1vye9FdKpzNyDN73lxjv/5FP4i0RATVh5IDQLmILpyIEgvMXve2IqwEKG56GPBT8x7ENSPZZg==
X-Received: by 2002:a5d:6d0e:0:b0:21d:6d4c:e0e4 with SMTP id e14-20020a5d6d0e000000b0021d6d4ce0e4mr23052805wrq.355.1658139010992;
        Mon, 18 Jul 2022 03:10:10 -0700 (PDT)
Received: from smtpclient.apple (ip5b434222.dynamic.kabel-deutschland.de. [91.67.66.34])
        by smtp.gmail.com with ESMTPSA id k15-20020a7bc30f000000b0039c54bb28f2sm14489511wmj.36.2022.07.18.03.10.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 03:10:10 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] ovl: Handle ENOSYS when fileattr support is missing in
 lower/upper fs
From:   =?utf-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>
In-Reply-To: <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
Date:   Mon, 18 Jul 2022 12:10:09 +0200
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com>
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> Am 18.07.2022 um 11:14 schrieb Miklos Szeredi <miklos@szeredi.hu>:
>=20
> On Mon, 4 Jul 2022 at 20:36, Christian Kohlsch=C3=BCtter
> <christian@kohlschutter.com> wrote:
>>=20
>> overlayfs may fail to complete updates when a filesystem lacks
>> fileattr/xattr syscall support and responds with an ENOSYS error =
code,
>> resulting in an unexpected "Function not implemented" error.
>=20
> Issue seems to be with fuse: nothing should be returning ENOSYS to
> userspace except the syscall lookup code itself.  ENOSYS means that
> the syscall does not exist.
>=20
> Fuse uses ENOSYS in the protocol to indicate that the filesystem does
> not support that operation, but that's not the value that the
> filesystem should be returning to userspace.
>=20
> The getxattr/setxattr implementations already translate ENOSYS to
> EOPNOTSUPP, but ioctl doesn't.
>=20
> The attached patch (untested) should do this.   Can you please give it =
a try?
>=20
> Thanks,
> Miklos
> <fuse-ioctl-translate-enosys.patch>

Yes, that change basically has the same effect for the demo use case,.

However: it will change (and potentially) break assumptions in user =
space. We should never break user space.

Example: lsattr /test/lower
Currently, fuse returns ENOSYS, e.g.
> lsattr: reading ./lost+found: Function not implemented
With your change, it would return ENOTTY
> lsattr: reading ./lost+found: Not a tty


I also tried the setup (without patches) on a very old 4.4.176 system, =
and everything works fine. ovl introduced the regression, so it should =
also be fixed there.
It may affect other filing systems as well (I see some other fs also =
return ENOSYS on occasion).

It's safe to say that adding the ENOSYS to the ovl code is probably the =
best move. Besides, you already have a workaround for ntfs-3g there as =
well.

Best,
Christian


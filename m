Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D0CC43334
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 10:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiGRK4X (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiGRK4X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 06:56:23 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE22101DA
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 03:56:22 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id a18-20020a05600c349200b003a30de68697so3155401wmq.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kohlschutter-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=brw7Qg3lnuCU3/y55+KdWQLiIpHBhmRs0hmh8uLzt7Q=;
        b=16A00L8W145N9zK8xgD+Jfp/q4pFJbTbS5qYx5lf8sy3cuM8JU+Q6I/0S+A415ZLOD
         CMGch0ehQr9j5mRrV+Mcv9j218cixAo+XCk6fzQevIpx9YkdgayuPwJh5TaFjN1TfGuW
         dwh55RlA2+oddLJJTs+SjGCaHhUQkZONHaSxUK5jcxJj242Whkjl+VxXFSR3S9iX5mHr
         CZVuVu70Aci+v4QRlnDcB4eiwqglkp3RIKh/YsgI7iTlT7Y0IXV8CMhwGiOZcP+iUsdR
         NYQD7GYn70rI9JZjHsMpGA/q21ddX9HQQXlkpV+ei5zhZEMud8RNi6XtEJD5UqAOR/Mw
         86sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=brw7Qg3lnuCU3/y55+KdWQLiIpHBhmRs0hmh8uLzt7Q=;
        b=HkAm6GhnqMz6amZP/TvCT4XQJeF54JjUL/mnCZtmvU5cHrGvYlR+gbaulAirVdWWfK
         iORLgM0P4aIR/DgD9RsUBsl5vDpJWLVAkKPJ4rpd1kVHPdfdBrZtQjeoOPut7R0n/t/o
         IxyPKZIVvIXp5WhJIwZSt5ZQXIqAh6lohq2KsP5VMgPwK+tc4Xu3PTJ00TRc09HVUXtl
         B1tpue9d0WbNp3iLH49H+QJ68f/x3qT9kAKJ9mFYYTxOwq85P+dHeTIWF1CQih6zjEVN
         STAv3d6hyXUhN+40Hj+lK6+0W8sG/RLNGk8+zhK4n0yKGZqqOnFBJqzD73hfW+13IM27
         iBtg==
X-Gm-Message-State: AJIora+1YqRkJChvv4Ve3ybbmx68MFAu83KayRkjk9QA8uPSN5Ih4f5L
        9WhXvU2awqOBaUaQj16MRsOLjg==
X-Google-Smtp-Source: AGRyM1u6ds6t/rX5vJd/Camils8xZ07/n/tTVpA9SXpQOobKIc/C6nZkOWVm7+HRuuemjD+gVIkzXA==
X-Received: by 2002:a05:600c:2116:b0:3a3:7f:f3cc with SMTP id u22-20020a05600c211600b003a3007ff3ccmr7828689wml.28.1658141780507;
        Mon, 18 Jul 2022 03:56:20 -0700 (PDT)
Received: from smtpclient.apple (ip5b434222.dynamic.kabel-deutschland.de. [91.67.66.34])
        by smtp.gmail.com with ESMTPSA id d3-20020adfe883000000b0021d7ff34df7sm12566514wrm.117.2022.07.18.03.56.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 03:56:20 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] ovl: Handle ENOSYS when fileattr support is missing in
 lower/upper fs
From:   =?utf-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>
In-Reply-To: <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
Date:   Mon, 18 Jul 2022 12:56:19 +0200
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com>
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com>
 <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org


--=20
Dr. Christian Kohlsch=C3=BCtter



> Am 18.07.2022 um 12:31 schrieb Miklos Szeredi <miklos@szeredi.hu>:
>=20
> On Mon, 18 Jul 2022 at 12:10, Christian Kohlsch=C3=BCtter
> <christian@kohlschutter.com> wrote:
>>=20
>>> Am 18.07.2022 um 11:14 schrieb Miklos Szeredi <miklos@szeredi.hu>:
>>>=20
>>> On Mon, 4 Jul 2022 at 20:36, Christian Kohlsch=C3=BCtter
>>> <christian@kohlschutter.com> wrote:
>>>>=20
>>>> overlayfs may fail to complete updates when a filesystem lacks
>>>> fileattr/xattr syscall support and responds with an ENOSYS error =
code,
>>>> resulting in an unexpected "Function not implemented" error.
>>>=20
>>> Issue seems to be with fuse: nothing should be returning ENOSYS to
>>> userspace except the syscall lookup code itself.  ENOSYS means that
>>> the syscall does not exist.
>>>=20
>>> Fuse uses ENOSYS in the protocol to indicate that the filesystem =
does
>>> not support that operation, but that's not the value that the
>>> filesystem should be returning to userspace.
>>>=20
>>> The getxattr/setxattr implementations already translate ENOSYS to
>>> EOPNOTSUPP, but ioctl doesn't.
>>>=20
>>> The attached patch (untested) should do this.   Can you please give =
it a try?
>>>=20
>>> Thanks,
>>> Miklos
>>> <fuse-ioctl-translate-enosys.patch>
>>=20
>> Yes, that change basically has the same effect for the demo use =
case,.
>>=20
>> However: it will change (and potentially) break assumptions in user =
space. We should never break user space.
>>=20
>> Example: lsattr /test/lower
>> Currently, fuse returns ENOSYS, e.g.
>>> lsattr: reading ./lost+found: Function not implemented
>> With your change, it would return ENOTTY
>>> lsattr: reading ./lost+found: Not a tty
>=20
> No, it would return success.

I'm referring to /test/lower (powered by fuse davfs2), not /test/mnt =
(overlayfs).

>=20
>> I also tried the setup (without patches) on a very old 4.4.176 =
system, and everything works fine. ovl introduced the regression, so it =
should also be fixed there.
>> It may affect other filing systems as well (I see some other fs also =
return ENOSYS on occasion).
>>=20
>> It's safe to say that adding the ENOSYS to the ovl code is probably =
the best move. Besides, you already have a workaround for ntfs-3g there =
as well.
>=20
> Flawed arguments.  The change in overlayfs just made the preexisting
> bug in fuse visible.  The bug should still be fixed in fuse.

I understand your point from ovl's perspective, however you are =
proposing a fix in fuse, and so we have to see it from fuse's =
perspective (and its users).

=46rom ovl's point of view, your patch fixes it because the behavior in =
ovl will now become how it was before the regression was introduced.
However, users of fuse that have no business with overlayfs suddenly see =
their ioctl return ENOTTY instead of ENOSYS.


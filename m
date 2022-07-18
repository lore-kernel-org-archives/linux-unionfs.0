Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D5FC433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiGRUdx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiGRUdx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 16:33:53 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10A060E4
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 13:33:51 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id z23so23454216eju.8
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 13:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kohlschutter-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=sSv2PAexsfUE9wq4Vnr5gzIcjcTTTaBz8dE26papfHA=;
        b=IJJcCEXhNxNmtiDW2OGrGVBpaFveJy/2+ca0zyYvkL0RyBQDhIpY8uCp607SqjC67d
         cer5uPHuB2hckfieCG89+jhd/m8haca5WABkZrhz8amgU7mWStKRNrw8s8oDR+jwR8a7
         mLdxl/woBcmoQ3H+Ftn55L/gWKLubVRv0UQtpb9vwEYyhTVbqEyTI/fbpzca1hPluQ53
         g12tYdpM4/5B3gfwAZMoFZcA2deW+VcqDKTwvadM6/AqXzP/3645ba5JYqaVN0nSQk3N
         G/CDnJMjvpAx3Z3zpBmA0ziBFb0WjTFF4iqXLyE00tIGg8/0qJ2bvXKdpNcI5fGROykV
         cvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=sSv2PAexsfUE9wq4Vnr5gzIcjcTTTaBz8dE26papfHA=;
        b=xVMCwUfHUWQSiExEVT6VyIjIklITTGVyPee3gpZLJK1kteD5WxqkI+4Lfpnc6uOdWC
         SoMAWtVlPNL1YJkpKLXp9YHWYmzj0xeimij8h3aeo6WQiXFrsgZy7ge2LFc9C/9pwtMj
         59xUPAKdZmcqaKrTzsiPwBFnr67wQDiFPsRxfgJbABv3zdUy/dhlBfpmGoHdjgUxFznX
         nc8Lqv8Py6Hp+BHmMh+RaBHAfKDye6GYoaO1CYC88InzBQE1yH2dzjMaB4KX1fpUOquy
         yZjyTwS8xJxXtEtmsyMLsLg8UgjCGRKZfDunQa2RHPZ2PHZwiZplNPzccSRxX2fLdz/R
         Ik7A==
X-Gm-Message-State: AJIora8CzK5KMiDxDpkC0OpwNtJoT1Sj3x9Su0QRA9DQTZQfDBcLgEVu
        bMP5EcRdEt5Yc6+Iq5oNiBFP0Q==
X-Google-Smtp-Source: AGRyM1uYoMKL4o8fEJPcZOlazCzJbfp4VNHRO5l1QjQlmBXCZz8CQv+PVr1YcoLXLQMjpIdnF70/jA==
X-Received: by 2002:a17:907:62a6:b0:6ef:8118:d3e2 with SMTP id nd38-20020a17090762a600b006ef8118d3e2mr26685388ejc.605.1658176430371;
        Mon, 18 Jul 2022 13:33:50 -0700 (PDT)
Received: from smtpclient.apple (ip5b434222.dynamic.kabel-deutschland.de. [91.67.66.34])
        by smtp.gmail.com with ESMTPSA id bc4-20020a056402204400b0043a78236cd2sm9238603edb.89.2022.07.18.13.33.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 13:33:49 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
From:   =?utf-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>
In-Reply-To: <CAHk-=wg+bpP5cvcaBhnmJKzTmAtgx12UhR4qzFXXb52atn9gDw@mail.gmail.com>
Date:   Mon, 18 Jul 2022 22:33:48 +0200
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <56E6CAAE-FF25-4898-8F9D-048164582E7B@kohlschutter.com>
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com>
 <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com>
 <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com>
 <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
 <CAHk-=wjg+xyBwMpQwLx_QWPY7Qf8gUOVek8rXdQccukDyVmE+w@mail.gmail.com>
 <EE5E5841-3561-4530-8813-95C16A36D94A@kohlschutter.com>
 <CAHk-=wh5V8tQScw9Bgc8OiD0r5XmfVSCPp2OHPEf0p5T3obuZg@mail.gmail.com>
 <CAJfpeguXB9mAk=jwWQmk3rivYnaWoLrju_hq-LwtYyNXG4JOeg@mail.gmail.com>
 <CAHk-=wg+bpP5cvcaBhnmJKzTmAtgx12UhR4qzFXXb52atn9gDw@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> Am 18.07.2022 um 22:12 schrieb Linus Torvalds =
<torvalds@linux-foundation.org>:
>=20
> On Mon, Jul 18, 2022 at 12:28 PM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>>=20
>> So this is a bug in the kernel part of fuse, that doesn't catch and
>> convert ENOSYS in case of the ioctl request.
>=20
> Ahh, even better. No need to worry about external issues.
>=20
>            Linus

My concern was fixing it in fuse instead of ovl would leave non-fuse =
filesystems affected (even though I don't have proof that such =
filesystems exist).

I'm glad you are OK with Miklos' change; the outcome of this discussion =
certainly adds some nuance to the famous "don't break userspace" / error =
code thread from 2012.

Best,
Christian


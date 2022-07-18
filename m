Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E513CC433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 18:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiGRSaE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 14:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbiGRSaE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 14:30:04 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E587B1D31B
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 11:30:02 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v12so16504041edc.10
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 11:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cmv5hgCvNzLGGr3LktdlyBF/B6b4xDynWT6Leb6vwMU=;
        b=KBwiHB+SXKRnkpvfkXzleS7byHrzZEABKfttt7pWmaEsExqk03fAWoqPR7nKPf3yLn
         Fyy7ZwVpbxtKJXXXE5vUlGB1XmrO7dWEjESKiVizPyTEuMwzHXNx/5JkAO4H6cQPZBsZ
         raIzGwzOE6ZLTmMNCIsGijKHIUXqYKCek8XUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cmv5hgCvNzLGGr3LktdlyBF/B6b4xDynWT6Leb6vwMU=;
        b=5vfgdPfgjpU4UpEnmWxosL3Z8p+JKCZE8tmkxDvWRyFiMUPA6fJnML4JsmfiAHWO03
         iKMpXPMqv9VhfDn2f9GyhS5Q1wEOAGrpmvk/SFQN4nWytOJGMIC0hi560ClxtlbUFdSH
         D6DuMLMeFktorlAKRijnHQn6pfwE0wpJOexzJlF5fObOh9gUNMlD2zp7RGN1jqBDBgoC
         72DgLQKL2cGeYDH6Tnih4MSxfl2/NKin2Vc10Zq5sDfupMNuJf/OU5iBj9Pfkr1qa3NF
         pX9teHZsQd6jrhPrD/X7tjQOpqQpdR6toYJEU33GQxtz+x/phAk0t9F4oSuyvHo+uyoj
         JnNA==
X-Gm-Message-State: AJIora9A70vi4H5UAL1M+jvLRb3aBOKZvbngF7iTgXL/Di+xxzwmSUea
        yBgu+pwqfVz30kPl1yq1mKN6nLUaxcng1bMp
X-Google-Smtp-Source: AGRyM1vbUKiY3NARiWPuy9Hzz16QaPXIeX6G/2SRbHE3vlqIXpsR2GYpesf/seOdOBmrsNmgdUjp2Q==
X-Received: by 2002:a05:6402:90a:b0:439:c144:24cd with SMTP id g10-20020a056402090a00b00439c14424cdmr38464988edz.209.1658169001236;
        Mon, 18 Jul 2022 11:30:01 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id u7-20020a056402110700b0043a6c9e50f4sm8946628edv.29.2022.07.18.11.30.00
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 11:30:00 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id bk26so18283959wrb.11
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 11:30:00 -0700 (PDT)
X-Received: by 2002:a5d:69c2:0:b0:21d:807c:a892 with SMTP id
 s2-20020a5d69c2000000b0021d807ca892mr23808743wrw.274.1658168999877; Mon, 18
 Jul 2022 11:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com> <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com> <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com> <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
In-Reply-To: <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Jul 2022 11:29:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjg+xyBwMpQwLx_QWPY7Qf8gUOVek8rXdQccukDyVmE+w@mail.gmail.com>
Message-ID: <CAHk-=wjg+xyBwMpQwLx_QWPY7Qf8gUOVek8rXdQccukDyVmE+w@mail.gmail.com>
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     =?UTF-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 18, 2022 at 6:13 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Correct.  The question is whether any application would break in this
> case.  I think not, but you are free to prove otherwise.

Most often, an error is "just an error", and most applications usually
won't care.

There are exceptions: some errors are very much "do something special"
(eg EAGAIN or EINTR _are_ often separately tested for and often mean
"just retry"). And permission error handling is often different from
EINVAL etc.

And ENOSYS can easily be such an error - people probing whether they
are running on a new kernel that supports a new system call or not.

And yeah, some of our ioctl's are odd, and we have a lot of drivers
(and driver infrastructure) that basically does "this device does not
support this ioctl, so return ENOSYS".

I don't think that's the right thing to do, but I think it's
understandable. The traditional error for "this device does not
support this ioctl" is ENOTTY, which sounds so crazy to non-tty people
that I understand why people have used ENOSYS instead.

It's sad that it's called "ENOTTY" and some (at least historical)
strerror() implementations will indeed return "Not a tty". Never mind
that modern ones will say "inappropriate ioctl for device" - even when
the string has been updated, the error number isn't called
EINAPPROPRAITEDEVICE.

But it is what it is, and so I think ENOTTY is understandably not used
in many situations just because it's such a senseless historical name.

And so if people don't use ENOSYS, they use EINVAL.

I *suspect* no application cares: partly because ioctl error numbers
are so random anyway, but also very much if this is a "without
overlayfs it does X, with overlayfs it does Y".

The sanest thing to do is likely to make ovl match what a non-ovl
setup would do in the same situation (_either_ of the overlaid
filesystems - there might be multiple cases).

But I'm missing the original report. It sounds like there was a
regression and we already have a case of "changing the error number
broke something". If so, that regression should be fixed.

In general, I'm perfectly happy with people fixing error numbers and
changing them.

The only thing I require is that if those cleanups and fixes are
reported to break something, people quickly revert (and preferably add
a big comment about "Use *this* error number, because while this
*other* error number would make sense, application XyZ expects AbC"..)

             Linus

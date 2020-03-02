Return-Path: <SRS0=C54B=4T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F15C3F2D2
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 11:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B620D20842
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 11:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="VMbgpL2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgCBLRq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 06:17:46 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36208 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgCBLRq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Mar 2020 06:17:46 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so8988200iln.3
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Mar 2020 03:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rCfajJy2odEKE9UWod+YUUZqgUNBlXp+xdv1zxYnUQQ=;
        b=VMbgpL2Ok5afarsVS7YSdCqV3nOi77vgDuj5DUwHg7PyARfFUuTMpHhzPbIRPRwm8X
         XIfu3tJ7lzbqTHgRsWm5EJnOXkUBoQ2K3YVjWMCjHobdMubGSihe/W+NNSJjMA9OsIx9
         zAwMCCJLVsURdb9GQy7QRaHeP66KH5dVty9sk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rCfajJy2odEKE9UWod+YUUZqgUNBlXp+xdv1zxYnUQQ=;
        b=CNoMsqcrP93HRbPCFbBq1H2r3EoacPOxPDF5Ky0n9CKKMKMIhsjkhb6wCcqqizEUYv
         p+YiDxOjNdG3vUlvVP6sskykmEJCCSuJNzwfkk72hm7aYp1qPj41rd/ybCrGOf3XLS5c
         5nWu0W1XeUvce80IapUnlZaN5YjsGJ7KmnCMYm2CDFKzDffxNj8Sq1k3vhMqlOMxeZJD
         UwNcIx9o73MKEiv+AJWzrwbbdgYhgqJdOcpU+1Fzp1OKmWYlqNClTn+CsxCHzNuKf/hb
         8gU2gATxwUGZ4NQ42WqRbBBgk7+U3hdSD1Uw8zpgegL9hlAAqxwra+KQBQEnBMjt9SKv
         dk+g==
X-Gm-Message-State: APjAAAU7YZ1bQ71bkIlH1FcWV2q5NcUWIxPZlqC23cjNxMRs09KtpRrX
        B0i+DlmvYbjZsn3TiBPoRdK4g0KZqkbIsEprPfRQ+w==
X-Google-Smtp-Source: APXvYqxvrjVUR7X4Fk4h+3FLfAAciLKi0ZSvsaIsPdXMuEJHh7HQoHoBeJG24L2bTDXlKRaWhP9DHyuaLoDDYDIqERU=
X-Received: by 2002:a92:c0c9:: with SMTP id t9mr16255244ilf.174.1583147865452;
 Mon, 02 Mar 2020 03:17:45 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3e319059fcfdc98@google.com> <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
In-Reply-To: <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 2 Mar 2020 12:17:34 +0100
Message-ID: <CAJfpeguB7v8OBAuJoiPKv6FbfXP6wV2H8a9ceUUuPk4Aca3NRA@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in ovl_llseek
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     syzbot <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 2, 2020 at 12:10 PM Amir Goldstein <amir73il@gmail.com> wrote:

> > =====================================
> > WARNING: bad unlock balance detected!
> > 5.6.0-rc3-syzkaller #0 Not tainted
> > -------------------------------------
> > syz-executor194/8947 is trying to release lock (&ovl_i_lock_key[depth]) at:
> > [<ffffffff828b7835>] ovl_inode_unlock fs/overlayfs/overlayfs.h:328 [inline]
> > [<ffffffff828b7835>] ovl_llseek+0x215/0x2c0 fs/overlayfs/file.c:193
> > but there are no more locks to release!
> >
>
> This is strange. I don't see how that can happen nor how my change would
> have caused this regression. If anything, the lock chance may have brought
> a bug in stack file ops to light, but don't see the bug.

The bug is that ovl_inode_lock() is interruptible and that the caller
doesn't check for error.

I think the fix is to make this lock uninterruptible (probably rename
the current helper to _interruptible and use the current name as the
uninterruptible version).

Thanks,
Miklos

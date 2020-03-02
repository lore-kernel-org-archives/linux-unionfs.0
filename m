Return-Path: <SRS0=C54B=4T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F777C3F2D8
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 12:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3674D2467B
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Mar 2020 12:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUAmuJ9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgCBMTo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 07:19:44 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41746 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgCBMTn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Mar 2020 07:19:43 -0500
Received: by mail-il1-f194.google.com with SMTP id q13so2957959ile.8;
        Mon, 02 Mar 2020 04:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aBLo9uKv4L7CgqBfft2ITwpjgr/q6ztUfdjZsHBhxAk=;
        b=RUAmuJ9MwFN04dbunSq52MYfI7o76saWVxiNQ4CndXlemq+WSACOXXYfNUDdUNdvwR
         ZjJKaZNL9dTNxrxeVuHbf6nImVFhUI9NdNU3pYWApS29y9gR2hhGKTvjYTW095nVrHG6
         QWWGjKgpgCSp/0GLu6u/HTukolNTIvCLS4KRDyjnEjeA6Sfwg9/DvwJD5we7ePrbll0Q
         tvrPR+RZFFO2DNIanQ/K46EIIa3dG6LsU/EpQwjg6zpMQ6iGX1UsQVPff0A7tAHbTFsO
         /nBOMoDeeXzcwQA/gSeTdhnuSdZDA96WB8lGO6df7r5cKEwbOlZoGn9ivrc0CM2NvrPE
         AEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aBLo9uKv4L7CgqBfft2ITwpjgr/q6ztUfdjZsHBhxAk=;
        b=FvVTmT+3l0itYW7eW3tSHMlDXKPVBM0RzH+aeouV3Rs6cutrndmP1C9BGCi4DX89Nl
         U04hbmdatDXjqKckAnvTDiLVf08I/uKkJHyxjMCyvDVLs1Kbs4JsiQv9JcdFSwO6lmec
         dRc7/jZxXaOrSR+C64WbdwFqMVMaZJJp+xew8BKHf/4TrTEaO/8u7iSPoO0AS+V4ZBch
         DCl503o3YIvTma/faoQt9KYZiJAXoMCeTU5OxSEQaMNBmS1fxwx0kQshOEEUpLmlnuoI
         Ef/hjSg9ROwDr4OkJQJn2J8PCsPFwRJW7xzfhkymDkYcJikAdn8VMdEIwZLVeARCIraP
         HwEg==
X-Gm-Message-State: ANhLgQ0HxWtVdH80Fs4KsZgPtpeXxZY/LuHpaFSYo1cfo0aI2gTZvyMo
        iZnFZWq2K03ec+OTVp8kiNQUfZ0+AiAUDA1H8v4=
X-Google-Smtp-Source: ADFU+vsVY3fdEiH1R4RHAT/EFhssAe+dnSHwcpH4v8jcUnbzL+0P/5a9qRLgdyGfWfAWloJ+BIuimlu+WnIuA7SWHYQ=
X-Received: by 2002:a92:daca:: with SMTP id o10mr4616041ilq.250.1583151583196;
 Mon, 02 Mar 2020 04:19:43 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d3e319059fcfdc98@google.com> <CAOQ4uxh=tLw1p8vsbzTTqrTzLSqr33WtVHek+Jhbi5C2HKQLTA@mail.gmail.com>
 <CAJfpeguB7v8OBAuJoiPKv6FbfXP6wV2H8a9ceUUuPk4Aca3NRA@mail.gmail.com>
In-Reply-To: <CAJfpeguB7v8OBAuJoiPKv6FbfXP6wV2H8a9ceUUuPk4Aca3NRA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 2 Mar 2020 14:19:32 +0200
Message-ID: <CAOQ4uxhb422zv4wEXKnvMTZkbmPcp8ZL_EMjV=qnUsGj0m1WhA@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in ovl_llseek
To:     Miklos Szeredi <miklos@szeredi.hu>
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

On Mon, Mar 2, 2020 at 1:17 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Mar 2, 2020 at 12:10 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > =====================================
> > > WARNING: bad unlock balance detected!
> > > 5.6.0-rc3-syzkaller #0 Not tainted
> > > -------------------------------------
> > > syz-executor194/8947 is trying to release lock (&ovl_i_lock_key[depth]) at:
> > > [<ffffffff828b7835>] ovl_inode_unlock fs/overlayfs/overlayfs.h:328 [inline]
> > > [<ffffffff828b7835>] ovl_llseek+0x215/0x2c0 fs/overlayfs/file.c:193
> > > but there are no more locks to release!
> > >
> >
> > This is strange. I don't see how that can happen nor how my change would
> > have caused this regression. If anything, the lock chance may have brought
> > a bug in stack file ops to light, but don't see the bug.
>
> The bug is that ovl_inode_lock() is interruptible and that the caller
> doesn't check for error.
>
> I think the fix is to make this lock uninterruptible (probably rename
> the current helper to _interruptible and use the current name as the
> uninterruptible version).
>

Ok.

Thanks,
Amir.

Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C15C433FE
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Dec 2020 15:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767F222C7B
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Dec 2020 15:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406317AbgLKOpb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405148AbgLKOpM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Dec 2020 09:45:12 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7B4C0613D6
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Dec 2020 06:44:32 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id p7so4900405vsf.8
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Dec 2020 06:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iA2d+rrgQXobuuvVm/MUOiVayGvmYelRBSVm3q6aijM=;
        b=QC+2zzSTtj2h9xb3ytk8TQjtarb/1GIRAvMJFFc+Qxkt/CBt49otfxb7ho4zOPpf4E
         UfBQ3/5zogW1pgkylCK4jy+jNk6SOq2gKmQdOBtYzQUikhcIC23uCLF+/y1pl5y/jKw5
         IOoj16FRlUdrkBotwusINUnIih2vrZpVeKZ/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iA2d+rrgQXobuuvVm/MUOiVayGvmYelRBSVm3q6aijM=;
        b=qrV3yOazH+MYm6aBHo+waHmZfbuYWBUhWVcZWE9NWbEFdOtEwzM6/tz95nPlB/53Jb
         wkHBGwQuCpQ+2jQ61+e/akLxHJSyC4AUlCztQpvWBimpRcOyG9jr6afER6loox66SrAZ
         ekRf7uAzKZyw5v+ZLPhNkosaMY9MBJxBes5NM+WJPzMNtcMX7gTWMs9jV4+c5AR/xx3L
         AWThnzqZ7QTgtoj6ZUSSqOC4911vzEiEvPQ6momy4Vozac5/NYXTFYXX61VKwWOgbDCa
         EO+v7XLVwQOxCMvDJWrmgJZykD9jMgQBVRSU9YIPNkJGvG+uCevXcFItWkioIUSSHZcQ
         PCyA==
X-Gm-Message-State: AOAM532j0uhEiKC30h+ChGyYpG9UEEN+iPN/lFO2QWlmzdt1DTHw3/GW
        R5OyEYgZth0Qj0CAEchM+0v5XgYfXPdd3/vPyjwkCg==
X-Google-Smtp-Source: ABdhPJw16B1+C37MqnknEmfxoPs/GB/5T0eiuKddU0msdiG+DFkYSfUXcfzDJxaC8LyuizxgKkePC4UHOQt5Q6aVUI4=
X-Received: by 2002:a67:ed57:: with SMTP id m23mr13654785vsp.7.1607697871933;
 Fri, 11 Dec 2020 06:44:31 -0800 (PST)
MIME-Version: 1.0
References: <20201207163255.564116-1-mszeredi@redhat.com> <20201207163255.564116-9-mszeredi@redhat.com>
 <CAOQ4uxgy23chB-NQcXJ+P3hO0_M3iAkgi_wyhbpfT3wkaU+E7w@mail.gmail.com>
In-Reply-To: <CAOQ4uxgy23chB-NQcXJ+P3hO0_M3iAkgi_wyhbpfT3wkaU+E7w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 11 Dec 2020 15:44:21 +0100
Message-ID: <CAJfpegvpEkB2HL5THcUsmBVvcru1-DkSTo_DmA4pWNU_TV7ODg@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] ovl: do not fail because of O_NOATIME
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 8, 2020 at 12:32 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Dec 7, 2020 at 6:37 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
> >
> > In case the file cannot be opened with O_NOATIME because of lack of
> > capabilities, then clear O_NOATIME instead of failing.
> >
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > ---
> >  fs/overlayfs/file.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index dc767034d37b..d6ac7ac66410 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -53,9 +53,10 @@ static struct file *ovl_open_realfile(const struct file *file,
> >         err = inode_permission(realinode, MAY_OPEN | acc_mode);
> >         if (err) {
> >                 realfile = ERR_PTR(err);
> > -       } else if (!inode_owner_or_capable(realinode)) {
> > -               realfile = ERR_PTR(-EPERM);
> >         } else {
> > +               if (!inode_owner_or_capable(realinode))
> > +                       flags &= ~O_NOATIME;
> > +
>
> Isn't that going to break:
>
>         flags |= OVL_OPEN_FLAGS;
>
>         /* If some flag changed that cannot be changed then something's amiss */
>         if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
>
> IOW setting a flag that is allowed to change will fail because of
> missing O_ATIME in file->f_flags.

Well spotted.  I just removed those lines as a fix.   The check never
triggered since its introduction in 4.19, so I guess it isn't worth
adding more complexity for.

>
> I guess we need test coverage for SETFL.

There might be some in ltp, haven't checked.  Would be nice if the fs
related ltp tests could be integrated into xfstests.


Thanks,
Miklos

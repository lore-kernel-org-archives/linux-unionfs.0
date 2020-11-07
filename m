Return-Path: <SRS0=vXub=EN=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAD2C388F9
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Nov 2020 09:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F0220872
	for <linux-unionfs@archiver.kernel.org>; Sat,  7 Nov 2020 09:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ft7oHE4+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgKGJfS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 7 Nov 2020 04:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbgKGJfR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 7 Nov 2020 04:35:17 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99305C0613CF
        for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2020 01:35:17 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y17so3262640ilg.4
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2020 01:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Hj34yyRidu727MILgu1uRXHGjxXou7p93gnPX+n47Y=;
        b=Ft7oHE4+VG+hhwwsAVI2ezZV1FNKRC3qE4q9RlmhpgZmFJFIg32lEdTBguJqDirBT1
         Cg/y3aJJWu4uorznHkN6OjX2+AwKzVZSFrCp8uwJO6xWeSBNiZc1YndH5+8MEslx1wyS
         maFAEAzzf/AiGJSk/ITww8iE84pRnM6JTIloAa/5FoMU1LX/UBgi1bsLUFOJjwME2ygn
         yr9lNCDDDIWhlRp8l7EImerOsArhwNQ8XxlniB4REDVigv+SgtjBjGtjsINsu6HH67jR
         2DiYpeJxBGYjQrPjDe6I2EgPkYbqE5IpVTVezTlhGNULJJTGQjWPop5D5xE2TUZwpicm
         9iDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Hj34yyRidu727MILgu1uRXHGjxXou7p93gnPX+n47Y=;
        b=Dod3DiQ+t84UuSuX4G8/zIgEQrVw3dCi75O4uhK3uHuZqFGGUxNpOMJ1s2uqa7VG8m
         J6QGl/YUv2yFXlapjmS1yrNAk/TrOYb2AhCHRg0ZtM3dTWdiL1qZybzcHsInd3MguhA/
         0QXJZsi6nQirl/Z3wsBE4ShjSRKwfqTgTM+0hID2OwvXaF8CFqqnqG66810aGAbrJicN
         RolNFp7Ie51iWoEb27FiD72nxOFsGxq/nRDvW0JkePo0Uj19CQAlbLk8/3fXWZLT8GAt
         g6HUflmJlS38M30I02+paYoPMhpI0YhgHF0xEYBvQ+7unohFCGtyv7irs0Gvy7zgOc83
         gyxg==
X-Gm-Message-State: AOAM532qL3/a0593WVRj/8ePpyisHAoBUF4lEdUs/4w9Pm156vzTAlnG
        hALr93I1hYu3VtIh0aVEcnqvmvoqa+MKnn1UXWRLj+xPPI0=
X-Google-Smtp-Source: ABdhPJys/VmOVdJKWDlcJctaLW2VKYcCz7tenO616lS7ADxaZhaqWXXa36xqgTLkFrraAacYdh4ZS6DTD1QOc2rpYAo=
X-Received: by 2002:a05:6e02:e51:: with SMTP id l17mr4218045ilk.275.1604741715829;
 Sat, 07 Nov 2020 01:35:15 -0800 (PST)
MIME-Version: 1.0
References: <20200831181529.GA1193654@redhat.com> <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <20201106190325.GB1445528@redhat.com> <87o8kamfuo.fsf@redhat.com>
In-Reply-To: <87o8kamfuo.fsf@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 7 Nov 2020 11:35:04 +0200
Message-ID: <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip sync
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 6, 2020 at 9:43 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Vivek Goyal <vgoyal@redhat.com> writes:
>
> > On Fri, Nov 06, 2020 at 09:58:39AM -0800, Sargun Dhillon wrote:
> >
> > [..]
> >> There is some slightly confusing behaviour here [I realize this
> >> behaviour is as intended]:
> >>
> >> (root) ~ # mount -t overlay -o
> >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> >> none /mnt/foo
> >> (root) ~ # umount /mnt/foo
> >> (root) ~ # mount -t overlay -o
> >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> >> none /mnt/foo
> >> mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> >> missing codepage or helper program, or other error.
> >>
> >> From my understanding, the dirty flag should only be a problem if the
> >> existing overlayfs is unmounted uncleanly. Docker does
> >> this (mount, and re-mounts) during startup time because it writes some
> >> files to the overlayfs. I think that we should harden
> >> the volatile check slightly, and make it so that within the same boot,
> >> it's not a problem, and having to have the user clear
> >> the workdir every time is a pain. In addition, the semantics of the
> >> volatile patch itself do not appear to be such that they
> >> would break mounts during the same boot / mount of upperdir -- as
> >> overlayfs does not defer any writes in itself, and it's
> >> only that it's short-circuiting writes to the upperdir.
> >
> > umount does a sync normally and with "volatile" overlayfs skips that
> > sync. So a successful unmount does not mean that file got synced
> > to backing store. It is possible, after umount, system crashed
> > and after reboot, user tried to mount upper which is corrupted
> > now and overlay will not detect it.
> >
> > You seem to be asking for an alternate option where we disable
> > fsync() but not syncfs. In that case sync on umount will still
> > be done. And that means a successful umount should mean upper
> > is fine and it could automatically remove incomapt dir upon
> > umount.
>
> could this be handled in user space?  It should still be possible to do
> the equivalent of:
>
> # sync -f /root/upperdir
> # rm -rf /root/workdir/incompat/volatile
>

FWIW, the sync -f command above is
1. Not needed when re-mounting overlayfs as volatile
2. Not enough when re-mounting overlayfs as non-volatile

In the latter case, a full sync (no -f) is required.

Handling this is userspace is the preferred option IMO,
but if there is an *appealing* reason to allow opportunistic
volatile overlayfs re-mount as long as the upperdir inode
is in cache (userspace can make sure of that), then
all I am saying is that it is possible and not terribly hard.

Thanks,
Amir.

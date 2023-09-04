Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC5FC83F33
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 18:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjIDSkm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 14:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjIDSkm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 14:40:42 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3D6CC8
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 11:40:37 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-6490c2c4702so7560216d6.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 11:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693852836; x=1694457636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCHY/ojplPGJni3Ug57OcuMaKReWsTGho4C8rNN31i8=;
        b=QL0ASjLka76PfXFd6MSRguOMKgID1qwBj8dzoRt7zGKIFzJBvje0XuyXw4CS6ZxNe0
         +b4Y9vafHZN9UN6NWyD6OwHYxXucVx//cnbcQlznzDUrsENRr49fQly6unF98HXDGPkk
         /I8bOKN1/7idjUKtXSndWopca/xu4sgnDqXXNxsZOkcaYd+YTmflGXjCzAQK8G93NM+h
         vqiEOvPjjvqP6wlktahOVx+fMAgKJVPWVqTsAvkCYVDQ9cOPCNQJYFb9PH7yyJLBC7fX
         SYLvdoaYxSC6L3TBHNI+SHXz7LAYK47VWpBL3viklwY34/Dfa1owSdaT/a3h7T+HkAp2
         Np0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693852836; x=1694457636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zCHY/ojplPGJni3Ug57OcuMaKReWsTGho4C8rNN31i8=;
        b=RbBZlsL+WH9e0dRlxj+Da6PeBYT7t6phC+1YwWgfxLjZtaT47qjIM5nnsounod+IUF
         4GodZ3nLnyRYBjn3REhDhPP8nGMXJrta689pZLK3fXnpcoDUSiuz8JjhKUvmWchX8pzK
         mtXd8JXi54QUPtqlJbqqo3vY1W7ccobPHW7E3erCrRKn5uPAa1/JD5zmOO3gM7dKDvyo
         d/pw73Z0rC9A3i7WsQO2Flrg5axCceqylSm9tJxo1mYxW/BhSp/vp5hqE/X9hQmg27vh
         FC24XjmfwApEHSFpnN6iRmr86eokhARQrysu7U+VV0ZYb0635hOVl6peP1s3/k5IyO7H
         ExrQ==
X-Gm-Message-State: AOJu0YzSHCRHLXCxsJOIIVvLJsqDa+0N9VOLcs0EEvstXEPN2OkFRztG
        +vuW698aHRSBcWnRpAo6BYJbONaA+MrBvwBtiCA2KkrcBWcZTxlD38byjA==
X-Google-Smtp-Source: AGHT+IHtUAa83rFo+HqRnMLeUsOyqS7d2q/kaAQrGrvZly3omv+sNJZpxB8cC1ACtv5mCqIN41uGUJ8qSTsC7pMEr2Y=
X-Received: by 2002:ad4:452c:0:b0:64c:92f8:6b11 with SMTP id
 l12-20020ad4452c000000b0064c92f86b11mr8935352qvu.37.1693852836444; Mon, 04
 Sep 2023 11:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230904132441.2680355-1-amir73il@gmail.com> <CAJfpegtNgHnacX4CaPU8cyZcK=WPWHF_yK6CcGH1MFNYpT3UqQ@mail.gmail.com>
In-Reply-To: <CAJfpegtNgHnacX4CaPU8cyZcK=WPWHF_yK6CcGH1MFNYpT3UqQ@mail.gmail.com>
From:   Ruiwen Zhao <ruiwen@google.com>
Date:   Mon, 4 Sep 2023 11:40:24 -0700
Message-ID: <CAKd=y5EWW0WBeG-pEhOFnooonOnqdAs1RUHPTsq7h3M9uDJMxg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix failed copyup of fileattr on a symlink
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 4, 2023 at 6:44=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>
> On Mon, 4 Sept 2023 at 15:24, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Some local filesystems support setting persistent fileattr flags
> > (e.g. FS_NOATIME_FL) on directories and regular files via ioctl.
> > Some of those persistent fileattr flags are reflected to vfs as
> > in-memory inode flags (e.g. S_NOATIME).
> >
> > Overlayfs uses the in-memory inode flags (e.g. S_NOATIME) on a lower fi=
le
> > as an indication that a the lower file may have persistent inode fileat=
tr
> > flags (e.g. FS_NOATIME_FL) that need to be copied to upper file.
> >
> > However, in some cases, the S_NOATIME in-memory flag could be a false
> > indication for persistent FS_NOATIME_FL fileattr. For example, with NFS
> > and FUSE lower fs, as was the case in the two bug reports, the S_NOATIM=
E
> > flag is set unconditionally for all inodes.
> >
> > Users cannot set persistent fileattr flags on symlinks and special file=
s,
> > but in some local fs, such as ext4/btrfs/tmpfs, the FS_NOATIME_FL filea=
ttr
> > flag are inheritted to symlinks and special files from parent directory=
.
> >
> > In both cases described above, when lower symlink has the S_NOATIME fla=
g,
> > overlayfs will try to copy the symlink's fileattrs and fail with error
> > ENOXIO, because it could not open the symlink for the ioctl security ho=
ok.
> >
> > To solve this failure, do not attempt to copyup fileattrs for anything
> > other than directories and regular files.
> >
> > Reported-by: Ruiwen Zhao <ruiwen@google.com>
> > Link: https://lore.kernel.org/r/CAKd=3Dy5Hpg7J2gxrFT02F94o=3DFM9QvGp=3D=
kcH1Grctx8HzFYvpiA@mail.gmail.com/
> > Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> > Cc: <stable@vger.kernel.org> # v5.15
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Hi Miklos,
> >
> > Do you agree with this solution?
>
> It's good enough.   Linux might add API's in the future that allow
> querying and setting fileattr on symlinks, but we can deal with that
> later.
>
> Thanks,
> Miklos

Thanks Amir for sending the fix! The fix looks good but I am not sure
how to LGTM it. (Still new to the kernel review process)

I believe the fix will be merged to the master branch first. Can we
backport it to 5.15, considering this is a regression and 5.15 is an
LTS version?

Thanks,
Ruiwen

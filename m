Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB9EC71153
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 18:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjIDS6B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 14:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjIDS6B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 14:58:01 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432A4127
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 11:57:58 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id a1e0cc1a2514c-7a4efcdab54so383997241.1
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 11:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693853877; x=1694458677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEBI6D0eBXmvW7vgbdhlJiUFQZIizcfjPdmjPlRCVQo=;
        b=DqX8Aagku9BMr6+w9euEl00uCEwth16tYgQ1YarbnelmYgoLICLYDXY9xswqdfjUda
         LGTztOyGE48CKW52+z7DbGoPKKZ+Q8LqNWWlhbaezYKr0Si2BnH0uPbIuNqs1j2rTkoc
         wOIZB9hK0QZS7dYgFy+PGd8OP4/2pDErvTkhDlAz/hY+uk6WpqqvCpkeoht6lcLqehdA
         mUbabdZMHPShOF/etaXJpmQNVoMqVM8a0OX7R4EpsY0KHSHHq1DPwYxnOisOIRFHUV4G
         Esh89NRQ8G7gmCThR7bUtWAu55uOFSXsk47PugxeHZ5I9WJRUMBqY8Hj+B3Bgp5/TM5J
         Ablg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693853877; x=1694458677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEBI6D0eBXmvW7vgbdhlJiUFQZIizcfjPdmjPlRCVQo=;
        b=XUNFAGVhFgB+T1UlsQE91fGb7xlcHGAQBN8eadGArEwhPqzugg6Wiw8BoFD2tez8ob
         pK0nI3obpyrVqV9yDwPgM0xvT/OuQBCUUprEWckDj92B6jp7IoQZtFno7A7Lm5O61QzA
         cM/JOuER3BhvkYhia48ley54rh0I+iBBd4jKvh3ZzKGJk6BPuYbcrRxJKJdSyBVf6Bfm
         zLqVXd7L4rgPCwLkYEUAIPb0GxJmbD1XpkJTQyooOAE2Yr3YEc6PH+z9BB/6xSoXF4ZP
         9humC4TT3Scgu+l22OO6IU6u+KHBb24NuycDpGezd4rqeyxIgZpd8eL6OGW6tM/T+8Lg
         +8OQ==
X-Gm-Message-State: AOJu0Yx5s1ZFMmXUN3/BZ4kEB440q4luKU4IDAm02UFxww4xjlBaKAe3
        lUNbuJTX1sFMREnRjQXJTxyJVU2locqTiqsaObg=
X-Google-Smtp-Source: AGHT+IHs2qEVKMGjxPnD0yGZKBMwH9hEo5ETMK7QN3Ov+TcjAoXwf3iH6IF9Fe4eB4mjHk462LNlwQhnr9HrhGzOLh8=
X-Received: by 2002:a67:fd8e:0:b0:44d:4a41:8940 with SMTP id
 k14-20020a67fd8e000000b0044d4a418940mr5878248vsq.15.1693853877190; Mon, 04
 Sep 2023 11:57:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230904132441.2680355-1-amir73il@gmail.com> <CAJfpegtNgHnacX4CaPU8cyZcK=WPWHF_yK6CcGH1MFNYpT3UqQ@mail.gmail.com>
 <CAKd=y5EWW0WBeG-pEhOFnooonOnqdAs1RUHPTsq7h3M9uDJMxg@mail.gmail.com>
In-Reply-To: <CAKd=y5EWW0WBeG-pEhOFnooonOnqdAs1RUHPTsq7h3M9uDJMxg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 4 Sep 2023 21:57:46 +0300
Message-ID: <CAOQ4uxgkHCCT8prDpKPf2rgXSEwgF6yj8AeTE1qrY9V=2CaEYw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix failed copyup of fileattr on a symlink
To:     Ruiwen Zhao <ruiwen@google.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Sep 4, 2023 at 9:40=E2=80=AFPM Ruiwen Zhao <ruiwen@google.com> wrot=
e:
>
> On Mon, Sep 4, 2023 at 6:44=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
> >
> > On Mon, 4 Sept 2023 at 15:24, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > Some local filesystems support setting persistent fileattr flags
> > > (e.g. FS_NOATIME_FL) on directories and regular files via ioctl.
> > > Some of those persistent fileattr flags are reflected to vfs as
> > > in-memory inode flags (e.g. S_NOATIME).
> > >
> > > Overlayfs uses the in-memory inode flags (e.g. S_NOATIME) on a lower =
file
> > > as an indication that a the lower file may have persistent inode file=
attr
> > > flags (e.g. FS_NOATIME_FL) that need to be copied to upper file.
> > >
> > > However, in some cases, the S_NOATIME in-memory flag could be a false
> > > indication for persistent FS_NOATIME_FL fileattr. For example, with N=
FS
> > > and FUSE lower fs, as was the case in the two bug reports, the S_NOAT=
IME
> > > flag is set unconditionally for all inodes.
> > >
> > > Users cannot set persistent fileattr flags on symlinks and special fi=
les,
> > > but in some local fs, such as ext4/btrfs/tmpfs, the FS_NOATIME_FL fil=
eattr
> > > flag are inheritted to symlinks and special files from parent directo=
ry.
> > >
> > > In both cases described above, when lower symlink has the S_NOATIME f=
lag,
> > > overlayfs will try to copy the symlink's fileattrs and fail with erro=
r
> > > ENOXIO, because it could not open the symlink for the ioctl security =
hook.
> > >
> > > To solve this failure, do not attempt to copyup fileattrs for anythin=
g
> > > other than directories and regular files.
> > >
> > > Reported-by: Ruiwen Zhao <ruiwen@google.com>
> > > Link: https://lore.kernel.org/r/CAKd=3Dy5Hpg7J2gxrFT02F94o=3DFM9QvGp=
=3DkcH1Grctx8HzFYvpiA@mail.gmail.com/
> > > Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> > > Cc: <stable@vger.kernel.org> # v5.15
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Hi Miklos,
> > >
> > > Do you agree with this solution?
> >
> > It's good enough.   Linux might add API's in the future that allow
> > querying and setting fileattr on symlinks, but we can deal with that
> > later.
> >
> > Thanks,
> > Miklos
>
> Thanks Amir for sending the fix! The fix looks good but I am not sure
> how to LGTM it. (Still new to the kernel review process)
>
> I believe the fix will be merged to the master branch first. Can we
> backport it to 5.15, considering this is a regression and 5.15 is an
> LTS version?
>

The commit, when it gets merged will include:

    Reported-by: Ruiwen Zhao <ruiwen@google.com>
    Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217850
    Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
    Cc: <stable@vger.kernel.org> # v5.15

So it should be automatically picked for stable bots
and by bugzilla I suppose.

Please let me know if you tested my patch and I will change to
Reported-and-tested-by:

Thanks,
Amir.

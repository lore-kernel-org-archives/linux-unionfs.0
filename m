Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD06CA0FF6
	for <linux-unionfs@archiver.kernel.org>; Sat,  2 Sep 2023 09:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjIBJwq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 2 Sep 2023 05:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbjIBJwp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 2 Sep 2023 05:52:45 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2CB10FA
        for <linux-unionfs@vger.kernel.org>; Sat,  2 Sep 2023 02:52:34 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id a1e0cc1a2514c-7a25071d633so1165891241.0
        for <linux-unionfs@vger.kernel.org>; Sat, 02 Sep 2023 02:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693648353; x=1694253153; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZ+OOB/WdyAucG4I+sQPgF1MvbKs0UllfwDSXLIVndE=;
        b=az2R/WLg9cHhSUstPi+GMI61L1p80GQ0UU3IGeOUU7AZhp2Yf3zgbjd83j/lVaO9rX
         8DfVwOvfpABodegTXDdHWpKJCGU/W7gOX4oLqKw854Tq/ugf6MhWRB524srxYY5F2o64
         U0k5LFubZeKSTkp7QRY1qDLZnJJuaMnOGSDKzuk4Jy+aFKYSVN4UUow+cD0/nrlkNZyz
         cx491i+tungBDMmSZSYPTxMicBT+dkz/L8DJeKFLS89mnSEMLOBP6e4STm6kJClE/pPr
         QIOp6+44df/w/NKtXILFPMqzUY6m6j9mOj95OPM0s3AJ3p0YhMM0QlDXXVMAGiWqQQOI
         8xgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693648353; x=1694253153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ+OOB/WdyAucG4I+sQPgF1MvbKs0UllfwDSXLIVndE=;
        b=dquIBi9UeICr/NoRz0uAz/sqkbtAhx8Q75upoeoS2RnUFCjbF6Z7PXW1p1+/KST8CS
         hq5w6lpCjnNhV3WzCPJhx6vAe8ROlz2Bt72XEJ0WXvHclwP5tFkbuQBA22hRtXx+jbtw
         0Kc6tYjR1IEfcKywkiSkRPoLzkzI0MT+lbtSRz0NzAGtzvFZ0pseIa4C9OV1fMKHBGXj
         e7SEpy4bh6mRVC3aZ5rYPc1rRwWNeMOGrT1j1mV5HlPdJW0ChXtDetktLWcZzzT62KW2
         yqa4FCJNFDI+gXR4UsB/heF0150BK5yo9cH1iRWZwh++uFLbpDLorTsDS9jvGGvl6gAm
         thZw==
X-Gm-Message-State: AOJu0Yx/sWuUUQMlXd/DpkZx2ZQ9AqDuSpPUUJT2CuzKZXT2WnyfNBHc
        LvWlIVNz2TBitlNInG2L0Gxj6/rv9oiQMHalWdHEfOC3Mwo=
X-Google-Smtp-Source: AGHT+IFvr5zFLrdUFGNEo72HOrD3oh1nsC5qGBf4Nj0vELOSNxEtq9llkcSAQphYtMA8E6o8SCwHlS2Z2o4phzDuZjk=
X-Received: by 2002:a67:f3c6:0:b0:44d:5c17:d066 with SMTP id
 j6-20020a67f3c6000000b0044d5c17d066mr4666340vsn.3.1693648353578; Sat, 02 Sep
 2023 02:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAKd=y5EeKfC6vBXh1xqTfeW6OQZiNWaZ04J1SNWxyEjY4QxhHw@mail.gmail.com>
 <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
 <CAOQ4uxid-eDr2XBHo_JoPhiP99PrXj0eNKgEQXP-SOEbg4hn_Q@mail.gmail.com>
 <CAKd=y5Gsz1z1xSmHGyoEs+SckC=M0T7nrP7t5mvvuoWkCWkDLg@mail.gmail.com>
 <CAOQ4uxiQtSSHL0gLohBpRs7vwUrF5LqCLB=Oh6kSz1O-ga04Tw@mail.gmail.com>
 <CAJfpegvCEsvac5j3CSVWjjZLsxDvZ-_vX-6u1ZQra26dnUk-jg@mail.gmail.com>
 <CAOQ4uxjHob=nDUghkGHpcfoAYSUNV_MZB5YHEkTUXB+bOuUBoA@mail.gmail.com>
 <CAKd=y5FZ+imzR_bWK+g-xhBNvxhV2OpuHYLtm3dd4y+k0pMyNw@mail.gmail.com> <CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com>
In-Reply-To: <CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 2 Sep 2023 12:52:22 +0300
Message-ID: <CAOQ4uxjiJGBMuru79HRua-9FnNdbNd4G9BZ53BL9EOhNs0MsnA@mail.gmail.com>
Subject: Re: [Bug report] overlayfs: cannot rename symlink if lower filesystem
 is FUSE/NFS
To:     Ruiwen Zhao <ruiwen@google.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        Sergey Kanzhelev <skanzhelev@google.com>,
        Michael Sheinin <msheinin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 1, 2023 at 11:02=E2=80=AFPM Ruiwen Zhao <ruiwen@google.com> wro=
te:

> On Fri, Sep 1, 2023 at 12:27=E2=80=AFPM Ruiwen Zhao <ruiwen@google.com> w=
rote:
> >
> > Hi all,
> >
> > Thanks for all the help! I tested the easy fix (i.e. to ignore ENXIO, s=
ee git diff here [1]), and can confirm it worked. The setup is the same as =
the repro steps I mentioned above, so I am only pasting the last step here:
> >
> > ```
> > ruiwen@instance-1:/tmp # mv merged/home/ruiwen/foolink merged/home/ruiw=
en/foolink2
> > ruiwen@instance-1:/tmp # ls -l merged/home/ruiwen/ -l
> > total 0
> > -rw-r--r-- 1 root root 0 Sep  1 18:46 foo
> > lrwxrwxrwx 1 root root 3 Sep  1 18:47 foolink2 -> foo
> > ```
> >
> > I also checked dmesg and can confirm that there is no error. I can send=
 out a PR for this fix. Meanwhile I have a followup question on the source =
of ENXIO.
> >
> > Amir - you mentioned that ENXIO might come from no_open() default ->ope=
n() method. I found no_open in fs/inode.c returned ENXIO [2], but cannot co=
nnect it to ovl_security_fileattr. If the error happens on every open, then=
 it will happen on even reading the symlink, instead of only moving it, rig=
ht? Can you elaborate on no_open() default ->open() method?
> >
> >
> > [1] https://gist.github.com/ruiwen-zhao/93ebe0b4ad20fab005d0300e9f0194c=
2
> >
> > [2] https://github.com/torvalds/linux/blob/b84acc11b1c9552c9ca3a099b161=
0a6018619332/fs/inode.c#L145
> >
> > Thanks,
> > Ruiwen
> >
> > On Fri, Sep 1, 2023 at 10:58=E2=80=AFAM Amir Goldstein <amir73il@gmail.=
com> wrote:
> >>
> >> On Fri, Sep 1, 2023 at 1:14=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> >> >
> >> > On Fri, 1 Sept 2023 at 12:08, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> >> > >
> >> > > On Fri, Sep 1, 2023 at 12:59=E2=80=AFAM Ruiwen Zhao <ruiwen@google=
.com> wrote:
> >> > > >
> >> > > > Thanks for the reply Amir! Really helps. I will try the easy fix=
 (i.e. ignoring ENXIO) and test it. Meanwhile I have two questions:
> >> > > >
> >> > > > 1. Since ENXIO comes from ovl_security_fileattr() trying to open=
 the symlink, I was trying to find who returns ENXIO in the first place. I =
did some code search on libfuse (https://github.com/libfuse/libfuse), but c=
annot find ENXIO anywhere. Could it be from the kernel side? (I am trying t=
o use this as a justification of the easy fix.)
> >> > > >
> >> > >
> >> > > I think ENXIO comes from no_open() default ->open() method.
> >> > >
> >> > > > 2. Miklos's commit message says "The reason is that ovl_copy_fil=
eattr() is triggered due to S_NOATIME being
> >> > > > set on all inodes (by fuse) regardless of fileattr." Does that m=
ean `ovl_copy_fileattr` should not be triggered on symlink files but it is,=
 and therefore it is getting the errors like ENXIO and ENOTTY?
> >> > > >
> >> > >
> >> > > Miklos' comment explains why ovl_copy_fileattr() passes the gate:
> >> > >
> >> > >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> >> > >
> >> > > S_NOATIME is an indication that the file MAY have fileattr FS_NOAT=
IME_FL,
> >> > > but in the case of FUSE and NFS, S_NOATIME is there for another un=
related
> >> > > reason.
> >> > >
> >> > > In any case, S_NOATIME on a symlink is never an indication of file=
attr,
> >> > > so I think the correct solution is to add the conditions to the ga=
te:
> >> > >
> >> > >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
> >> > >            ((S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode))) {
> >> > >
> >> >

>
> (Sending again in plain-text mode because previous email was blocked)

In the future, when sending to mailing lists, please do not "top post".
write your reply below the text, so mailing list readers can follow
the conversation.

>
> Hi all,
>
> Thanks for all the help! I tested the easy fix (i.e. to ignore ENXIO,
> see git diff here [1]), and can confirm it worked. The setup is the

For the record, there is no need to check ENXIO on upper.
It makes no sense to get ENXIO from upper and not from lower.

> same as the repro steps I mentioned above, so I am only pasting the
> last step here:

Thanks for the report.
Could you please also test the alternative I suggested above.

>
> ```
> ruiwen@instance-1:/tmp # mv merged/home/ruiwen/foolink
> merged/home/ruiwen/foolink2
> ruiwen@instance-1:/tmp # ls -l merged/home/ruiwen/ -l
> total 0
> -rw-r--r-- 1 root root 0 Sep  1 18:46 foo
> lrwxrwxrwx 1 root root 3 Sep  1 18:47 foolink2 -> foo
> ```
>

Thank you for testing.
I will add your Tested-by.
If you want to learn how to write an xfstest for this repro
I can guide you - if not, I will do it myself.

> I also checked dmesg and can confirm that there is no error. I can
> send out a PR for this fix. Meanwhile I have a followup question on
> the source of ENXIO.
>
> Amir - you mentioned that ENXIO might come from no_open() default
> ->open() method. I found no_open in fs/inode.c returned ENXIO [2], but
> cannot connect it to ovl_security_fileattr. If the error happens on
> every open, then it will happen on even reading the symlink, instead
> of only moving it, right? Can you elaborate on no_open() default
> ->open() method?
>
> [1] https://gist.github.com/ruiwen-zhao/93ebe0b4ad20fab005d0300e9f0194c2
>
> [2] https://github.com/torvalds/linux/blob/b84acc11b1c9552c9ca3a099b1610a=
6018619332/fs/inode.c#L145
>

The way that fileattr flags are set and read from a file/dir is via ioctl.
It is not possible to open a symlink to perform the ioctl in this manner.

The situation with blockdev and chardev is even messier -
it is possible to open them for ioctl, but trying to set the fileattr
with ioctl is not expected to work and in any case, those are not
going to be inode attributes that ovl needs to copy up.

Thanks,
Amir.

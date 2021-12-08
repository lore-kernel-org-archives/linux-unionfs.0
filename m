Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0C4C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Dec 2021 07:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbhLHHE5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 02:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbhLHHE5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Dec 2021 02:04:57 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0123C061574
        for <linux-unionfs@vger.kernel.org>; Tue,  7 Dec 2021 23:01:25 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id t8so1314397ilu.8
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Dec 2021 23:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0jYE5vSptQ1KqL8SqpU9wSHPFOy5JhWjnzkpTkShnbY=;
        b=Nnyuqaz1PaxNq7+76peQEgDxVGRER34RJU8g3pVgk+JhqDRMPQgObsGOI1M31M+F6L
         tp3aUj/7BM8HLK1ONMTtqWewv5Pd8HJNCRHPwCBwGiEryLj9B5nrQYGd3jjJyOjCswwb
         jxrLIgRyy7zrpnfdXNGueYoV6rfu/UFLeTHATl7Dw+r+yXlHWaMAx4s3Ozyu6d3I/00A
         buHDoE8ftAILZVDoSjQ8tGQ59fexb06l0zN7baMBllJ5j49HWVXsdCWIjYF8oJeVe6ve
         +vYJfD2ndXH9i1uYKy/17mVPp2PeNQyxnhvf6XETtYhCPeAr4HO3irZzIGWJ9v662V4O
         6U4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0jYE5vSptQ1KqL8SqpU9wSHPFOy5JhWjnzkpTkShnbY=;
        b=JS8QYXszhYnKUpB6xgEumLgcAmx+F3Se4RZPCrU0uMyB/rwyjyLuOzU9IQYdp7cy2I
         o3XO1zJpRK0okf943XCqQoKlF2p0wtHBuz8+bY09lfUkJClWxly5Qfkp9aJRhgXJ2+ty
         a0f0Ck7xWpgz/PrbaBK+AS4rqaLuj4mycZjilqTbmb2MGaIf0kcttB6ZVRfbKavhtJ5+
         VVMsE3JeCMOYnHgoxY3bmyepBd+uaGKrrmJiFgP7ZQ2jaUH03ph7TlK2qa4JofRMDxyP
         dFeN1UbCMo2CQIlJY8l4qJZ3s5bMoXLlumP6GxicFFjNURvOidF4i79JTuC78w3BGXB8
         UJSg==
X-Gm-Message-State: AOAM530CVadhxHLPi1hbQjQyS1zqPkTzApWAucp2hN2DJOGfFORoq0yS
        4KcdbqqzVigqFaOJ0wDlosPkZC90v+Z0s1w6UfKvojIw
X-Google-Smtp-Source: ABdhPJwNa7s0N3TIh8EMJs5NC9d5AdDfJWb4WYm+9khYv2caz2Gcow4/3P4xdzdYY/F99J3ADxyl5eMQ4n+n8dtAEn8=
X-Received: by 2002:a05:6e02:c87:: with SMTP id b7mr4225233ile.198.1638946885286;
 Tue, 07 Dec 2021 23:01:25 -0800 (PST)
MIME-Version: 1.0
References: <CADmzSSjKoiYn7moEVFDV2p+x2BuTnWBLMBtdPQYsqQOttcgN1A@mail.gmail.com>
 <CAOQ4uxgb4cGHS9ZU-LfJAzSnmFDQmZgEBwHHA-J+G520gVsCyg@mail.gmail.com> <CADmzSSj2F77Z0Ufp-O7xQzPW=_BbUW3h3OCn7uhNUnS-tz8tCw@mail.gmail.com>
In-Reply-To: <CADmzSSj2F77Z0Ufp-O7xQzPW=_BbUW3h3OCn7uhNUnS-tz8tCw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Dec 2021 09:01:14 +0200
Message-ID: <CAOQ4uxj-7fcQykRLxS3S=wOz+rbNXA5R-yV-jwF3WrcZ=Lq=Aw@mail.gmail.com>
Subject: Re: failed to verify upper - halts boot
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 7, 2021 at 11:17 PM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> On Mon, Dec 6, 2021 at 9:55 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Dec 7, 2021 at 4:38 AM Carl Karsten <carl@nextdayvideo.com> wrote:
> > >
> > > I powercyced my box, I'm assuming I did a sudo poweroff or halt or
> > > something, but maybe not.
> > >
> > > It got stuck, (enter rescue mode, root account disabled, hit enter to
> > > enter rescue mode... )  so I killed power.
> > >
> > > I edited fstab, changed auto to noauto, booted.
> > >
> > > overlay   /srv/nfs/rpi/bullseye/boot/merged    overlay
> > > noauto,defaults,ro,lowerdir=/srv/nfs/rpi/bullseye/boot/updates:/srv/nfs/rpi/bullseye/boot/setup:/srv/nfs/rpi/bullseye/boot/base,upperdir=/srv/nfs/rpi/bullseye/boot/play,workdir=/srv/nfs/rpi/bullseye/boot/work,nfs_export=on
> > >    0   0
> > >
> > > # mount /srv/nfs/rpi/bullseye/boot/merged
> > > mount: /srv/nfs/rpi/bullseye/boot/merged: mount(2) system call failed:
> > > Stale file handle.
> > >
> > > dmesg shows:
> > >
> > > [   45.941350] overlayfs: failed to verify upper (boot/play,
> > > ino=379405, err=-116)
> > > [   45.941369] overlayfs: failed to verify index dir 'upper' xattr
> > > [   45.941379] overlayfs: try deleting index dir or mounting with '-o
> > > index=off' to disable inodes index.
> > >
> >
> > Did you by any change re-create boot/play dir without re-creating
> > boot/work dir? because that is what that message means.
> > I doubt it has to do with the power cycle.
>
> Maybe.
>
> would that include:
> mount: lower=base,setup upper= updates
> unmount
> mount: lower=base,setup,updates upper=play
> ?
>
> That might have happened.

Yes, that would do it.

>
> >
> > > It is a bit concerning that I need to consider a power cycle may
> > > require local console use.  I plan on managing this remotely.  For now
> > > I'll leave it noauto and remotely mount when needed.  so this isn't a
> > > critical blocker to me.
> > >
> > > What would happen:  errors=remount-ro
> > >
> > > errors={continue|remount-ro|panic}
> > >     Define the behavior  when  an  error  is  encountered.  The
> > > default is set in the filesystem superblock,  ...     and can be
> > > changed using tune2fs(8).
> > >
> >
> > This looks like a quote from the man page section about ext2 mount options.
> > Those are not options supported for overlayfs.
> >
> > Anyway, with that error, as the kernel log says, you could have mounted
> > overlayfs ro with -o index=off and we could have added a mount option
> > to fallback to ro mount with index=off, but that means no nfs_export,
> > so not sure if that is what you wanted.
>
> That would be an improvement, as would errors=continue.
>
> Either of these would let a healthy system come up and be usable, and
> errors would let the system come up (finish booting) but the
> nfs/overlay part needs attention.
>
> Currently I have noauto so any reboot requires attention.
> If I set auto, an error will cause the boot to stop and I don't have a
> way to fix it remotely. I don't want to risk that, so noauto.
>

There is no need for a kernel change.
You can use boot scripts or mount helper to implement the mount options
fallback that suits your system needs.

> I think I would prefer errors=continue as It would be more obvious
> that the overlayfs mount has issues.
>

That is not likely to happen and FYI errors=continue does not even
mean what you think for ext4 where it is supported.
It does not continue on failure to mount, it continues on IO and
fs corruption errors detected during operations on a mounted fs.

Thanks,
Amir.

Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F630C433B4
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EBCE60FE8
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhDJTgj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbhDJTgj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 15:36:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5960AC06138B
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:36:24 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g18-20020a7bc4d20000b0290116042cfdd8so6467901wmk.4
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NJjR2Rc5GAcbM9d2d/u81JGD5YaISqu0kuRfnPGhsvE=;
        b=VuiGDF+yvROe0ZcWRZj84vhJSOWodYgYwiDQBA7JcrciYPNRtulbAzx9qcAhVEdtgg
         KCk0JCgMkL0rhXazrYBaij8T5oUdiDiDZdrjusxTy+4OyP7nK+s7gBzXilUR8K8FuNeO
         Dizc5j2qb2iRLP7jIhHfj2Va+z4SUAPeVmAekHe/PxjSWAjJv5/JcBWdKAQVA7mG7fqH
         aqnbkjgL6LTmTlfTspLH8ghWFU5ThatZeVMesEul4RJDPwMYHEb1cxWzfCdVyk/di2sQ
         hllIIVfwTCuXmsd2G7uSH1+aRljalCnz81bMz+x8sM7w1zbxmB2+jGPHa6+Vd6qIkif2
         1Hyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NJjR2Rc5GAcbM9d2d/u81JGD5YaISqu0kuRfnPGhsvE=;
        b=tjFNXo8Dhs2Eb999s9ubgSgHy12YyfJ7gRr5/WRT/Zn1SQC8izFamYFDdOEnBK1KZS
         koH7f3CDRo0TCxCc/xjV7y9MuaxwoVcnInhtMBBbm1swf0aDdIJHqdpuoYhY1rv/mnAx
         qQphmLVEd9bZ2eYN3CQ+FhE6H3gi+C11Tn9XYkr9HZdVaoLfoA3TOTdUHxkaNy5d64vW
         C9LvFR64+mzqCxFx3c50naHWpTwYH+s8yXhQ3aSiI+fa5Ieyx1wBTHWryHzHhBJv/L9O
         pn8J7sOVp/XaMunAVZqfIfwbyYnLuMn+dX/W+RkJ7wr3JrJx1+sJhCCbblsUaH7Kxgpy
         YBlA==
X-Gm-Message-State: AOAM53267R1qBBaf3aIzNnEiI1IyL2r7NuZVK5euNyvGMHG0zfaeN3Dp
        kF6XDx3E9p6bFA32vmXiRX7BeO88xgTRT1Zi1J6XBCIezR3vZqSf
X-Google-Smtp-Source: ABdhPJxem2kf/rwE3day/0mPINt6CyHgydRqypDyFoswD/3sXp9gEMNjmhIIEotX196kBoBHkgG8wwl2YOTh0bxJjJ4=
X-Received: by 2002:a05:600c:3650:: with SMTP id y16mr19437356wmq.182.1618083382892;
 Sat, 10 Apr 2021 12:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com> <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 10 Apr 2021 13:36:06 -0600
Message-ID: <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 10, 2021 at 11:55 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Apr 10, 2021 at 8:36 PM Chris Murphy <lists@colorremedies.com> wrote:
> >
> > I can reproduce the bolt testcase problem in a podman container, with
> > overlay driver, using ext4, xfs, and btrfs. So I think I can drop
> > linux-btrfs@ from this thread.
> >
> > Also I can reproduce the title of this thread simply by 'podman system
> > reset' and see the kernel messages before doing the actual reset. I
> > have a strace here of what it's doing:
> >
> > https://drive.google.com/file/d/1L9lEm5n4-d9qemgCq3ijqoBstM-PP1By/view?usp=sharing
> >
>
> I'm confused. The error in the title of the page is from overlayfs mount().
> I see no mount in the strace.
> I feel that I am missing some info.
> Can you provide the overlayfs mount arguments
> and more information about the underlying layers?

Not really? There are none if a container isn't running, and in this
case no containers are running, in fact there are no upper or lower
dirs because I had already reset podman before doing 'strace podman
system reset' - I get the kernel message twice every time I merely do
'podman system reset'

overlayfs: upper fs does not support xattr, falling back to index=off
and metacopy=off
overlayfs: upper fs does not support xattr, falling back to index=off
and metacopy=off

This part of the issue might be something of a goose chase. I don't
know if it's relevant or distracting.


> > Yep. I think tmpfs supports xattr but not user xattr? And this example
> > is rootless podman, so it's all unprivileged.
> >
>
> OK, so unprivileged overlayfs mount support was added in v5.11
> and it requires opt-in with mount option "userxattr", which could
> explain the problem if tmpfs is used as upper layer.
>
> Do you know if that is the case?
> I sounds to me like it may not be a kernel regression per-se,
> but a regression in the container runtime that started to use
> a new kernel feature?
> Need more context to understand.
>
> Perhaps the solution will be to add user xattr support to tmpfs..

$ sudo mount -o remount,userxattr /home
mount: /home: mount point not mounted or bad option.

[   92.573364] BTRFS error (device sda6): unrecognized mount option 'userxattr'

/home is effectively a bind mount because it is backed by a btrfs subvolume...

/dev/sda6 on /home type btrfs
(rw,noatime,seclabel,compress=zstd:1,ssd,space_cache=v2,subvolid=586,subvol=/home)

...which is mounted via fstab using -o subvol=home

Is it supported to remount,userxattr? If not then maybe this is needed:

rootflags=subvol=root,userxattr


-- 
Chris Murphy

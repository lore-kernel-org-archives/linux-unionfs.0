Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9416CC4361B
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Dec 2020 06:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598892333E
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Dec 2020 06:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgLPGFv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 01:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPGFu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Dec 2020 01:05:50 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76724C0613D6
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 22:05:10 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y5so22863492iow.5
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 22:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BTvAc5Sc5ojErOT13Mp+ZJ1fiPt7Hzdq2+n0DDKfgU0=;
        b=t55Y8o99Pf8jCTwbDS6vlYqo7VaDMwWdIDd201z7psa/JST8//y50fueWxFuyUsfz8
         kZN3D8u7Wm6bTD00Q52KN2zjQOegXyI0NmyuvsbzAykEbqI9/dU0fWZbFNnNbCEWMXtW
         envAkQatd3L3SnS/9LxDckxdQkmu+7DpEwpe1Nntv6XxmyP4pcGepGEbYcDDItuH71Sg
         aeCssHmZM6z625/8BWH9c98UrYpsPP65k60FGsIfny5wHUm9hMd0KuLvWwZ2qFwfG7Ys
         avE2YCHb+Mn+Wz5dKPF8oHLqvy+3JFzfTXicAYiowb104vxj9ZO2iX5hjxEfEyPX+u21
         ATyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BTvAc5Sc5ojErOT13Mp+ZJ1fiPt7Hzdq2+n0DDKfgU0=;
        b=e4MMksBtfgHHuRMbzRvIA34sslEf7rY2bcq6/oLdV0ENb8oqxnbbzlQqegtUBGfn5Y
         9fpQ0zpEeIvQYKo9wHh0mXQFwQfkG9YMFQSkcXpuI+88KXQnOW5kmSVg4iGYkCINHtZ4
         C519rujBSDtf2KfowooqaVyUzbotiBNk/4XpSwmUs3O9S9kjZ2/NjJjarZFDKIS8Hc18
         FCLV4JncCqgzbEKKgQYVWaNB1olmM51E46W2/qSu3eOmLlOnI06oq+MWkq08b4ZtjVJ9
         EhZLTMm9ZeVsRUoqgBmd3rQRG3WaJPMF/qzfzC5QeRXlONhYUyMFSIu4rnUcYzmZXR3D
         B5UA==
X-Gm-Message-State: AOAM5338IrYgOSA74FQLYeD1EA56+/uJquLafU19XcgqInBVWVKLdKqG
        aJe56OQa6pk8c1nKA0sI6aYXBePhKSnRrW8tsJsx/oAuO6g=
X-Google-Smtp-Source: ABdhPJyIebv3dALJObMqBlJMVeFKlHCjVVUhX1FOF/zgvWJoc0imH4U5WIROAccUywU5jEeiaUHzQNHH9iR4faSTmpw=
X-Received: by 2002:a02:8482:: with SMTP id f2mr41876615jai.93.1608098709782;
 Tue, 15 Dec 2020 22:05:09 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com> <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
In-Reply-To: <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 16 Dec 2020 08:04:58 +0200
Message-ID: <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Michael Labriola <michael.d.labriola@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 15, 2020 at 9:29 PM Michael Labriola
<michael.d.labriola@gmail.com> wrote:
>
> On Tue, Dec 15, 2020 at 11:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Dec 15, 2020 at 5:33 PM Michael D Labriola
> > <michael.d.labriola@gmail.com> wrote:
> > >
> > > On Mon, Dec 14, 2020 at 6:06 PM Michael D Labriola <michael.d.labriola@gmail.com> wrote:
> > > >
> > > > I'm sporatically getting "no data available" as a reason to fail to
> > > > open files on an overlay mount.  Most obvious is during ln of backup
> > > > file during apt install.  Only seems to happen on copy_up from lower
> >
> > How do you know that? Do you have some more tracing info?
>
> I haven't done any tracing, perhaps I overstated.  The problem I'm
> seeing only happens when overlayfs goes to create a copy of a lower
> layer file in the upper layer.  When the problem occurs, it's always
> on a file that exists on lower but not upper, and is about to be
> modified.
>
> >
> > > > layer.  Lower layer is squashfs (I've seen it happen with both the
> > > > default zlib and also zstd compression), upper is EXT4.
> > > >
> > > > I've only bumped into this problem recently with 5.9+ kernels.  I'm
> > > > gonna go see if I can reproduce in some older kernels I still have
> > > > installed.
> > >
> > > Rebooting into 5.4 made the problem go away and I can apt upgrade
> > > w/out any problems.  Rebooting an affected virtual machine into 5.8
> > > also fixed the problem, so it looks to be something introduced in 5.9.
> >
> > There are no overlayfs changes v5.8..v5.9 nor squashfs changes.
> > Are you sure that your reproducer is reliable enough for the bisection?
> > If it is, please try to bisect the offending commit because I have no idea
> > where it may be.
>
> I'm having a hard time reproducing the problem.  It's only happening
> frequently enough for me to be pretty sure it's a bug.  I've been
> using an overlay of squashfs/EXT4 on my development laptop for over a
> year, using the squashfs image to fork off disposable virtual machines
> for testing.  It's worked flawlessly up until I started testing w/
> 5.9... but I couldn't correlate my problems to anything specific until
> just recently.
>
> More than once now, my host system or a virtual machine has randomly
> failed to process an apt update.  Either a backup hardlink creation
> fails or some other processing command fails, always with an error
> message of "No data available", which makes no sense to me.  Booting
> back into my 5.4 or 5.8 kernel and performing the upgrade, then back
> into my 5.9 kernel alleviates the problem until it happens again on
> some other package.
>
> I have also seen "No data available" pop up in seemingly random
> places.  For example, yesterday postfix refused to send mail, and when
> I went to restart the service I got this:
>
> postfix/bounce[24836]: fatal: open lock file pid/unix.bounce: cannot
> open file: No data available
>
> Today, in 5.9.14, I did an apt upgrade which didn't fail creating
> backup files, but instead failed doing a postinstall task like this:
>
> Setting up sudo (1.8.21p2-3ubuntu1.3) ...
> chown: changing ownership of '/etc/sudoers': No data available
> dpkg: error processing package sudo (--configure):
>  installed sudo package post-installation script subprocess returned
> error exit status 1
>
> Rebooting the vm resulted in the same problem.  Booting into 5.8.18,
> apt upgrade succeeded.  Then I rebooted back into 5.9.
>
> >
> > >
> > > I suppose I should try 5.10 and see if this problem has already been
> > > fixed.
> > >
> >
> > Wouldn't hurt.
>
> Trying that shortly.  Also trying to figure out how to force the
> problem to happen...  I'll never get to the bottom of it at this rate.
> I was really hoping somebody on the list would recognize the
> problem...  :-/  Just my luck.

The problem rings a bell, but I would expect it had something to
do with the change:
a888db310195 ovl: fix regression with re-formatted lower squashfs

From v5.8.0 that was also applied to stable v5.4.y, so there is no
match to your report.

'No data available' means ENODATA error from getxattr()
which is not expected to be returned from operations like chmod() and
link() as you reported that is why the message makes no sense.
I did not find any internal vfs_getxattr() call in overlayfs code where
ENODATA can be exposed to the caller.

I did find that ENODATA could be exposed from lookup via a call to
ovl_verify_origin(), but that implies that the index feature is enabled
and is expected to print "overlayfs: failed to verify..." to kmsg.
We should probably replace the use visible lookup error with EIO,
but that in itself won't help users to understand the problem.

Do you use an existing upper (ext4) dir with a lower squashfs image that
is not the original image used when first mounting overlay with that upper dir
AND enable the index=on feature?
I still don't see how that would be a regression of kernel v5.8 and certainly
not v5.9.

Do you use any non default overlay config/mount options?

Please share the output of '/proc/self/mountinfo' with mounted overlay
and 'grep Y /sys/module/overlay/parameters/*'

Do you see any "overlayfs:" logs in kmsg?

If you do not need nfs export, you could try to create squashfs image with
-no-exports as a possible workaround.

Thanks,
Amir.

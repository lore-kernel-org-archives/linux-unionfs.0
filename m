Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19106C2BB9A
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 19:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D60F822B2D
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 19:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgLOTaC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 14:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgLOT3y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Dec 2020 14:29:54 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECE3C0617A6
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 11:29:14 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id 9so17455084oiq.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 11:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2os84qui7cdHqLpOA1txv7ohx3zMLEtYg0MMMFWPYKs=;
        b=Cj2SyevXynumsiV6OKjTPXDp7UmQ2D/fsO0rJjJG8rdaadZNjOuKhQtZCRWhgDQRwT
         TvMbq1PoWb66yL4n/jXDCwTYH6Gw4zyYw2IJBzrJtdDz+2b4FEtUpLphIHKeG9eE10+0
         3g8Re+jptyetC8B1byz0M/1H7TrApFjHcgun5ck3SMyBh0BWqmTVKlbMCBs/cZ6/KPVZ
         2kUaGyNAY65RZ69qtSjqFnNnyDBeYRqJ24kZuFK6GTUeuTfA14W0AkvD3NZU1w8+SrPO
         ilO+pCzCNH1WugTfVfY102UJ6Lq1fi9Mfyn8tqGJSyeAmuy7XiIMt61acjcFKxdj8CGs
         VG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2os84qui7cdHqLpOA1txv7ohx3zMLEtYg0MMMFWPYKs=;
        b=r/UTRzPlx5cw0IFH5v6IweDtOFiSgHHEw7OakDkGmX7rhZiC3NS7L1T82BrNZi37SQ
         8l4GHPxlY7m6Yt8YQhk88wF7F5Z06zMdb/pDJk8xyvvjOvdQUNWmdhKMGLc1XL+bF7g3
         kWEAYw5eTgMJgDKmiW9Js2KNMm+Gwrp1ZdvENsq2SejQOzQBGRmS+iVkNAD5TgakoHCr
         zuAElRuje5EdjRGLbk1oTZ1wrfJ0233CGJ/1PbAYkfKjzYZFUWTR5GPn+EdPfXSGjhQ0
         U5F1PmwtILYVSx5eq1NlowZPc4UpbOc4p7p+s6CN4YmO72Gg3up0cWBrMyIfIIAhFWdF
         W8yQ==
X-Gm-Message-State: AOAM530d0YThJjjDyVOXUP0uqi4F/N55Z4HnkOkObirkvReJueqVdCxD
        WGH7X9YW5ygT6gSKiN8bMzsZ6SO+SidM90i2gFc=
X-Google-Smtp-Source: ABdhPJxo7ZzSA+w6Memp3KDy1YryhaFWusraYCmD44OTNmR22xRmtFX8VCGemJVkNJAL7+gjG9EQ0YppB+aK29gisOg=
X-Received: by 2002:a05:6808:3c3:: with SMTP id o3mr307606oie.24.1608060553635;
 Tue, 15 Dec 2020 11:29:13 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
In-Reply-To: <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
From:   Michael Labriola <michael.d.labriola@gmail.com>
Date:   Tue, 15 Dec 2020 14:29:02 -0500
Message-ID: <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 15, 2020 at 11:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Dec 15, 2020 at 5:33 PM Michael D Labriola
> <michael.d.labriola@gmail.com> wrote:
> >
> > On Mon, Dec 14, 2020 at 6:06 PM Michael D Labriola <michael.d.labriola@gmail.com> wrote:
> > >
> > > I'm sporatically getting "no data available" as a reason to fail to
> > > open files on an overlay mount.  Most obvious is during ln of backup
> > > file during apt install.  Only seems to happen on copy_up from lower
>
> How do you know that? Do you have some more tracing info?

I haven't done any tracing, perhaps I overstated.  The problem I'm
seeing only happens when overlayfs goes to create a copy of a lower
layer file in the upper layer.  When the problem occurs, it's always
on a file that exists on lower but not upper, and is about to be
modified.

>
> > > layer.  Lower layer is squashfs (I've seen it happen with both the
> > > default zlib and also zstd compression), upper is EXT4.
> > >
> > > I've only bumped into this problem recently with 5.9+ kernels.  I'm
> > > gonna go see if I can reproduce in some older kernels I still have
> > > installed.
> >
> > Rebooting into 5.4 made the problem go away and I can apt upgrade
> > w/out any problems.  Rebooting an affected virtual machine into 5.8
> > also fixed the problem, so it looks to be something introduced in 5.9.
>
> There are no overlayfs changes v5.8..v5.9 nor squashfs changes.
> Are you sure that your reproducer is reliable enough for the bisection?
> If it is, please try to bisect the offending commit because I have no idea
> where it may be.

I'm having a hard time reproducing the problem.  It's only happening
frequently enough for me to be pretty sure it's a bug.  I've been
using an overlay of squashfs/EXT4 on my development laptop for over a
year, using the squashfs image to fork off disposable virtual machines
for testing.  It's worked flawlessly up until I started testing w/
5.9... but I couldn't correlate my problems to anything specific until
just recently.

More than once now, my host system or a virtual machine has randomly
failed to process an apt update.  Either a backup hardlink creation
fails or some other processing command fails, always with an error
message of "No data available", which makes no sense to me.  Booting
back into my 5.4 or 5.8 kernel and performing the upgrade, then back
into my 5.9 kernel alleviates the problem until it happens again on
some other package.

I have also seen "No data available" pop up in seemingly random
places.  For example, yesterday postfix refused to send mail, and when
I went to restart the service I got this:

postfix/bounce[24836]: fatal: open lock file pid/unix.bounce: cannot
open file: No data available

Today, in 5.9.14, I did an apt upgrade which didn't fail creating
backup files, but instead failed doing a postinstall task like this:

Setting up sudo (1.8.21p2-3ubuntu1.3) ...
chown: changing ownership of '/etc/sudoers': No data available
dpkg: error processing package sudo (--configure):
 installed sudo package post-installation script subprocess returned
error exit status 1

Rebooting the vm resulted in the same problem.  Booting into 5.8.18,
apt upgrade succeeded.  Then I rebooted back into 5.9.

>
> >
> > I suppose I should try 5.10 and see if this problem has already been
> > fixed.
> >
>
> Wouldn't hurt.

Trying that shortly.  Also trying to figure out how to force the
problem to happen...  I'll never get to the bottom of it at this rate.
I was really hoping somebody on the list would recognize the
problem...  :-/  Just my luck.

> Thanks,
> Amir.

-- 
Michael D Labriola
21 Rip Van Winkle Cir
Warwick, RI 02886
401-316-9844 (cell)

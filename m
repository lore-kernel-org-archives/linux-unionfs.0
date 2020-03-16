Return-Path: <SRS0=I2E7=5B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA79C0044D
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707282051A
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TOcEDD7v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgCPNwr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:52:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46896 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731258AbgCPNwq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Mar 2020 09:52:46 -0400
Received: by mail-io1-f68.google.com with SMTP id v3so17143988iom.13;
        Mon, 16 Mar 2020 06:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=evLSLS3oddQ35jzc19igvW67YCvhCiGKly31HxckwHA=;
        b=TOcEDD7vGEcni3Wjmeqv+XWYdZyAZ9GbGZbjFmnBHqrG0w0LyKLMxJ4EeAoA2XHXof
         ICd+xdOkM8VigD0dG+dB9WbxGvOBKbxn6D+deu7GMtUvWCXwfhImyV489ocoXUas7gVU
         JK5N+tIiSyQBKYjUUYtvlMzHJNp+1dwWMbS/OwJbeL0B5M8AoHucaSNZkMll6KMdHOps
         rdJBlfO0sRcUdp5xfsnBpUj2JQxJd7OrbHX3D+RGqlNTRuJtfZRfwlkrZTsI9drTqijx
         nqyRZ1UvvDrEjVZrI76tG86mEChaUt3GKyyw5+fTeXK3bzKyjzQUENI0aGd7j6AJEjgU
         hiRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=evLSLS3oddQ35jzc19igvW67YCvhCiGKly31HxckwHA=;
        b=Pm3WDd+xYIprUZ6xr/PD8bvSyt7AFim0iG4UYwMEd8jxteo5ux4MtAc3RgN9to6G/U
         fGbhWBvkWpLhUeTw4zHvGBua+UuHuyhu+3n3xh/+wCtiW6G0D84nm7okUos3cD9XNrSs
         c6Y9uqujtuWFyo7MMfr03NUiK+r2jngsieQJgrwg27aHKEdy8fAgJMROPaB0MU/JPIVY
         e+9gZMLXG3rSMJkom24vQRY3myrtPsmzBDR11PoOiZRnUNo2lkZpezigja6U2NnLkSrm
         04hSMv1NktgkAUDzpH/t6mNnDCqHa17dggJGlYdsDJKZ8g3+d6CvjtFWG6TFZJjCCL6D
         WauA==
X-Gm-Message-State: ANhLgQ18jtjEUelfutorBQu5qKi9q+hgC7BmoHWFIDW2tnEjF92qaG0/
        o0Yte2Ub8UDquEdOmwAUAwKPlgoiw1qfh+bcCeY=
X-Google-Smtp-Source: ADFU+vtR2l0ZDYYb77SM1NS9sfP/ZVu3rzq8PkML8jp6gju/ZEUyhKhq3XRXGKDU9BDcEuEIgTJAL9aA9UVNjNfSIpw=
X-Received: by 2002:a5d:980f:: with SMTP id a15mr23475578iol.203.1584366765680;
 Mon, 16 Mar 2020 06:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191230141423.31695-1-amir73il@gmail.com> <20191230141423.31695-5-amir73il@gmail.com>
 <CAJfpegvHAq+yT1qW4JqTBpviCHUrQqOPMfWEcvhy4Jpr2bLJfQ@mail.gmail.com>
In-Reply-To: <CAJfpegvHAq+yT1qW4JqTBpviCHUrQqOPMfWEcvhy4Jpr2bLJfQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 16 Mar 2020 15:52:33 +0200
Message-ID: <CAOQ4uxiANoiXhdbXMYLsttAHB9nrh_9vMn3z8usS46=H54QJ3A@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] overlay: test constant ino with nested overlay
 over samefs lower
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 16, 2020 at 2:29 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Dec 30, 2019 at 3:14 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Also test that d_ino of readdir entries and i_ino from /proc/locks are
> > consistent with st_ino and that inode numbers persist after rename to
> > new parent, drop caches and mount cycle.
>
> overlay/070 and overlay/071 fail for me like this:
>
>      QA output created by 071
>     +flock: cannot open lock file
> /scratch/ovl-mnt/lowertestdir/blkdev: No such device or address
> ...
>
> I.e. there's no block dev with rdev=1/1.
>
> I don't see any other way to fix this, than to remove the device
> tests.

I ran into similar complain when I worked on generic/564.
Apparently, this is not the first test that uses rdev b/1/1 and c/1/1
so not sure how those tests work for everyone.
In generic/564 I used a loopdev as blockdev and /dev/zero as chardev.

> Why are these needed?  Is locking code in any way dependent on
> file type?
>

Not strictly needed.
See that they already skip file types fifo|socket|symlink.

But note that we are not testing locking, we are using /proc/locks
to get a peek at i_ino, so if we skip also blockdev and chardev, we
end up testing no special files at all for i_ino consistency.
Not the end of the world, but then again using loop dev and /dev/zero
would be quite trivial as well.

If it bothers you, I can post a fix.

Thanks,
Amir.

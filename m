Return-Path: <SRS0=1hX+=AA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58E0C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 19 Jun 2020 03:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDB92080D
	for <linux-unionfs@archiver.kernel.org>; Fri, 19 Jun 2020 03:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpnT7Ikw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgFSD3V (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 23:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbgFSD3U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jun 2020 23:29:20 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C5AC06174E
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2020 20:29:20 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id s18so9736060ioe.2
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2020 20:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8fHyWgTeE7hWMPe3U50bhqcSd/TvQ9o1jrTHSq04yM=;
        b=JpnT7IkwLtCtWxpH4wpQH9gwGTexljWUc7J7uOV4nvyhEYP6RfFtEq6HAFa/6jn67r
         ++Ki2IscFMYalFzkvyJ0WikNk1+lyyieFXU3G1jgTeLjQjisDgtLPYP3+5oDx5hWS5BC
         TAEL8ZqWTzu5vHtE2+3NjViYl4n5++N6YIe1ZsGFOgmzjEmkx+l1K2KBO0RQVHlthNjt
         QULaWW8iWus6BmTmyp6N+qMRKajHbg4ktF233sPoDxt3kN7GzqPuSTH7PcBz5AN3kbvg
         3s+yeRF7dQUUCpUtsMPhSzDRDYYOyHjlUbGcnW9pbzExVIda/TYLjVT1yhW+Gjutdhpi
         U/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8fHyWgTeE7hWMPe3U50bhqcSd/TvQ9o1jrTHSq04yM=;
        b=PvqCjCAEMYWiYfs4eXnOB5LxVl21vfDiQwL8G/wxekCgostB8FcsP1qsZ6R2/PDgg/
         AjYtONXlioaG0ecoc2btEQvivCsCYggLZINCmCY9Tja1tRCHOH+tJmqQiLLfTbQJQOxL
         wz7ydfluYko4rRwUWw339dHSlAGlTUtUJgKjhD+sRoOwZJgm3NzTYIPhghvNOgXmTYJp
         cp16XCh/kT5O8E8EGNg+stwuof/fblTTWoXfsYLZybPa+dJJmr4S/lzTHEFXJE54vAke
         UI74x6S1zFvXbtM0UTYWK5MDK1C9YbcvmAwFA9YXZCOE/4rCPCLNOoEE29y7RUDsLUOz
         80qA==
X-Gm-Message-State: AOAM531aAgRVeuwKnJJJitjvDLQuzDVgM/psrM0I1CdnQTR9X6olLiMz
        RfYtHnprMh4cs3BJbQhI7VQl5VqwiDfV2FK6Uvw=
X-Google-Smtp-Source: ABdhPJyIuKW6kklRNXk51pyddZjbjKDqgbncS4shRIY9oruWPD+ajwk0mkNWiOXKdUmwpaGixK8XSzRPLVYVAo8mm0M=
X-Received: by 2002:a6b:b483:: with SMTP id d125mr764123iof.186.1592537359194;
 Thu, 18 Jun 2020 20:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200529164058.4654-1-amir73il@gmail.com> <20200618213831.GF3814@redhat.com>
In-Reply-To: <20200618213831.GF3814@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 19 Jun 2020 06:29:08 +0300
Message-ID: <CAOQ4uxi8a1sLc_5j2RcYZL0ZSHnBhufhLkr92FmXv33KjX7qsA@mail.gmail.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: master branch updated to 9c60a9c
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 19, 2020 at 12:38 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, May 29, 2020 at 07:40:58PM +0300, Amir Goldstein wrote:
> > Hi All,
> >
> > The master branch on the unionmount-testsuite tree [1] has been updated.
> >
> > Changes in this update:
> > - Support user configurable underlying filesystem
> >
> > So far, unionmount-testsuite used hardcoded paths for layers and
> > mount point.  Using underlying filesystem other than tmpfs was possible,
> > but not very easy to setup.
> >
> > This update brings the ability for user to configure custom paths
> > with a custom filesystem for the underlying layers.
> > This is intended to be used for integration with xfstests [2].
> >
> > Here is an excerpt from the README:
> > ---
> >   The following environment variables are supported:
> >
> >   UNIONMOUNT_BASEDIR  - parent dir of all samefs layers (default: /base)
>
> Hi Amir,
>
> I am running these tests with.
>
> UNIONMOUNT_BASEDIR="/mnt/foo/"

I suspect there is a bug with trailing / in UNIONMOUNT_BASEDIR
I did not test with trailing /
Can you try without it?

>
> - ./run --ov runs fine. But when I try to run it again it complains
>   that.
>
>   rm: cannot remove '/mnt/overlayfs//m': Device or resource busy
>
> So I have to first unmount /mnt/overlayfs/m/ and then run tests
> again.
>
> I think it will be nice if it can clear the environment by itself.
>

It should.
All the tests I tried cleaned up previous test env automatically.
The only case where explicit cleanup is needed is before changing
context and modifying envvars.

> - I am running one the recent kernel (5.7.0+) and following errors
>   out.
>
> # ./run --ov --verify
> Environment variables:
> UNIONMOUNT_BASEDIR=/mnt/overlayfs/
>
> ***
> *** ./run --ov --samefs --ts=0 open-plain
> ***
> TEST open-plain.py:10: Open O_RDONLY
> /mnt/overlayfs/m/a/foo100: not on union mount
>
> Will spend more time to figure out what happened.
>
> - I am planning to use these environment variables and run overlay over
>   virtiofs tests. Can I do the same thing with xfstests overlay tests.
>   In README.overlay I see that I need to specify two separate devices.
>   Can I specify to directories (and not devices) to be used as TEST
>   and SCRATCH and run overlay test.

As far as I can tell, SCRATCH_DEV and TEST_DEV are directories
in all those non-block filesystems including virtiofs:
_scratch_mkfs()
...
      case $FSTYP in
        nfs*|cifs|ceph|overlay|glusterfs|pvfs2|9p|virtiofs)
                # unable to re-create this fstyp, just remove all files in
                # $SCRATCH_MNT to avoid EEXIST caused by the leftover files
                # created in previous runs
                _scratch_cleanup_files

So I think you just need to set SCRATCH_DEV and TEST_DEV to
two different directories and you are good to go for running
check or check -overlay.

Thanks,
Amir.

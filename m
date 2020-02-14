Return-Path: <SRS0=3MWK=4C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B48C35242
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABAED2082F
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MarzV/1k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgBNWh7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 17:37:59 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33267 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgBNWh7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Feb 2020 17:37:59 -0500
Received: by mail-il1-f196.google.com with SMTP id s18so9389327iln.0;
        Fri, 14 Feb 2020 14:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yh5AohT+JBGMlZIkgzxcyeLi/0+gL4C8IdKBB5Ex4EI=;
        b=MarzV/1k02WmgfLVevkQweZtVCBCVfRb5Bgq0lgV5J1xv7W5bMUxaLLbStUWJFFdYp
         YRT6wbE+n++6wBmWucPBKvZg4JONc4ahGUAcuct34AIPcKLEusrMXmrnM19LQ/UB3JiM
         KaQEHflFFV1NgmnDcZMttCOhve16S24ElccjwoeVoIeHTgoqNqFZQEAUnBAf6IP9/jeN
         yAh+5kYLDhayQvPG4GGMr6YJpIq411CgjkE1icgR6MKPMiMcFJ9MuISKeH6LX+Yc5Evm
         soQ1sIGSQpm5ZwTvOPEMJLHmZXkMJhO5klc+OQCPPEgW8rftEDR0PvC6hix/JiI6a4ju
         IZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yh5AohT+JBGMlZIkgzxcyeLi/0+gL4C8IdKBB5Ex4EI=;
        b=ribiNh0NnrDc/BGl4b0ew7sASjYCIx+3mEPGxWHzF1wMpbgwwEezuEYTeHmtoTv5pn
         IYal18i2eh4mLjQUwMyGvC9YhootK+8ifRywJJsWjQ7BMCM6mW7YCEF/wkqgRjbkOmQm
         J09K9N9pEhbUEWZWLoWvxZsktfo6PKqEm6mmxfdC+gdEAeKxl/ngZN2CPNJ0/szuxyQn
         JEbABpPEIpHMGD3QL5ntzrITe3DLDJOL0NxzfCMoP2lonEn4LrHgQthPShoqYi0vKYkE
         k4zCXvDnQbUiRMSDZlMFrpC081+IWMKeTmLKLbuHL74f5xlL61MVF+cOLCjR3I0qw036
         lkeg==
X-Gm-Message-State: APjAAAULrWzNaDck+gOrEKxuYT1bvdPEoaY+bTa06xoJWcGhZy0nb6dJ
        TwCe2SOAPLrOqRnM+Fevuy4al4ZFxsCSGM+A+kg=
X-Google-Smtp-Source: APXvYqx28TUcTRJwStak2Sn/bx3dWB+YDPBDNrjmfYaVJkwmGQSQDCYEVWa6fbKwOQj+RTVuGd3BhsLqlbV/DX47j9E=
X-Received: by 2002:a92:9f1a:: with SMTP id u26mr5199317ili.72.1581719878556;
 Fri, 14 Feb 2020 14:37:58 -0800 (PST)
MIME-Version: 1.0
References: <20200214151848.8328-1-mfo@canonical.com> <20200214151848.8328-5-mfo@canonical.com>
In-Reply-To: <20200214151848.8328-5-mfo@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 15 Feb 2020 00:37:47 +0200
Message-ID: <CAOQ4uxj9+BDv5DCcioUCTXhv9_32t5L+spBn8_2n+QKkjQ6nGA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] common/rc: add quirks for fuse-overlayfs
 device/mount point
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 14, 2020 at 5:18 PM Mauricio Faria de Oliveira
<mfo@canonical.com> wrote:
>
> On fuse-overlayfs the mount device is always reported as
> a "fuse-overlayfs" string, instead of the parent directory
> of the mount point (the string expected by overlay/scripts).
>
> Unfortunately, it seems that the fuse mount option 'fsname'
> doesn't set the filesystem source/device on fuse-overlayfs,
> so the easy fix of just adding it to mount options is gone.
>
> So two quirks are used to check for a fuse-overlayfs mount,
> that checks the mount point/directory in _check_mounted_on()
> and init_rc(); latter with the new helper _fs_type_dev_dir().
>
> With this, fuse-overlayfs can now keep going through tests!
>
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
> ---
>  README.overlay |  1 +
>  common/rc      | 19 ++++++++++++++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/README.overlay b/README.overlay
> index 08a39b8830c9..7ef07ae6bbab 100644
> --- a/README.overlay
> +++ b/README.overlay
> @@ -53,4 +53,5 @@ OVERLAY_FSCK_OPTIONS will be used to check both test and scratch overlay.
>
>  To test other filesystem types (experimental) configure the OVL_FSTYP variable:
>
> + OVL_FSTYP=fuse.fuse-overlayfs
>   OVL_FSTYP=aufs
> diff --git a/common/rc b/common/rc
> index 5711eca2a1d2..6a4cb9b6d604 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1481,6 +1481,14 @@ _check_mounted_on()
>
>         # find $dev as the source, and print result in "$dev $mnt" format
>         local mount_rec=`findmnt -rncv -S $dev -o SOURCE,TARGET`
> +
> +       # fuse-overlayfs dev is not $dev, check via $mnt.
> +       if [ -z "$mount_rec" -a "$FSTYP" = "overlay" -a \
> +               "$OVL_FSTYP" = "fuse.fuse-overlayfs" ]; then
> +               dev="fuse-overlayfs"
> +               mount_rec=`findmnt -rncv -S $dev -T $mnt -o SOURCE,TARGET`
> +       fi
> +

I guess if we have to do the quirk then we better do it before the
first findmnt.
I don't see the point of trying the first time.

But I wonder, how come this is not also problem for virtiofs?
Maybe there is a way to make fuse fsname mount option work
instead of these quirks?

>         [ -n "$mount_rec" ] || return 1 # 1 = not mounted
>
>         # if it's mounted, make sure its on $mnt
> @@ -3788,8 +3796,17 @@ init_rc()
>         fi
>
>         # if $TEST_DEV is not mounted, mount it now as XFS
> -       if [ -z "`_fs_type $TEST_DEV`" ]
> +       if [ -n "`_fs_type $TEST_DEV`" ]
>         then
> +               # $TEST_DEV is mounted
> +               true
> +       elif [ "$FSTYP" = "overlay" -a "$OVL_FSTYP" = "fuse.fuse-overlayfs" -a \
> +               -n "`_fs_type_dev_dir fuse-overlayfs $TEST_DEV/$OVL_MNT`" ]

Somewhat simplified:
       elif [ "$OVL_FSTYP" = "fuse.fuse-overlayfs" -a \
               -n "`_fs_type_dev_dir fuse-overlayfs $TEST_DIR`" ]


Thanks,
Amir.

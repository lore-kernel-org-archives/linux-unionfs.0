Return-Path: <SRS0=3MWK=4C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94C7C35242
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86C5A206D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TMeaNoh0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBNWvg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 17:51:36 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:32792 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbgBNWvg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Feb 2020 17:51:36 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so755679ioh.0;
        Fri, 14 Feb 2020 14:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x1blGNXEvaN9sSEFaGvs0PQlrjhIn7iC/664ptnmuQY=;
        b=TMeaNoh07lsis7eG0P+4c081sEzgcjQF1rXcQ5wW8Zl/ClpP9OfiXt4+NWQoxUkSiF
         FLIX3tMGvsclaltB/BVeCT74Dl3joKUFvJJu8vpIlpu+kGLpdUuaDG8VMYz/dTn2VWAm
         UIn/BSJxFztiQsMHxOgRUduBaSzmNEGhcOvGFqqEBECpmheZLYJho2/UB0NNs0h1hP94
         GKKCbA7tRvhRxFZFcupIdG25CPAcO77GRJI0zJV4Fpl+AhpfQqc2uD0frNL4Lc0sJuoe
         gPxyCtxR2N819B1uNbIV7rX9dKP0burUzDby4/F85lkyEvcSawGVXAZJXrJzlpUKOY8a
         j/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x1blGNXEvaN9sSEFaGvs0PQlrjhIn7iC/664ptnmuQY=;
        b=mhQU8g57WawL5Jy/yfFQPMtPZX4RfTRmZuU3r+tH5Bk/EuVLXZBR6EcDJdxC7+RB9a
         GiMeqcXhqKqkb/RYAHhLa52ZoJ/C5L0aRk3sELpwfQz/eC7O3dG+JoZpJG0EH1tfr60h
         j3wdWbXdCfFVkQqnJepSUxotH4dGZgkC/EGO+jEAps0FtrtaEVx2LepzB+cvnLjbjiH2
         2QViU3yddJlSXowfOavAIS8jOgLmL+Jge9ZDYHxBs/nG3vo0Xm52hSi7qL5+qihd+kV6
         54IlkzQzdRAghXUu3kfWjl2gvcK9vVu8HACSMsHowEOsKtbTGXqNw+etbytjXtlvjunf
         4meg==
X-Gm-Message-State: APjAAAWom/b6pTra1kcaFbnm/qXdO3cZZNtIkmW+vUTdy8Ekjo+yHvK1
        ZMPvaUr8a9xfRoV4FqLQB6CDJYwXSTadpTyLPyY=
X-Google-Smtp-Source: APXvYqxSihw0+bkCs9dIbjghUv0izqg7PJQNz2DQreIa5sF4/+ksKxPc1hNIc8Os9CH9vlWTvhgACsJt5lwVlhtnbR8=
X-Received: by 2002:a6b:f214:: with SMTP id q20mr4357054ioh.137.1581720695504;
 Fri, 14 Feb 2020 14:51:35 -0800 (PST)
MIME-Version: 1.0
References: <20200214151848.8328-1-mfo@canonical.com> <20200214151848.8328-6-mfo@canonical.com>
In-Reply-To: <20200214151848.8328-6-mfo@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 15 Feb 2020 00:51:24 +0200
Message-ID: <CAOQ4uxgpLtJeUcn2Uu38hkNt0xpZn-MKdn4dwYm60H15dmrgmA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] common/overlay: silence some mount messages for fuse-overlayfs
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 14, 2020 at 5:19 PM Mauricio Faria de Oliveira
<mfo@canonical.com> wrote:
>
> When mouting fuse-overlayfs there are some messages that make
> the tests report failures due to output mismatch; ignore them:
>
>   uid=unchanged
>   uid=unchanged
>   upperdir=/mnt/test/ovl-upper
>   workdir=/mnt/test/ovl-work
>   lowerdir=/mnt/test/ovl-lower
>   mountpoint=/mnt/test/ovl-mnt
>
> For other filesystem types (e.g., overlay and aufs) make sure to
> only print non-null output, to avoid blank lines output mismatch.
>
> And return the status of the mount command, not other commands.
>
> Currently, running './check -overlay' tests (excluding generic/062)
> the numbers for fuse-overlayfs on loop devices on v5.4-based Ubuntu
> kernel with the fuse-overlayfs package from Ubuntu Eoan/19.10 are:
>
>  - Ran: 530
>  - Not run: 395
>  - Failures: 29
>
> And hopefully this helps with testing for fuse-overlayfs too.
>
> Steps:
>
>   $ export OVL_FSTYP=fuse.fuse-overlayfs
>   $ export FSTYP=ext4
>   $ export TEST_DEV=/dev/loop0
>   $ export TEST_DIR=/mnt/test
>   $ export SCRATCH_DEV=/dev/loop1
>   $ export SCRATCH_MNT=/mnt/scratch
>
>   $ sudo mkfs.$FSTYP -F $TEST_DEV
>   $ sudo mkfs.$FSTYP -F $SCRATCH_DEV
>   $ sudo mkdir $TEST_DIR $SCRATCH_MNT
>
>   $ cat <<EOF >/tmp/exclude-tests
>   generic/062
>   EOF
>
>   $ sudo -E ./check -overlay -E /tmp/exclude-tests
>
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
> ---
>  common/overlay | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/common/overlay b/common/overlay
> index a1076926c23f..27f3c08252ee 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -19,6 +19,8 @@ _overlay_mount_dirs()
>         local upperdir=$2
>         local workdir=$3
>         local options
> +       local output
> +       local rc
>         shift 3
>
>         options="-o lowerdir=$lowerdir -o upperdir=$upperdir -o workdir=$workdir"
> @@ -26,7 +28,23 @@ _overlay_mount_dirs()
>                 options="-o br=$upperdir=rw -o br=$lowerdir=ro"
>         fi
>
> -       $MOUNT_PROG -t $OVL_FSTYP $options `_common_dev_mount_options $*`
> +       options="$options `_common_dev_mount_options $*`"
> +       output="`$MOUNT_PROG -t $OVL_FSTYP $options 2>&1`"
> +       rc=$?
> +
> +       if [ "$OVL_FSTYP" = "fuse.fuse-overlayfs" ]; then
> +               # Less verbosity to avoid output mismatch.
> +               echo "$output" | grep -v \
> +                       -e "^uid=" \
> +                       -e "^upperdir=" \
> +                       -e "^lowerdir=" \
> +                       -e "^workdir=" \
> +                       -e "^mountpoint="
> +       elif [ -n "$output" ]; then
> +               echo "$output"
> +       fi
> +
> +       return $rc

rc will always be 0 because it holds the return code of the assignment
expression 'output=...', not the return code of mount.

Does fuse mount verbose output go to stdout or to stderr?
I don't think we ever care about stdout of this mount command
on golden output - it is always assumed to be silent and
only a silent or noisy stderr is verified in golden output.
So if I am not mistaken and if fuse verbose output it to stdout,
then maybe would be enough to redirect stdout to /dev/null?

Thanks,
Amir.

Return-Path: <SRS0=3MWK=4C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7869BC47409
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BCCA2082F
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 22:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwhVy+1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBNWUr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 17:20:47 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34830 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbgBNWUq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Feb 2020 17:20:46 -0500
Received: by mail-il1-f193.google.com with SMTP id g12so9366645ild.2;
        Fri, 14 Feb 2020 14:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LvRcQYOHsaX/BEpyH5XMNZEwVcgL69BEbewjjoaQpa0=;
        b=iwhVy+1duZ8+1XtUzBwprI8OKMUGZFkJ3TYccKGuAdOJVyszvgWj2iph11npdabvq5
         EVp4h3eypRmHzbmzTfKqPjyWrHykuu245RZLmh/maKqHwCWyoOFTttvEZucgsUZv4cBj
         x5n0Jul7nI9ri/nzruxrqHIheDXioBKyWvmxkV3tbbTTUFZgv2E+JK+jIDwPiiCUIEXW
         Bq0a4F23SWR3q2E7AQFQmWaDOGFg9vP986eWHdBo2jeJCABk4+3Zit6jyasTvtK4glrJ
         mH3QjsvaTvRXpzGPdRrgujQkYNs8LvQf1w0N3Cuyl8JoDuQzi9oHdG3tGcQm9/iSw3FE
         OO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LvRcQYOHsaX/BEpyH5XMNZEwVcgL69BEbewjjoaQpa0=;
        b=P6s9LJF7S4IBsID/gKtUIrcl79L5FzFa7UK3SjuDHXGgGrSftr8naO0BXoVCnJQcuM
         ZwGfjKu4fBormOjmEvPtBA7e3nwhMDrS6rOTr+RzbA3KF5lJNX3cdIwolqllOaDegg4Y
         mGsLgXPcGSfPj6T3WlLaPZCPye0AwyCJS+lBEJXE8+mIVc+Nlc8xRTXhKnvBPc7MRfEM
         Av+Z5HphBiunXjmcZ74r1jskgLVaucXG5SWBHUINI8142z1yl4PERF6pESR27edeeZ5T
         5Hy7u0Xnpu0l+oNbJXOXk/R0BSfOGdU0dhMVcZSTmCgiVvq56zXQ6TsvT0cVDzoaRE94
         CnqQ==
X-Gm-Message-State: APjAAAWyVrkhZpizxKVjYA/rq/+re7GNt0yZFE8NHpZT0d/hdmKap1SZ
        6Q0Gq/8na1qIvka5WILWAFfsLTOGL0Vz36RX59o=
X-Google-Smtp-Source: APXvYqy/wuEH+2Bt+dbdcn1dygK0bG2eoPKjLFOrQnQq3wVGrbMhlo+plXWjLEjIeVgdVwetYwu9/bQEXiGXcc5QtDQ=
X-Received: by 2002:a92:5c8a:: with SMTP id d10mr5292516ilg.137.1581718845638;
 Fri, 14 Feb 2020 14:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20200214151848.8328-1-mfo@canonical.com> <20200214151848.8328-4-mfo@canonical.com>
In-Reply-To: <20200214151848.8328-4-mfo@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 15 Feb 2020 00:20:34 +0200
Message-ID: <CAOQ4uxgyh2-Msmhbj0zs7nQ-feJN=AGX6gcx48HBRjHrJHDGQQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] common/rc: introduce new helper function _fs_type_dev_dir()
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 14, 2020 at 5:18 PM Mauricio Faria de Oliveira
<mfo@canonical.com> wrote:
>
> In order to determine the fs type on fuse-overlayfs (coming)
> we need to search for the mount point/directory; the device
> is not enough. (details in the next patch.)
>
> Thus the _fs_type() function is insufficient to determine
> the filesystem type, as it only searches for mount device.
>
> So, introduce the _fs_type_dev_dir() function, which also
> searches for the mountpoint/dir in addition to the device.
>
> The fs type fix-up sed script goes into a common function.
>
> P.S.: there might be other sites that need similar changes,
> since the mount device is also checked elsewhere, but just
> with this bit tests can run, so it is good enough for now.)
>
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>

Looks ok.
You may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/rc | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index 1feae1a94f9e..5711eca2a1d2 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1262,6 +1262,19 @@ _used()
>      _df_device $1 | $AWK_PROG '{ sub("%", "") ; print $6 }'
>  }
>
> +# fix filesystem type up
> +#
> +_fix_fs_type()
> +{
> +    #
> +    # The Linux kernel shows NFSv4 filesystems in df output as
> +    # filesystem type nfs4, although we mounted it as nfs earlier.
> +    # Fix the filesystem type up here so that the callers don't
> +    # have to bother with this quirk.
> +    #
> +    sed -e 's/nfs4/nfs/' -e 's/fuse.glusterfs/glusterfs/'
> +}
> +
>  # return the FS type of a mounted device
>  #
>  _fs_type()
> @@ -1272,14 +1285,21 @@ _fs_type()
>         exit 1
>      fi
>
> -    #
> -    # The Linux kernel shows NFSv4 filesystems in df output as
> -    # filesystem type nfs4, although we mounted it as nfs earlier.
> -    # Fix the filesystem type up here so that the callers don't
> -    # have to bother with this quirk.
> -    #
> -    _df_device $1 | $AWK_PROG '{ print $2 }' | \
> -        sed -e 's/nfs4/nfs/' -e 's/fuse.glusterfs/glusterfs/'
> +    _df_device $1 | $AWK_PROG '{ print $2 }' | _fix_fs_type
> +}
> +
> +# return the FS type of a mounted device
> +# on a mount point directory (check both)
> +#
> +_fs_type_dev_dir()
> +{
> +    if [ $# -ne 2 ]
> +    then
> +       echo "Usage: _fs_type_dev_dir device directory" 1>&2
> +       exit 1
> +    fi
> +
> +    _df_dir $2 | $AWK_PROG -v what=$1 '($1==what) { print $2 }' | _fix_fs_type
>  }
>
>  # return the FS mount options of a mounted device
> --
> 2.20.1
>

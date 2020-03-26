Return-Path: <SRS0=Z+t6=5L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87174C43331
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Mar 2020 07:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54677206F8
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Mar 2020 07:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G/ogvrF3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCZHe1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 03:34:27 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:36581 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgCZHe0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Mar 2020 03:34:26 -0400
Received: by mail-io1-f54.google.com with SMTP id d15so5063041iog.3
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Mar 2020 00:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKARzHIzeq1ojj7/RLhMetgiOgc7j0tEz+brIkK9EUA=;
        b=G/ogvrF3yBgb9yB3MVbYSRIoMcwokYtmfe4Z8V51wZhS3n6mdfPhmMUs5u6st3/6A8
         K0AthMxxBPHAWxqs2/+VdK1ZXXZ8R6qYtx14rdX8u7f/uDXIm1Ks1axDIgZ0YnTR71Zm
         DkFeWh8awcyB19fadKTEWINoWiBK8C+GtzQq3LFhdupc8ywdcZ75dt3XzD9/5MEMuKgA
         XDcEO4vvo2vFMAR/KL6f+6Kl/fWAEwjit5LzIww0iYdVoSCSvi2u9F/iFpaOVZOPlwaP
         Vz415pvuDCJuZgdfxunGwRTn20FVb1kwDdg4mtz7r+rrOawppUGSfkPWW9jb+ps2M7gb
         SZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKARzHIzeq1ojj7/RLhMetgiOgc7j0tEz+brIkK9EUA=;
        b=R1u6oscTui6uVIK+qefbGUZf3glpRU5tEp5vDHuuQM3D/w+oRW3vyhoPnHqA6JO4Ea
         B5axPODRi3wnAqzOI88qI+VPv0k+7Y7V6cVuxX53PUWECUxTPUYQSSwM4L5sboqXRPWb
         Eqivsufq1jN7+mCU5X1A68plXw1xs7FGNQkb/6A/vTHnr7bTB8nuJWiEC/65rs/NDgQ2
         Inab32/q+6Xae7rIoj23hHhWzMlFm3uHm/3+HJ0Cov9hAggkchh5Q7Pen8bhkaZivnR4
         P8jOF7uayB40yzpFECk2NGeoZzaf2Eg6hfsvMGm9czjd1CvuLNAksWHXsLyPT8IOZJn1
         Mjnw==
X-Gm-Message-State: ANhLgQ2PWir7MVEEfTNmO+XwgW970Fjk6EL6zkwvKwmYBr8xxesp7+a1
        yUGvxBIosJXxy755TnRs2PG8ovqRK6utg8smAPO7cZwB
X-Google-Smtp-Source: ADFU+vtGmR3OY/ADXmIlnuFNJofQ8cc24fVAghOL2JknUytknj2qe0zwQ36PAbLVFtYC2hWmQ9LhsQztKovC7kgWrNM=
X-Received: by 2002:a02:4881:: with SMTP id p123mr6291169jaa.30.1585208064373;
 Thu, 26 Mar 2020 00:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net>
In-Reply-To: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 Mar 2020 09:34:13 +0200
Message-ID: <CAOQ4uxgAubW72xGej-Tg4juicRe3nY0gmH32p0Sf3OWV45fviA@mail.gmail.com>
Subject: Re: Inode limitation for overlayfs
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>,
        miklos <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Mar 26, 2020 at 7:45 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Hello,
>
> On container use case, in order to prevent inode exhaustion on host file system by particular containers,  we would like to add inode limitation for containers.
> However,  current solution for inode limitation is based on project quota in specific underlying filesystem so it will also count deleted files(char type files) in overlay's upper layer.
> Even worse, users may delete some lower layer files for getting more usable free inodes but the result will be opposite (consuming more inodes).
>
> It is somewhat different compare to disk size limitation for overlayfs, so I think maybe we can add a limit option just for new files in overlayfs. What do you think?

The questions are where do we store the accounting and how do we maintain them.
An answer to those questions could be - in the inode index:

Currently, with nfs_export=on, there is already an index dir containing:
- 1 hardlink per copied up non-dir inode
- 1 directory per copied-up directory
- 1 whiteout per whiteout in upperdir (not an hardlink)

We can also make this behavior independent of nfs_export feature.
In the past, I proposed the option index=all for this behavior.

On mount, in ovl_indexdir_cleanup(), the index entries for file/dir/whiteout
can be counted and then maintained on index add/remove.

Now if you combine that with project quotas on upper/work dir, you get:
<Total upper/work inodes> = <pure upper inodes> + <non-dir index count> +
                                           2*<dir index count> +
2*<whiteout index count>

Assuming that you know the total from project quotas and the index counts
from overlayfs, you can calculate total pure upper.

Now you *can* implement upper inodes quota within overlayfs, but you
can also do that without changing overlayfs at all assuming you can
allow some slack in quota enforcement -
periodically scan the index dir and adjust project quota limits.

Note that if inodes are really expensive on your system, index_all
wastes 1 inode per whiteout + 1 inode per copied up dir, but those
counts should be pretty small compared to number of pure upper inodes
and copied up files.

Thanks,
Amir.

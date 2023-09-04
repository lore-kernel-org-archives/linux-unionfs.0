Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E544BC71153
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 13:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjIDNop (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjIDNop (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 09:44:45 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662D5198C
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 06:44:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-99c1c66876aso211809666b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 06:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1693835045; x=1694439845; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BbHp3voh2vEjn3V4fhI8IaOGVK30Ny7z7fcKcq/RFa4=;
        b=n0oilBBrgr162XHYBuH7O/78fKzMKK3fU0yu8L/BjI7FImwBLkUCk7oSdqgWwTASt4
         vo2fwywJNuCCDmLOWIX1VRAWnMKmXrIxGZFH35vZiJRkd1cHK1gzcrYsZElzDUPKEDTN
         Z0zoSs7Qj37mGlSHaeDDID5zkmcs7EWEd41qw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693835045; x=1694439845;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BbHp3voh2vEjn3V4fhI8IaOGVK30Ny7z7fcKcq/RFa4=;
        b=hg0+4LJdXRQp6ojKj+Y9+ApIW9CtJK6HFzv/eE89bUOh8ALE4PA7v6l3zjN/fi9gE6
         zAojEGb3I+vCC7EXT00yue1lOxE4Odcf42z8zzdZb86dk/Pmb/GhlDfG9fv8oBLlqijW
         UCeeR9qyLnxVHjQ56ZV3skC/0C61WmgJOskjhGRvJVZhZHSfFWPCTRtmVjY41aLfdx5J
         KIrNFsPXhUYpEz2OjsVuVDe9OlmxLXw2WGpo437fcdKSnXwPWyoZcjCZgHeOY8ZNxKKT
         LxPPxYvRPoYjW3KzxdTtvq80ZkX5Xyqe/Ej/MgadnCKBcwoxNvSDD1Z4hDN7BbE+9Jv9
         tHlw==
X-Gm-Message-State: AOJu0Yx59v2ESFQZFyAJJY5ANfATLO2/kth6QgIIc6GfM6JICsBqsNgX
        ajfRAXG7iqARDPdRHXUmArD+k4lSJBLte4uVvcOFrg==
X-Google-Smtp-Source: AGHT+IGfnRnGUANPfjAiyhB5CbpM5+xRiouh5bK+VXsKDhna7f97BOBacxyuB02S5z51uquG5pAZ3a4wDpIBS/MhKh4=
X-Received: by 2002:a17:907:b0c:b0:9a1:d7cd:6028 with SMTP id
 h12-20020a1709070b0c00b009a1d7cd6028mr6859724ejl.56.1693835045071; Mon, 04
 Sep 2023 06:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230904132441.2680355-1-amir73il@gmail.com>
In-Reply-To: <20230904132441.2680355-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 4 Sep 2023 15:43:53 +0200
Message-ID: <CAJfpegtNgHnacX4CaPU8cyZcK=WPWHF_yK6CcGH1MFNYpT3UqQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix failed copyup of fileattr on a symlink
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 4 Sept 2023 at 15:24, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Some local filesystems support setting persistent fileattr flags
> (e.g. FS_NOATIME_FL) on directories and regular files via ioctl.
> Some of those persistent fileattr flags are reflected to vfs as
> in-memory inode flags (e.g. S_NOATIME).
>
> Overlayfs uses the in-memory inode flags (e.g. S_NOATIME) on a lower file
> as an indication that a the lower file may have persistent inode fileattr
> flags (e.g. FS_NOATIME_FL) that need to be copied to upper file.
>
> However, in some cases, the S_NOATIME in-memory flag could be a false
> indication for persistent FS_NOATIME_FL fileattr. For example, with NFS
> and FUSE lower fs, as was the case in the two bug reports, the S_NOATIME
> flag is set unconditionally for all inodes.
>
> Users cannot set persistent fileattr flags on symlinks and special files,
> but in some local fs, such as ext4/btrfs/tmpfs, the FS_NOATIME_FL fileattr
> flag are inheritted to symlinks and special files from parent directory.
>
> In both cases described above, when lower symlink has the S_NOATIME flag,
> overlayfs will try to copy the symlink's fileattrs and fail with error
> ENOXIO, because it could not open the symlink for the ioctl security hook.
>
> To solve this failure, do not attempt to copyup fileattrs for anything
> other than directories and regular files.
>
> Reported-by: Ruiwen Zhao <ruiwen@google.com>
> Link: https://lore.kernel.org/r/CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com/
> Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> Cc: <stable@vger.kernel.org> # v5.15
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Hi Miklos,
>
> Do you agree with this solution?

It's good enough.   Linux might add API's in the future that allow
querying and setting fileattr on symlinks, but we can deal with that
later.

Thanks,
Miklos

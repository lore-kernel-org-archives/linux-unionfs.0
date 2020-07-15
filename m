Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D977CC433E1
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 19:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FAB20657
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 19:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="RNlnXXbd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGOTkX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 15:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOTkW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 15:40:22 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F600C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 12:40:22 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so3404488ejb.11
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 12:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GX+yXZwsK5tEUbqkgmKrqDk62Ki+06Tuhxl0CkNwkVg=;
        b=RNlnXXbdXSsoJhUjUn5D2WA0alj39VJcflVphdGKY1p21/0CUQrl21pdOPrtGL4ty9
         tKYUT7tqGYLdJw154B0/F+IdA/6YnPQzlx0VLLc8+5QAAnZznhxYo/f/KOsGrhCaKQQY
         bkLy7PUutmvMCHCxDHz+kjOs62i4YDFBLW8OQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GX+yXZwsK5tEUbqkgmKrqDk62Ki+06Tuhxl0CkNwkVg=;
        b=VBZ+jR5+Sei0UMCNWZa4VaEBjqZ29w7X7L2IL6MobVYy5J+qWEC4H0reWaOUUUYa55
         S4x0eipXjOy1k4RuFArDHO/wM+FFCeNJDI4uH/lcSTroNlVVuA+QLMPSTm7TPBYLRLqn
         AssHEjZ86fR/HYcjTkbU1zlDRiqfBcbx7xJNhSvXeKt1mYjqfDR9UgKSGgrInNjq8WOM
         WYLw7KzdLW79J34otPuZbEdykwPyfxdeHh8xP2EjnD58m2TM1r+71YqGwa7NQVlVL0a0
         YqIGbi0ViCchWFey74f0/yH9wN5TgKkpFG8cl5QMSvjswWLbi3WQncO1jQARXAIj7YZy
         bzSQ==
X-Gm-Message-State: AOAM530UN56D/U4YZdEBX9wk3D3LLLOgbLeRVHg9JDpY1qDx8ruD384v
        EMoQQPYX5DfMQ8cYZ8TazqgTzO+Apk5vL3C+0b5dY9xqjII=
X-Google-Smtp-Source: ABdhPJxA955Lgjhg2MohlnlNuJUdTdFUuYBptu5xMRwTau34YKZpYgRH/kRKruLP8NAYeBkatfKN4yas/y80eBGY9GY=
X-Received: by 2002:a17:906:1c05:: with SMTP id k5mr517669ejg.320.1594842020993;
 Wed, 15 Jul 2020 12:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200617065711.3784-1-amir73il@gmail.com>
In-Reply-To: <20200617065711.3784-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 21:40:09 +0200
Message-ID: <CAJfpegu3AyjLby6a+WAm7M8_FrdOjE=0dKMhLdbDApn5gkvgGA@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax WARN_ON() when decoding lower directory file handle
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 17, 2020 at 8:57 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Decoding a lower directory file handle to overlay path with cold
> inode/dentry cache may go as follows:
>
> 1. Decode real lower file handle to lower dir path
> 2. Check if lower dir is indexed (was copied up)
> 3. If indexed, get the upper dir path from index
> 4. Lookup upper dir path in overlay
> 5. If overlay path found, verify that overlay lower is the lower dir
>    from step 1
>
> On failure to verify step 5 above, user will get an ESTALE error and
> a WARN_ON will be printed.
>
> A mismatch in step 5 could be a result of lower directory that was renamed
> while overlay was offline, after that lower directory has been copied
> up and indexed.
>
> This is a scripted reproducer based on xfstest overlay/052:
>
>   # Create lower subdir
>   create_dirs
>   create_test_files $lower/lowertestdir/subdir
>   mount_dirs
>   # Copy up lower dir and encode lower subdir file handle
>   touch $SCRATCH_MNT/lowertestdir
>   test_file_handles $SCRATCH_MNT/lowertestdir/subdir -p -o $tmp.fhandle
>   # Rename lower dir offline
>   unmount_dirs
>   mv $lower/lowertestdir $lower/lowertestdir.new/
>   mount_dirs
>   # Attempt to decode lower subdir file handle
>   test_file_handles $SCRATCH_MNT -p -i $tmp.fhandle
>
> Since this WARN_ON() can be triggered by user we need to relax it.
>
> Fixes: 4b91c30a5a19 ("ovl: lookup connected ancestor of dir in inode...")
> Cc: <stable@vger.kernel.org> # v4.16+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Applied, thanks.

Miklos

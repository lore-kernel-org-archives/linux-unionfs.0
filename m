Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366A7C64EC4
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Mar 2023 15:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjCIPDZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 10:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjCIPDG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Mar 2023 10:03:06 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F42AF0C65
        for <linux-unionfs@vger.kernel.org>; Thu,  9 Mar 2023 06:59:40 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id da10so8190578edb.3
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Mar 2023 06:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1678373979;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+VSDa7dBH/bVf4+A7dL/Xx6tG+g312K6/L+r45ZA+CU=;
        b=De0gNLn6ZBXhJR3GiPLzdHVtUHk9b0I+eQyNxZGTw8O0e8giDVjxj1uqT0EfDgqJIG
         48/LmTbYk1rbeobIw+Bkvgp1z5/QMmUcoa55yGfMpZAdIJ9ECQDcNjRJHy0Etaz9qTbV
         n4nWOz+0tWPMXB5F7AdPyXHI2n/71TPUZnQN4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373979;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VSDa7dBH/bVf4+A7dL/Xx6tG+g312K6/L+r45ZA+CU=;
        b=ED2HsggrgqfBeCMS3MCrhnWW86CnuTeJSOHpWvNMmGC/UzVEdZaDiLeI9av7oer1rx
         o98bVbdIAkzooaQQR3IZbFw51KAmuTNik4x31iGMi2uFRiwI3uzXvPC6KX1t/atStNWC
         HJ5hQQdwooJ4cGL6+BiKtt7/NFsxhElUVjXuXiJWrLocqX8X7jxC/yIMd6GtMsEnMv12
         i8SavjbZA+SGSSh75XEBPNgAsagkRLVzOGvL6X98Xz6GpsL6YbTKoz/E3OByxjRN8Iaw
         +fjvAciZAx5bVg9gIf1DWwSejMACQMbWuqwxDsNMMl6puXv8nl0x9WXtH1XCC0I9zjco
         2pPw==
X-Gm-Message-State: AO0yUKUf+TjW5SAdWeyelcOYKgO7vTKTvuhje0UBQWc1EkDSbmARTPjq
        YefZCmWhWQMo7aIEwsKaKIRMAjjUjyxDMnNwi4ueSg==
X-Google-Smtp-Source: AK7set+19crCv3xn8eV6LTvRSmhextzlOUuWjoia6pFldjZHmUNJ1nqnArcoZB1onZ3MrlNAowxHKoc6ietIxmjkjrU=
X-Received: by 2002:a50:8e5d:0:b0:4c8:1fda:52fd with SMTP id
 29-20020a508e5d000000b004c81fda52fdmr12485472edx.8.1678373979006; Thu, 09 Mar
 2023 06:59:39 -0800 (PST)
MIME-Version: 1.0
References: <CAL7ro1GQcs28kT+_2M5JQZoUN6KHYmA85ouiwjj6JU+1=C-q4g@mail.gmail.com>
In-Reply-To: <CAL7ro1GQcs28kT+_2M5JQZoUN6KHYmA85ouiwjj6JU+1=C-q4g@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 9 Mar 2023 15:59:28 +0100
Message-ID: <CAJfpeguTqXKuBcR3ZBbpWTPTbhnLja0QkBz3ASa4mgaw+A4-rQ@mail.gmail.com>
Subject: Re: WIP: verity support for overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 8 Mar 2023 at 16:29, Alexander Larsson <alexl@redhat.com> wrote:
>
> As was recently discussed in the various threads about composefs we
> want the ability to specify a fs-verity digest for metacopy files,
> such that the lower file used for the data is guaranteed to have the
> specified digest.
>
> I wrote an initial version of this here:
>
>   https://github.com/alexlarsson/linux/tree/overlay-verity
>
> I would like some feedback on this approach. Does it make sense?
>
> For context, here is the main commit text:
>
> This adds support for a new overlay xattr "overlay.verity", which
> contains a fs-verity digest. This is used for metacopy files, and
> whenever the lowerdata file is accessed overlayfs can verify that
> the data file fs-verity digest matches the expected one.
>
> By default this is ignored, but if the mount option "verity_policy" is
> set to "validate" or "require", then all accesses validate any
> specified digest. If you use "require" it additionally fails to access
> metacopy file if the verity xattr is missing.
>
> The digest is validated during ovl_open() as well as when the lower file
> is copied up. Additionally the overlay.verity xattr is copied to the
> upper file during a metacopy operation, in order to later do the validation
> of the digest when the copy-up happens.

Hmm, so what exactly happens if the file is copied up and then
modified?  The verification will fail, no?

Thanks,
Miklos

Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8E7C433DB
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 028F7652AE
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhCHRmQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCHRmF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Mar 2021 12:42:05 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422BAC06174A
        for <linux-unionfs@vger.kernel.org>; Mon,  8 Mar 2021 09:42:05 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id 81so10807074iou.11
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Mar 2021 09:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AGghRo0I3poOSZc5o0XHFleRsiWxTyZDigIpup3Gwes=;
        b=NezzKMB2Qc6eEAMykWT/udXh8dhvAPfv3V2h7m01ZPa9H1S+fKxHKeTvVa9AY8tjs3
         736TKIOd7A1ca9jBgt22w5TKVDEge/8CjBjFyKctx1EO2wmmU4d/JGcrU1YWP8aMGy7J
         4XukG8ztxdPljbTX5GsqfRjV8cCO9VcVSGF8XEYDqoB4KO6VWbPHjHd+vmq+ik/PDjiv
         32Zks88sklXiUXQIpzEj2Lp3McgTSkyI+F5/z6+r8owOAWbHAeRzB+NyEYCd0/x6QZgn
         HdYtjLpGhrO7Db7Q1RMAykh5U2suxC9ED6TbbH31jN5QDJgsQ5rER81SDgLO9U1VTkJR
         +hEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AGghRo0I3poOSZc5o0XHFleRsiWxTyZDigIpup3Gwes=;
        b=quLF1y83vvynfYNBohwre8KOycH5jYo0p6vJqv5DKM7uFqiA+PFv8zhADDND+SACb4
         Ut3B5xqPJUl9Fv5LdZatImVEWJDqLnAGwCc7VNt6yPp+1VFLWXjsIofE06p24+0fWz9M
         ISlzcduEv3Bkw2VrMgOd5/G4RwSvcvpB0jgNn4mpJ1qFzwj+VGyv/CB1hZJCF72Un9Nh
         wpzRqEMha68e8SyDLG7TR/cdGWwQkE6ohw4RambP/IIH4Hv6qWs/z+o0N6EoqmiA/xNq
         F18D3+hzSo8Q7Ml6nPkpFNbVmjl4FLKbhVvQL0P2er5p6D+2yxreDidBupoqaT/atmDH
         V2MA==
X-Gm-Message-State: AOAM5300IDDKAT6+DQfAgaE2OqZkrapYqJRpnJIkLwRzOc7Ld3DrRqIY
        r1U7N/TVJJUbQiLAYy1c8d7xYWa+otILIodwuqlCC7wuIpA=
X-Google-Smtp-Source: ABdhPJzDNe/xOT/9nNhQb7HPvxl5XY0nOk7La9cfN+SBNaJJ9mxrb3+C+ZU++xKnH56zreEGOSSMyqp5o4fJipCQN0U=
X-Received: by 2002:a02:74a:: with SMTP id f71mr24030587jaf.30.1615225324653;
 Mon, 08 Mar 2021 09:42:04 -0800 (PST)
MIME-Version: 1.0
References: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
 <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
In-Reply-To: <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 8 Mar 2021 19:41:53 +0200
Message-ID: <CAOQ4uxhGSbEPPwZswXHq+k1YF=+ntDfukxnfGsJ3+RaGjgNDnQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: add xino to "changes to underlying fs" docs
To:     Kevin Locke <kevin@kevinlocke.name>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 8, 2021 at 5:23 PM Kevin Locke <kevin@kevinlocke.name> wrote:
>
> Add "xino" to the list of features which cause undefined behavior for
> offline changes to the lower tree in the "Changes to underlying
> filesystems" section of the documentation to make users aware of
> potential issues if the lower tree is modified and xino was enabled.
>
> This omission was noticed by Amir Goldstein, who mentioned that xino is
> one of the "forbidden" features for making offline changes to the lower
> tree and that it wasn't currently documented.
>

Hi Kevin,

Thanks for following up on this.
I see my original comment did not make it to the list, because the message
was formatted incorrectly.

My full comment was:

"...
My feeling is that we need to adjust the fix and not treat the case
of xino=auto as "user opted-in for xino" thus disabling origin inode
decode for lower without uuid.

Also the documentation does not mention the xino feature as one
of the "forbidden" features for this use case.
..."

So your Documentation fix may represent the current code, but
I think we should fix the code instead.

When looking again, I actually don't see a reason to include "xino"
in this check at all (not xino=on nor xino=auto):

 if (!ofs->config.index && !ofs->config.metacopy && !ofs->config.xino &&
     uuid_is_null(uuid))
         return false;

The reason that "index" and "metacopy" are in this check is because
they *need* to follow the lower inode of a non-dir upper in order to
operate correctly. The same is not true for "xino".

Moreover, "xino" will happily be enabled also when lower fs does not
support file handles at all. It will operate sub-optimally, but it will live up
to the promise to provide a unified inode namespace and uniform st_dev.


> Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
> ---
>  Documentation/filesystems/overlayfs.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 78240e29b0bb..52d47bed9ef8 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -476,9 +476,9 @@ a crash or deadlock.
>
>  Offline changes, when the overlay is not mounted, are allowed to the
>  upper tree.  Offline changes to the lower tree are only allowed if the
> -"metadata only copy up", "inode index", and "redirect_dir" features
> -have not been used.  If the lower tree is modified and any of these
> -features has been used, the behavior of the overlay is undefined,
> +"metadata only copy up", "inode index", "redirect_dir", and "xino"
> +features have not been used.  If the lower tree is modified and any of
> +these features has been used, the behavior of the overlay is undefined,
>  though it will not result in a crash or deadlock.

Note that "redirect_dir" is not one of the "forbidden" features.

Thanks,
Amir.

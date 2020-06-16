Return-Path: <SRS0=94B3=75=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DABC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 Jun 2020 05:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C016206DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 Jun 2020 05:33:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fs2M6Uw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgFPFdc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 01:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgFPFdc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Jun 2020 01:33:32 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4345C05BD43;
        Mon, 15 Jun 2020 22:33:30 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c8so20606835iob.6;
        Mon, 15 Jun 2020 22:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4uyF2RUlCdnSFAJV5Wl+CY7z+DUfiYVF1gsd7+1UiO4=;
        b=Fs2M6Uw++nsDIdE2QfmT2+C0f1+qYIbdQPfQVLFgDkL4D8RKffO6NgSqDOiRmhPHil
         iAnNWSMnUq570NcahXtPJm6OzvwxnDWCZCVpWNVPBF9HDG8bRWR2cEli9u7D/XH3HhuQ
         HK3EhBXsZ0+sXATLDJGfYyjYg1vkikocPkii7fK0XrLf4veZWkpSd37vttip5ciiE8zH
         ahvbcjsyxhYjt7lW4Zvq8TaMrXsmmlkfbyWSiJPmzjIGVlL28FdO9R7gzT9w7AbgGPPJ
         DQiat/cZ0nL1OrCHEHGu7h9kkixATijCw+KjwAgbgN9x1e50735+2cyHM7CG4alen1Hy
         V8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4uyF2RUlCdnSFAJV5Wl+CY7z+DUfiYVF1gsd7+1UiO4=;
        b=S8ArDTnQdxSGKf3a5p18x5/WLGyq/iDCybXMz4coUDwmpBotIoP0vy1ApX4BPyUzfA
         xMsZ0kWZzDKEbwfqQgvzi7ckQFjayhCPdCKbBgntbAzbFZ4OceNRpa0lUcogU4tD33pL
         oxMkw8T1mgfFmglGrCHxpZfwiZjwlAd8WzJkuZV1QHNMNjQzqn2jnEEpB/Low2RQPeqV
         UfccPXBsEF+wqxbAiZUXkNPCuSDSov6jps579cmBMHrXNlf2uETOFvctCv4dPhQUHivY
         HPupcIlDSj5eS51OZw95bi+AmUX8Rpc/DFZJvoT6MT/d4B//Pc7QdhX2LwD6TIoY6PEl
         pmsQ==
X-Gm-Message-State: AOAM5314itOGeGFFGe1A7N26UrQsgo5T24kBdqKN10GQxzcbYW0ocMep
        xfzWJjphuEJYR+eWSKF77w/rmgvoy9LBMIvNHQo=
X-Google-Smtp-Source: ABdhPJzRhSJT0QnUjkt0p2Em7jYJ/L1KbaLRIUHcgXlgg+3uk2KU8xhyUihET6hqlOHYFEkNL6RlYPA8BsUiZJa32Lk=
X-Received: by 2002:a05:6602:2e87:: with SMTP id m7mr985555iow.203.1592285610189;
 Mon, 15 Jun 2020 22:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200615155645.32939-1-her0gyugyu@gmail.com> <20200616044647.19071-1-her0gyugyu@gmail.com>
In-Reply-To: <20200616044647.19071-1-her0gyugyu@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 16 Jun 2020 08:33:18 +0300
Message-ID: <CAOQ4uxhS_3Xmf0xpo-6BmxFjSFfJZAmJVpHeZFjrPA+8R4e0gg@mail.gmail.com>
Subject: Re: [PATCH] ovl: inode reference leak in ovl_is_inuse true case.
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi youngjun!

Thank you for your patch.
You asked for guidance about posting patch revisions so let me repeat
my comment in a more clear way (see below).


On Tue, Jun 16, 2020 at 7:46 AM youngjun <her0gyugyu@gmail.com> wrote:
>

When posting a revision of a patch already posted, the practice
is to use the subject prefix [PATCH v2].
This will be auto generated for you with -v option for git format-patch.

Also, it is not valuable to CC LKML on patches with such a narrow
scope. The only relevant CC for this patch is the overlayfs list,
overlayfs maintainer and developers that reviewed v1 (me in that case).

> When "ovl_is_inuse" true case, trap inode reference not put.
> plus adding the comment explaining sequence of
> ovl_is_inuse after ovl_setup_trap.
>

Please add these lines to the bottom of commit message:
(They help the stable tree maintainers know that patch
 should be picked up and to which stable tree)

Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers..")
Cc: <stable@vger.kernel.org> # v4.19+
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>
> ---
>  fs/overlayfs/super.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..0396793dadb8 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1029,6 +1029,12 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
>         NULL
>  };
>
> +/*
> + * Check if lower root conflicts with this overlay layers before checking
> + * if it is in-use as upperdir/workdir of "another" mount, because we do
> + * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
> + * in-use by our upperdir/workdir.
> + */

Sorry for not being clear about this comment.
I meant it should come before the call to ovl_setup_trap() in
ovl_get_layers(). It is not true in general that we always call ovl_setup_trap()
before ovl_is_inuse(). It is only true and relevant for checking lower layers.

If anything I wrote is not clear, do not hesitate to ask for more clarification.

Thanks,
Amir.

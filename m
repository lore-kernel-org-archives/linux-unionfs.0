Return-Path: <SRS0=mld1=7M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDF1C433E0
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 10:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95EF520842
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 10:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewV+V3qS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgE3Khu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 30 May 2020 06:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3Kht (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 May 2020 06:37:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51401C03E969
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 03:37:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c8so2032707iob.6
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 03:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FY+5CqibrIfANGAtXP6xlwb6R5EGunBNtN9bEXg8q6g=;
        b=ewV+V3qSwgE0cl/ig7xSviAevBcIqdozqO8IfOWT9Vgn8OjIpESSrlvRlfwsdqPUad
         EEzFcq1tKNAnuJCH/IahLjS2Y9G6vEBpQaVIe/4TsMpul9gRvPdj9ywz5dLlAfBIptCM
         oVf6f/FCntJjFPHzaaLC3a4d2EkBcWbHd3nYCW9QikISVT2nRXK21L6+wIz4AT/vDjLB
         aJTESYWsGeEDkO/oJV6J33mNb3hNFShd0Z6AeMBZ3Vsuk0ScU/sau3rX2RkuAkQ9msGe
         wd2IG/gHWFNuBGLKDWDjZCWCpjN/QvSz3rIJB2VKz2goS8jIahfw1a7IyAn1Jp0VuU0K
         W7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FY+5CqibrIfANGAtXP6xlwb6R5EGunBNtN9bEXg8q6g=;
        b=VuX2TRp1vIPBbcY8XcL/qr2JEcE/eiPywkNtF3i7glcWaUw9l5Da5hqSxwYy43Um3T
         vvsRUi7dTmOIjVz6Aw8iRbAJZfI99gl3Ve3tseqHQURFO00c/gRhlW4jxm8B/PcybrpU
         cP5Rd6nwxLXSbNtd5ZozN++RZoTgF8wH5KQiTR/PwQWHvU/DfMZkwpHUxcmScPqb+tsh
         9urgGRIkxof79kj13uuNjGIO5V5tytWOQJBGD01TLCjcM98Ibl+C5b3rqVRYqkXub3cb
         uUivIKrx3xdyDm7JZ1zOcaYwqVVGmKTsfB0BjFNRi4yTJTvG+eDNSSjegpO9IZTdt+ne
         NmcQ==
X-Gm-Message-State: AOAM533790r8X0jqY3M45IpE+d3Jbgl+7tQwXACKt3IpL8Ok1nBRym6p
        UG62ZOF2tno+jjAz1tEZRABO2cGY8BxXX8WX7sfMJeYX
X-Google-Smtp-Source: ABdhPJz/hqD6ng3MLQ8+PQLFrUVO775cvZBsgNDr0XDwAaB/dmA3WfeVAT+o48Hg7S/GK3zBHGBUavQTCBrNrp/Sx0Y=
X-Received: by 2002:a02:270d:: with SMTP id g13mr5954173jaa.93.1590835068584;
 Sat, 30 May 2020 03:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200529212952.214175-1-vgoyal@redhat.com> <20200529212952.214175-2-vgoyal@redhat.com>
In-Reply-To: <20200529212952.214175-2-vgoyal@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 30 May 2020 13:37:37 +0300
Message-ID: <CAOQ4uxj=MoKfo32tz8zmxf13gheDt+y1DZ3-oznY9YX=DhWiFg@mail.gmail.com>
Subject: Re: [PATCH 1/3] overlayfs: Simplify setting of origin for index lookup
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 30, 2020 at 12:30 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> overlayfs can keep index of copied up files and directories and it
> seems to serve two primary puroposes. For regular files, it avoids
> breaking lower hardlinks over copy up. For directories it seems to
> be used for various error checks.
>
> During ovl_lookup(), we lookup for index using lower dentry in many
> a cases. That lower dentry is called "origin" and following is a summary
> of current logic.
>
> If there is no upperdentry, always lookup for index using lower dentry.
> For regular files it helps avoiding breaking hard links over copyup
> and for directories it seems to be just error checks.
>
> If there is an upperdentry, then there are 3 possible cases.
>
> - For directories, lower dentry is found using two ways. One is regular
>   path based lookup in lower layers and second is using ORIGIN xattr
>   on upper dentry. First verify that path based lookup lower dentry
>   matches the one pointed by upper ORIGIN xattr. If yes, use this
>   verified origin for index lookup.
>
> - For regular files (non-metacopy), there is no path based lookup in
>   lower layers as lookup stops once we find upper dentry. So there
>   is no origin verification. If there is ORIGIN xattr present on upper,
>   use that to lookup index otherwise don't.
>
> - For regular metacopy files, again lower dentry is found using
>   path based lookup as well as ORIGIN xattr on upper. Path based lookup
>   is continued in this case to find lower data dentry for metacopy
>   upper. So like directories we only use verified origin. If ORIGIN
>   xattr is not present (Either because lower did not support file
>   handles or because this is hardlink copied up with index=off), then
>   don't use path lookup based lower dentry as origin. This is same
>   as regular non-metacopy file case.
>

Very good summary.
You may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

But see one improvement below.
Also, please make sure to run unionmount setups:

./run --ov=10 --verify
./run --ov=10 --meta --verify

--verify will enable index and check st_dev;st_ino are not broken
on copy up. --ov=10 will cause lower hardlink copy up, because
after hardlink is creates by some test, upper is rotated to mid layer
and next modifying operation will trigger the hardlink copy up.

> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 0db23baf98e7..5d80d8cc0063 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1005,25 +1005,30 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 }
>                 stack = origin_path;
>                 ctr = 1;
> +               origin = origin_path->dentry;
>                 origin_path = NULL;
>         }
>
[...]
> -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> +       if (!origin && ctr && !upperdentry)
>                 origin = stack[0].dentry;
>

No need to understand the long story to verify this change is correct.
This is true simply because the conditions to set stack = origin_path are:

       if (!metacopy && !d.is_dir && upperdentry && !ctr && origin_path)

And after getting there and setting ctr = 1, the complex conditions to
setting origin are met for certain:

        if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))

Therefore, it is logically equivalent (and makes much more sense)
to assign origin near stack = origin_path.

Further, thanks to Vivek's explanation, it is now clear to me that after
setting origin above, all that is left to do here is:

         /* Always lookup index of non-upper */
        if (!upperdentry)
                origin = stack[0].dentry;

All the upperdentry cases described in the commit message have already
been dealt with by the time we get here.

Thanks,
Amir.

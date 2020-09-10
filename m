Return-Path: <SRS0=dgBR=CT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8CBC433E2
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Sep 2020 14:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB3620BED
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Sep 2020 14:11:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BOLC6ok+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbgIJOKy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731057AbgIJOJr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Sep 2020 10:09:47 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC93C06179E;
        Thu, 10 Sep 2020 07:00:03 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b17so5755782ilh.4;
        Thu, 10 Sep 2020 07:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lvPkRRhrBGbOAlVQcxU7oQ3T9OZp7RX6WB3tEAcEMIM=;
        b=BOLC6ok+FtrWxvDoFQHvg1oXi/Li71f3ZP9QY39h/3aOjLanIvFM9Nt8+imGdoHPAQ
         Ax2UZCIlWvuqE4lz7pZkGbT4vG4/bgCZ83WGRB77i2+UFRtM+X05Baa5pP0TW+boNel8
         ZKnfC7rplPWkLfSg8eFACDLqLLX/blObYEZQlPYK5KrDtWiNby7orVH9TLaOUHd8VhB2
         JncmogazqXpFrYdZcX6hRWsj56fwhaRavrAy7Q8qFbCCtZ81/RjF7ngxO8UWLLDz2XAX
         H3lzG9bd1DDYutcuY/DmNQsaP2qZ0HIcSIg8L5pE69ok0w1Ua8kPu4/lhsOt1usR1tVs
         Dpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvPkRRhrBGbOAlVQcxU7oQ3T9OZp7RX6WB3tEAcEMIM=;
        b=offtcsy5x6CGEiacHJgK8tjKCOzmmkU+2d4/FShxrJiiopjoYUntRNK86F+gpOXSjn
         zWxoUg03pttqIaherjkVAge6ZkbZtbiRjIGAsSEmdoKuuB+234Q+p1FuCbt7QhM5sDpX
         m1VDzosM7M4IOcUNCviJqXHjAIFogDd73LwsKQTeP63ZeK2V4YIJL4do1EQPfuT8KWrR
         sbVlB7m4gWPAIzq4+tnwdSpLhUVutNsbzozmDWXsUxNitQ+AP03tsQWioxDUxUaQHxKO
         kQoAEBV7t+C0OY5rBQ/v+Z2YBS/zbYNaJsRHqMS+EXKHRG365drG9Cn3lQLB5MlyockB
         CbqA==
X-Gm-Message-State: AOAM532ncgyd9Zr54bW0+xEKeZSrq7epLHrKVaiaw1cD4xiPYO/x1VsV
        oYMAPG6u6qgEg+z1NdR2ZiuJQvrRbXQJGM8gpbg=
X-Google-Smtp-Source: ABdhPJz7yCF3IRdTtj8SfS9zPkBKUsxpLDdYgI9tnCpdTmGaG2UcbqmPuZSeBl2BBLPJ/SYwLWuV8StOqK8vHb3oAF4=
X-Received: by 2002:a05:6e02:1141:: with SMTP id o1mr7798003ill.275.1599746401618;
 Thu, 10 Sep 2020 07:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200910055110.3lumztku3ld4vf2j@xzhoux.usersys.redhat.com>
In-Reply-To: <20200910055110.3lumztku3ld4vf2j@xzhoux.usersys.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 10 Sep 2020 16:59:50 +0300
Message-ID: <CAOQ4uxh+ppPMOSeAZU3sdwxwb_ixMHEpHLF9ZO_MTiedNJRgsw@mail.gmail.com>
Subject: Re: [PATCH] overlay/073: test with nfs_export being off
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 10, 2020 at 8:51 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> When nfs_export is enabled, the link count of upper dir
> objects are more then the expected number in this testcase.
> Because extra index entries are linked to upper inodes.
>
>  QA output created by 073
> +Expected link count is 12 but real count is 23, file name is dir
> +Expected link count is 12 but real count is 23, file name is 1
> ...
> +Expected link count is 12 but real count is 23, file name is 10
>  Silence is golden
>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
> Hi folks,
>
> Please help review that with nfs_export enabled, this is expected.
> I think so but I'm not 100% sure about it. Maybe it's a bug in
> the kernel.
>

Indeed this is expected.
With nfs_export, for every unlinked lower file/dir there is a whiteout
"tombstone" in the index directory, whose name is the file handle
of the unlinked inode.

So this test creates extra 11 tombstones with nfs_export enabled.

> Thanks.
>
>  tests/overlay/073 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/overlay/073 b/tests/overlay/073
> index 37860c92..b78551eb 100755
> --- a/tests/overlay/073
> +++ b/tests/overlay/073
> @@ -99,7 +99,7 @@ run_test_case()
>  {
>         _scratch_mkfs
>         make_lower_files ${1}
> -       _scratch_mount -o "index=on"
> +       _scratch_mount -o "index=on,nfs_export=off"

So the fix looks fine, but let's document why nfs_export=off is needed.

Thanks,
Amir.

Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11FFC433FE
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 May 2022 05:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiE3Fyj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 May 2022 01:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiE3Fyh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 May 2022 01:54:37 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE163C4A7;
        Sun, 29 May 2022 22:54:36 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id i19so3740066qvu.13;
        Sun, 29 May 2022 22:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XoeP0MWsqlS9SBCtVy8FEzgcM0IN2SJZSy5ovcsWriE=;
        b=QJc48QS93YYkuZBJGT4NiXkpO5O3FlqdCnu/dVSwB1E1+3Vzchu5Ch150Dc8H6tmgp
         j0ehhDobpB5NEPiMk5IWgCANLDXBnoiz3fISrbtKpvzjEHFiJ1x8lqXUU5ZTCl1JG5kN
         mwJxeSdY/NRF9v+KT1tiBSwHdTEEQXT1MKQAiSdpr6gElUuGcjXg68/2BJVQyREmgEvX
         CKh1cTif6kwoSS+a+r0jxpwyKD9n8Ix8Qko072KTe9HX+EX4wlHnrHU/TbMVGF1jnae1
         9llzPgpz7mh6hPhva3w4x9ZfBlOZx46nG8oQUQfsYkheFVd1Q+DJofUfzAS9L+zNGtT8
         UF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XoeP0MWsqlS9SBCtVy8FEzgcM0IN2SJZSy5ovcsWriE=;
        b=3DE2ab99quVVRR89BykxlShXFH9ekedYquKb7wjB6vxYz1RlsYDFcplCucwLEqTFMu
         hFsV1x7hE4uYc/MmhdYAzEC8Zcl4iCOhls/sbPHwnOfVvS8aG0neoKwgjnQw+dVRHi+P
         KFb/ZbMAtD2dSC7CDrrMrVApEHTSwb18rXOasQ+7RZ+KUNxGSMN/4rkYGSGRxPqiPmRK
         9WmrflWIJVq3WhGnkx/gcbrjVHvkfnotI57dbuYi6/piCugfV5VIy79Wc7H22gc+R0xv
         YzzLAddbyQRzJjoDEEKNhHtKlNDJslH43nXCwiC00ABQ7hFwMHchteKVwcUD8I7vmS1b
         xyOQ==
X-Gm-Message-State: AOAM533m5J/+YXqQTqlTQGj9KGNe4sLiVHV5qGgswXu0jWDq+gGK3iC4
        dNLPJsWHc79zZAhXmja+4cUyLgPKkHbsQmwMGHk+KtWzBPA=
X-Google-Smtp-Source: ABdhPJz4Na5R1LRWJVA5QkdvFsr1+c3IrDFJC8iCQ2bKUaJUBdVPCh7GUwZ35b1OukVz3IUqiqlTQ65VLMmwSSDWH7M=
X-Received: by 2002:a05:6214:766:b0:462:1701:bca1 with SMTP id
 f6-20020a056214076600b004621701bca1mr38175595qvz.77.1653890074974; Sun, 29
 May 2022 22:54:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220529105505.667891-1-zlang@kernel.org> <20220529105505.667891-6-zlang@kernel.org>
In-Reply-To: <20220529105505.667891-6-zlang@kernel.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 30 May 2022 08:54:23 +0300
Message-ID: <CAOQ4uxix_Un2EZUO=7PGMuFgimmKx0QDS_jvkBmgyFQjUgZHrg@mail.gmail.com>
Subject: Re: [PATCH 5/5] generic/623: add overlay into the blacklist
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 29, 2022 at 8:59 PM Zorro Lang <zlang@kernel.org> wrote:
>
> The _require_scratch_shutdown can't help this test case, except use
> _scratch_shutdown or _scratch_shutdown_handle with it. But this test
> case does 'shutdown' on $SCRATCH_MNT/file directly. It's not suitable
> for overlay.
>

This is not about testing overlayfs.
It is about testing FS under overlayfs which can detect bugs in FS
that are otherwise hard to trigger.
mmap is an especially odd case of overlayfs so I rather not loose this
test coverage. Please do not apply this patch I will send a fix to the test.

Thanks,
Amir.

> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  tests/generic/623 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tests/generic/623 b/tests/generic/623
> index ea016d91..1083e796 100755
> --- a/tests/generic/623
> +++ b/tests/generic/623
> @@ -11,7 +11,7 @@ _begin_fstest auto quick shutdown
>
>  . ./common/filter
>
> -_supported_fs generic
> +_supported_fs ^overlay
>  _fixed_by_kernel_commit e4826691cc7e \
>         "xfs: restore shutdown check in mapped write fault path"
>
> --
> 2.31.1
>

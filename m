Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A19EC873E
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 16:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243704AbjIGQuF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbjIGQuE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 12:50:04 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778371FEB
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 09:49:38 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-d7b79a4899bso1012800276.2
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 09:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694105320; x=1694710120; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MaxZdmgmCvo5Fw9so0MXWCFgHVG6G03XSCfi5PqSeDE=;
        b=UbIbxNCgbTlcoeuNhu4IB+nM/6Ct5CEklCZ5uE5Nfw+UFLFkRFnKdgejGr++cS04G/
         OfrlVfyo/k6PPm3ZFn5qbD2o+6PzLfarbdm0DMpoo9JzUirfXuBg7myuMqB25qX3/CWk
         geEo6jwBmRHrFdkhv2l7qLmWOW/erFLXVeTDm+Sk1zLNT6YZoomXE3DMtenrkUpHc1H8
         0C9CVE4U0XmC3rRYZuOMgxebAFri6xsdYa2gShjS9pwbIiP6CKZOOC2s4pTcm5Rzb//2
         mt3+hu01eqBcLUCIe27/XDejIc86qVgTw5BiCAlBYmI6OjoGRkQXWgSVbDO8tO/lehIC
         pDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694105320; x=1694710120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaxZdmgmCvo5Fw9so0MXWCFgHVG6G03XSCfi5PqSeDE=;
        b=F/9YiN2L+1FAagUMM3M1GFHgOFrwb3UNitXHDy1eFwCiQ2XsSQ7Di/8PwX1Au8Uqei
         yl9llMY82e9ynIXjwFm7uklH5fyRtzraSQJakeYuM7xmYzz3VTazH1g04T63lT2ij+9M
         Z+l4uIDDjKq7/29+EZI9rfude2eDy4QVH4TFmUie6Toi4QhT1rnPZeP4Ov7gkTGORjpw
         VFpbGPL700DrHe4x+YrhSn1f2j57Yc/U6MASAsXXscmvgbQgVEiyJMAzBM8jNTOCrzZE
         U6EeVQVkYr+94lBYxVO/xHQMxFBX1thyCvIgtbl81U9pCX3UZrq0n7fS+Lp0xunpAdeh
         gcWQ==
X-Gm-Message-State: AOJu0YyGapsWOhUZrDTSMhfuGxRGi9i4GdwbZ5TbaGD5Zt0MPOwZNpOg
        4Zgyei2sCQj9OF1D/v/TxHv90Z0Qp5UerCCrNXZrQ9Usg7k=
X-Google-Smtp-Source: AGHT+IERtb+FUHbAkqZ89sg7kpOBH9RTIQH8NKHsHWGX+vsBUT9+Emamq/zhQuRqlrTJIlWDkQ0VHvlt22XvrPb9nT0=
X-Received: by 2002:a05:6102:3a7a:b0:44e:8353:e86a with SMTP id
 bf26-20020a0561023a7a00b0044e8353e86amr4831469vsb.24.1694084236934; Thu, 07
 Sep 2023 03:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com> <261be2df5093dda05aaffe10a6c8831439232574.1694075674.git.alexl@redhat.com>
In-Reply-To: <261be2df5093dda05aaffe10a6c8831439232574.1694075674.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 7 Sep 2023 13:57:05 +0300
Message-ID: <CAOQ4uxiGiv_5VP6NcnouLWV_QDi==Mt6LtiD_A+EY9gMNxn3tw@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] ovl: Add documentation on nesting of overlayfs mounts
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 7, 2023 at 11:44=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  Documentation/filesystems/overlayfs.rst | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index cdefbe73d85c..ae194543dbda 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -492,6 +492,29 @@ directory tree on the same or different underlying f=
ilesystem, and even
>  to a different machine.  With the "inodes index" feature, trying to moun=
t
>  the copied layers will fail the verification of the lower root file hand=
le.
>
> +Nesting overlayfs mounts
> +------------------------
> +
> +It is possible to use a lower directory that is stored on an overlayfs
> +mount. For regular files this does not need any special care. However, f=
iles
> +that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs =
will be
> +interpreted by the underlying overlayfs mount and stripped out. In order=
 to
> +allow the second overlayfs mount to see the attributes they must be esca=
ped.
> +
> +Overlayfs specific xattrs are escaped by using a special prefix of
> +"overlay.overlay.". So, a file with a "trusted.overlay.overlay.metacopy"=
 xattr
> +in the lower dir will be exposed as a regular file with a
> +"trusted.overlay.metacopy" xattr in the overlayfs mount. This can be nes=
ted by
> +repeating the prefix multiple time, as each instance only removes one pr=
efix.
> +
> +A lower dir with a regular whiteout will always be handled by the overla=
yfs
> +mount, so to support storing an effective whiteout file in an overlayfs =
mount an
> +alternative form of whiteout is supported. This form is a regular, zero-=
size
> +file with the "overlay.whiteout" xattr set, inside a directory with the
> +"overlay.whiteouts" xattr set. Such whiteouts are never created by overl=
ayfs,
> +but can be used by userspace tools (like containers) that generate lower=
 layers.
> +These alternative whiteouts can be escaped using the standard xattr esca=
pe
> +mechanism in order to properly nest to any depth.
>
>  Non-standard behavior
>  ---------------------
> --
> 2.41.0
>

Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA763EB64D9
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 10:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjGFKIF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 06:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjGFKIE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 06:08:04 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6581B6;
        Thu,  6 Jul 2023 03:08:03 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id a1e0cc1a2514c-791b8500a1dso151186241.1;
        Thu, 06 Jul 2023 03:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688638082; x=1691230082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOJW2b/hzctB1XvlKMlBOwrSPqWJGd8zHZJwhB0hN1I=;
        b=bVPgPFDyMiLCFQXMSecBvqZlHrKbAJlBFr7U4j2e11J04VwXsapIc/yWq/dzNpnCRW
         mQ3j2oT0yQnAJgAhtaNX2M9a0GP7utUVuZsnnYzVL2nr9/f6u567/k1NwxthD4DKZLv3
         Y1VjE08PuvyGQDTdNdZ2MUZGNSlqq0x7SgnPgSK8hXp01SwXU4dpLs0CGUPSC6SeRfD6
         ku2QCtdk4yLep80GxFal8vt+/EeEPIg/LSZYCTLCm7YppJlH4qTYSJKAKhXZCQjNfaij
         XE6rQQcyneqKisaeL12eNOn/5Rz6W7RLTJ2MyJrCQK3vLC3ldrf1H7sPg7r7xITySu+O
         0Z2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688638082; x=1691230082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOJW2b/hzctB1XvlKMlBOwrSPqWJGd8zHZJwhB0hN1I=;
        b=fAmyafLbqPvoZzpKfY77Uge0EHAm/3781Re0h2EBYzdPVTiPniGRJOkl/Xt9VnxtFq
         r/nREH7yu4+HP7gtzzIpAVSpwtALPcbROAZrS66Afc2mfPt8tbDK2r3KH3begAwz4Ivu
         LfEHsFmFHiZNzyzVD7weSs12+1vn6MsYdWF+1hTTtPsv0odReWVkw5buxZYPBuidAxdY
         yLmTrt0yAo36NUK0yLhx7QSzEKWPdtWCGrThN6W08hhUzAKtEL+AzjlFoIo9lU8ShCt5
         +B+NgZhWvkeuwjAUK/Qww+hzu/IZwhvMGde+xZx1XJjZ3oy7THl69iaJ9GlzXE8f6aLV
         ULeQ==
X-Gm-Message-State: ABy/qLbox7LPKMWOO23jYXesQ7eGpM+WRLrGqno3XUGGhFrDE4MEgGJV
        fG8cawU0d97miFaUo+Wiy4rv5QEMeEJrCZ3hD+U=
X-Google-Smtp-Source: APBJJlE9s3A8FjlCQ2Bc2OjTlAGbCab7C4gMNWNfaIDWK/0Hc7Hpg/d84UEQSc6hbCYh88xgT6g2NoD3heiHgGqf1xg=
X-Received: by 2002:a05:6102:3016:b0:444:481d:f1 with SMTP id
 s22-20020a056102301600b00444481d00f1mr487639vsa.19.1688638082621; Thu, 06 Jul
 2023 03:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1688634271.git.alexl@redhat.com> <76c983397d13212ff3105ae05fe4240d830440a9.1688634271.git.alexl@redhat.com>
In-Reply-To: <76c983397d13212ff3105ae05fe4240d830440a9.1688634271.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 6 Jul 2023 13:07:51 +0300
Message-ID: <CAOQ4uxhLgGQH4R1GExOfegkqKLWOagsEdi+70Go+5b103v51hQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] overlay: add helper for mounting rdonly overlay
To:     alexl@redhat.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 6, 2023 at 12:51=E2=80=AFPM <alexl@redhat.com> wrote:
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> Allow passing empty upperdir to _overlay_mount_dirs().
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Forgot to say - you need to sign off on patches that you submit
on behalf of someone else, so please reply with SOB on those patches.

>  common/overlay | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/common/overlay b/common/overlay
> index 20cafeb1..452b3b09 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -17,15 +17,19 @@ if [ -n "$OVL_BASE_FSTYP" ];then
>  fi
>
>  # helper function to do the actual overlayfs mount operation
> +# accepts "-" as upperdir for non-upper overlayfs
>  _overlay_mount_dirs()
>  {
>         local lowerdir=3D$1
>         local upperdir=3D$2
>         local workdir=3D$3
>         shift 3
> +       local diropts=3D"-olowerdir=3D$lowerdir"
>
> -       $MOUNT_PROG -t overlay -o lowerdir=3D$lowerdir -o upperdir=3D$upp=
erdir \
> -                   -o workdir=3D$workdir `_common_dev_mount_options $*`
> +       [ -n "$upperdir" ] && [ "$upperdir" !=3D "-" ] && \
> +               diropts+=3D",upperdir=3D$upperdir,workdir=3D$workdir"
> +
> +       $MOUNT_PROG -t overlay $diropts `_common_dev_mount_options $*`
>  }
>
>  # Mount with same options/mnt/dev of scratch mount, but optionally
> --
> 2.40.1
>

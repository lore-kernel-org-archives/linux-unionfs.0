Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FDBE748E9
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Oct 2023 12:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbjJAMnZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 1 Oct 2023 08:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjJAMnY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 1 Oct 2023 08:43:24 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB8494;
        Sun,  1 Oct 2023 05:43:22 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id a1e0cc1a2514c-7ab68ef45e7so4639531241.3;
        Sun, 01 Oct 2023 05:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696164201; x=1696769001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsSgA1yxS4COhTN+0/4fRoFWkqqUo+Lvf6slhyu7+e8=;
        b=WN6kw0i2GYvUggVQ8u8Tyu78s7mgRKQV1VPqum4jlTJqVL5UyNjNmTuScBZkDXlEhy
         ESqO3BFZBuVzpmDCpBzE5BnL5AgfWZqRS9e5WXJn24Cx6sn5jGUY1CXvMRuQrzoAduS2
         h4DzGll8ZKgmc9DQrpyTaxqTDtU60yNGJ7zOaFz0S/KOdgS+mEyRtZTpsMCwhGwxBpp+
         fLyubQMlH9NPQUtnyUp0p7ffeVg34R+tO2mBBN82bTmwyAcf2VjX6pWT5cUFm5mnc9MP
         QPcZ4OCuzzW9eemqZhwUtd4F3jrwhoA4ydd7uZV15k2MQMFz9slzeTtHrvn9FNHNlYfG
         ElHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696164201; x=1696769001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IsSgA1yxS4COhTN+0/4fRoFWkqqUo+Lvf6slhyu7+e8=;
        b=DFAG2fF/AGBG0SvXNRsa5Sbot/qewUday3DGK4GYO3XNm0p4bah0NAgPS7LmGobhSX
         D8Z3JmY2QaNqivgm4au+1cUqiCGp1sbDKd6oM0n1gdOW6djIRM10rTuAclKlVis9QpU2
         bv2D2r4/QBd1dnV3nHbnjkftAuSyS0lqIjd/qxVSEbMzvbHIqwwLjbizP+YzRjV2HRx3
         RUjBBKF3ipMYxZnyNWpoCnH15K7Lfo4Bz0m4n/7ShkGFDUILjDmYCLV5hUmlIwFIoPJ9
         mq5uUNJM8Q5hLb7DIL5b/SIroTRoTMHDYK+DLWny7avrsWoeZ08OZdxznARv0xNCkd/+
         1C9Q==
X-Gm-Message-State: AOJu0YxfmFL/JctPgavE3ghQEpPNsxsndJQfNhvkU2UYPRM6xzotODVS
        Q/cdd8pWIkoIVj1O2bu8n+YwZzp6LW+9UvVp8y4=
X-Google-Smtp-Source: AGHT+IHLoIqVoFMImw62LXF07AY7rv46EBkcRuM5cZPHwSl4vU/BdOgU5kACZBzfM4/btedE2kpeooQ7Kjzd5AMHlsQ=
X-Received: by 2002:a05:6102:51a:b0:44e:ac98:c65d with SMTP id
 l26-20020a056102051a00b0044eac98c65dmr5433300vsa.27.1696164201225; Sun, 01
 Oct 2023 05:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20231001005710.58314-1-uvv.mail@gmail.com>
In-Reply-To: <20231001005710.58314-1-uvv.mail@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 1 Oct 2023 15:43:10 +0300
Message-ID: <CAOQ4uxh0GNo__uYe05niFLyJFhUQ6riRp9q6ySw0ftVY7YNwcw@mail.gmail.com>
Subject: Re: [PATCH v2] README: Update overlayfs instructions
To:     Vyacheslav Yurkov <uvv.mail@gmail.com>
Cc:     fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Oct 1, 2023 at 3:58=E2=80=AFAM Vyacheslav Yurkov <uvv.mail@gmail.co=
m> wrote:
>
> Overlayfs-tools and overlayfs-progs projects have been merged together.
>
> Signed-off-by: Vyacheslav Yurkov <uvv.mail@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  README         | 12 ------------
>  README.overlay |  9 ++++++++-
>  2 files changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/README b/README
> index d9db9675..e0dabe96 100644
> --- a/README
> +++ b/README
> @@ -18,9 +18,6 @@ Ubuntu or Debian
>     $ sudo apt-get install exfatprogs f2fs-tools ocfs2-tools udftools xfs=
dump \
>          xfslibs-dev
>
> -   For OverlayFS install:
> -    - see https://github.com/hisilicon/overlayfs-progs
> -
>  Fedora
>  ------
>
> @@ -36,9 +33,6 @@ Fedora
>      $ sudo yum install btrfs-progs exfatprogs f2fs-tools ocfs2-tools xfs=
dump \
>          xfsprogs-devel
>
> -   For OverlayFS build and install:
> -    - see https://github.com/hisilicon/overlayfs-progs
> -
>  RHEL or CentOS
>  --------------
>
> @@ -74,9 +68,6 @@ RHEL or CentOS
>      For ocfs2 build and install:
>       - see https://github.com/markfasheh/ocfs2-tools
>
> -    For OverlayFS build and install:
> -     - see https://github.com/hisilicon/overlayfs-progs
> -
>  SUSE Linux Enterprise or openSUSE
>  ---------------------------------
>
> @@ -94,9 +85,6 @@ SUSE Linux Enterprise or openSUSE
>      For XFS install:
>       $ sudo zypper install xfsdump xfsprogs-devel
>
> -    For OverlayFS build and install:
> -     - see https://github.com/hisilicon/overlayfs-progs
> -
>  Build and install test, libs and utils
>  --------------------------------------
>
> diff --git a/README.overlay b/README.overlay
> index ec4671c3..3093bf8c 100644
> --- a/README.overlay
> +++ b/README.overlay
> @@ -1,4 +1,3 @@
> -
>  To run xfstest on overlayfs, configure the variables of TEST and SCRATCH
>  partitions to be used as the "base fs" and run './check -overlay'.
>
> @@ -69,3 +68,11 @@ UNIONMOUNT_TESTSUITE to the local path where the repos=
itory was cloned.
>
>  Run './check -overlay -g overlay/union' to execute all the unionmount te=
stsuite
>  test cases.
> +
> +
> +Overlayfs Tools
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +A few tests require additional tools. For fsck.overlay [optional],
> +build and install:
> +  https://github.com/kmxz/overlayfs-tools
> --
> 2.35.1
>

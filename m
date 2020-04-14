Return-Path: <SRS0=sqyI=56=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01AAC2BA2B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 03:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90A3C20732
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 03:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIqVBzp4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404677AbgDNDWl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 23:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404650AbgDNDWk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Apr 2020 23:22:40 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B614BC0A3BDC;
        Mon, 13 Apr 2020 20:22:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f19so11744110iog.5;
        Mon, 13 Apr 2020 20:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIMoFaJkbHHJFHVc4iyFqBLqm9kQvTSmlUjs4Key7eI=;
        b=kIqVBzp4oMXMl9mia0yhjgb9cEu354jGzEAr/0euUt0zsy0XyhsSQ6ypgxJXUYO0yd
         7/Kacqw5JdFBc+Y+fAfvk80lCSfwmRTAGdRH7kWBzsQ+NgNv2TKKuOD2N42gHHIU8IvR
         UiZWzi2Upu0Jk88iY2o6sZjDJH9sf1u9EDEw62vKNfvwOo2+/spPU+AmWy3I2rlew2bB
         8my31Nt0msQkCQJuMZen7n/8KVzfiDfrwOP7KxfySKq5DliWOUaOs6qrSVT6m1efojAV
         H6zOs6CrzoQZ/uSu3Lb+hGpjh90V5IGm7w2c+Vwm+ugppKt3I+XcR+EkwJrY3hLIs1AD
         gRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIMoFaJkbHHJFHVc4iyFqBLqm9kQvTSmlUjs4Key7eI=;
        b=J59u1P2YNBvCe9TE5X0vdLfAz+eNxV7rPsFJWLhlcPhEt9NIf9Z/AsOf0t/YM4fMmn
         pozpoCH9y4+FBAg4rIxXp72JVYipPFVuJ+ZqkFCEbOdOxlgqyDx4LmmM9y9vtj8cVogn
         VBRbn4iVdpWVBl9u5afupuw3jHUnRxTEqc0qk/OYOy8pHUbarpmGP2lFP9CsHOO/GxXN
         Q82wJivHD4tbN4wyVcJH9XzfXnpBWPx1jUmMKQ+ANzlSP9yRcjBSqF3E5FIs6eqZ9t75
         geO4twEKphvMXU85+arG443xQSCW36okiKtaUCHpW/7gTBRjsBkr5i3poyaLdlgppBoi
         38aQ==
X-Gm-Message-State: AGi0PuarT7g+8636a1l4rfrQlPCaBrWDXFOEjXPx5f+59aeq/hHKHLMz
        U/Q4B/NwXOopeI4ccYUXJtR5EvDeCV4/aHZi/t4=
X-Google-Smtp-Source: APiQypKySfAsd2u/qk645ndipulCbOzwU2Nz1aJ9RrdLLFo1comx76Sj7yEbleq8wBM/rbta6FNusGqwy2Z5ocUoQ2E=
X-Received: by 2002:a05:6602:2fc4:: with SMTP id v4mr19360998iow.64.1586834558059;
 Mon, 13 Apr 2020 20:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200414023105.28261-1-cgxu519@mykernel.net>
In-Reply-To: <20200414023105.28261-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Apr 2020 06:22:26 +0300
Message-ID: <CAOQ4uxhP81fkjjVHFkeE-G2eZVvqVz33X2VuBTBqDc8j=t0-NQ@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/072: test for whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 14, 2020 at 5:31 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This is a test for whiteout inode sharing feature.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> v1->v2:
> - Address Amir's comments in v1.

Looks good. Some nits.
With those fixed you may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>


>
>  common/module         |   9 +++
>  tests/overlay/072     | 148 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/072.out |   2 +
>  tests/overlay/group   |   1 +
>  4 files changed, 160 insertions(+)
>  create mode 100755 tests/overlay/072
>  create mode 100644 tests/overlay/072.out
>
> diff --git a/common/module b/common/module
> index 39e4e793..148e8c8f 100644
> --- a/common/module
> +++ b/common/module
> @@ -81,3 +81,12 @@ _get_fs_module_param()
>  {
>         cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
>  }
> + # Set the value of a filesystem module parameter
> + # at /sys/module/$FSTYP/parameters/$PARAM
> + #
> + # Usage example:
> + #   _set_fs_module_param param value
> + _set_fs_module_param()
> +{
> +       echo ${2} > /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
> +}
> diff --git a/tests/overlay/072 b/tests/overlay/072
> new file mode 100755
> index 00000000..e1244394
> --- /dev/null
> +++ b/tests/overlay/072
> @@ -0,0 +1,148 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 072
> +#
> +# This is a test for whiteout inode sharing feature.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +       _set_fs_module_param $param_name $orig_param_value

verify orig_param_value is not empty

> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_test

test partition not used

> +_require_scratch
> +
> +param_name="whiteout_link_max"
> +
> +# Check overlayfs module param(whiteout_link_max)
> +check_whiteout_link_max()
> +{
> +       orig_param_value=`_get_fs_module_param ${param_name}`
> +       if [ -z ${orig_param_value} ]; then
> +               _notrun "${FSTYP} does not support whiteout inode sharing"
> +       fi
> +}
> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +
> +# Make some testing files in lowerdir.
> +# Argument:
> +# $1: Testing file number
> +make_lower_files()
> +{
> +       for name in `seq -s' ' ${1}`

-s' ' not needed

> +       do
> +               touch $lowerdir/file${name} 1>&2 2>/dev/null

&>/dev/null

> +       done
> +}
> +
> +# Delete all copy-uped files in upperdir.
> +make_whiteout_files()
> +{
> +       rm -f $SCRATCH_MNT/* 1>&2 2>/dev/null

&>/dev/null

> +}
> +
> +# Check link count of whiteout files.
> +# Arguments:
> +# $1: Testing file number
> +# $2: Expected link count
> +check_whiteout_files()
> +{
> +       for name in `seq -s' ' ${1}`

-s' ' not needed

> +       do
> +               local real_count=`stat -c %h $upperdir/file${name} 2>/dev/null`
> +               if [[ ${2} != $real_count ]]; then
> +                       echo "Expected link count is ${2} but real count is $real_count, file name is file${name}"
> +               fi
> +       done
> +       local tmpfile_count=`ls $workdir/work/\#* $workdir/index/\#* 2>/dev/null |wc -l 2>/dev/null`
> +       if [[ -n $tmpfile_count && $tmpfile_count > 1 ]]; then

-n "$tmpfile_count" or you won't get desired outcome

> +               echo "There are more than one whiteout tmpfile in work/index dir!"
> +               ls -l $workdir/work/\#* $workdir/index/\#* 2>/dev/null
> +       fi
> +}
> +
> +# Run test case with specific arguments.
> +# Arguments:
> +# $1: Maximum link count
> +# $2: Testing file number
> +# $3: Expected link count
> +run_test_case()
> +{
> +       _scratch_mkfs
> +       _set_fs_module_param $param_name ${1}
> +       make_lower_files ${2}
> +       _scratch_mount
> +       make_whiteout_files
> +       check_whiteout_files ${2} ${3}
> +       _scratch_unmount
> +}
> +
> +check_whiteout_link_max
> +
> +# Case1:
> +# Setting whiteout_link_max=0 means whiteout files will not
> +# share inode, each whiteout file will have it's own inode.
> +
> +link_max=0
> +file_count=10
> +link_count=1
> +run_test_case $link_max $file_count $link_count
> +
> +# Case2:
> +# Setting whiteout_link_max=0 means whiteout files will not

you mean whiteout_link_max=1

> +# share inode, each whiteout file will have it's own inode.
> +
> +link_max=1
> +file_count=10
> +link_count=1
> +run_test_case $link_max $file_count $link_count
> +
> +# Case3:
> +# Setting whiteout_link_max>2 means whiteout files will share

you mean whiteout_link_max>1

> +# inode and link count could up to whiteout_link_max.
> +
> +link_max=2
> +file_count=10
> +link_count=2
> +run_test_case $link_max $file_count $link_count
> +
> +# Case4:
> +# Setting whiteout_link_max>2 means whiteout files will share

you mean whiteout_link_max>1

Thanks,
Amir.

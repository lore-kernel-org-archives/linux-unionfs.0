Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516D0C47071
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Nov 2023 07:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjKPHxF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 02:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjKPHxE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2023 02:53:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D40199
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Nov 2023 23:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700121180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IcJ3rcR8Miv9CI5k5e5Ubu9tQmUURbRqEdiSTe9Utnc=;
        b=al9WIzM5ze4r7McuXECjEE/On0IYSkq1hZ6H4gzPu+M5HypYvPuWqBTWh+TX/Xb7HQp2qs
        +pVucgefxr5pbm/8GY7E6ELjojbenXshSDs3JufStLD0x7i89MXQYqwNvxIvPaKdo4Vau9
        S6fFFn4NdRwFS+SQ9MbEJHZos3S8g0E=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-5we44vHBN_2fYBP_UQux1Q-1; Thu, 16 Nov 2023 02:52:56 -0500
X-MC-Unique: 5we44vHBN_2fYBP_UQux1Q-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3b3e1c828a4so636039b6e.0
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Nov 2023 23:52:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700121175; x=1700725975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcJ3rcR8Miv9CI5k5e5Ubu9tQmUURbRqEdiSTe9Utnc=;
        b=iHKEmy+CgIWyKo4IlD4CoUq0TiSyi2KdxEykD8qthF1Jb1Wr9oev5h0L3wFEiA4klj
         un9UvuP+Lu8h2wohEPsBOhkb9P/IR1UhndsiRy1hR2UXqDarYZnsXjSjQMkyq+xqLeBV
         4iLLTH/fYtqBl+XCgz4wfuZEbx+TGMxvQ+lghg+1OD5GUtGiV9M+Lj34iRF1FqqFSPMs
         82ZuIHaTYb+8DRyxa5Tk9t5zw9JvGiv2rPNhbK2x/ulBE0I1GvYig68fmhA/wjiZyQdj
         MNr0zS9hNMeC5skC+grgM24TZbrdFBLKGZTLbwIyIJtPFG8YKetzbCDsRU8L9OyY0N3a
         rdGg==
X-Gm-Message-State: AOJu0YzRIkZ+vUOv3ENVpSvGk8pXCF6tHcpPeUEE1viqZW65ujGoMKk2
        BWvK962F1a08oEhd3GEZ+tvOFmCw6aqziSrBHvV28F/bgHw1vJIOeFwZkuIs7knOBpUpwgrgQI1
        VNN/9W9fso+X3flPNtbymZou2PA==
X-Received: by 2002:a05:6808:2191:b0:3ae:16b6:6338 with SMTP id be17-20020a056808219100b003ae16b66338mr21431769oib.3.1700121175538;
        Wed, 15 Nov 2023 23:52:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtmLvRqYTeG43Zm7XrhtSCPgLYITfbuc5jwiskSxqRtqheikMTUy2kWou2JtNxNr7WfcLwaw==
X-Received: by 2002:a05:6808:2191:b0:3ae:16b6:6338 with SMTP id be17-20020a056808219100b003ae16b66338mr21431755oib.3.1700121175285;
        Wed, 15 Nov 2023 23:52:55 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 28-20020a630c5c000000b005c1ce3c960bsm2354075pgm.50.2023.11.15.23.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 23:52:54 -0800 (PST)
Date:   Thu, 16 Nov 2023 15:52:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay/026: Fix test expectation for newer kernels
Message-ID: <20231116075250.ntopaswush4sn2qf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231112080242.1492842-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231112080242.1492842-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Nov 12, 2023 at 10:02:42AM +0200, Amir Goldstein wrote:
> From: Alexander Larsson <alexl@redhat.com>
> 
> We now support xattr of overlayfs.* xattrs, so check that either
> both set and get work, or neither.
> 
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> This test is failing since overlayfs merge for v6.7-rc1, because it
> encodes an expectation that set/get of private overlay.* xattrs
> should fail.
> 
> This expectation is no longer correct for new kernel, so Alex has
> fixed the test to expect consistent behavior of set/get of private
> overlay.* xattrs.
> 
> We have some new tests for features merged for v6.7-rc1, but this fix
> has higher priority, so sending it early.
> 
> Thanks,
> Amir.
> 
> 
>  tests/overlay/026     | 35 +++++++++++++++++++++++++----------
>  tests/overlay/026.out |  2 --
>  2 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/tests/overlay/026 b/tests/overlay/026
> index 77030d20..f71b3f13 100755
> --- a/tests/overlay/026
> +++ b/tests/overlay/026
> @@ -57,21 +57,36 @@ $SETFATTR_PROG -n "trusted.overlayfsrz" -v "n" \
>  _getfattr --absolute-names -n "trusted.overlayfsrz" \
>    $SCRATCH_MNT/testf0 2>&1 | _filter_scratch
>  
> -# {s,g}etfattr of "trusted.overlay.xxx" should fail.
> +# {s,g}etfattr of "trusted.overlay.xxx" fail on older kernels
>  # The errno returned varies among kernel versions,
> -#            v4.3/7   v4.8-rc1    v4.8       v4.10
> -# setfattr  not perm  not perm   not perm   not supp
> -# getfattr  no attr   no attr    not perm   not supp
> +#            v4.3/7   v4.8-rc1    v4.8       v4.10     v6.7
> +# setfattr  not perm  not perm   not perm   not supp  ok
> +# getfattr  no attr   no attr    not perm   not supp  ok
>  #
> -# Consider "Operation not {supported,permitted}" pass.
> +# Consider both "Operation not {supported,permitted}" and
> +# "No such attribute" as pass for getattr to support all kernel
> +# version. However, the setfattr result must match getattr.
>  #
> -$SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
> -  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
> -  sed -e 's/permitted/supported/g'
>  
> -_getfattr --absolute-names -n "trusted.overlay.fsz" \
> +getres=$(_getfattr --absolute-names -n "trusted.overlay.fsz" \
> +  $SCRATCH_MNT/testf1 2>&1 | _filter_scratch)

Can we have a helper in common/overlay to check if current FSTYP supports
get or set overlay.* xattr, to deal with this patch?

Thanks,
Zorro

> +
> +supported=n
> +if [[ "$getres" =~ "No such attribute" ]]; then
> +    supported=y
> +else
> +   [[ "$getres" =~ Operation\ not\ (supported|permitted) ]] || echo unexpected getattr result: $getres
> +fi
> +
> +setres=$($SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
>    $SCRATCH_MNT/testf1 2>&1 | _filter_scratch | \
> -  sed -e 's/permitted/supported/g'
> +  sed -e 's/permitted/supported/g')
> +
> +if [ $supported == 'y' ]; then
> +    [[ "$setres" == "" ]] || echo unexpected setattr result: $setres
> +else
> +    [[ "$setres" =~ "Operation not supported" ]] || echo unexpected setattr result: $setres
> +fi
>  
>  # success, all done
>  status=0
> diff --git a/tests/overlay/026.out b/tests/overlay/026.out
> index c4572d67..53030009 100644
> --- a/tests/overlay/026.out
> +++ b/tests/overlay/026.out
> @@ -2,5 +2,3 @@ QA output created by 026
>  # file: SCRATCH_MNT/testf0
>  trusted.overlayfsrz="n"
>  
> -setfattr: SCRATCH_MNT/testf1: Operation not supported
> -SCRATCH_MNT/testf1: trusted.overlay.fsz: Operation not supported
> -- 
> 2.34.1
> 


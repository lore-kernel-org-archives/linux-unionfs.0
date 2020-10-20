Return-Path: <SRS0=P7/h=D3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F640C433E7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Oct 2020 02:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41806222E9
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Oct 2020 02:53:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ka5yNy4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390872AbgJTCxL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 22:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390804AbgJTCxJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Oct 2020 22:53:09 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1CDC0613CE;
        Mon, 19 Oct 2020 19:53:07 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so181808pll.11;
        Mon, 19 Oct 2020 19:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dy8fgiv0CyhZesILyZRrDUbj71GvO0eanKC3zRGVQTk=;
        b=Ka5yNy4TYGqJFFpxu9YQlyHhrGkanGqhFBpjGeD/kC/gykA2db3lVsTwV2PFIv5t6B
         +0DyrdNnqp6yaYSjhJGQiqM9OzUmTUDQ4q+Srv4oSVYhE4tx03xXi4JXmiSDnyjtcWJE
         3SAuF7A7DRwvlldhz8AMHlRm4xc6ZzsGBTWKlwkyj18OraR4ZpSaW5tuNHu3uGjo3OKc
         TGd/piddENSijRYE1q7j+y6/Elv39mkP5uKISztIa1vtMyIxhYajbcZlUuC03yr25zxz
         KI0JwhtIe8xfFad3n+De+Qwq7YmXRpzkEyIjoiLSDZMDdO2l1rh/7GX8Y0MwXnBGh+ko
         PdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dy8fgiv0CyhZesILyZRrDUbj71GvO0eanKC3zRGVQTk=;
        b=G+BbFjmxcl3qt4tGHNjrURy9eCSanJ/AGDRnJA1b5dcW4AaEYe4Kneu3Mb8H6vRcci
         w6JCsnlvDi4ypFKtSOPQ6Y8fFluX2krTLHORxf8Kz/5ExiKEjTdIIMO4X4OImnZuYi8w
         r+sIJ/6KDuiGs/V+ZAGjNobdDwAxOZSoKnfntGLPDxtWoiXZNgtX/EHPFThehOTHpFof
         xjOl+mM6dXHVvm37CcxRZEuW4BZNRGdmv/6i075rfWBzlZ1YONd+Wi3/dDEJuFR/aGea
         +YqnEcSwzgrkL6V69Zkphwu8qNz+gsHQjLnr6qNi3Uh8lmYBrJcCls/xozagG5fmcgHA
         qFEQ==
X-Gm-Message-State: AOAM533/zl8kDaHOqaEBucHhJCnoo7AXGkvhtEBh18tU6hrOJOFQEC46
        mvHdzqN7rC71XaNG20BaLe4u2qrRGIQ=
X-Google-Smtp-Source: ABdhPJwozJ4JF8QEHGk493Gt3YQWjplGGM865z1vs3nGEtzMn6jceU9gqQxqtVgIbowfdJKt90ASmQ==
X-Received: by 2002:a17:902:b107:b029:d2:ab87:c418 with SMTP id q7-20020a170902b107b02900d2ab87c418mr861296plr.40.1603162387177;
        Mon, 19 Oct 2020 19:53:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kv19sm194162pjb.22.2020.10.19.19.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 19:53:06 -0700 (PDT)
Date:   Tue, 20 Oct 2020 10:52:59 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH v2] overlay/073: test with nfs_export being off
Message-ID: <20201020024538.tl7xenmmguhcj6af@xzhoux.usersys.redhat.com>
References: <CAOQ4uxh+ppPMOSeAZU3sdwxwb_ixMHEpHLF9ZO_MTiedNJRgsw@mail.gmail.com>
 <20200911021813.o6vtueabupevfgab@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911021813.o6vtueabupevfgab@xzhoux.usersys.redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Ping on this one.

On Fri, Sep 11, 2020 at 10:18:13AM +0800, Murphy Zhou wrote:
> When nfs_export is enabled, the link count of upper dir
> objects are more then the expected number in this testcase.
> Because extra index entries are linked to upper inodes.
> 
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  tests/overlay/073 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/overlay/073 b/tests/overlay/073
> index 37860c92..c5deccc6 100755
> --- a/tests/overlay/073
> +++ b/tests/overlay/073
> @@ -99,7 +99,9 @@ run_test_case()
>  {
>  	_scratch_mkfs
>  	make_lower_files ${1}
> -	_scratch_mount -o "index=on"
> +	# There will be extra hard links with nfs_export enabled which
> +	# is expected. Turn it off explicitly to avoid the false alarm.
> +	_scratch_mount -o "index=on,nfs_export=off"
>  	make_whiteout_files
>  	check_whiteout_files ${1} ${2}
>  	_scratch_unmount
> -- 
> 2.20.1
> 

-- 
Murphy

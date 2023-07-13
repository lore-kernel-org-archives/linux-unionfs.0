Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5309EC0015E
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 15:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjGMPgS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 11:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjGMPgR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 11:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDA13580
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 08:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689262505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WWX/2RdmzMlzeOXQbV2SXlI4tVXd/cgTFBBGmD8VxPY=;
        b=TsWtxHHq34zycfNDK5bIXR6aMHrbOMHx12Cq3M7cthNnx+C13KANLsFZCVEpljY3Gy8yGU
        eCygxOlo5KCUSAhw6KIigbeaZD2bmpcxti9aGWA6e8ju77JLhUkdlbecs13gmQjdm9ghOZ
        VMZBuMLl741YNuHIkKbq3ExxLLf+OII=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-T3ecpIquPBixVVp3jRVszQ-1; Thu, 13 Jul 2023 11:35:03 -0400
X-MC-Unique: T3ecpIquPBixVVp3jRVszQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-55c79a55650so716241a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 08:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689262502; x=1691854502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWX/2RdmzMlzeOXQbV2SXlI4tVXd/cgTFBBGmD8VxPY=;
        b=ZgHf6fxABLKpodaeM07Wwenwbe9V4BsJxiWNRuQ3KlwUuTMc44z3nnd+bZtNhzN4Bn
         +CPpA/XdfDxL1vAaVOySeqVcCy1FiMdYy9ox4N7JlWN3wvC8p0p298LGej3MQYLT1fFi
         /rNm0MTSxv+R21FZJ2BK45QmjawrvBIvuNkVPPnPGbzkgWX0vQp43o25dneG1g148sQd
         ngiApxn+gXroadRdrOT3bdLTJDhmesMm3dYZTPKeVkmNz7yKd4BxOg7M/urrKAZ0DKe7
         0kAEQ4/W4cM5zEdLSTPBCSJdRxNXMydZG3Jz5CoUkKC5HSNWJMgnKDTPDArxtxewppZH
         9yag==
X-Gm-Message-State: ABy/qLa/NBYrLU5H5Wb4hRV3k9QkWvi1LPie7lL7fwTjK7jx4/51LnBy
        BAtG4K8e4dqYrC+ubXww/YMSzLjUXPund6i9vQTNUaU9g8MH1ndjRkpCylJVLU3ez83HoxxTFQl
        iQB52Vswk8DbWW9/D6gCi4EV7kA==
X-Received: by 2002:a17:902:bd83:b0:1b8:ae12:5610 with SMTP id q3-20020a170902bd8300b001b8ae125610mr1939222pls.7.1689262501960;
        Thu, 13 Jul 2023 08:35:01 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFouuLPNOhM+tHoNY8x7Sb6yJTPZepnALm5nFskVxVhslrQlwybjZ2K7enE1PmSQ0J9alXZNg==
X-Received: by 2002:a17:902:bd83:b0:1b8:ae12:5610 with SMTP id q3-20020a170902bd8300b001b8ae125610mr1939211pls.7.1689262501684;
        Thu, 13 Jul 2023 08:35:01 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902748500b001a95f632340sm6107157pll.46.2023.07.13.08.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 08:35:01 -0700 (PDT)
Date:   Thu, 13 Jul 2023 23:34:57 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     alexl@redhat.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH v2 0/4] overlayfs: Test data-only upperdirs and fs-verity
Message-ID: <20230713153457.5723wtjidhvlxfyz@zlang-mailbox>
References: <cover.1688979643.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1688979643.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 10, 2023 at 11:07:09AM +0200, alexl@redhat.com wrote:
> From: Alexander Larsson <alexl@redhat.com>
> 
> This adds support for testing the new data-only upperdir feature which is
> currently in master and will be in 6.5-rc1. It also adds tests for the
> fs-verity validation feature which is queued in overlayfs-next for 6.6.
> 
> All new tests check for the required features before running, so
> having it in early will be nice for testers of linux-next.
> 
> Changes since v1:
>  * Consistently use $fstyp and $scratch_mnt in _require_scratch_verity
>    (Pointed out by Eric Biggers)
>  * Added Signed-off-by to patches from Amir
> 
> Alexander Larsson (1):
>   overlay: Add test coverage for fs-verity support
> 
> Amir Goldstein (3):
>   overlay: add helper for mounting rdonly overlay
>   overlay/060: add test cases of follow to lowerdata
>   overlay: Add test for follow of lowerdata in data-only layers

This patchset looks good to me, and I didn't regression from it. So if there's
not more review points from overlayfs side, I'll merge this patchset in next
fstests release.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> 
>  common/overlay        |  35 ++++-
>  common/verity         |  16 ++-
>  tests/overlay/060     |  43 +++++-
>  tests/overlay/060.out |  18 +++
>  tests/overlay/079     | 325 +++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/079.out |  42 ++++++
>  tests/overlay/080     | 326 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/080.out |   7 +
>  8 files changed, 800 insertions(+), 12 deletions(-)
>  create mode 100755 tests/overlay/079
>  create mode 100644 tests/overlay/079.out
>  create mode 100755 tests/overlay/080
>  create mode 100644 tests/overlay/080.out
> 
> -- 
> 2.40.1
> 


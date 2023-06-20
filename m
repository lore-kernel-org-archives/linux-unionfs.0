Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB82AEB64DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 09:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbjFTJwu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjFTJwS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 05:52:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7701BD1;
        Tue, 20 Jun 2023 02:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1573860FEF;
        Tue, 20 Jun 2023 09:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F01C433C8;
        Tue, 20 Jun 2023 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687254606;
        bh=ucwRgN0SPATufz0OvMFtfGnUKIt2sxhZ1UPCIOUbqtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MJv1rwOUfxfLYIDr1mM9Zu2j953ECp4PkPIHlPsf0HBZOqZeIxBcO4DqgEGhOBeBa
         B0Lh618yyyd/VOcxPCBneyF1kXBg42h9TE3Rt+lCzmc3/DZ2Rp51Li+jxg0eiQAN76
         bxryEJ1ssTMvz9/6oZKZmTvf9Oz8g3oRJ6YK69JQ6a9xcxuvPO04Cc4mQqdmY6Snjw
         bEj4Q4KQ1ERtkSTOx1iK4qvIS/uN7+swxfWVpjZpLzCA6t1craxLScm+1wSg2elx43
         3G9MG2ezuRmOw/4qHGDA3KKbCZntj5xwNoefWFuGTWwPms0cmC3HFKqJIRo/LzkGXt
         JImxPBBJhaomw==
Date:   Tue, 20 Jun 2023 11:49:57 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] generic/604: Fix for overlayfs
Message-ID: <20230620-dissident-bestmarke-33d41a1c4d40@brauner>
References: <20230618124506.2642352-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230618124506.2642352-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 18, 2023 at 03:45:06PM +0300, Amir Goldstein wrote:
> Since v6.3, I noticed that generic/604 does not run on overlayfs
> because:
> 
>   generic/604 -- upper fs needs to support d_type
> 
> This is odd because the base fs I am using (xfs) does support d_type.
> 
> The reason is that for overlayfs, this sequence run by this test:
> 
>   _scratch_unmount &
>   _scratch_mount
> 
> Translates to:
> 
>   umount $OVL_MNT; umount $BASE_MNT &
>   mount $BASE_MNT ...; mount $OVL_MNT ...
> 
> Which can end up reordred as:
> 
>   umount $OVL_MNT;
>   mount $BASE_MNT ...
>                   umount $BASE_MNT &
>                   mount $OVL_MNT ...
> 
> and overlayfs is trying to use a non-existing upper fs.
> 
> Use UMOUNT_PROG directly instead of the _scratch_unmount
> helper, to avoid unmounting the base fs.
> 
> Incidently, the only thing that has changed in overlayfs in v6.3
> is idmapped mounts support and the test in question was run without
> idmapped mounts enabled, so the cahnge in behavior must be related
> to some subtle timing change.

I implemented testing overlayfs on top of idmapped mounts in xfstests
and changed a lot of the overlayfs test infrastructure. So I wouldn't be
surprised if that's the reason.

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

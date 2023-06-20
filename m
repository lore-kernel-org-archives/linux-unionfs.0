Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD07EB64D8
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 09:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjFTJ16 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjFTJ1Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 05:27:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4159410FE
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 02:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A53C610A7
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 09:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2996EC433C0;
        Tue, 20 Jun 2023 09:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687253201;
        bh=9dsszqRAhseubpgY+zarQKBMM6YfNIRrxr6eIyoHi6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WzMFAgkkQPYR9O+j3GDmwsGRr5BqUcL9GFfhL62fblro6l4Fuey5DcGs96H/M9hFM
         /irNwWYFOIOx5ElaWUyCqN4D10vCu563c8YtAFUDgKM/GRAjlTLxQL89RL58/V//v1
         JHYfBhCERyXpMpGGEPAdiW6n00cgjmARFadramuym96P7lJsjjrGDHwknxly7O561N
         Mp6wcVrn0PLTLB+6o8vahMsZTJVMfI/+sw/r4sQFzY8nQQQTDAQfKHm9BH5qr9Pl8K
         ZtAu1+D2iyG9bAGRORJxYYpiKIqD9Dc9tY4YayZdQ4uNatnwXQc5vj5AR8m+h+Ae8w
         JzqBsy2XOtySg==
Date:   Tue, 20 Jun 2023 11:26:37 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Prep patches for porting overlayfs to new mount
 api
Message-ID: <20230620-emblem-umgeladen-7d5c2cc0a8db@brauner>
References: <20230617084702.2468470-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230617084702.2468470-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 17, 2023 at 11:46:57AM +0300, Amir Goldstein wrote:
> Miklos,
> 
> Following some more cleanup patches that make Christian's new mount api
> patches smaller and easier to review.
> 
> I had rebased Christain's patches over these cleanups and pushed the
> result to github branch fs-overlayfs-mount_api [1].
> 
> The v1 prep patches had a bug with xino option parsing that resulted in
> some tests being skipped (not failing) and I had only noticed the
> skipped test after posting v1.
> 
> The v2 prep patches + new mount api patches have passed all the tests
> with no new tests skipped.
> 
> In addition to running the tests with the default kernel config, I also
> ran the tests with the following non-default configs (individually):
> 
> 1) CONFIG_OVERLAY_FS_REDIRECT_DIR=y
> 2) CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=n
> 3) CONFIG_OVERLAY_FS_XINO_AUTO=y

Thanks for splitting some work into preparatory patches. I'm not sure
how worthwhile this actually is given they aren't marked as backports
for LTS releases so the overall delta ould still the same between LTSes
and mainline but it might make bisection easier.

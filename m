Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BFFEB64D9
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Jul 2023 01:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjGHB4Y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 7 Jul 2023 21:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGHB4X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Jul 2023 21:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6150C3;
        Fri,  7 Jul 2023 18:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A26261AD7;
        Sat,  8 Jul 2023 01:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE9FC433C8;
        Sat,  8 Jul 2023 01:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688781381;
        bh=vxuakzuq+M+kamMjhgrbOuVS08VE6uEVejdiYB3EKG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxNiuVAS7yV8Ho6jC9sfBf3+UxOcC+YC1MAUjPH8YpqicthlIAegMN/ZLTufGkB84
         BcwwkWaBPEXUKzsxhn+S3kDerq4hULAO4EpGa2jowYxIPyw1lYXSMAtyl2Fw0/Wsv8
         o9aAynLYWS0Xw9kPgT7xKHLOLypIYmI3OfOJcCCoX31I/zy83GQNPHCS9HEM2utCtQ
         NXSDyMgfSnlbAINjZQLokgPPCDk485uqQnyfhIbzw2eapbqOlrfjqJb32oYHMsfG9l
         UadMFm38xmHhpqw2WXCuhzHTtVio5SeN8az4A5hlefPOpa/KiDP+KWLVjgvJARnX0A
         pZG4PAITUBKdQ==
Date:   Fri, 7 Jul 2023 18:56:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     alexl@redhat.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH 4/4] overlay: Add test coverage for fs-verity support
Message-ID: <20230708015619.GA1731@sol.localdomain>
References: <cover.1688634271.git.alexl@redhat.com>
 <0d9e64f67dfe314f163a5c8c15421a48deb9a9d5.1688634271.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d9e64f67dfe314f163a5c8c15421a48deb9a9d5.1688634271.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 06, 2023 at 11:51:01AM +0200, alexl@redhat.com wrote:
> +	local fstyp=${1:-$FSTYP}
> +	local scratch_mnt=${2:-$SCRATCH_MNT}

Some code after this still uses $FSTYP and $SCRATCH_MNT.  Is that a bug?

- Eric

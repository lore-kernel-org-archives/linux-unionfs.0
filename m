Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BE0EB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 09:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjFTJUw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjFTJUu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 05:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07832197
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 02:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8671760F8F
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 09:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138DBC433C0;
        Tue, 20 Jun 2023 09:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687252839;
        bh=0zEbQttg1URY4G4OmxJ3p0pqHIHDFY3PcC3f4GjZBt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rv6btY7jDUsnuh9sxK+fd2CpsKJB0ekHRBzuKS1gQnDmGpOIXNjahfXZOpgynKHsM
         uYC20+FkjHYAuWonA7pr06xO5nyA5UL25jxuK41aWUwGiPA9Yq+23NHVFhirHBxNI5
         yNYOiTMJEDB0uRJTe3/LXr5cP11GWL4uO9AvR2A5oA54NsKsBzUdCeTU+YN+mFuqex
         Nuc0dcwflf/uq7zIvwMk6fqdvkCEOI7Gka8coA4W8QH8YYs9X/O13af5hDmSKCjurr
         iQD0D0EoslseXxjqdupZzZc6HVZ4Ez7NntDTC5IbRlIJOIs8Xe+TyP+23LIqTR9Pd6
         fYSD8KUO3F3Ng==
Date:   Tue, 20 Jun 2023 11:20:36 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ovl: negate the ofs->share_whiteout boolean
Message-ID: <20230620-bezwingen-formt-c612519d444d@brauner>
References: <20230617084702.2468470-1-amir73il@gmail.com>
 <20230617084702.2468470-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230617084702.2468470-2-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 17, 2023 at 11:46:58AM +0300, Amir Goldstein wrote:
> The default common case is that whiteout sharing is enabled.
> Change to storing the negated no_shared_whiteout state, so we will not
> need to initialize it.
> 
> This is the first step towards removing all config and feature
> initializations out of ovl_fill_super().
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

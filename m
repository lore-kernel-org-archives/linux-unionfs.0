Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326B5C001B0
	for <linux-unionfs@archiver.kernel.org>; Mon,  3 Jul 2023 19:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjGCTYi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 15:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjGCTYi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Jul 2023 15:24:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA81E4F
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Jul 2023 12:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B3360F1E
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Jul 2023 19:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B31C433C7;
        Mon,  3 Jul 2023 19:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688412276;
        bh=24gB9uuPVMuPz9sNUw7Be/LhVJMoNfTXJbJI9B/QOEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KvgfO2DdoSbye16XkswC3wWkB5rPSZ4yJ8iyC/2ijq5hhJiPjJqXj9L6RmRon0LyA
         Zv9ez0fQ69FyewP/iPFoDIroWy7wmUfAw03NVAQ9RUQIeJaikaxO/vWlD0v1XkrPRo
         1tLLoHgMKst78DHH4c1dFN05Emlo6ltIfGm9pk8MxY6UojeC9m6j1SJyGWF/i/NlbN
         fA08XPXrDCXZl/QVfnYt3+3KJlreOQQXHTvzRqMjxqmNDtckBaaC7OZbxOHqygaOcj
         MwrNaZ8wVdqGg5iI233M59YPUsnEztdFtawV4AcajEux7kl1yl9KJMFSrTy5XzM2iB
         r/a0jOGTtSgOg==
Date:   Mon, 3 Jul 2023 12:24:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH v4 3/4] ovl: Validate verity xattr when resolving
 lowerdata
Message-ID: <20230703192434.GD1194@sol.localdomain>
References: <cover.1687345663.git.alexl@redhat.com>
 <5dfdecee8f0260729c4a8e8150587f128a731ccb.1687345663.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dfdecee8f0260729c4a8e8150587f128a731ccb.1687345663.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 21, 2023 at 01:18:27PM +0200, Alexander Larsson wrote:
> +static int ovl_ensure_verity_loaded(struct path *datapath)
> +{
> +	struct inode *inode = d_inode(datapath->dentry);
> +	const struct fsverity_info *vi;
> +	struct file *filp;
> +
> +	vi = fsverity_get_info(inode);
> +	if (vi == NULL && IS_VERITY(inode)) {

Can you please use '!fsverity_active(inode)' instead of
'fsverity_get_info(inode) == NULL'?  The result is exactly the same, but
fsverity_active() is the intended "API" for code outside fs/verity/.
fsverity_get_info() is in the header only because fsverity_active() calls it.

Same comment in ovl_need_meta_copy_up().

- Eric

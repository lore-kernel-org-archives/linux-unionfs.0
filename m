Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C640CC7618E
	for <linux-unionfs@archiver.kernel.org>; Wed, 26 Apr 2023 21:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbjDZVrt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 26 Apr 2023 17:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjDZVrr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2023 17:47:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9715120
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 14:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EC1761565
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 21:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE9DC433EF;
        Wed, 26 Apr 2023 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682545665;
        bh=xzooVPlLJGbbf0vgExnpBPZ3keOfqQYgMfnBZepoFgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=py9DvG0n6cx82FF7vhrHlUSbJ/hI0LxtPfwQRbtw5aNK9hO3Pub2d76nAEZQeTqDw
         PhY0ZkHeRw7isV0+AaQZYyKBO5vbKLARcU7jPbOcxkBMiKbm03W/eqzrCnE8bFP7oF
         SnRlp1cqDid78ww5Ni5/u5lG9gscpnh5jPnbNkAz5SUnprTcaca4VJMOJnvzM/WE9g
         HAsznfDm0Bp9Jqi5qtPztiN8oZMqaJiEldfS0qLEZArYeLv60//uNlcpm32XzyWY2H
         Umc9x3oyQ2GRK3zTcvJiUwUnYIQ8e2nYmR7xCxRikwul+lsoIFWV1Ck09pZZPOJRWP
         DMHbab7zntbLg==
Date:   Wed, 26 Apr 2023 14:47:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH 5/6] ovl: Validate verity xattr when resolving lowerdata
Message-ID: <20230426214743.GA58528@sol.localdomain>
References: <cover.1681917551.git.alexl@redhat.com>
 <df41e9dc96ddad9f9e1e684e39c28f4e097e9d9b.1681917551.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df41e9dc96ddad9f9e1e684e39c28f4e097e9d9b.1681917551.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 20, 2023 at 09:44:04AM +0200, Alexander Larsson wrote:
> +	err = fsverity_get_digest(d_inode(datapath->dentry), actual_digest, &verity_algo);
> +	if (err < 0) {
> +		pr_warn_ratelimited("lower file '%pd' has no fs-verity digest\n", datapath->dentry);
> +		return -EIO;
> +	}
> +
> +	if (digest_len != hash_digest_size[verity_algo] ||
> +	    memcmp(required_digest, actual_digest, digest_len) != 0) {
> +		pr_warn_ratelimited("lower file '%pd' has the wrong fs-verity digest\n",
> +				    datapath->dentry);
> +		return -EIO;
> +	}
> +
> +	return 0;

This is incorrect because the digest algorithm is not being compared.

- Eric

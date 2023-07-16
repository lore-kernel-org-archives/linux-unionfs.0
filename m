Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40A8EB64DA
	for <linux-unionfs@archiver.kernel.org>; Sun, 16 Jul 2023 15:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjGPPNo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 16 Jul 2023 11:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjGPPNn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Jul 2023 11:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B05E1B7;
        Sun, 16 Jul 2023 08:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDD4360CEC;
        Sun, 16 Jul 2023 15:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0101C433C8;
        Sun, 16 Jul 2023 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689520422;
        bh=cWG4PNnZsug6VEfKe/LFOgjXd2wLbV9Kp7KvEO+UGcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jleRNJPpVnEDCJq7WR8xqLMk5k8IAWm32fdwviDhU3KSHK+3kOohyYSCU6w0OeW34
         EqLBWj+/4VvtNTvLAEOtMF6NlTyAXU+ugVere7H8VvhHS8xKWkCpbKd/ifZhcJX9O5
         pqp4VDsL/u0VGL/CPbfq48cfqvN4QwkFTe1LjDlI=
Date:   Sun, 16 Jul 2023 17:13:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     miklos@szeredi.hu, amir73il@gmail.com,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH 5.15] ovl: fix null pointer dereference in
 ovl_get_acl_rcu()
Message-ID: <2023071631-mulch-dork-101c@gregkh>
References: <20230710032730.2049748-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710032730.2049748-1-chengzhihao1@huawei.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 10, 2023 at 11:27:30AM +0800, Zhihao Cheng wrote:
> [ Upstream commit f4e19e595cc2e76a8a58413eb19d3d9c51328b53 ]

Thanks for this, now queued up.

greg k-h

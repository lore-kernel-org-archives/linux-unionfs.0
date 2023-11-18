Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CB1C2BB3F
	for <linux-unionfs@archiver.kernel.org>; Sat, 18 Nov 2023 20:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjKRUC4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 18 Nov 2023 15:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjKRUCz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Nov 2023 15:02:55 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8487A130;
        Sat, 18 Nov 2023 12:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1HrSB+im/NzPY2KyPxH/critEWt9ArRCIHwfg0baYBY=; b=KjUE7CVgxIHd1dee7M8O+RUktL
        OfL8tgrAEnUMByDrUg7r5PZlGABqEgcooVGanCtuktiMu0i3zh6LSofgqgKd9ZRkWGUANovAkhfhM
        vihokT67awoUzsXoVfXTUUCfiizxyUHz4FRkXm178blIpDCzjcYFQ8VITbQZgOxgJkxTtrPFHGNQg
        /3DV6G1NbOgbZMGEAD1qPuD3YQae2tBJZV9+syXl95kB54UpuVEF5JZyltGMw5mh+bjLFY2pdHfU1
        QMRIKSEnYj8MQz1cpIgi8BIbgfQMUD9k3IicOLDxUeM7OcIiM8QGvLPXwQrZwcSRlk7Ai0IVXUmjN
        OIK+dnGg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r4RWh-00HYdk-0B;
        Sat, 18 Nov 2023 20:02:47 +0000
Date:   Sat, 18 Nov 2023 20:02:47 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][overlayfs] do we still need d_instantiate_anon() and
 export of d_alloc_anon()?
Message-ID: <20231118200247.GF1957730@ZenIV>
References: <20231111080400.GO1957730@ZenIV>
 <CAOQ4uxhQdHsegbwdqy_04eHVG+wkntA2g2qwt9wH8hb=-PtT2A@mail.gmail.com>
 <20231111185034.GP1957730@ZenIV>
 <CAOQ4uxjYaHk6rWUgvsFA4403Uk-hBqjGegV4CCOHZyh2LSYf4w@mail.gmail.com>
 <CAOQ4uxiJSum4a2F5FEA=a8JKwWh1XhFOpWaH8xas_uWKf+29cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiJSum4a2F5FEA=a8JKwWh1XhFOpWaH8xas_uWKf+29cw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Nov 12, 2023 at 09:26:28AM +0200, Amir Goldstein wrote:

> Tested the patch below.
> If you want to apply it as part of dcache cleanup, it's fine by me.
> Otherwise, I will queue it for the next overlayfs update.

OK...  Let's do it that way - overlayfs part goes into never-rebased branch
(no matter which tree), pulled into dcache series and into your overlayfs
update, with removal of unused stuff done in a separate patch in dcache
series.

That way we won't step on each other's toes when reordering, etc.
Does that work for you?  I can put the overlayfs part into #no-rebase-overlayfs
in vfs.git, or you could do it in a v6.7-rc1-based branch in your tree -
whatever's more convenient for you.

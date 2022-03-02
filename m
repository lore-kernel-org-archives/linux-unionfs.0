Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09A5C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed,  2 Mar 2022 06:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbiCBHAk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 2 Mar 2022 02:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbiCBHAj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 2 Mar 2022 02:00:39 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 216C8B0A75;
        Tue,  1 Mar 2022 22:59:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AA7DF533D99;
        Wed,  2 Mar 2022 17:59:53 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPIxk-000XUh-CB; Wed, 02 Mar 2022 17:59:52 +1100
Date:   Wed, 2 Mar 2022 17:59:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Generic per-sb io stats
Message-ID: <20220302065952.GE3927073@dread.disaster.area>
References: <20220301184221.371853-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301184221.371853-1-amir73il@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=621f15eb
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=5vdu9WYVys6x0XKM02IA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 01, 2022 at 08:42:15PM +0200, Amir Goldstein wrote:
> Miklos,
> 
> Following your feedback on v2 [1], I moved the iostats to per-sb.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-unionfs/20220228113910.1727819-1-amir73il@gmail.com/
> 
> Changes since v2:
> - Change from per-mount to per-sb io stats (szeredi)
> - Avoid percpu loop when reading mountstats (dchinner)
> 
> Changes since v1:
> - Opt-in for per-mount io stats for overlayfs and fuse

Why make it optional only for specific filesystem types? Shouldn't
every superblock capture these stats and export them in exactly the
same place?

Making it properly generic greatly simplifies the implementation,
too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

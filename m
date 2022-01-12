Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14FFC433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Jan 2022 21:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiALVGY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 16:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiALVGV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jan 2022 16:06:21 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED78FC06173F
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 13:06:20 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id v123so2502815wme.2
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 13:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=C37SYENE8LJoUDnK12TmDays2Aa5wPK3VQob1YUl2H4=;
        b=cve0zinT5P/PgQmSs/m2opO+kxzGob+l+60c8K0vKxLr5em9VuaDjxizZpmdgVQYjA
         IdFfHyGbKPRTJ9e+07BuR0Xs24bGcfSp/UYvKIk3TqX/weFmJIbJlQUQsK82sPyNWOIX
         RWouiivTvFlKOaRAcc1L3eyD1Owu+tyEkSPEULraHxmmFSxXhLAQjkRQv2RVw/0sXaZI
         5jdsHU00LSQdzo/XfK3Rh/aU0NaTD73zqJTaoVuaPT7P0Rtt0Qy4woEdcDPjD9D5YiNc
         8OBaJmBzsiSQuNcY1/C05YPLs0u+JLs0uTpANOrxgpq/3tEXcuG3P0oTEJP/IyGEEyPK
         fJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version
         :content-transfer-encoding;
        bh=C37SYENE8LJoUDnK12TmDays2Aa5wPK3VQob1YUl2H4=;
        b=JwAp0N90MOQlPMoEXwxH5EV5UUvh0Vw3GG+zdGVPMNOZQDD9FRA2POAHGloC1PuXOA
         RDAYB9p84Dpxj02YLNlRSf/XLvvtQDbTTAnGGXaAZULlVTfLL1LDoqgGsUo7rNy+doqE
         PpXdwe3gHJzPudR3ojGdxieDznqPryS1pLYl9ULhUXxuCweOgY7arpibDO4m2RCtyqMl
         Kvf7En3ahjlNRwdWW2z4JxM5gH7tH8+UzfLqsJ+V2JN0nT5IEgnWQmSebdRPuKIuUEpc
         RrNSC9QOLkgSiqrA1laPzu8FW1QCUhrIYyWX0xzCzQvb8I7T+2sI02QxvqNsXDPSH3hk
         wvZA==
X-Gm-Message-State: AOAM533Gm0lNN/melPM25smBstkdUcI3I+QpC2zIpH1LpBzrBYStE5bD
        ut2aWFW7cxNCyEkzczi7uIwONAVTBnQ=
X-Google-Smtp-Source: ABdhPJzzOn9AnR0q5Da+3jol6KPya2p1XK0rvaTfe3Gpb6bFh1NlaUb9dxCL3tiF37e9CG1//TGZBw==
X-Received: by 2002:a1c:c915:: with SMTP id f21mr1135599wmb.39.1642021579616;
        Wed, 12 Jan 2022 13:06:19 -0800 (PST)
Received: from mars.fritz.box ([2a02:8070:bb0:8700:3e7c:3fff:fe20:2cae])
        by smtp.gmail.com with ESMTPSA id r13sm668985wrn.101.2022.01.12.13.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 13:06:19 -0800 (PST)
Message-ID: <61820434137bd1be48b58cb25fcd4366db26a794.camel@googlemail.com>
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
From:   Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To:     Kevin Locke <kevin@kevinlocke.name>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Date:   Wed, 12 Jan 2022 22:06:18 +0100
In-Reply-To: <Yd9A9g9nsjwmbZtm@kevinlocke.name>
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
         <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
         <Yd9A9g9nsjwmbZtm@kevinlocke.name>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Kevin
> > These have been -ENOIOCTLCMD errors but got (falsely?) converted to
> > -ENOTTY by the recently introduced commit 5b0a414d06c3 ("ovl: fix
> > filattr copy-up failure"):
> 
> Which filesystem are you using for upper (and lower) in your mount?


It's tmpfs.

> Presumably the upper doesn't support file attributes, if it returns
> -ENOIOCTLCMD?


Tmpfs does support file attributes.

Thanks
  -- Christoph



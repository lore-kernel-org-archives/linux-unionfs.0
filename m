Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCDAC2D0DB
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 16:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63621206D3
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 16:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LSIZgQLD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgAaQGH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 11:06:07 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36942 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgAaQGH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 11:06:07 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so8722991ioc.4
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 08:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVz24Zsr9oNwygj5KgYpb3eR7TSSOJlPu0ZbOqwsN6M=;
        b=LSIZgQLDBrbMF2c2mc0G16882YEC+pORFZ+BuRqUUByLgL6cREuO90VwCGtCkiqp6m
         Y51NDYZde8B48PX0kJHedMpNqaBC1qN0AGUzH29VCQbsaIJmvaNdscKK+ur+VKh3LEo5
         68cLuxRDjUCLlq6K8McDLXJ9gzK1Wy1fcqewQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVz24Zsr9oNwygj5KgYpb3eR7TSSOJlPu0ZbOqwsN6M=;
        b=HuAwVjBPv/3y5K3HYd9Q2jll00oMA7N7b/mHC2ZPdydRax3/zg5HKPNOQi84qjFYEf
         EIxyqquv3z7cHv1KacWEuBrlqWDt/vLJgzRb3OpRUibyj81FEzhehI2Ou8C/ZlFgVEv/
         JbS7pNWqADRFDi1W/EhXdpNmRMoE8RIMODCsRrGvzyRCwcWCE7QL2RLgaUnhGmSWSOIu
         8QZo7ltXI+YqqJxCR5RcHivSyv3l6SfrMU68/KJNYQUwAdfL06iZ5h/rsXVcspOWv6Fs
         t9bMKvyRpqEi/voqW25JPP4To4B/R2DXC0n+AbK1CCayPZMdNZLKJYH1Yd+Lytr3eISc
         XRDA==
X-Gm-Message-State: APjAAAUI5JARjfPxUJnsvb3WeeU8sEW9rrvSnKKYps6R9i4KKg2y+whl
        XH8HUXfXodupr2Mg/c+fIMmS4v5ku3syPerGasB6d+geJEU=
X-Google-Smtp-Source: APXvYqw8nWvq0z2rl2ol8fNciDRX4bI2WxLTZO8ZpnCO1z+LhYcMVTHBMDtVW1nG8eUMrjPOmV29IWcNlf232p94GQ4=
X-Received: by 2002:a02:9988:: with SMTP id a8mr9166334jal.33.1580486767189;
 Fri, 31 Jan 2020 08:06:07 -0800 (PST)
MIME-Version: 1.0
References: <20200131115004.17410-1-mszeredi@redhat.com> <20200131115004.17410-5-mszeredi@redhat.com>
 <CAOQ4uxgV9KbE9ROCi5=RmXe1moqnmwWqaZ98jDjLcpDuM70RGQ@mail.gmail.com>
 <CAJfpegvMz-nHOb3GkoU_afqRrBKt-uvOXL6GxWLa3MVhwNGLpg@mail.gmail.com> <CAOQ4uxificaCG4uVRh94WC-nSNbGSqtmNt6Bx92j1chF_Khpmw@mail.gmail.com>
In-Reply-To: <CAOQ4uxificaCG4uVRh94WC-nSNbGSqtmNt6Bx92j1chF_Khpmw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 31 Jan 2020 17:05:56 +0100
Message-ID: <CAJfpegvkVaDVpk9fdqBoX5mmwH4Op2cEpU-5mF-pH=faShYycg@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: alllow remote upper
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jan 31, 2020 at 4:50 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> I checked - afs has d_automount and gfs2 is d_hash.
> They do not qualify as any layer.

DCACHE_NEED_AUTOMOUNT doesn't work that way: it's set on specific
automount-point dentries only.  So AFS won't be disqualified based on
that criteria.   But afs also does not have RENAME_WHITEOUT, so that's
fine.

Thanks,
MIklos

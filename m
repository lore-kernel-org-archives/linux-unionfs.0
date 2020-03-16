Return-Path: <SRS0=I2E7=5B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7794C3F2CE
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC39206E2
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 12:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="iMuvtRM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgCPM3F (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 08:29:05 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:34939 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730999AbgCPM3F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Mar 2020 08:29:05 -0400
Received: by mail-il1-f196.google.com with SMTP id v6so5106040ilq.2
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Mar 2020 05:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZGGRuaKQhMX4px0JtkjJt8BcVaQIFCUr3KcXBU9aDQ=;
        b=iMuvtRM+LzR43x5s93l6b2B8+QyQA2vs1aaX/ZOXi/CSlZglWwdxKHgQ6aeuqiIlal
         FY/U6gtTO3YJ6gbYLHDDrtdNlCC2u11bZd0/db1gwsATYgjpFhfR2ObBCPgzmnZwgIKh
         bAtCEN+20RBvwYijKtp98myROfLY3PKcl7uas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZGGRuaKQhMX4px0JtkjJt8BcVaQIFCUr3KcXBU9aDQ=;
        b=S26cojSQh3rMRYppNMkuDmqQ/alsMXkFvmyKMBzGgszpsek1x4TFofYCX60fhqYVal
         wRrjNYCu92p2EwwzFiaJH8IdOiqyTdJ+HxprSXhaO3tbNXaDaFwi7oeGFxH4NEgEfNOR
         OCoCnm1iXsd/fDJwqVWZ9q81aPOefsp4cK2tSaFriKeurBuZuJt1u8GW0mZtwv899mn1
         Ta/rE8AXd/niyXSNP3vHfBiTmNrvkLHVUSp1c5BzDt5LUgHBn+GsSUExxQTuv+GF8m5S
         DdiBaey7Nj8j6EYvJVWMv0/3D+J6YhMHxrWoko+B2XUnuq1aTbSTftSenLwHjn2qhq2r
         /GNA==
X-Gm-Message-State: ANhLgQ1jccer5fs14psKkdYdIREcCw4g4YPms75o9VIam1TaIFtx70IZ
        LvWi+cZymyNAxZTC8SnlHwjVRLiSr6Q7ukKasbTlFg==
X-Google-Smtp-Source: ADFU+vtrBIgdSTTlk46pFKF0XyNxSc2KxQlr6YZr+ZUSgjGGY3I2Um+kkJsTWw/BCGzuID3YwIxaetmqr78F8Z/kbZA=
X-Received: by 2002:a92:aa87:: with SMTP id p7mr25070122ill.63.1584361744244;
 Mon, 16 Mar 2020 05:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20191230141423.31695-1-amir73il@gmail.com> <20191230141423.31695-5-amir73il@gmail.com>
In-Reply-To: <20191230141423.31695-5-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 16 Mar 2020 13:28:53 +0100
Message-ID: <CAJfpegvHAq+yT1qW4JqTBpviCHUrQqOPMfWEcvhy4Jpr2bLJfQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] overlay: test constant ino with nested overlay
 over samefs lower
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Dec 30, 2019 at 3:14 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Also test that d_ino of readdir entries and i_ino from /proc/locks are
> consistent with st_ino and that inode numbers persist after rename to
> new parent, drop caches and mount cycle.

overlay/070 and overlay/071 fail for me like this:

     QA output created by 071
    +flock: cannot open lock file
/scratch/ovl-mnt/lowertestdir/blkdev: No such device or address
...

I.e. there's no block dev with rdev=1/1.

I don't see any other way to fix this, than to remove the device
tests.  Why are these needed?  Is locking code in any way dependent on
file type?

Thanks,
Miklos

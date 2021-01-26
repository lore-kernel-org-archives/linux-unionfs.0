Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8938C433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B9F2223D
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbhAZFuz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731085AbhAZBxp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Jan 2021 20:53:45 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB580C061351
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jan 2021 17:53:01 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id i20so14833992otl.7
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jan 2021 17:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tyhicks-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xxAVgjAWeUTEVk1HKoPhPhQyjhCFuGz73HIshLBYon4=;
        b=riPm+/XUbjsAldf1p8jPot+uVTxVczaBXz0aEQG7pvqrNi1989sRc/7cbedqpPJPx9
         nzsf66cprhMZT2cJbOEQAnxvi48Dds+OfeLAYrGgEbRez4WPjZ7WxbOHuJSganDrzCSi
         Y/15cdUHCTLPzgEzBOxIy8h27TyTOwjjBZpGjsievDj3LuyRVXuBDwo3n1ZT3pXS2N7V
         2vlii1CFP1R7IoYfng2lqfkebgwsEVGHnh6Rd/Ok01UoeEZjeakwah+DQcwmHUu1F+uF
         AeglkbPIhIr6BMfzKfqBgePaBlZrhitoSQuxrRHN8B3xZo/nro6oNYhHlsOgx0FMwri0
         b7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xxAVgjAWeUTEVk1HKoPhPhQyjhCFuGz73HIshLBYon4=;
        b=umCdi+Jsd3+avSBdh7r/aCypR26zR/Mi3m78Edl+ZuZ/n5pWhtDBRZxsu/wBlpaqNc
         TF3Jae7YafWkbRf0+YXopk4Y/4ZdaQBKk6ozIVmzH81BikzhLZeo3NDXsiVumJD0ij+l
         a0r0O6r3rZFAady/mKoMRJGejTZgaG83i9HJ3Hc67f6Qg0j/Mnsdrm6DPqqjQr9SeNOs
         MVBGUijPY/gEPzZgnqQKu6ZQ7hbIoXBlaAzlUuoUAV35RAvkWnNpnPJcipnV9Z756pk/
         +Hv4oOLZFzEGYb/Ezcz7uCJVERzuYXljBtlv8ehzta/RdaDqDdf+HXwUkujWNJUrFcLV
         7S8w==
X-Gm-Message-State: AOAM532OON5yCtLoSuoUSyjSO3UM5cScbRlvU2m9OGE7+4cy8g+iLxwa
        tdJ7ba9Stnob4po761tsWP1RenVKCfiTpQmu
X-Google-Smtp-Source: ABdhPJwmBKO2BxEJEdzwgX6J9ip8RQTuHi2fV5X10UwC0NNCZWDYPMwTCr8sBOgxExy4ZelLMj18eA==
X-Received: by 2002:a05:6830:1545:: with SMTP id l5mr2484767otp.61.1611625981223;
        Mon, 25 Jan 2021 17:53:01 -0800 (PST)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net. [162.237.133.238])
        by smtp.gmail.com with ESMTPSA id y10sm2846742ooy.11.2021.01.25.17.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 17:53:00 -0800 (PST)
Date:   Mon, 25 Jan 2021 19:52:59 -0600
From:   Tyler Hicks <code@tyhicks.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 1/2] ecryptfs: fix uid translation for setxattr on
 security.capability
Message-ID: <20210126015259.GC81247@sequoia>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
 <20210119162204.2081137-2-mszeredi@redhat.com>
 <20210122183141.GB81247@sequoia>
 <CAOssrKd-P=4n-nzhjnvnChbCkcrAaLC=NjmCTDRHtzRtzJaU-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKd-P=4n-nzhjnvnChbCkcrAaLC=NjmCTDRHtzRtzJaU-g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 2021-01-25 14:25:38, Miklos Szeredi wrote:
> On Fri, Jan 22, 2021 at 7:31 PM Tyler Hicks <code@tyhicks.com> wrote:
> >
> > On 2021-01-19 17:22:03, Miklos Szeredi wrote:
> > > Prior to commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into
> > > vfs_setxattr()") the translation of nscap->rootid did not take stacked
> > > filesystems (overlayfs and ecryptfs) into account.
> > >
> > > That patch fixed the overlay case, but made the ecryptfs case worse.
> >
> > Thanks for sending a fix!
> >
> > I know that you don't have an eCryptfs setup to test with but I'm at a
> > loss about how to test this from the userns/fscaps side of things. Do
> > you have a sequence of unshare/setcap/getcap commands that I can run on
> > a file inside of an eCryptfs mount to verify that the bug exists after
> > 7c03e2cda4a5 and then again to verify that this patch fixes the bug?
> 
> You need two terminals:
> $ = <USER>
> # = root
> 
> $ unshare -Um
> $ echo $$
> <PID>
> # echo "0 1000 1" > uid_map
> # cp uid_map gid_map
> # echo 1000 2000 1 >> uid_map
> # echo 2000 3000 1 >> uid_map
> # cat uid_map > /proc/<PID>/uid_map
> # cat gid_map > /proc/<PID>/gid_map
> $ mkdir ~/tmp ~/mnt
> $ mount -t tmpfs tmpfs ~/tmp
> $ pwd
> /home/<USER>
> # nsenter -t <PID> -m
> # [setup ecryptfs on /home/<USER>/mnt using /home/<USER>/tmp]
> $ cd ~/mnt
> $ touch test
> $ /sbin/setcap -n 1000 cap_dac_override+eip test
> $ /sbin/getcap -n test
> test = cap_dac_override+eip [rootid=1000]
> 
> Without the patch, I'm thinking that it will do a double translate and
> end up with rootid=2000 in the user namespace, but I might well have
> messed it up...
> 
> Let me know how this goes.

Spot-on instructions. Thank you for taking the time to provide the
steps.

I was able to repro the bug and verify the fix. The change visually
looks good to me and it passed through the eCryptfs regression tests.

I've pushed it to the eCryptfs next branch and I plan to submit it to
Linus on Thursday. Thanks again!

Tyler

> 
> Thanks,
> Miklos
> 

Return-Path: <SRS0=etKX=CB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BE0C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 14:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80F8E20706
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 14:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgHWOar (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 10:30:47 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:37352 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWOaq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 23 Aug 2020 10:30:46 -0400
Received: from kevinlocke.name (2600-6c67-5080-46fc-a47f-9b33-b66b-40a6.res6.spectrum.com [IPv6:2600:6c67:5080:46fc:a47f:9b33:b66b:40a6])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 43DA11BA3BD3;
        Sun, 23 Aug 2020 14:30:45 +0000 (UTC)
Received: by kevinlocke.name (Postfix, from userid 1000)
        id 8D73B1300671; Sun, 23 Aug 2020 08:30:43 -0600 (MDT)
Date:   Sun, 23 Aug 2020 08:30:43 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: warn about orphan metacopy
Message-ID: <20200823143043.GA14919@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <137e14ca5f75179d23ee2b6408201ae022c88191.1598148862.git.kevin@kevinlocke.name>
 <CAOQ4uxj0HevW0iwLq61LwohsH2=-JhxYG1i_MUfmqgB3V4bQCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj0HevW0iwLq61LwohsH2=-JhxYG1i_MUfmqgB3V4bQCQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 2020-08-23 at 17:12 +0300, Amir Goldstein wrote:
> On Sun, Aug 23, 2020 at 5:14 AM Kevin Locke <kevin@kevinlocke.name> wrote:
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index f7d4358db637..30e1c10800ab 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -1000,6 +1000,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>          * Just make sure a corresponding data dentry has been found.
>>          */
>>         if (d.metacopy || (uppermetacopy && !ctr)) {
>> +               pr_warn_ratelimited("orphan metacopy (%pd2)\n", dentry);
> 
> Funny. You started this thread because of a pain point - you did not know
> what caused EIO in your setup.
> 
> Try to go back to where you stood when you got EIO.
> Would that message in the log would have helped you understand?
> Would it have helped someone who is less skilled than you are in reading
> kernel code? I doubt it.

After I was unable to reproduce EIO by accessing the file on upper
directly and had no error message, I started grepping for EIO in
overlayfs, which led to multiple results and no clear next step (kernel
tracing helped, but was still difficult to isolate the source of EIO).
Having any error message would get me to the point in the code where the
error was encountered.  Mentioning metacopy gets me to a causal feature,
which would have been helpful for understanding.

> You better be more explicit about what has gone wrong, e.g.:
> "metacopy upper with no lower data found - abort lookup..."
> 
> It is nice that you followed a precedent of "orphan index", but if you
> look closely you will see that those cases do not end up with a user
> error - they end up with auto cleaning those "orphan index", so the
> kernel messages are just FYI - it doesn't matter if users understand them
> because they do not require users to take any action.

Sure.  That wording sounds better to me.  I'll send an updated patch
shortly.

Thanks,
Kevin

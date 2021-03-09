Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C67CC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E78A765238
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCIRnz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhCIRnd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Mar 2021 12:43:33 -0500
X-Greylist: delayed 94791 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 09 Mar 2021 09:43:32 PST
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9303C06174A
        for <linux-unionfs@vger.kernel.org>; Tue,  9 Mar 2021 09:43:32 -0800 (PST)
Received: from kevinolos.kevinlocke.name (2600-6c67-5000-3d1b-7fc1-9b6c-62fb-b24f.res6.spectrum.com [IPv6:2600:6c67:5000:3d1b:7fc1:9b6c:62fb:b24f])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 2E94D2109988;
        Tue,  9 Mar 2021 17:43:31 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id 4123813001B9; Tue,  9 Mar 2021 10:43:28 -0700 (MST)
Date:   Tue, 9 Mar 2021 10:43:28 -0700
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: add xino to "changes to underlying fs" docs
Message-ID: <YEezwCuvq51i+bIs@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
References: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
 <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
 <CAOQ4uxhGSbEPPwZswXHq+k1YF=+ntDfukxnfGsJ3+RaGjgNDnQ@mail.gmail.com>
 <YEa4Jd0VE6w4T7/v@kevinlocke.name>
 <CAOQ4uxjBb_whXA5eNqkwDNj2VSS-F+0uACF7tpqFTrM8fYETQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjBb_whXA5eNqkwDNj2VSS-F+0uACF7tpqFTrM8fYETQg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 2021-03-09 at 09:24 +0200, Amir Goldstein wrote:
> We should leave "redirect_dir" in the documented list and add "xino"
> just like the patch you posted.
> But I guess if I am going to post a patch to change the xino behavior,
> it would be better to include your change in my patch for context.

Many thanks for the detailed explanations!  My apologies for misreading
(and reading too much into) your previous post.  That sounds good to me.
The "xino" docs addition in the patch you posted looks great!

Thanks again,
Kevin

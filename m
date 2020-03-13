Return-Path: <SRS0=HZ4d=46=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3024CC5ACBF
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Mar 2020 22:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080882074F
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Mar 2020 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584138610;
	bh=I1/Uo5r8zJxfH2QrS8CQuphlInGnHcRlU6B617jbaxU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=FapfFKfATelNbooqw1/aVD8MrxbsrytypUwYttDqut7fGnuoQKagO/a+trjXM1YXt
	 PrbUQjoCWVYDnKYeMTHw88qk9AiNtu6uCQZQTzpErHwxQabF/onpqeckG+SMbxufr0
	 KLl47JoPWy2AWAQrEI8cPNu6KexQX8vYpnl0O9OA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgCMWaF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 18:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgCMWaE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Mar 2020 18:30:04 -0400
Subject: Re: [GIT PULL] overlayfs fixes for 5.6-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584138604;
        bh=I1/Uo5r8zJxfH2QrS8CQuphlInGnHcRlU6B617jbaxU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jXLA023gfw9b/ng5JOdpAAICEt3HgOdIjmtVjeblqfOJ7Y2w9JebSiZWbMFxxI321
         358rKeebDqr3AvebgdwyBhVYJUgBdTCpmcr5rNPxyBy5B6+W/clEL0cdoAzrdniSGL
         frKOzWk7UN5l2jPx4dW5UDdg6+P6AUw65l1hb6uc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200313211624.GC28467@miu.piliscsaba.redhat.com>
References: <20200313211624.GC28467@miu.piliscsaba.redhat.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200313211624.GC28467@miu.piliscsaba.redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
 tags/ovl-fixes-5.6-rc6
X-PR-Tracked-Commit-Id: c853680453ac235e9010987a8bdaaba0e116d3c8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2af82177af47a3bff0cd0113dfde14d6e44a6243
Message-Id: <158413860421.20505.13797238837339472073.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Mar 2020 22:30:04 +0000
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The pull request you sent on Fri, 13 Mar 2020 22:16:24 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.6-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2af82177af47a3bff0cd0113dfde14d6e44a6243

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
